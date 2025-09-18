import 'dart:async';
import 'dart:collection';
import 'dart:js_interop';
import 'package:atomify/atomify.dart';
import 'package:web/web.dart' as web;

enum Event {
  click,
  doubleClick,
  mouseDown,
  mouseUp,
  mouseOver,
  mouseOut,
  mouseEnter,
  mouseLeave,
  mouseMove,
  contextMenu,
  wheel,
  keyDown,
  keyUp,
  keyPress,
  input,
  touchStart,
  touchEnd,
  touchMove,
  touchCancel,
  pointerDown,
  pointerUp,
  pointerMove,
  pointerOver,
  pointerOut,
  pointerEnter,
  pointerLeave,
  pointerCancel,
  gotPointerCapture,
  lostPointerCapture,
  focus,
  blur,
  focusIn,
  focusOut,
  change,
  inputEvent,
  submit,
  reset,
  invalid,
  copy,
  cut,
  paste,
  drag,
  dragStart,
  dragEnd,
  dragEnter,
  dragLeave,
  dragOver,
  drop,
  play,
  pause,
  ended,
  volumeChange,
  timeUpdate,
  durationChange,
  seeking,
  seeked,
  loadedData,
  loadedMetadata,
  canPlay,
  canPlayThrough,
  waiting,
  stalled,
  suspend,
  rateChange,
  progress,
  abort,
  error,
  animationStart,
  animationEnd,
  animationIteration,
  transitionEnd,
  transitionRun,
  transitionStart,
  transitionCancel,
  resize,
  scroll,
  load,
  unload,
  beforeUnload,
  hashChange,
  popState,
  visibilityChange,
  select,
  pointerLockChange,
  pointerLockError,
  fullscreenChange,
  fullscreenError,
}

extension EventName on Event {
  String get name {
    switch (this) {
      case Event.click:
        return 'click';
      case Event.doubleClick:
        return 'dblclick';
      case Event.mouseDown:
        return 'mousedown';
      case Event.mouseUp:
        return 'mouseup';
      case Event.mouseOver:
        return 'mouseover';
      case Event.mouseOut:
        return 'mouseout';
      case Event.mouseEnter:
        return 'mouseenter';
      case Event.mouseLeave:
        return 'mouseleave';
      case Event.mouseMove:
        return 'mousemove';
      case Event.contextMenu:
        return 'contextmenu';
      case Event.wheel:
        return 'wheel';
      case Event.keyDown:
        return 'keydown';
      case Event.keyUp:
        return 'keyup';
      case Event.keyPress:
        return 'keypress';
      case Event.input:
        return 'input';
      case Event.touchStart:
        return 'touchstart';
      case Event.touchEnd:
        return 'touchend';
      case Event.touchMove:
        return 'touchmove';
      case Event.touchCancel:
        return 'touchcancel';
      case Event.pointerDown:
        return 'pointerdown';
      case Event.pointerUp:
        return 'pointerup';
      case Event.pointerMove:
        return 'pointermove';
      case Event.pointerOver:
        return 'pointerover';
      case Event.pointerOut:
        return 'pointerout';
      case Event.pointerEnter:
        return 'pointerenter';
      case Event.pointerLeave:
        return 'pointerleave';
      case Event.pointerCancel:
        return 'pointercancel';
      case Event.gotPointerCapture:
        return 'gotpointercapture';
      case Event.lostPointerCapture:
        return 'lostpointercapture';
      case Event.focus:
        return 'focus';
      case Event.blur:
        return 'blur';
      case Event.focusIn:
        return 'focusin';
      case Event.focusOut:
        return 'focusout';
      case Event.change:
        return 'change';
      case Event.inputEvent:
        return 'input';
      case Event.submit:
        return 'submit';
      case Event.reset:
        return 'reset';
      case Event.invalid:
        return 'invalid';
      case Event.copy:
        return 'copy';
      case Event.cut:
        return 'cut';
      case Event.paste:
        return 'paste';
      case Event.drag:
        return 'drag';
      case Event.dragStart:
        return 'dragstart';
      case Event.dragEnd:
        return 'dragend';
      case Event.dragEnter:
        return 'dragenter';
      case Event.dragLeave:
        return 'dragleave';
      case Event.dragOver:
        return 'dragover';
      case Event.drop:
        return 'drop';
      case Event.play:
        return 'play';
      case Event.pause:
        return 'pause';
      case Event.ended:
        return 'ended';
      case Event.volumeChange:
        return 'volumechange';
      case Event.timeUpdate:
        return 'timeupdate';
      case Event.durationChange:
        return 'durationchange';
      case Event.seeking:
        return 'seeking';
      case Event.seeked:
        return 'seeked';
      case Event.loadedData:
        return 'loadeddata';
      case Event.loadedMetadata:
        return 'loadedmetadata';
      case Event.canPlay:
        return 'canplay';
      case Event.canPlayThrough:
        return 'canplaythrough';
      case Event.waiting:
        return 'waiting';
      case Event.stalled:
        return 'stalled';
      case Event.suspend:
        return 'suspend';
      case Event.rateChange:
        return 'ratechange';
      case Event.progress:
        return 'progress';
      case Event.abort:
        return 'abort';
      case Event.error:
        return 'error';
      case Event.animationStart:
        return 'animationstart';
      case Event.animationEnd:
        return 'animationend';
      case Event.animationIteration:
        return 'animationiteration';
      case Event.transitionEnd:
        return 'transitionend';
      case Event.transitionRun:
        return 'transitionrun';
      case Event.transitionStart:
        return 'transitionstart';
      case Event.transitionCancel:
        return 'transitioncancel';
      case Event.resize:
        return 'resize';
      case Event.scroll:
        return 'scroll';
      case Event.load:
        return 'load';
      case Event.unload:
        return 'unload';
      case Event.beforeUnload:
        return 'beforeunload';
      case Event.hashChange:
        return 'hashchange';
      case Event.popState:
        return 'popstate';
      case Event.visibilityChange:
        return 'visibilitychange';
      case Event.select:
        return 'select';
      case Event.pointerLockChange:
        return 'pointerlockchange';
      case Event.pointerLockError:
        return 'pointerlockerror';
      case Event.fullscreenChange:
        return 'fullscreenchange';
      case Event.fullscreenError:
        return 'fullscreenerror';
    }
  }
}

