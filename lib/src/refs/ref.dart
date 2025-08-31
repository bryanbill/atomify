import 'package:atomify/atomify.dart';

/// Base Ref class for referencing Box elements.
abstract class Ref<T extends Box> {
  T? current;

  void dispose() {
    current?.dispose();
    current = null;
  }

  void init(T box) {
    current = box;
  }
}

class BoxRef<T extends Box> extends Ref<T> {
  BoxRef([T? box]) {
    if (box != null) {
      current = box;
    }
  }

  @override
  void init(T box) {
    current = box;
  }

  @override
  void dispose() {
    current?.remove();
    current = null;
  }
}
