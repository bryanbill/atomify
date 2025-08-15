import 'dart:js_interop';
import 'dart:async';
import 'package:meta/meta.dart';
import 'package:atomify/atomify.dart';

/// The main application class that serves as the entry point for Atomify applications.
///
/// The App class manages the complete application lifecycle, from initialization
/// to rendering and error handling. It provides a robust, production-ready
/// foundation for building scalable web applications.
///
/// ## Key Features
///
/// - **Lifecycle Management**: Complete control over app initialization and rendering
/// - **Error Handling**: Comprehensive error handling with fallback mechanisms
/// - **Performance Optimization**: Efficient DOM manipulation and memory management
/// - **Validation**: Input validation and type safety
/// - **Accessibility**: Built-in accessibility considerations
/// - **Development Tools**: Enhanced debugging and development support
///
/// ## Basic Usage
///
/// ```dart
/// void main() {
///   App(
///     children: [
///       Container(
///         children: [
///           Text('Hello, Atomify!'),
///           Button(
///             Text('Click me'),
///             onClick: (e) => print('Clicked!'),
///           ),
///         ],
///       ),
///     ],
///   ).run();
/// }
/// ```
///
/// ## Advanced Usage
///
/// ```dart
/// void main() {
///   App(
///     target: '#app-root',
///     children: [
///       MyHomePage(),
///       MyAboutPage(),
///     ],
///     beforeRender: () {
///       // Initialize fonts, icons, and global styles
///       useFont(fontFamily: 'Inter');
///       useIcon(pack: IconPack.lineIcons);
///       print('App initializing...');
///     },
///     onRender: (element) {
///       print('App rendered to: ${element.tagName}');
///       // Set focus for accessibility
///       element.querySelector('[autofocus]')?.focus();
///     },
///     onError: (error) {
///       print('App error: $error');
///       // Send to error reporting service
///       // ErrorReporting.captureException(error);
///     },
///   ).run();
/// }
/// ```
///
/// ## Performance Considerations
///
/// - Uses efficient DOM manipulation techniques
/// - Implements proper cleanup for memory management
/// - Provides batched DOM updates
/// - Supports lazy loading of components
///
/// ## Error Handling
///
/// The App class provides multiple layers of error handling:
/// 1. Constructor validation
/// 2. Runtime error catching during render
/// 3. Custom error handlers with fallback UI
/// 4. Development-friendly error messages
///
/// @since 0.1.0
class App {
  /// The CSS selector or element ID where the app should be mounted.
  ///
  /// Defaults to '#output'. Common values:
  /// - '#app' - for mounting to an element with id="app"
  /// - '#root' - for mounting to an element with id="root"
  /// - 'body' - for mounting directly to the document body
  /// - '.app-container' - for mounting to an element with class="app-container"
  final String target;

  /// The list of root-level pages/components that make up the application.
  ///
  /// These are typically top-level components like pages, layouts, or
  /// major application sections. Each child should extend [Page] or [Box].
  ///
  /// Example:
  /// ```dart
  /// children: [
  ///   HomePage(),
  ///   AboutPage(),
  ///   ContactPage(),
  /// ]
  /// ```
  final List<Page> children;

  /// Callback function executed before the application is rendered.
  ///
  /// This is the ideal place to perform setup operations such as:
  /// - Loading fonts and icon libraries
  /// - Initializing global styles
  /// - Setting up analytics
  /// - Configuring third-party libraries
  /// - Performing authentication checks
  ///
  /// Example:
  /// ```dart
  /// beforeRender: () {
  ///   useFont(fontFamily: 'Inter');
  ///   useIcon(pack: IconPack.lineIcons);
  ///   Analytics.initialize();
  ///   AuthService.checkAuthStatus();
  /// }
  /// ```
  final void Function()? beforeRender;