/// Optimized event handler with fast lookup and memory management
class EventHandler {
  final Event event;
  final StreamSubscription<web.Event> subscription;
  final void Function(web.Event) callback;

  EventHandler(this.event, this.subscription, this.callback);

  void cancel() {
    subscription.cancel();
  }
}

/// Global MutationObserver for efficient DOM change detection
class _BoxMutationObserver {
  static web.MutationObserver? _observer;
  static final Map<web.HTMLElement, Box> _elementToBox =
      <web.HTMLElement, Box>{};
  static final Set<Box> _pendingOnRender = <Box>{};

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
    final processedBoxes = <Box>{};

    for (int i = 0; i < mutations.length; i++) {
      final mutation = mutations[i].dartify() as MutationRecord;
      final addedNodes = mutation.addedNodes;

      for (var i = 0; i < addedNodes.length; i++) {
        final node = addedNodes.item(i);
        if (node.isA<web.HTMLElement>()) {
          _checkForBoxElements(node as web.HTMLElement, processedBoxes);
        }
      }
    }

    // Call onRender for all processed boxes
    for (final box in processedBoxes) {
      if (box.onRender != null && !box._onRenderCalled) {
        try {
          box.onRender!(box);
          box._onRenderCalled = true;
        } catch (e) {
          // Handle error silently in production, log in debug
          if (box._isDebugMode) {
            print('Error in onRender callback for ${box.runtimeType}: $e');
          }
        }
      }
    }
  }

  static void _checkForBoxElements(
    web.HTMLElement element,
    Set<Box> processedBoxes,
  ) {
    // Check if this element is associated with a Box
    final box = _elementToBox[element];
    if (box != null && !processedBoxes.contains(box)) {
      processedBoxes.add(box);
    }

    // Check children recursively
    final children = element.children;
    for (int i = 0; i < children.length; i++) {
      final child = children.item(i);
      if (child.isA<web.HTMLElement>()) {
        _checkForBoxElements(child as web.HTMLElement, processedBoxes);
      }
    }
  }

  static void registerBox(web.HTMLElement element, Box box) {
    _initializeObserver();
    _elementToBox[element] = box;
  }

  static void unregisterBox(web.HTMLElement element) {
    _elementToBox.remove(element);
  }

  /// Global cleanup method for the mutation observer system.
  /// Should be called when the application is shutting down.
  // ignore: unused_element
  static void dispose() {
    _observer?.disconnect();
    _observer = null;
    _elementToBox.clear();
    _pendingOnRender.clear();
  }
}

abstract class Box {
  // Core properties
  final Ref? ref;
  final String? style;
  final String? id;
  final String? className;
  final Map<String, String>? attributes;
  final String? tagName;
  final String? text;
  final Function(Box)? onRender;

  // Performance optimizations
  static const bool _kIsDebugMode =
      bool.fromEnvironment('dart.vm.product') == false;
  static final Map<String, Queue<web.HTMLElement>> _elementPool = {};
  static const int _maxPoolSize = 50;

  // Instance state
  final Map<Event, EventHandler> _eventHandlers = <Event, EventHandler>{};
  web.HTMLElement? _element;
  bool _onRenderCalled = false;
  bool _isDisposed = false;
  bool _isRendered = false;

