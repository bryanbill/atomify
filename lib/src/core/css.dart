import 'package:cssify/cssify.dart';
import 'package:web/web.dart';

void useCss({
  List<Cssify> styles = const [],
  Map<String, MediaConfig>? mediaQueries,
  String? target,
}) {
  final styleElement = HTMLStyleElement();
  styleElement.setAttribute('type', 'text/css');

  final css = cssify(styles, mediaConfig: mediaQueries);

  styleElement.textContent = css;
  if (target != null) {
    final targetElement = document.querySelector(target);
    if (targetElement != null) {
      targetElement.prepend(styleElement);
    } else {
      throw Exception('Target element $target not found in the document.');
    }
  } else {
    document.head?.append(styleElement);
  }
}
