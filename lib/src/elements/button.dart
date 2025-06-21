import 'package:ui/src/elements/box.dart';
import 'package:web/web.dart' as web;

class Button extends Box {
  final Box label;
  final bool disabled;
  final void Function(web.Event)? onPressed;
  final void Function(web.Event)? onClick;

  Button(
    this.label, {
    this.disabled = false,
    this.onClick,
    this.onPressed,
    super.id,
    super.className,
    super.attributes,
    super.style,
    String? tagName,
    super.onRender,
  }) : super(tagName: tagName ?? 'button');

  @override
  web.HTMLElement render() {
    final element = super.render();
    if (disabled) {
      element.setAttribute('disabled', 'true');
    }

    if ((onPressed != null || onClick != null) && !disabled) {
      on(Event.click, (event) {
        if (onPressed != null) {
          onPressed!(event);
        }

        if (onClick != null) {
          onClick!(event);
        }
      });
    }

    element.append(label.render());
    return element;
  }
}
