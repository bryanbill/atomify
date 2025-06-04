import 'package:ui/ui.dart';
import 'package:web/web.dart';

class Link extends Box {
  final Box child;
  final String href;
  final String? target;
  final String? rel;

  /// Creates a link element with the specified [href], [target], and [rel].
  ///
  /// The [child] is the content of the link.
  Link({
    required this.child,
    required this.href,
    this.target,
    this.rel,
    super.id,
    super.className,
    super.attributes,
    super.style,
  }) : super(tagName: 'a') {
    assert(href.isNotEmpty, 'The href attribute cannot be empty.');
  }

  @override
  HTMLElement render() {
    final element = super.render();
    element.setAttribute('href', href);
    if (target != null) {
      element.setAttribute('target', target!);
    }
    if (rel != null) {
      element.setAttribute('rel', rel!);
    }

    final childElement = child.render();
    element.appendChild(childElement);

    return element;
  }
}
