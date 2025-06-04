import 'package:ui/ui.dart';

/// Base Ref class for referencing Box elements.
abstract class Ref<T extends Box> {
  T? current;

  void dispose() {
    current?.remove();
    current = null;
  }
}
