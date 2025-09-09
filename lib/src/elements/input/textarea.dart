import 'package:atomify/atomify.dart';
import 'package:web/web.dart' as web;

class Textarea extends Box {
  String? value;
  final String? placeholder;
  final bool? disabled;
  final int? rows;
  final int? cols;
  final String? wrap;
  final bool? readonly;
  final int? maxLength;

  final void Function(String)? onChanged;
  final void Function(web.Event)? onInput;
  final void Function(web.Event)? onFocus;
  final void Function(web.Event)? onBlur;

  Textarea({
    this.value,
    this.placeholder,
    this.disabled = false,
    this.rows,
    this.cols,
    this.wrap,
    this.readonly = false,
    this.maxLength,
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
  }) : super(tagName: 'textarea') {
    ref?.init(this);
  }

  late web.HTMLTextAreaElement _element;

  void click() {
    _element.click();
  }

  void focus() {
    _element.focus();
  }

  void blur() {
    _element.blur();
  }

  void select() {
    _element.select();
  }

  @override
  web.HTMLElement render() {
    _element = super.render() as web.HTMLTextAreaElement;

    if (placeholder != null) _element.placeholder = placeholder!;
    if (value != null) _element.value = value!;
    if (disabled == true) _element.disabled = true;
    if (readonly == true) _element.readOnly = true;
    if (rows != null) _element.rows = rows!;
    if (cols != null) _element.cols = cols!;
    if (wrap != null) _element.wrap = wrap!;
    if (maxLength != null) _element.maxLength = maxLength!;

    on(Event.input, (e) {
      final target = e.target as web.HTMLTextAreaElement;
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