  // Getters
  web.HTMLElement? get element => _element;
  bool get isRendered => _isRendered;
  bool get isDisposed => _isDisposed;
  bool get _isDebugMode => _kIsDebugMode;

  Box({
    this.ref,
    this.style,
    this.id,
    this.className,
    this.attributes,
    this.tagName,
    this.text,
    this.onRender,
  }) {
    // Only add to stack if not disposed and in valid state
    if (!_isDisposed) {
      Stack.push(this);
      ref?.init(this);
    }
  }

  /// Creates or reuses an HTML element from the pool for better performance
  web.HTMLElement _createOrReuseElement(String tagName) {
    final pool = _elementPool[tagName];
    if (pool != null && pool.isNotEmpty) {
      final element = pool.removeFirst();
      _resetElement(element);
      return element;
    }
    return web.document.createElement(tagName) as web.HTMLElement;
  }

  /// Resets an element to its default state for reuse
  void _resetElement(web.HTMLElement element) {
    element.id = '';
    element.className = '';
    element.removeAttribute('style');
    element.textContent = '';

    // Remove all custom attributes but preserve essential ones
    final attributesToKeep = {'id', 'class', 'style'};
    final attributesToRemove = <String>[];

    for (int i = 0; i < element.attributes.length; i++) {
      final attr = element.attributes.item(i);
      if (attr != null && !attributesToKeep.contains(attr.name.toLowerCase())) {
        attributesToRemove.add(attr.name);
      }
    }

    for (final attrName in attributesToRemove) {
      element.removeAttribute(attrName);
    }
  }

  /// Returns an element to the pool for reuse
  void _returnElementToPool(web.HTMLElement element, String tagName) {
    final pool = _elementPool.putIfAbsent(
      tagName,
      () => Queue<web.HTMLElement>(),
    );

    if (pool.length < _maxPoolSize) {
      _resetElement(element);
      pool.add(element);
    }
  }

  /// Optimized render method with batched DOM operations and error handling
  web.HTMLElement render() {
    if (_isDisposed) {
      throw StateError('Cannot render a disposed Box');
    }

    try {
      // Create or reuse element efficiently
      final elementTagName = tagName ?? 'div';
      _element = _createOrReuseElement(elementTagName);

      // Batch all attribute operations
      _batchDOMOperations();

      // Register with global mutation observer for onRender callback
      _BoxMutationObserver.registerBox(_element!, this);

      _isRendered = true;
      return _element!;
    } catch (e) {
      if (_kIsDebugMode) {
        print('Error rendering Box: $e');
      }
      // Fallback to basic div element
      _element = web.document.createElement('div') as web.HTMLElement;
      return _element!;
    }
  }

  /// Batches DOM operations for better performance
  void _batchDOMOperations() {
    if (_element == null) return;

    // Batch basic properties
    if (id != null) _element!.id = id!;
    if (className != null) _element!.className = className!;
    if (text != null) _element!.textContent = text!;

    // Batch attributes
    attributes?.forEach((key, value) {
      _element!.setAttribute(key, value);
    });

    // Apply styles last to avoid reflows
    if (style != null) {
      _element!.style.cssText = style!;
    }
  }

  /// Optimized event handling with O(1) lookup and memory management
  void on(Event event, void Function(web.Event) callback) {
    if (_element == null) {
      throw StateError('Cannot attach event handler to unrendered Box');
    }

    if (_isDisposed) {
      if (_kIsDebugMode) {
        print('Warning: Attempting to add event handler to disposed Box');
      }
      return;
    }

    // Remove existing handler for this event type
    off(event);

    try {
      final eventProvider = web.EventStreamProvider(
        event.name,
      ).forElement(_element!);
      final subscription = eventProvider.listen(callback);
      _eventHandlers[event] = EventHandler(event, subscription, callback);
    } catch (e) {
      if (_kIsDebugMode) {
        print('Error attaching event handler for ${event.name}: $e');
      }
    }
  }

  /// Efficiently removes event handlers using Map lookup
  void off(Event event) {
    final handler = _eventHandlers.remove(event);
    handler?.cancel();
  }

  /// Add event handler that triggers only once
  void once(Event event, void Function(web.Event) callback) {
    void wrapper(web.Event e) {
      callback(e);
      off(event);
    }

    on(event, wrapper);
  }

  /// Add event listener
  void addEventListener(
    String type,
    web.EventListener listener, [
    bool? useCapture,
  ]) {
    if (_element == null) {
      throw StateError('Cannot attach event listener to unrendered Box');
    }

    if (_isDisposed) {
      if (_kIsDebugMode) {
        print('Warning: Attempting to add event listener to disposed Box');
      }
      return;
    }

    try {
      _element!.addEventListener(
        type,
        listener,
        useCapture?.toJS ?? false.toJS,
      );
    } catch (e) {
      if (_kIsDebugMode) {
        print('Error attaching event listener for $type: $e');
      }
    }
  }

