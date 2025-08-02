import 'package:atomify/atomify.dart';

class Audio extends Box {
  final String src;
  final bool autoplay;
  final bool controls;
  final bool loop;
  final String? preload;

  Audio({
    required this.src,
    this.autoplay = false,
    this.controls = true,
    this.loop = false,
    this.preload,
    super.ref,
    super.id,
    super.className,
    super.style,
    super.attributes,
  }) : super(tagName: 'audio');

  @override
  HTMLElement render() {
    final element = super.render() as HTMLAudioElement;
    element.src = src;
    element.autoplay = autoplay;
    element.controls = controls;
    element.loop = loop;
    if (preload != null) {
      element.preload = preload!;
    }
    return element;
  }
}