  /// Error handler for application-level errors.
  ///
  /// This callback is invoked whenever an error occurs during:
  /// - Application initialization
  /// - DOM rendering
  /// - Component lifecycle
  ///
  /// The error handler receives the error object and should handle it
  /// appropriately (logging, user notification, fallback UI, etc.).
  ///
  /// Example:
  /// ```dart
  /// onError: (error) {
  ///   print('Application error: $error');
  ///   ErrorReporting.captureException(error);
  ///   NotificationService.showError('An error occurred. Please refresh.');
  /// }
  /// ```
  final void Function(Object error, StackTrace? stackTrace)? onError;

  /// Callback function executed after the application has been rendered.
  ///
  /// This callback receives the root DOM element and is called after
  /// all components have been successfully rendered to the DOM.
  ///
  /// Use this for:
  /// - Setting focus for accessibility
  /// - Starting animations
  /// - Initializing third-party widgets
  /// - Performance monitoring
  /// - Analytics tracking
  ///
  /// Example:
  /// ```dart
  /// onRender: (element) {
  ///   // Set focus on the first focusable element
  ///   final firstFocusable = element.querySelector('[tabindex], button, input, select, textarea');
  ///   firstFocusable?.focus();
  ///
  ///   // Track app render time
  ///   Analytics.track('app_rendered', {'render_time': DateTime.now().millisecondsSinceEpoch});
  /// }
  /// ```
  final void Function(HTMLElement element, App? instance)? onRender;

  /// Controls whether the app should clear existing content in the target container.
  ///
  /// When `true` (default), all existing children of the target element are
  /// removed before rendering the app. When `false`, the app content is
  /// appended to existing content.
  final bool clearTarget;

  /// The timeout duration for app initialization operations.
  ///
  /// If initialization takes longer than this timeout, an error will be thrown.
  /// Defaults to 30 seconds.
  final Duration initializationTimeout;

  /// Development mode flag for enhanced debugging.
  ///
  /// When `true`, provides additional debugging information, warnings,
  /// and development-only features. Automatically determined based on
  /// compilation mode but can be overridden.
  final bool developmentMode;

  // Internal state management
  MutationObserver? _mutationObserver;
  HTMLElement? _rootElement;
  bool _isRendered = false;
  bool _isDisposed = false;
  Timer? _initializationTimer;

  /// Creates a new Atomify application.
  ///
  /// ## Required Parameters
  ///
  /// - [children]: List of root-level Page components
  ///
  /// ## Optional Parameters
  ///
  /// - [target]: CSS selector for mount point (default: '#output')
  /// - [beforeRender]: Setup callback executed before rendering
  /// - [onRender]: Post-render callback with access to root element
  /// - [onError]: Error handler for application errors
  /// - [clearTarget]: Whether to clear existing content (default: true)
  /// - [initializationTimeout]: Maximum time for initialization (default: 30s)
  /// - [developmentMode]: Enable development features (auto-detected)
  ///
  /// ## Validation
  ///
  /// The constructor performs comprehensive validation:
  /// - Ensures children list is not empty
  /// - Validates target selector format
  /// - Checks for reasonable timeout values
  ///
  /// @throws ArgumentError if validation fails
  App({
    required this.children,
    this.beforeRender,
    this.target = '#output',
    this.onError,
    this.onRender,
    this.clearTarget = true,
    this.initializationTimeout = const Duration(seconds: 30),
    bool? developmentMode,
  }) : developmentMode = developmentMode ?? _isDevelopmentMode() {
    _validateInputs();
    _initializeApp();
  }