  /// Production-ready element replacement with error handling
  void replaceWith(Box newBox) {
    if (_element == null || _isDisposed) {
      if (_kIsDebugMode) {
        print('Warning: Cannot replace unrendered or disposed Box');
      }
      return;
    }

    try {
      final newElement = newBox.render();
      _element!.replaceWith(newElement);
      _cleanup();
    } catch (e) {
      if (_kIsDebugMode) {
        print('Error replacing Box: $e');
      }
    }
  }

  /// Optimized child appending with validation
  void append(Box child) {
    if (_element == null || _isDisposed) {
      if (_kIsDebugMode) {
        print('Warning: Cannot append child to unrendered or disposed Box');
      }
      return;
    }

    try {
      _element!.append(child.render());
    } catch (e) {
      if (_kIsDebugMode) {
        print('Error appending child Box: $e');
      }
    }
  }

  /// Safe element removal with proper cleanup
  void remove() {
    if (_element == null || _isDisposed) return;

    try {
      final parent = _element!.parentNode;
      if (parent != null) {
        parent.removeChild(_element!);
      }
      _cleanup();
    } catch (e) {
      if (_kIsDebugMode) {
        print('Error removing Box: $e');
      }
    }
  }

  /// Efficient update with minimal DOM manipulation
  void update() {
    if (_element == null || _isDisposed) return;

    try {
      final oldElement = _element!;
      final parent = oldElement.parentNode;

      if (parent != null) {
        // Create new element
        _element = null;
        _isRendered = false;
        _onRenderCalled = false;

        final newElement = render();
        parent.replaceChild(newElement, oldElement);

        // Return old element to pool
        _returnElementToPool(oldElement, oldElement.tagName.toLowerCase());
      }
    } catch (e) {
      if (_kIsDebugMode) {
        print('Error updating Box: $e');
      }
    }
  }

  /// Comprehensive cleanup and disposal
  void dispose() {
    if (_isDisposed) return;

    _cleanup();
    _isDisposed = true;
  }

  void _cleanup() {
    // Cancel all event handlers
    for (final handler in _eventHandlers.values) {
      handler.cancel();
    }
    _eventHandlers.clear();

    // Unregister from mutation observer
    if (_element != null) {
      _BoxMutationObserver.unregisterBox(_element!);

      // Return element to pool if applicable
      if (_isRendered) {
        _returnElementToPool(_element!, _element!.tagName.toLowerCase());
      }
    }

    _element = null;
    _isRendered = false;
    _onRenderCalled = false;
  }

  /// Optimized scrolling with error handling
  void scrollToTop() {
    if (_element == null || _isDisposed) {
      if (_kIsDebugMode) {
        print('Warning: Cannot scroll unrendered or disposed Box');
      }
      return;
    }

    try {
      _element!.scrollTop = 0;
    } catch (e) {
      if (_kIsDebugMode) {
        print('Error scrolling Box: $e');
      }
    }
  }

  /// Efficient child clearing with proper cleanup
  void clear() {
    if (_element == null || _isDisposed) return;

    try {
      // More efficient than removing children one by one
      _element!.textContent = '';
    } catch (e) {
      if (_kIsDebugMode) {
        print('Error clearing Box: $e');
      }
    }
  }

  /// Static method to clear element pools for memory management
  static void clearElementPools() {
    _elementPool.clear();
  }

  /// Static method to get pool statistics for monitoring
  static Map<String, int> getPoolStatistics() {
    return _elementPool.map((tag, pool) => MapEntry(tag, pool.length));
  }

  Map<String, dynamic> tree() {
    var childrenList = <Map<String, dynamic>>[];
    if (_element != null) {
      for (var i = 0; i < _element!.children.length; i++) {
        final childElement = _element!.children.item(i);
        if (childElement != null) {
          final childBox = _BoxMutationObserver._elementToBox[childElement];
          if (childBox != null) {
            childrenList.add(childBox.tree());
          } else {
            childrenList.add({
              'tagName': childElement.tagName,
              'id': childElement.id,
              'className': childElement.className,
              'text': childElement.textContent,
            });
          }
        }
      }
    }
    return {
      'id': id,
      'className': className,
      'tagName': tagName,
      'text': text,
      'style': style,
      'isRendered': isRendered,
      'isDisposed': isDisposed,
      'children': childrenList,
    };
  }

  @override
  String toString() {
    return 'Box(id: $id, className: $className, tagName: $tagName, '
        'text: $text, style: $style, isRendered: $isRendered, '
        'isDisposed: $isDisposed)';
  }
}
