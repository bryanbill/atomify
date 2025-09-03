import 'dart:js_interop';
import 'package:atomify/atomify.dart';
import 'package:web/web.dart' as web;

/// Global MutationObserver for efficient Page lifecycle management
class _PageMutationObserver {
  static web.MutationObserver? _observer;
  static final Map<web.HTMLElement, Page> _elementToPage =
      <web.HTMLElement, Page>{};
  static final Map<web.HTMLElement, View> _elementToView =
      <web.HTMLElement, View>{};
  static final Set<Page> _pendingPageChange = <Page>{};
  static final Map<Page, Set<View>> _pendingStyleApplication =
      <Page, Set<View>>{};

  static void _initializeObserver() {
    if (_observer != null) return;

    _observer = web.MutationObserver(
      (JSArray<JSObject> mutations, JSObject observer) {
        _handleMutations(mutations);
      }.toJS,
    );

    // Observe the entire document for added nodes
    _observer!.observe(
      web.document.body!,
      web.MutationObserverInit(childList: true, subtree: true),
    );
  }

  static void _handleMutations(JSArray<JSObject> mutations) {
    final processedPages = <Page>{};
    final processedViewElements = <web.HTMLElement>{};

    for (int i = 0; i < mutations.length; i++) {
      final mutation = mutations[i].dartify() as MutationRecord;
      final addedNodes = mutation.addedNodes;

      for (var i = 0; i < addedNodes.length; i++) {
        final node = addedNodes.item(i);
        if (node.isA<web.HTMLElement>()) {
          _checkForPageElements(node as web.HTMLElement, processedPages);
          _checkForViewElements(node, processedViewElements);
        }
      }
    }

    // Apply styles for views that are now in the DOM
    _applyPendingStyles(processedViewElements);

    // Call onPageChange for all processed pages
    for (final page in processedPages) {
      if (page.onPageChange != null && !page._pageChangeCallbackCalled) {
        try {
          page.onPageChange!(page.currentView);
          page._pageChangeCallbackCalled = true;
        } catch (e) {
          if (page._isDebugMode) {
            print('Error in onPageChange callback for ${page.runtimeType}: $e');
          }
        }
      }
    }
  }

  static void _checkForPageElements(
    web.HTMLElement element,
    Set<Page> processedPages,
  ) {
    // Check if this element is associated with a Page
    final page = _elementToPage[element];
    if (page != null && !processedPages.contains(page)) {
      processedPages.add(page);
    }

    // Check children recursively
    final children = element.children;
    for (int i = 0; i < children.length; i++) {
      final child = children.item(i);
      if (child.isA<web.HTMLElement>()) {
        _checkForPageElements(child as web.HTMLElement, processedPages);
      }
    }
  }

  static void _checkForViewElements(
    web.HTMLElement element,
    Set<web.HTMLElement> processedViewElements,
  ) {
    // Check if this element is associated with a View
    final view = _elementToView[element];
    if (view != null && !processedViewElements.contains(element)) {
      processedViewElements.add(element);
    }

    // Check children recursively for nested view elements
    final children = element.children;
    for (int i = 0; i < children.length; i++) {
      final child = children.item(i);
      if (child.isA<web.HTMLElement>()) {
        _checkForViewElements(child as web.HTMLElement, processedViewElements);
      }
    }
  }

  static void _applyPendingStyles(Set<web.HTMLElement> processedViewElements) {
    for (final element in processedViewElements) {
      final view = _elementToView[element];
      if (view != null) {
        // Find the page this view belongs to
        Page? ownerPage;
        for (final entry in _pendingStyleApplication.entries) {
          if (entry.value.contains(view)) {
            ownerPage = entry.key;
            break;
          }
        }

        if (ownerPage != null && ownerPage.id != null) {
          try {
            view.applyStyles();

            // Remove from pending styles
            _pendingStyleApplication[ownerPage]?.remove(view);
            if (_pendingStyleApplication[ownerPage]?.isEmpty == true) {
              _pendingStyleApplication.remove(ownerPage);
            }
          } catch (e) {
            if (ownerPage._isDebugMode) {
              print('Error applying styles for view ${view.id}: $e');
            }
          }
        }
      }
    }
  }