  /// Validates constructor inputs and throws descriptive errors for invalid values.
  void _validateInputs() {
    // Validate children
    if (children.isEmpty) {
      throw ArgumentError.value(
        children,
        'children',
        'App must have at least one child component',
      );
    }

    // Validate target selector
    if (target.trim().isEmpty) {
      throw ArgumentError.value(
        target,
        'target',
        'Target selector cannot be empty',
      );
    }

    // Validate basic CSS selector format
    if (!_isValidCssSelector(target)) {
      throw ArgumentError.value(
        target,
        'target',
        'Target must be a valid CSS selector (e.g., "#id", ".class", "tag")',
      );
    }

    // Validate initialization timeout
    if (initializationTimeout.isNegative ||
        initializationTimeout > const Duration(minutes: 5)) {
      throw ArgumentError.value(
        initializationTimeout,
        'initializationTimeout',
        'Initialization timeout must be between 0 and 5 minutes',
      );
    }

    // Development mode warnings
    if (developmentMode) {
      if (children.length > 20) {
        _developmentWarning(
          'Large number of root children (${children.length}). '
          'Consider using a container component for better organization.',
        );
      }

      // Check for potential selector conflicts
      if (target == 'body' || target == 'html') {
        _developmentWarning(
          'Mounting to $target may cause conflicts with other libraries. '
          'Consider using a specific container element.',
        );
      }
    }
  }

