import 'package:atomify/atomify.dart';

class Reactive<T> extends Box {
  final Box Function(T state) builder;

  Reactive({
    required this.builder,
    required super.ref,
    super.id,
    super.className,
    super.style,
    super.attributes,
    super.onRender,
  }) : super(tagName: 'div') {
    assert(ref is ReactiveRef<T>, 'ref must be of type ReactiveRef<T>');
  }

  @override
  render() {
    final element = super.render();
    final ref = super.ref as ReactiveRef;
    if (ref.state != null) {
      final initialBox = builder(ref.state as T);
      element.append(initialBox.render());
    }

    (super.ref as ReactiveRef).stream.listen((state) {
      final newBox = builder(state).render();
      final hashCode = newBox.hashCode;
      if (hashCode == super.ref!.current.hashCode) {
        return; // No change, skip rendering
      }

      for (var i = 0; i < element.children.length; i++) {
        element.children.item(i)?.remove();
      }

      element.append(newBox);
    });
    return element;
  }
}
