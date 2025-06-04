import 'package:ui/ui.dart';
import 'package:web/web.dart';

class App {
  final List<Box> children;
  final Map<Breakpoint, String>? breakpoints;
  final Function(Box)? onRender;
  final void Function()? beforeRender;

  App({
    required this.children,
    this.breakpoints,
    this.onRender,
    this.beforeRender,
  }) {
    if (breakpoints != null) {
      Breakpoints.configure(breakpoints!);
    }

    if (beforeRender != null) {
      beforeRender!();
    }
  }

  void run({String target = 'body', Function(Element)? onRender}) {
    try {
      final container = document.querySelector(target);
      if (container == null) {
        throw Exception('Target element "$target" not found.');
      }

      for (var i = 0; i < container.children.length; i++) {
        container.children.item(i)?.remove();
      }

      for (final child in children) {
        container.append(child.render());
      }

      onRender?.call(container);
    } catch (e) {
      print('Error rendering app: $e');
    }
  }
}