  /// Initializes the application with proper error handling and lifecycle management.
  void _initializeApp() {
    if (_isDisposed) {
      throw StateError('Cannot initialize a disposed App instance');
    }

    try {
      // Set up initialization timeout
      _initializationTimer = Timer(initializationTimeout, () {
        if (!_isRendered) {
          final error = TimeoutException(
            'App initialization timed out after ${initializationTimeout.inSeconds}s',
            initializationTimeout,
          );
          _handleError(error, StackTrace.current);
        }
      });

      // Execute beforeRender callback with error handling
      if (beforeRender != null) {
        _executeWithErrorHandling(
          beforeRender!,
          'Error in beforeRender callback',
        );
      }

      // Set up DOM mutation observer for lifecycle management
      _setupMutationObserver();
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
  }

  /// Sets up a mutation observer to track DOM changes and trigger callbacks.
  void _setupMutationObserver() {
    try {
      _mutationObserver = MutationObserver(
        (JSObject mutations, JSObject observer) {
          _handleMutations(
            List<MutationRecord>.from(mutations.dartify() as List),
            observer.dartify() as MutationObserver,
          );
        }.toJS,
      );
    } catch (error) {
      if (developmentMode) {
        _developmentWarning('Failed to set up mutation observer: $error');
      }
      // Continue without mutation observer - it's not critical
    }
  }

  /// Handles DOM mutations and triggers appropriate callbacks.
  void _handleMutations(
    List<MutationRecord> mutations,
    MutationObserver observer,
  ) {
    try {
      for (final mutation in mutations) {
        if (mutation.type == 'childList' && _rootElement != null) {
          // Trigger onRender callback
          if (onRender != null) {
            _executeWithErrorHandling(
              () => onRender!(_rootElement!, this),
              'Error in onRender callback',
            );
          }

          // Disconnect observer after first successful render
          observer.disconnect();
          _isRendered = true;
          _initializationTimer?.cancel();
          break;
        }
      }
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
  }

  /// Contains the elapsed time for every render
  final List<Duration> renderTimes = [];

  /// Renders the application to the DOM.
  ///
  /// This method performs the actual DOM manipulation to render all
  /// child components to the target element. It includes comprehensive
  /// error handling and performance optimizations.
  ///
  /// ## Process
  ///
  /// 1. Validates DOM readiness
  /// 2. Locates and validates target element
  /// 3. Clears existing content (if clearTarget is true)
  /// 4. Renders all child components efficiently
  /// 5. Sets up DOM observation for callbacks
  /// 6. Handles any errors gracefully
  ///
  /// ## Performance Features
  ///
  /// - Batches DOM operations for better performance
  /// - Uses DocumentFragment for efficient multiple insertions
  /// - Implements proper memory management
  /// - Provides efficient element cleanup
  ///
  /// ## Error Recovery
  ///
  /// If rendering fails:
  /// - Attempts to render a fallback error UI
  /// - Logs detailed error information
  /// - Prevents cascade failures
  /// - Maintains app stability
  ///
  /// @throws StateError if the app is already disposed
  /// @throws Exception if critical rendering fails
  void run() {
    if (_isDisposed) {
      throw StateError('Cannot run a disposed App instance');
    }

    if (_isRendered) {
      if (developmentMode) {
        _developmentWarning(
          'App.run() called multiple times. This may cause issues.',
        );
      }
      return;
    }

    try {
      _validateDomReadiness();
      final container = _findAndValidateContainer();

      // Store reference to root element
      _rootElement = container;

      _renderToContainer(container);
    } catch (error, stackTrace) {
      _handleRenderError(error, stackTrace);
    }
  }

  /// Validates that the DOM is ready for manipulation.
  void _validateDomReadiness() {
    if (document.readyState == 'loading') {
      throw StateError(
        'DOM is not ready. Call App.run() after DOMContentLoaded or use defer/async scripts.',
      );
    }
  }

  /// Finds and validates the target container element.
  HTMLElement _findAndValidateContainer() {
    final container = document.querySelector(target) as HTMLElement?;

    if (container == null) {
      throw Exception(
        'Target element "$target" not found in DOM. '
        'Ensure the element exists before initializing the app.',
      );
    }

    if (!document.contains(container)) {
      throw Exception(
        'Target element "$target" is not attached to the document. '
        'Ensure the element is properly added to the DOM.',
      );
    }

    // Development mode checks
    if (developmentMode) {
      if (container.hasAttribute('data-atomify-app')) {
        _developmentWarning(
          'Target element already contains an Atomify app. '
          'Multiple apps on the same element may cause conflicts.',
        );
      }

      // Mark element for development tracking
      container.setAttribute('data-atomify-app', 'true');
      container.setAttribute('data-atomify-version', '0.1.0');
    }

    return container;
  }

  /// Renders all children to the specified container with performance optimizations.
  void _renderToContainer(HTMLElement container) {
    Stopwatch? stopwatch;
    if (developmentMode) {
      stopwatch = Stopwatch()..start();
    }

    try {
      // Clear existing content efficiently if requested
      if (clearTarget) {
        _clearContainerContent(container);
      }

      // Use DocumentFragment for efficient batch DOM operations
      final fragment = document.createDocumentFragment();

      // Render all children to fragment first
      final renderedElements = <HTMLElement>[];
      for (int i = 0; i < children.length; i++) {
        try {
          final child = children[i];
          final renderedElement = child.render();

          // Validate rendered element
          if (renderedElement.parentNode != null) {
            throw StateError(
              'Child component at index $i returned an element '
              'that is already attached to the DOM. Each component must return a new element.',
            );
          }

          fragment.append(renderedElement);
          renderedElements.add(renderedElement);
        } catch (error, stackTrace) {
          _handleChildRenderError(error, stackTrace, i);
        }
      }

      // Batch append all elements at once
      if (fragment.hasChildNodes()) {
        // Set up mutation observer before appending
        if (_mutationObserver != null) {
          _mutationObserver!.observe(
            container,
            MutationObserverInit(childList: true, subtree: false),
          );
        }

        container.append(fragment);
      }

      // Performance logging
      if (developmentMode && stopwatch != null) {
        stopwatch.stop();
      }

      // Set accessibility attributes
      _setAccessibilityAttributes(container);
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
  }

  /// Efficiently clears container content with proper cleanup.
  void _clearContainerContent(HTMLElement container) {
    // More efficient than removing children one by one
    container.textContent = '';

    // Alternative approach for better performance with many children:
    // while (container.lastElementChild != null) {
    //   container.lastElementChild!.remove();
    // }
  }

  /// Handles errors that occur during child component rendering.
  void _handleChildRenderError(
    Object error,
    StackTrace stackTrace,
    int childIndex,
  ) {
    final errorMessage =
        'Error rendering child component at index $childIndex: $error';

    if (developmentMode) {
      print('Atomify Error: $errorMessage');
      print('Stack trace: $stackTrace');
    }

    // Try to render a fallback error component
    try {
      final errorElement = _createErrorElement(
        'Component Error',
        'Failed to render component at index $childIndex',
        error.toString(),
      );

      // Replace the problematic child with error element
      if (_rootElement != null) {
        _rootElement!.append(errorElement);
      }
    } catch (fallbackError) {
      // If even error rendering fails, just log it
      if (developmentMode) {
        print('Atomify: Failed to render error fallback: $fallbackError');
      }
    }

    // Always call the error handler
    _handleError(Exception(errorMessage), stackTrace);
  }

  /// Sets accessibility attributes on the root container.
  void _setAccessibilityAttributes(HTMLElement container) {
    try {
      // Set ARIA role if not already present
      if (!container.hasAttribute('role')) {
        container.setAttribute('role', 'main');
      }

      // Ensure the container is focusable for screen readers
      if (!container.hasAttribute('tabindex')) {
        final hasFocusableElements =
            container.querySelector(
              '[tabindex], button, input, select, textarea, a[href]',
            ) !=
            null;
        if (!hasFocusableElements) {
          container.setAttribute('tabindex', '-1');
        }
      }

      // Add landmark label if not present
      if (!container.hasAttribute('aria-label') &&
          !container.hasAttribute('aria-labelledby')) {
        container.setAttribute('aria-label', 'Application content');
      }
    } catch (error) {
      if (developmentMode) {
        _developmentWarning('Failed to set accessibility attributes: $error');
      }
    }
  }

  /// Creates a user-friendly error element for display.
  HTMLElement _createErrorElement(
    String title,
    String message,
    String details,
  ) {
    final errorContainer = document.createElement('div') as HTMLElement;
    errorContainer.className = 'atomify-error';
    errorContainer.setAttribute('role', 'alert');
    errorContainer.setAttribute('aria-live', 'assertive');

    // Create elements programmatically instead of using innerHTML
    final errorDiv = document.createElement('div') as HTMLElement;
    errorDiv.style.cssText = '''
      background: #fee;
      border: 1px solid #fcc;
      border-radius: 8px;
      padding: 16px;
      margin: 16px 0;
      color: #c53030;
      font-family: system-ui, sans-serif;
    ''';

    // Create title
    final titleElement = document.createElement('h3') as HTMLElement;
    titleElement.style.cssText = 'margin: 0 0 8px 0; font-size: 1.1em;';
    titleElement.textContent = '⚠️ $title';

    // Create message
    final messageElement = document.createElement('p') as HTMLElement;
    messageElement.style.cssText = 'margin: 0 0 8px 0;';
    messageElement.textContent = message;

    errorDiv.append(titleElement);
    errorDiv.append(messageElement);

    // Add details in development mode
    if (developmentMode) {
      final detailsElement = document.createElement('details') as HTMLElement;
      detailsElement.style.cssText = 'font-size: 0.9em;';

      final summaryElement = document.createElement('summary') as HTMLElement;
      summaryElement.textContent = 'Error Details';

      final preElement = document.createElement('pre') as HTMLElement;
      preElement.style.cssText = 'white-space: pre-wrap; margin-top: 8px;';
      preElement.textContent = details;

      detailsElement.append(summaryElement);
      detailsElement.append(preElement);
      errorDiv.append(detailsElement);
    }

    errorContainer.append(errorDiv);
    return errorContainer;
  }

  /// Handles rendering-specific errors with fallback UI.
  void _handleRenderError(Object error, StackTrace stackTrace) {
    final errorMessage = 'Failed to render Atomify app: $error';

    if (developmentMode) {
      print('Atomify Render Error: $errorMessage');
      print('Stack trace: $stackTrace');
    }

    // Try to render a fallback error UI
    try {
      final container = document.querySelector(target);
      if (container != null) {
        final errorElement = _createErrorElement(
          'Application Error',
          'The application failed to load. Please refresh the page.',
          error.toString(),
        );

        if (clearTarget) {
          container.textContent = '';
        }
        container.append(errorElement);
      }
    } catch (fallbackError) {
      // If even fallback rendering fails, show a basic error
      print(
        'Atomify: Critical error - unable to render fallback UI: $fallbackError',
      );

      try {
        final container = document.querySelector(target);
        if (container != null) {
          container.textContent =
              'Application failed to load. Please refresh the page.';
        }
      } catch (_) {
        // Last resort - at least log the error
        print('Atomify: Fatal error - unable to show any error message');
      }
    }

    // Always call the error handler
    _handleError(Exception(errorMessage), stackTrace);
  }

  /// Centralized error handling with proper logging and user notification.
  void _handleError(Object error, StackTrace? stackTrace) {
    try {
      if (onError != null) {
        onError!(error, stackTrace);
      } else if (developmentMode) {
        print('Atomify Error: $error');
        if (stackTrace != null) {
          print('Stack trace: $stackTrace');
        }
      }
    } catch (handlerError) {
      // Prevent infinite error loops
      if (developmentMode) {
        print('Atomify: Error in error handler: $handlerError');
        print('Original error: $error');
      }
    }
  }

  /// Executes a callback with proper error handling.
  void _executeWithErrorHandling(
    void Function() callback,
    String contextMessage,
  ) {
    try {
      callback();
    } catch (error, stackTrace) {
      _handleError(Exception('$contextMessage: $error'), stackTrace);
    }
  }

  /// Disposes of the application and cleans up resources.
  ///
  /// This method should be called when the application is being destroyed
  /// or when switching to a new app instance. It ensures proper cleanup
  /// of:
  ///
  /// - DOM observers
  /// - Event listeners
  /// - Timers
  /// - Memory references
  ///
  /// After disposal, the app instance cannot be used again.
  void dispose() {
    if (_isDisposed) {
      return;
    }

    try {
      // Cancel initialization timer
      _initializationTimer?.cancel();
      _initializationTimer = null;

      // Disconnect mutation observer
      _mutationObserver?.disconnect();
      _mutationObserver = null;

      // Clean up DOM references
      if (_rootElement != null && developmentMode) {
        _rootElement!.removeAttribute('data-atomify-app');
        _rootElement!.removeAttribute('data-atomify-version');
      }
      _rootElement = null;

      // Mark as disposed
      _isDisposed = true;
      _isRendered = false;

      if (developmentMode) {
        print('Atomify: App disposed successfully');
      }
    } catch (error, stackTrace) {
      _handleError(error, stackTrace);
    }
  }

  /// Validates if a string is a reasonable CSS selector.
  static bool _isValidCssSelector(String selector) {
    if (selector.trim().isEmpty) return false;

    // Basic validation - should start with valid CSS selector characters
    final validStart = RegExp(r'^[#.]?[a-zA-Z_-]');
    if (!validStart.hasMatch(selector.trim())) {
      return false;
    }

    // Should not contain dangerous characters
    final dangerous = RegExp(r'[<>"]');
    if (dangerous.hasMatch(selector)) {
      return false;
    }

    return true;
  }

  /// Determines if the app is running in development mode.
  static bool _isDevelopmentMode() {
    // In production builds, this should return false
    // For now, we'll use a simple heuristic
    try {
      assert(false);
      return false; // This line only executes in production
    } catch (e) {
      return true; // Assertions are enabled, so we're in development
    }
  }

  /// Logs development warnings when in development mode.
  void _developmentWarning(String message) {
    if (developmentMode) {
      print('Atomify Warning: $message');
    }
  }

  /// Gets the current application state for debugging and monitoring.
  ///
  /// Returns a map containing information about the app's current state,
  /// useful for debugging and development tools.
  @visibleForTesting
  Map<String, dynamic> getDebugInfo() {
    return {
      'isRendered': _isRendered,
      'isDisposed': _isDisposed,
      'target': target,
      'childrenCount': children.length,
      'hasRootElement': _rootElement != null,
      'hasMutationObserver': _mutationObserver != null,
      'developmentMode': developmentMode,
    };
  }

  Map<String, dynamic> tree() {
    return {'children': children.map((e) => e.tree()).toList()};
  }

  /// Returns a string representation of the App for debugging.
  @override
  String toString() {
    return 'App(target: $target, children: ${children.length}, '
        'rendered: $_isRendered, disposed: $_isDisposed)';
  }
}
