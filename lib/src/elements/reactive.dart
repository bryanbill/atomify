import 'package:atomify/atomify.dart';

class Reactive<T> extends Box {
  final Box Function(T state) builder;
  final T? initialState;
  Reactive({
    required this.builder,
    this.initialState,
    required super.ref,
    super.id,
    super.className,
    super.style,
    super.attributes,
    super.onRender,
  });

  @override
  render() {
    final element = super.render();
    if (initialState != null) {
      final initialBox = builder(initialState as T);
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
