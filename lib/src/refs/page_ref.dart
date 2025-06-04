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

  void onPageChange(int index) {
    if (current != null && current!.onPageChange != null) {
      current!.onPageChange!(index);
    }
  }

  void push(int index) {
    if (current != null) {
      current!.push(index);
    }
  }
}