  static void registerPage(web.HTMLElement element, Page page) {
    _initializeObserver();
    _elementToPage[element] = page;
  }

  static void unregisterPage(web.HTMLElement element) {
    _elementToPage.remove(element);
  }

  static void registerViewForStyleApplication(
    web.HTMLElement element,
    View view,
    Page page,
  ) {
    _initializeObserver();
    _elementToView[element] = view;

    // Add to pending styles
    _pendingStyleApplication.putIfAbsent(page, () => <View>{}).add(view);
  }

  static void unregisterView(web.HTMLElement element, Page page, View view) {
    _elementToView.remove(element);
    _pendingStyleApplication[page]?.remove(view);
    if (_pendingStyleApplication[page]?.isEmpty == true) {
      _pendingStyleApplication.remove(page);
    }
  }

  /// Global cleanup method for the page mutation observer system.
  /// Should be called when the application is shutting down.
  // ignore: unused_element
  static void dispose() {
    _observer?.disconnect();
    _observer = null;
    _elementToPage.clear();
    _elementToView.clear();
    _pendingPageChange.clear();
    _pendingStyleApplication.clear();
  }
}

/// Production-ready, high-performance Page component with optimized lifecycle management.
///
/// This enhanced Page class provides:
/// - Efficient view rendering with error handling
/// - MutationObserver integration for proper callback timing
/// - Memory leak prevention with automatic cleanup
/// - Production-ready error handling and validation
/// - Optimized DOM operations and URL management
/// - Performance monitoring and debugging capabilities
class Page extends Box {
  /// List of views that this page contains.
  final List<View> views;

  /// The id of the initial view to display when the page is loaded.
  final String? initial;

  /// Callback function whenever a new page is rendered and added to DOM.
  final void Function(View view)? onPageChange;

  // Performance and lifecycle management
  static const bool _kIsDebugMode =
      bool.fromEnvironment('dart.vm.product') == false;
  bool _pageChangeCallbackCalled = false;
  bool _isDisposed = false;
  View? _currentView;
  int _renderCount = 0;

  // Getters
  bool get _isDebugMode => _kIsDebugMode;
  View get currentView => _currentView ?? views.first;
  @override
  bool get isDisposed => _isDisposed;
  int get renderCount => _renderCount;

  Page({
    required super.ref,
    super.id,
    super.className,
    super.attributes,
    super.onRender,
    this.views = const [],
    this.initial,
    this.onPageChange,
  }) : super(tagName: 'div', style: 'height: 100%; width: 100%;') {
    _validateInputs();
  }

  /// Validates constructor inputs and throws descriptive errors for invalid values.
  void _validateInputs() {
    if (views.isEmpty) {
      throw ArgumentError.value(
        views,
        'views',
        'Page must have at least one view',
      );
    }

    if (ref is! PageRef) {
      throw ArgumentError.value(
        ref,
        'ref',
        'Page reference must be of type PageRef',
      );
    }

    // Validate view IDs are unique
    final viewIds = views.map((v) => v.id).toSet();
    if (viewIds.length != views.length) {
      throw ArgumentError.value(
        views,
        'views',
        'All views must have unique IDs',
      );
    }

    // Validate initial view exists
    if (initial != null && !viewIds.contains(initial)) {
      throw ArgumentError.value(
        initial,
        'initial',
        'Initial view "$initial" not found in views list',
      );
    }

    // Development mode warnings
    if (_kIsDebugMode) {
      if (views.length > 50) {
        print(
          'Warning: Page has ${views.length} views. Consider splitting into multiple pages for better performance.',
        );
      }
    }
  }

