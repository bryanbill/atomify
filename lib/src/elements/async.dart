import 'package:atomify/atomify.dart';

class Async<T> extends Box {
  /// This function is called to fetch the data asynchronously.
  final Future<T> Function() future;

  /// This function is called with the fetched data.
  final void Function(T) then;

  /// Initial box to render while the future is being resolved.
  /// This box will be removed once the future resolves.
  final Box? initialBox;

  /// This function is called if an error occurs during the fetch.
  final void Function(Object)? onError;

  /// Creates an Async box that fetches data asynchronously.
  Async({
    required this.future,
    required this.then,
    this.initialBox,
    this.onError,
    super.id,
    super.className,
    super.style,
    super.attributes,
    super.onRender,
    super.ref,
  }) : super(tagName: "div");

  @override
  HTMLElement render() {
    final element = super.render();
    if (initialBox != null) {
      element.append(initialBox!.render());
    }
    future()
        .then((data) {
          if (initialBox != null) {
            initialBox!.remove();
          }

          then(data);
        })
        .catchError((error) {
          if (onError != null) {
            onError!(error);
          } else {
            print('Error fetching data: $error');
          }
        });

    return element;
  }
}
