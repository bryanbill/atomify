import 'package:atomify/src/elements/box.dart';
import 'package:web/web.dart';

class Page extends Box {
  List<PageItem> pages;
  int currentPageIndex;
  final void Function(Box)? onPageChange;

  /// [id] is required here as it is used to identify the page in the DOM.
  Page({
    this.pages = const [],
    this.currentPageIndex = 0,
    this.onPageChange,
    super.ref,
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

  void push(
    int index, {
    bool scrollToTop = true,
    Map<String, dynamic>? params,
  }) {
    if (index < 0 || index >= pages.length) {
      throw RangeError('Index $index is out of range for pages.');
    }
    _clear();

    // add all the params to the query parameters
    if (params != null) {
      var uri = Uri.parse(Uri.base.toString());
      var otherQuery = uri.queryParametersAll;
      uri = uri.replace(
        queryParameters: {
          ...otherQuery,
          ...params.map((k, v) => MapEntry(k, v.toString())),
        },
      );
      window.history.pushState(null, '', uri.toString());
    }

    var page = pages[index];
    currentPageIndex = index;

    _element.appendChild(page.render(params).render());

    scrollToTop ? this.scrollToTop() : () {}();

    onPageChange?.call(page.render(params));
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

    // get all the query parameters
    var uri = Uri.parse(Uri.base.toString());
    var otherQuery = uri.queryParametersAll;
    var params = {...otherQuery.map((k, v) => MapEntry(k, v.first))};

    _element.appendChild(initial.render(params).render());

    return _element;
  }
}

class PageItem {
  final String id;
  final Box Function(Map<String, dynamic>?) render;
  final void Function(PageItem item)? onRender;

  PageItem({required this.id, required this.render, this.onRender});
}
