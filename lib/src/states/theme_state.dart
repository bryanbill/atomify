import 'package:ui/ui.dart';

class ThemeState extends State {
  final Map<String, Style> styles;

  ThemeState(super.box, this.styles);

  Style? getStyle(String name) => styles[name];
}
