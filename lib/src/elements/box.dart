import 'dart:async';
import 'package:ui/src/ui.dart';
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

class EventHandler {
  final Event event;
  StreamSubscription<web.Event> subscription;

  EventHandler(this.event, this.subscription);

  set updateSubscription(StreamSubscription<web.Event> newSubscription) {
    subscription.cancel();
    subscription = newSubscription;
  }
}

abstract class Box {
  final Style? style;
  final String? id;
  final String? className;
  final Map<String, String>? attributes;
  final String? tagName;
  final String? text;
  final Function(Box)? onRender;

  final List<EventHandler> _eventHandlers = [];
  web.HTMLElement? _element;

  Box({
    this.style,
    this.id,
    this.className,
    this.attributes,
    this.tagName,
    this.text,
    this.onRender,
  }) {
    Stack.push(this);
  }

  set tagName(String? value) {
    if (value != null) {
      _element = web.document.createElement(value) as web.HTMLElement;
    }
  }

  set id(String? value) {
    if (value != null) {
      _element?.id = value;
    }
  }

  set className(String? value) {
    if (value != null) {
      _element?.className = value;
    }
  }

  set style(Style? value) {
    if (value != null) {
      style!.injectCss();
      if (_element?.classList.contains(value.name) == false) {
        _element?.classList.add(value.name);
      }
    }
  }

  set attributes(Map<String, String>? value) {
    if (value != null) {
      value.forEach((key, val) {
        _element?.setAttribute(key, val);
      });
    }
  }

  set text(String? value) {
    if (value != null) {
      _element?.textContent = value;
    }
  }

  web.HTMLElement render() {
    _element = web.document.createElement(tagName ?? 'div') as web.HTMLElement;

    if (id != null) _element!.id = id!;
    if (className != null) _element!.className = className!;
    attributes?.forEach((key, value) {
      _element!.setAttribute(key, value);
    });
    if (text != null) _element!.textContent = text;
    if (style != null) {
      style!.injectCss();
      if (_element!.classList.contains(style!.name) == false) {
        _element!.classList.add(style!.name);
      }
    }
    onRender?.call(this);
    return _element!;
  }

  void on(Event event, void Function(web.Event) callback) {
    assert(
      _element != null,
      'Cannot attach event handler to a Box that has not been rendered yet.',
    );

    final eventProvider = web.EventStreamProvider(
      event.name,
    ).forElement(_element!);
    final subscription = eventProvider.listen(callback);
    _eventHandlers.add(EventHandler(event, subscription));
  }

  void off(Event event) {
    final handlerIndex = _eventHandlers.indexWhere(
      (handler) => handler.event == event,
    );

    if (handlerIndex != -1) {
      _eventHandlers[handlerIndex].subscription.cancel();
      _eventHandlers.removeAt(handlerIndex);
    }
  }

  void replaceWith(Box newBox) {
    assert(
      _element != null,
      'Cannot replace a Box that has not been rendered yet.',
    );

    final newElement = newBox.render();
    _element?.replaceWith(newElement);
  }

  void append(Box child) {
    assert(
      _element != null,
      'Cannot append a child to a Box that has not been rendered yet.',
    );
    _element?.append(child.render());
  }

  void remove() {
    assert(
      _element != null,
      'Cannot remove a Box that has not been rendered yet.',
    );

    final parent = _element?.parentNode;
    if (parent != null) {
      parent.removeChild(_element!);
    }
  }

  void update() {
    final oldElement = _element;
    _element = null;
    final newElement = render();

    oldElement?.replaceWith(newElement);
  }

  void dispose() {
    for (final handler in _eventHandlers) {
      handler.subscription.cancel();
    }
    _eventHandlers.clear();
    _element?.remove();
    _element = null;
  }

  @override
  String toString() {
    return 'Box(id: $id, className: $className, tagName: $tagName, text: $text, style: $style)';
  }
}