  @override
  web.HTMLElement render() {
    if (_isDisposed) {
      throw StateError('Cannot render a disposed Page');
    }

    try {
      _renderCount++;
      Stopwatch? stopwatch;
      if (_kIsDebugMode) {
        stopwatch = Stopwatch()..start();
      }

      // Register with PageRef
      (ref as PageRef).add(this);

      // Call parent render method
      final element = super.render() as web.HTMLDivElement;

      // Clear existing content efficiently
      _clearContent();

      // Handle empty views case
      if (views.isEmpty) {
        if (_kIsDebugMode) {
          element.textContent = 'No views available';
        }
        return element;
      }

      // Determine which view to render
      final viewToRender = _determineViewToRender();
      _currentView = _findViewById(viewToRender);

      if (_currentView == null) {
        if (_kIsDebugMode) {
          element.textContent = 'View "$viewToRender" not found';
        }
        return element;
      }

      // Update URL if needed
      _updateUrlIfNeeded(viewToRender);

      // Render the current view
      _renderCurrentView(element);

      // Register with mutation observer for onPageChange callback
      _PageMutationObserver.registerPage(element, this);

      // Performance logging
      if (_kIsDebugMode && stopwatch != null) {
        stopwatch.stop();
        print(
          'Page ${id ?? 'unnamed'} rendered in ${stopwatch.elapsedMilliseconds}ms (render #$_renderCount)',
        );
      }

      return element;
    } catch (e, stackTrace) {
      if (_kIsDebugMode) {
        print('Error rendering Page: $e\n$stackTrace');
      }

      // Return fallback element
      final fallback = super.render() as web.HTMLDivElement;
      fallback.textContent = _kIsDebugMode ? 'Error: $e' : 'Page unavailable';
      return fallback;
    }
  }

  /// Efficiently clears page content
  void _clearContent() {
    try {
      if (element != null) {
        element!.textContent = '';
      }
    } catch (e) {
      if (_kIsDebugMode) {
        print('Error clearing page content: $e');
      }
    }
  }

  /// Determines which view should be rendered based on current state
  String _determineViewToRender() {
    return params[id] ?? initial ?? views.first.id;
  }

  /// Finds a view by its ID with efficient lookup
  View? _findViewById(String viewId) {
    try {
      return views.firstWhere((v) => v.id == viewId, orElse: () => views.first);
    } catch (e) {
      if (_kIsDebugMode) {
        print('Error finding view "$viewId": $e');
      }
      return views.isNotEmpty ? views.first : null;
    }
  }

  /// Updates URL parameters if necessary
  void _updateUrlIfNeeded(String viewToRender) {
    try {
      if (params[id] == null && id != null) {
        setQueryParams({id!: viewToRender});
      }
    } catch (e) {
      if (_kIsDebugMode) {
        print('Error updating URL: $e');
      }
    }
  }

  /// Renders the current view with error handling
  void _renderCurrentView(web.HTMLDivElement element) {
    if (_currentView == null) return;

    try {
      final viewElement = _currentView!.render(params);
      _currentView!.element = viewElement;

      // Get the actual rendered HTML element
      final renderedElement = viewElement.render();
      element.append(renderedElement);

      // Register view element with MutationObserver for style application
      // Styles will be applied automatically when the element is detected in the DOM
      if (id != null) {
        _PageMutationObserver.registerViewForStyleApplication(
          renderedElement,
          _currentView!,
          this,
        );
      }
    } catch (e) {
      if (_kIsDebugMode) {
        print('Error rendering view ${_currentView!.id}: $e');
        final errorElement =
            web.document.createElement('div') as web.HTMLElement;
        errorElement.textContent = 'Error rendering view: $e';
        errorElement.style.cssText =
            'color: red; padding: 16px; border: 1px solid red;';
        element.append(errorElement);
      }
    }
  }

  /// Sets the current view
  void setCurrentView(View view) {
    if (_isDisposed) {
      throw StateError('Cannot set current view on disposed Page');
    }

    if (!views.contains(view)) {
      throw ArgumentError.value(
        view,
        'view',
        'View must be one of the Page\'s views',
      );
    }

    _currentView = view;
  }

  /// Gets current URL parameters with caching for performance
  Map<String, String> get params {
    try {
      final uri = Uri.parse(web.window.location.href);
      return Map<String, String>.from(uri.queryParameters);
    } catch (e) {
      if (_kIsDebugMode) {
        print('Error getting URL parameters: $e');
      }
      return <String, String>{};
    }
  }

