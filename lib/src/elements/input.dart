import 'package:atomify/atomify.dart';
import 'package:web/web.dart' as web;

class Input extends Box {
  String? value;
  final String? placeholder;
  final String? type;
  final bool? disabled;

  final void Function(String)? onChanged;
  final void Function(web.Event)? onInput;
  final void Function(web.Event)? onFocus;
  final void Function(web.Event)? onBlur;

  Input({
    this.value,
    this.placeholder,
    this.type = 'text',
    this.disabled = false,
    this.onChanged,
    this.onInput,
    this.onFocus,
    this.onBlur,
    super.ref,
    super.id,
    super.className,
    super.attributes,
    super.style,
    super.onRender,
  }) : super(tagName: 'input') {
    ref?.init(this);
  }

  late web.HTMLInputElement _element;

  void click() {
    _element.click();
  }

  @override
  web.HTMLElement render() {
    _element = super.render() as web.HTMLInputElement;
    _element.type = type ?? 'text';
    if (placeholder != null) _element.placeholder = placeholder!;
    if (value != null) _element.value = value!;
    if (disabled == true) _element.disabled = true;

    on(Event.input, (e) {
      final target = e.target as web.HTMLInputElement;
      value = target.value; // Update the value property
      onChanged?.call(target.value);
    });

    if (onInput != null) {
      on(Event.input, onInput!);
    }
    if (onFocus != null) {
      on(Event.focus, onFocus!);
    }
    if (onBlur != null) {
      on(Event.blur, onBlur!);
    }
    return _element;
  }
}
