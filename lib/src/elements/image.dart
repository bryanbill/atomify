import 'package:atomify/atomify.dart';

class Image extends Box {
  final String src;
  final String? alt;
  final String? width;
  final String? height;
  final void Function()? onLoad;
  final void Function()? onError;
  final String? crossOrigin;
  final String? referrerPolicy;

  Image({
    required this.src,
    this.alt,
    this.width,
    this.height,
    this.onLoad,
    this.onError,
    this.crossOrigin,
    this.referrerPolicy,
    super.ref,
    super.id,
    super.className,
    super.style,
    super.attributes,
  }) : super(tagName: 'img');

  @override
  HTMLElement render() {
    final element = super.render() as HTMLImageElement;
    element
      ..src = src
      ..alt = alt ?? ''
      ..onLoad.listen((event) {
        if (onLoad != null) onLoad!();
      })
      ..onError.listen((event) {
        if (onError != null) onError!();
      });
    if (width != null) element.width = int.tryParse(width!) ?? 0;
    if (height != null) element.height = int.tryParse(height!) ?? 0;
    if (crossOrigin != null) element.crossOrigin = crossOrigin!;
    if (referrerPolicy != null) element.referrerPolicy = referrerPolicy!;
    return element;
  }
}
