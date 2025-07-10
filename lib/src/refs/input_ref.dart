import 'package:atomify/atomify.dart';
import 'package:web/web.dart' as web;

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

  @override
  void init(Input box) {
    current = box;
  }

  /// Clears the input value.
  void clear() {
    if (current != null) {
      current!.value = '';
    }
  }

  /// Add an event listener to the input.
  void on(Event event, void Function(web.Event) callback) {
    current?.on(event, callback);
  }

  /// Removes the input from the DOM.
  @override
  void dispose() {
    current?.remove();
    current = null;
  }
}
