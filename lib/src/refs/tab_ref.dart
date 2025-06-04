import 'package:ui/src/ui.dart';

class TabRef extends Ref<Tab> {
  TabRef([Tab? tab]) {
    current = tab;
  }

  List<Box> get tabs => current?.tabs ?? [];

  List<Box> get children => current?.children ?? [];

  void init(Tab tab) {
    current = tab;
  }

  void onTabChange(int index) {
    if (current != null && current!.onTabChange != null) {
      current!.onTabChange!(index);
    }
  }

  void push(int index) {
    if (current != null) {
      current!.push(index);
    }
  }
}
