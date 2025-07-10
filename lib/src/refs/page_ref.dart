import 'dart:async';

import 'package:atomify/src/atomify.dart';

class PageRef extends Ref<Page> {
  PageRef([Page? page]) {
    current = page;
  }

  final StreamController<int> _controller = StreamController<int>.broadcast();

  List<Box> get pages => current?.pages ?? [];

  set pages(List<Box> newPages) {
    if (current != null) {
      current!.pages = newPages;
    }
  }

  int get currentPageIndex => current?.currentPageIndex ?? 0;

  set currentPageIndex(int index) {
    if (current != null) {
      current!.currentPageIndex = index;
    }
  }

  @override
  void init(Page box) {
    current = box;
  }

  void push(int index) {
    if (current != null) {
      current!.push(index);
      _controller.add(index);
    }
  }

  void goTo(String id) {
    if (current != null) {
      var index = current!.pages.indexWhere((page) => page.id == id);
      if (index != -1) {
        current!.push(index);
      } else {
        throw ArgumentError('Page with id $id not found.');
      }
    }
  }

  void onPageChange(void Function(int) callback) {
    _controller.stream.listen(callback);
  }

  @override
  void dispose() {
    _controller.close();
    _controller.stream.drain();
    current?.remove();
    current = null;
  }
}
