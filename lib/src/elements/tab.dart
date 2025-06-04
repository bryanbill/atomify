import 'package:ui/ui.dart';
import 'package:web/web.dart';

enum TabAxis { horizontal, vertical }

enum TabPosition { top, bottom, left, right }

/// Enum for all style slots in Tab
enum TabStyleSlot { header, btn, btnActive, content }

class Tab extends Box {
  final List<Box> tabs;
  final List<Box> children;
  final TabRef? ref;
  final void Function(int index)? onTabChange;
  int currentTabIndex;
  final TabAxis? orientation;
  final TabPosition? position;

  /// Allows overriding default styles for tab-header, tab-btn, tab-btn-active, tab-content.
  final Map<TabStyleSlot, Style>? tabStyles;

  Tab({
    this.tabs = const [],
    this.children = const [],
    this.currentTabIndex = 0,
    this.onTabChange,
    this.ref,
    this.orientation,
    this.position,
    this.tabStyles,
    required super.id,
    super.className,
    super.attributes,
    super.style,
    super.onRender,
  }) : super(tagName: 'div') {
    if (currentTabIndex < 0 || currentTabIndex >= tabs.length) {
      throw ArgumentError('currentTabIndex must be within the range of tabs.');
    }
    if (tabs.length != children.length) {
      throw ArgumentError('Tabs and children must have the same length.');
    }
    var queryTab = Uri.base.queryParameters['$id:ix'];
    if (queryTab != null) {
      var index = int.tryParse(queryTab);
      if (index != null && index >= 0 && index < children.length) {
        currentTabIndex = index;
      }
    }
    ref?.init(this);

    // Use custom styles if provided, else use defaults
    final stylesToUse = [
      tabStyles?[TabStyleSlot.header] ?? _defaultTabHeaderStyle,
      tabStyles?[TabStyleSlot.btn] ?? _defaultTabBtnStyle,
      tabStyles?[TabStyleSlot.btnActive] ?? _defaultTabBtnActiveStyle,
      tabStyles?[TabStyleSlot.content] ?? _defaultTabContentStyle,
    ];
    useStyle(stylesToUse);
  }

  late HTMLElement _element;

  void push(int index) {
    if (index < 0 || index >= tabs.length) {
      throw RangeError('Index $index is out of range for tabs.');
    }
    var tab = children[index];
    currentTabIndex = index;

    // update the active tab button
    final tabHeader = _element.querySelector('.tab-header');
    if (tabHeader != null) {
      for (var i = 0; i < tabHeader.children.length; i++) {
        final btn = tabHeader.children.item(i);
        if (btn != null) {
          if (i == index) {
            btn.classList.add('tab-btn-active');
          } else {
            btn.classList.remove('tab-btn-active');
          }
        }
      }
    }

    final contentArea = _element.querySelector('.tab-content');
    if (contentArea != null) {
      for (var i = 0; i < contentArea.children.length; i++) {
        contentArea.children.item(i)?.remove();
      }
      contentArea.append(tab.render());
    }

    onTabChange?.call(index);

    // set to tab query parameter
    var uri = Uri.parse(Uri.base.toString());
    var otherQuery = uri.queryParametersAll;
    uri = uri.replace(
      queryParameters: {...otherQuery, '$id:ix': index.toString()},
    );
    window.history.pushState(null, '', uri.toString());
  }

  @override
  HTMLElement render() {
    _element = super.render();

    // Header for tabs
    final tabHeader = document.createElement('div') as HTMLDivElement;
    tabHeader.className = 'tab-header';

    for (var i = 0; i < tabs.length; i++) {
      final tabBtn = tabs[i].render();
      tabBtn.classList.add('tab-btn');
      if (i == currentTabIndex) {
        tabBtn.classList.add('tab-btn-active');
      }
      tabBtn.onClick.listen((_) {
        if (i != currentTabIndex) {
          push(i);
          render();
        }
      });
      tabHeader.append(tabBtn);
    }

    // Content area
    final contentArea = document.createElement('div');
    contentArea.className = 'tab-content';
    if (children.isNotEmpty) {
      contentArea.append(children[currentTabIndex].render());
    }

    // Layout logic
    final orientationValue = orientation ?? TabAxis.horizontal;
    final positionValue = position ?? TabPosition.top;

    if (orientationValue == TabAxis.vertical) {
      final layout = document.createElement('div') as HTMLDivElement;
      layout.style.display = 'flex';
      if (positionValue == TabPosition.left) {
        layout.append(tabHeader);
        layout.append(contentArea);
        tabHeader.style.flexDirection = 'column';
        tabHeader.style.marginRight = '1rem';
      } else {
        layout.append(contentArea);
        layout.append(tabHeader);
        tabHeader.style.flexDirection = 'column';
        tabHeader.style.marginLeft = '1rem';
      }
      _element.append(layout);
    } else {
      if (positionValue == TabPosition.top) {
        _element.append(tabHeader);
        _element.append(contentArea);
        tabHeader.style.marginBottom = '1rem';
      } else {
        _element.append(contentArea);
        _element.append(tabHeader);
        tabHeader.style.marginTop = '1rem';
      }
    }

    return _element;
  }

 
  // Default styles
  static final Style _defaultTabHeaderStyle = Style('tab-header', {
    Breakpoint.base: StyleBlock(
      styles: {
        Css.display: 'flex',
        Css.gap: '0.5rem',
        Css.margin: '0 0 1rem 0',
      },
    ),
  });

  static final Style _defaultTabBtnStyle = Style('tab-btn', {
    Breakpoint.base: StyleBlock(
      styles: {
        Css.backgroundColor: 'transparent',
        Css.border: 'none',
        Css.padding: '0.5rem 1rem',
        Css.fontWeight: '600',
        Css.fontSize: '1rem',
        Css.cursor: 'pointer',
        Css.transition: 'background 0.2s, color 0.2s',
        Css.borderRadius: '0.375rem',
      },
    ),
  });

  static final Style _defaultTabBtnActiveStyle = Style('tab-btn-active', {
    Breakpoint.base: StyleBlock(
      styles: {Css.fontWeight: '700', Css.border: 'none', Css.outline: 'none'},
    ),
  });

  static final Style _defaultTabContentStyle = Style('tab-content', {
    Breakpoint.base: StyleBlock(
      styles: {
        Css.padding: '1rem',
        Css.backgroundColor: '#fff',
        Css.borderRadius: '0.5rem',
        Css.boxShadow: '0 1px 2px rgba(0,0,0,0.05)',
      },
    ),
  });
}
