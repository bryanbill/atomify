import 'package:atomify/atomify.dart';

class App {
  final List<Box> children;
  final void Function()? beforeRender;

  App({required this.children, this.beforeRender}) {
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
