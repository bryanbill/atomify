import 'package:ui/src/elements/box.dart';
import 'package:web/web.dart';

class Container extends Box {
  final List<Box> children;

  Container({
    required this.children,
    super.id,
    super.className,
    super.attributes,
    super.style,
    super.onRender,
  }) : super(tagName: 'div');

  @override
  HTMLElement render() {
    final element = super.render();
    for (var i = 0; i < element.children.length; i++) {
      element.children.item(i)?.remove();
    }
    for (final child in children) {
      element.append(child.render());
    }

    return element;
  }
}
