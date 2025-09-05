import 'dart:js_interop';

import 'package:atomify/atomify.dart';

class Option {
  final String value;
  final Box label;

  Option({required this.value, required this.label});
}

class Select extends Box {
  final List<Option> options;
  final Option? selected;

  final void Function(Option)? onOptionSelected;

  Select({
    required this.options,
    this.onOptionSelected,
    this.selected,
    super.ref,
    super.id,
    super.className,
    super.attributes,
    super.onRender,
    super.style,
  }) : super(tagName: 'select') {
    ref?.init(this);
  }

  @override
  HTMLElement render() {
    final element = super.render() as HTMLSelectElement;
    for (var option in options) {
      final optionElement = HTMLOptionElement()..value = option.value;
      optionElement.append(option.label.render());
      element.append(optionElement);
    }

    if (selected?.value != null) {
      if (options.any((option) => option.value == selected!.value)) {
        element.value = selected!.value;
      }
    }

    element.onchange =
        (event) {
          final selectedOption = options.firstWhere(
            (option) => option.value == element.value,
            orElse: () => options.first,
          );
          onOptionSelected?.call(selectedOption);
        }.toJS;

    return element;
  }
}
