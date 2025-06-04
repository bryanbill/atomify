import 'package:ui/ui.dart';

class RailRef extends Ref<Rail> {
  RailRef([Rail? rail]) {
    current = rail;
  }

  List<Box> get items => current?.items ?? [];

  int get selectedIndex => current?.selectedIndex ?? 0;

  void onItemSelected(int index) {
    if (current != null && current!.onItemSelected != null) {
      current!.onItemSelected!(index);
    }
  }

  void init(Rail rail) {
    current = rail;
  }

  void push(int index) {
    if (current != null) {
      current!.push(index);
    }
  }
}
