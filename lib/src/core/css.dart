import 'package:cssify/cssify.dart';
import 'package:web/web.dart';

void useCss({
  List<Cssify> styles = const [],
  Map<String, MediaConfig>? mediaQueries,
}) {
  final styleElement = HTMLStyleElement();
  styleElement.setAttribute('type', 'text/css');

  final css = cssify(styles, mediaConfig: mediaQueries);

  styleElement.textContent = css;
  document.head?.append(styleElement);
}
