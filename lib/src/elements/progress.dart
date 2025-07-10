import 'package:atomify/atomify.dart';
import 'package:web/web.dart' as web;

/// Implements the HTML <progress> element with all MDN and web standard attributes.
/// See: https://developer.mozilla.org/en-US/docs/Web/HTML/Element/progress
class Progress extends Box {
  final double? value;
  final double? max;
  final String? form;
  final String? name;
  final String? label; // Optional label for accessibility (not rendered here)
  final String? ariaValueText;
  final String? ariaLabel;
  final String? ariaLabelledBy;
  final String? ariaDescribedBy;
  final String?
  fallback; // Fallback text for browsers that don't support <progress>

  Progress({
    this.value,
    this.max,
    this.form,
    this.name,
    this.label,
    this.ariaValueText,
    this.ariaLabel,
    this.ariaLabelledBy,
    this.ariaDescribedBy,
    this.fallback,
    super.ref,
    super.id,
    super.className,
    super.style,
    super.attributes,
    super.onRender,
  }) : super(tagName: 'progress');

  @override
  web.HTMLElement render({String? newId}) {
    final element =
        web.document.createElement('progress') as web.HTMLProgressElement;
    if (id != null) element.id = id!;
    if (className != null) element.className = className!;
    if (value != null) element.value = value!;
    if (max != null) element.max = max!;
    if (form != null) element.setAttribute('form', form!);
    if (name != null) element.setAttribute('name', name!);
    if (ariaValueText != null) {
      element.setAttribute('aria-valuetext', ariaValueText!);
    }
    if (ariaLabel != null) element.setAttribute('aria-label', ariaLabel!);
    if (ariaLabelledBy != null) {
      element.setAttribute('aria-labelledby', ariaLabelledBy!);
    }
    if (ariaDescribedBy != null) {
      element.setAttribute('aria-describedby', ariaDescribedBy!);
    }
    attributes?.forEach((k, v) => element.setAttribute(k, v));
    // Add fallback text for unsupported browsers
    if (fallback != null) {
      final fallbackNode = web.document.createTextNode(fallback!);
      element.append(fallbackNode);
    }
    // Note: label is not rendered here; user should compose <label> + <progress> as needed.
    return element;
  }
}
