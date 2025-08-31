import 'package:atomify/atomify.dart';

class Stack {
  static final List<Box> _boxes = [];

  static void push(Box box) {
    _boxes.add(box);
  }

  static Box pop() {
    if (_boxes.isNotEmpty) {
      return _boxes.removeLast();
    }
    throw Exception('Stack is empty');
  }

  static Box peek() {
    if (_boxes.isNotEmpty) {
      return _boxes.last;
    }
    throw Exception('Stack is empty');
  }

  /// Find a box by a [query] string.
  /// Valid queries are:
  /// - `id`: Find a box by its ID.
  /// - `className`: Find a box by its class name.
  /// - `tagName`: Find a box by its tag name.
  static Box? find(String query) {
    for (final box in _boxes) {
      if (box.id == query || box.className == query || box.tagName == query) {
        return box;
      }
    }
    return null;
  }

  static bool get isEmpty => _boxes.isEmpty;

  static List<Box> get boxes => List.unmodifiable(_boxes);

  @override
  String toString() {
    return 'Stack{boxes: $_boxes}';
  }
}