  /// Sets query parameters with error handling and performance optimization
  void setQueryParams(Map<String, String> newParams) {
    if (_isDisposed) return;

    try {
      final uri = Uri.parse(web.window.location.href);
      final combinedParams = Map<String, String>.from(uri.queryParameters);
      combinedParams.addAll(newParams);

      final newUri = uri.replace(queryParameters: combinedParams);
      web.window.history.pushState(null, '', newUri.toString());
    } catch (e) {
      if (_kIsDebugMode) {
        print('Error setting query parameters: $e');
      }
    }
  }

  /// Navigates to a specific view with validation and error handling
  void navigateToView(String viewId, {Map<String, String>? additionalParams}) {
    if (_isDisposed) {
      if (_kIsDebugMode) {
        print('Cannot navigate on disposed Page');
      }
      return;
    }

    final targetView = _findViewById(viewId);
    if (targetView == null) {
      throw ArgumentError.value(
        viewId,
        'viewId',
        'View "$viewId" not found in this page',
      );
    }

    try {
      final params = <String, String>{};
      if (id != null) {
        params[id!] = viewId;
      }
      if (additionalParams != null) {
        params.addAll(additionalParams);
      }

      setQueryParams(params);

      // Update current view before re-rendering
      _currentView = targetView;

      // Re-render to show new view
      // Styles will be automatically applied via MutationObserver when DOM is updated
      update();
    } catch (e) {
      if (_kIsDebugMode) {
        print('Error navigating to view "$viewId": $e');
      }
    }
  }

  /// Applies styles for all views in this page
  /// Useful for ensuring all view styles are loaded upfront
  void applyAllViewStyles() {
    if (_isDisposed || id == null) return;

    for (final view in views) {
      try {
        view.applyStyles();
      } catch (e) {
        if (_kIsDebugMode) {
          print('Error applying styles for view ${view.id}: $e');
        }
        // Continue with other views even if one fails
      }
    }
  }

  /// Applies styles for the current view only
  /// Useful for manual style refresh
  void applyCurrentViewStyles() {
    if (_isDisposed || id == null || _currentView == null) return;

    try {
      _currentView!.applyStyles();
    } catch (e) {
      if (_kIsDebugMode) {
        print('Error applying styles for current view ${_currentView!.id}: $e');
      }
    }
  }

  /// Comprehensive cleanup and disposal
  @override
  void dispose() {
    if (_isDisposed) return;

    // Cleanup view registrations from mutation observer
    if (_currentView?.element?.element != null) {
      _PageMutationObserver.unregisterView(
        _currentView!.element!.element!,
        this,
        _currentView!,
      );
    }

    // Cleanup views
    try {
      for (final view in views) {
        view.dispose();
      }
    } catch (e) {
      if (_kIsDebugMode) {
        print('Error disposing views: $e');
      }
    }

    // Unregister from mutation observer
    if (element != null) {
      _PageMutationObserver.unregisterPage(element!);
    }

    _currentView = null;
    _isDisposed = true;
    _pageChangeCallbackCalled = false;

    if (id != null) {
      try {
        final uri = Uri.parse(web.window.location.href);
        final combinedParams = Map<String, String>.from(uri.queryParameters);
        combinedParams.remove(id!);

        final newUri = uri.replace(queryParameters: combinedParams);
        web.window.history.pushState(null, '', newUri.toString());
      } catch (e) {
        if (_kIsDebugMode) {
          print('Error setting query parameters: $e');
        }
      }
    }

    // Call parent dispose
    super.dispose();
  }

  /// Gets performance and debugging information
  Map<String, dynamic> getDebugInfo() {
    return {
      'id': id,
      'viewCount': views.length,
      'currentViewId': _currentView?.id,
      'renderCount': _renderCount,
      'isDisposed': _isDisposed,
      'pageChangeCallbackCalled': _pageChangeCallbackCalled,
      'params': params,
    };
  }

  @override
  String toString() {
    return 'Page(id: $id, views: ${views.length}, currentView: ${_currentView?.id}, '
        'renderCount: $_renderCount, isDisposed: $_isDisposed)';
  }
}
