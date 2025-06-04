import 'package:ui/src/elements/box.dart';
import 'package:ui/src/core/style.dart';
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

    if (children.length == 1) {
      // If only one child, make it span all columns unless it sets its own width
      final child = children.first;
      final childElement = child.render();
      // Only set gridColumn if child style does not specify width
      final childStyle = child.style;
      if (childStyle == null || childStyle.get(Css.width) == null) {
        childElement.style.setProperty('grid-column', '1 / -1');
      }
      element.append(childElement);
    } else {
      for (final child in children) {
        element.append(child.render());
      }
    }
    return element;
  }
}
