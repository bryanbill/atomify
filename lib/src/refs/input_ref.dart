import 'package:ui/ui.dart';

/// InputRef allows programmatic access to an Input box.
class InputRef extends Ref<Input> {
  InputRef([Input? input]) {
    current = input;
  }

  String? get value => current?.value;

  set value(String? newValue) {
    if (current != null) {
      current!.value = newValue;
    }
  }

  void init(Input input) {
    current = input;
  }
}
