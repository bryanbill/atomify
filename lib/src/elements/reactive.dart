import 'package:ui/ui.dart';

class Reactive<T> extends Box {
  final ReactiveRef ref;
  final Box Function(T state) builder;
  final T? initialState;
  Reactive({
    required this.ref,
    required this.builder,
    this.initialState,
    super.id,
    super.className,
    super.style,
    super.attributes,
    super.onRender,
  }) : super(tagName: 'div') {
    ref.init(this);
  }

  @override
  render() {
    final element = super.render();
    if (initialState != null) {
      final initialBox = builder(initialState as T);
      element.append(initialBox.render());
    }

    ref.stream.listen((state) {
      final newBox = builder(state).render();
      final hashCode = newBox.hashCode;
      if (hashCode == ref.current?.hashCode) {
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
