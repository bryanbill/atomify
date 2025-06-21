import 'package:ui/src/elements/box.dart';
import 'package:ui/src/refs/page_ref.dart';
import 'package:web/web.dart';

class Page extends Box {
  List<Box> pages;
  int currentPageIndex;
  final void Function(int index, {Box? page})? onPageChange;
  final PageRef? ref;

  /// [id] is required here as it is used to identify the page in the DOM.
  Page({
    this.pages = const [],
    this.currentPageIndex = 0,
    this.onPageChange,
    this.ref,
    required super.id,
    super.className,
    super.attributes,
    super.style,
    super.onRender,
  }) : super(tagName: 'div') {
    var queryPage = Uri.base.queryParameters['$id:ix'];
    if (queryPage != null) {
      var index = int.tryParse(queryPage);
      if (index != null && index >= 0 && index < pages.length) {
        currentPageIndex = index;
      }
    }

    if (currentPageIndex < 0 || currentPageIndex >= pages.length) {
      throw ArgumentError(
        'currentPageIndex must be within the range of pages.',
      );
    }

    ref?.init(this);
  }

  late HTMLElement _element;

  void push(int index) {
    if (index < 0 || index >= pages.length) {
      throw RangeError('Index $index is out of range for pages.');
    }
    _clear();

    var page = pages[index];
    currentPageIndex = index;

    _element.appendChild(page.render());

    onPageChange?.call(index, page: page);
    // set to page query parameter
    var uri = Uri.parse(Uri.base.toString());
    var otherQuery = uri.queryParametersAll;
    uri = uri.replace(
      queryParameters: {...otherQuery, '$id:ix': index.toString()},
    );
    window.history.pushState(null, '', uri.toString());
  }

  void _clear() {
    for (var i = 0; i < _element.children.length; i++) {
      _element.children.item(i)?.remove();
    }
  }

  @override
  HTMLElement render() {
    _element = super.render();
    var initial = pages[currentPageIndex];

    _element.appendChild(initial.render());

    return _element;
  }
}
