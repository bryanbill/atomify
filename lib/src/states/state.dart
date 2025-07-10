import 'package:atomify/src/elements/box.dart';

abstract class State {
  final Box box;
  final Map<String, dynamic> data;

  const State(this.box, [this.data = const {}]);

  void update() {
    box.update();
  }
}
