import 'dart:async';

import 'package:atomify/atomify.dart';

class ReactiveRef<T> extends Ref {
  StreamSubscription? _subscription;
  final StreamController<T> _controller = StreamController<T>.broadcast();
  Stream<T> get stream => _controller.stream;
  final Map<String, dynamic> props = {};

  T? state;

  ReactiveRef([Box? initialBox]) {
    if (initialBox != null) {
      current = initialBox;
    }
  }
  @override
  void init(Box box) {
    current = box;
    state = box is Reactive<T> ? box.initialState : null;
    _subscription?.cancel();
  }

  void emit(T value, [Map<String, dynamic> data = const {}]) {
    if (_controller.isClosed) {
      throw StateError('Cannot emit value on a closed stream.');
    }
    _controller.add(value);
    props.addAll(data);
    state = value;
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _controller.close();

    super.dispose();
  }
}
