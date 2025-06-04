import 'package:ui/src/elements/box.dart';
import 'package:ui/src/core/style.dart';
import 'package:ui/src/states/theme_state.dart';
import 'package:web/web.dart' as web;

typedef ThemeBuilder = Box Function(ThemeState state);

class Theme extends Box {
  final ThemeBuilder builder;
  final Map<String, Style> defaultStyles;
  late ThemeState _state;

  Theme({
    required this.builder,
    Map<String, Style>? styles,
    String? id,
    String? className,
    String? tagName,
    Map<String, String>? attributes,
  }) : defaultStyles = styles ?? {};

  @override
  web.HTMLElement render() {
    final element = super.render();

    _state = ThemeState(this, defaultStyles);
    element.appendChild(builder(_state).render());
    return element;
  }
}
