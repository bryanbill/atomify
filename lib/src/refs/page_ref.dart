import 'package:atomify/atomify.dart';

/// A reference class for managing page state and navigation.
/// It holds a reference to the current page and provides methods to push views onto the page.
class PageRef extends Ref {
  Page? page;
  PageRef({this.page});

  /// Adds a page to the reference.
  void add(Page page) {
    this.page = page;
  }

  /// Pushes the specified view onto the page.
  /// [viewId] is the ID of the view to push.
  /// [params] are the parameters to pass to the view.
  /// Throws an exception if the view is not found in the page's views.
  void push(String viewId, {Map<String, String> params = const {}}) {
    if (page == null) {
      throw Exception('PageRef is not initialized with a Page.');
    }

    if (page!.currentView.id == viewId) {
      return; // No need to push the same view again
    }

    if (!page!.views.any((v) => v.id == viewId)) {
      throw Exception('View with id $viewId not found in the page.');
    }

    page!.currentView.dispose();

    final view = page!.views.firstWhere(
      (v) => v.id == viewId,
      orElse: () => throw Exception('View with id $viewId not found.'),
    );
    page!.clear();
    page!.append(
      view.element = view.render(
        Map<String, String>.from(params)..addAll(page!.params),
      ),
    );

    view.applyStyles();

    page!.setCurrentView(view);

    page!.onPageChange?.call(view);
    page!.setQueryParams({page!.id!: viewId});
  }
}
