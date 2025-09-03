import 'package:atomify/atomify.dart';

/// Represents a video element in the DOM.
/// The [Video] class extends the [Box] class and provides properties
/// to configure the video element such as `src`, `autoplay`, `controls`, `loop`, and `preload`.
class Video extends Box {
  final String src;
  final bool autoplay;
  final bool controls;
  final bool loop;
  final String? preload;

  Video({
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
  }) : super(tagName: 'video');

  @override
  HTMLElement render() {
    final element = super.render() as HTMLVideoElement;
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
