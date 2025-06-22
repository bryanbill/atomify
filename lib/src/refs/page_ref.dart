import 'package:ui/src/ui.dart';

class PageRef extends Ref<Page> {
  PageRef([Page? page]) {
    current = page;
  }

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

  void init(Page page) {
    current = page;
  }

  void push(int index) {
    if (current != null) {
      current!.push(index);
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
}
