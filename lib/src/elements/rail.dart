import 'package:ui/ui.dart';

enum RailAxis { horizontal, vertical }

enum RailPosition { top, bottom, left, right }

enum RailStyleSlot { nav, btn, btnActive, content }

class Rail extends Box {
  final List<Box> rails;
  final List<Box> items;
  final RailAxis? axis;
  final RailPosition? position;
  final RailRef? ref;
  final void Function(int index)? onItemSelected;
  int selectedIndex;
  final Map<RailStyleSlot, Style>? styles;

  Rail({
    required this.rails,
    required this.items,
    this.selectedIndex = 0,
    this.onItemSelected,
    this.ref,
    this.axis = RailAxis.horizontal,
    this.position = RailPosition.bottom,
    this.styles,
    super.id,
    super.className,
    String? tagName,
    super.attributes,
  }) : super(tagName: tagName ?? 'rail') {
    assert(rails.isNotEmpty, 'Rails cannot be empty.');
    if (selectedIndex < 0 || selectedIndex >= items.length) {
      throw ArgumentError('selectedIndex must be within the range of items.');
    }
    if (axis == RailAxis.vertical &&
        (position == RailPosition.top || position == RailPosition.bottom)) {
      throw ArgumentError('For vertical axis, position must be left or right.');
    }
    if ((position == RailPosition.left || position == RailPosition.right) &&
        axis != RailAxis.vertical) {
      throw ArgumentError('For left or right position, axis must be vertical.');
    }
    if (rails.length != items.length) {
      throw ArgumentError('Rails and items must have the same length.');
    }
    ref?.init(this);

    final stylesToUse = [
      styles?[RailStyleSlot.nav] ?? _defaultRailNavStyle,
      styles?[RailStyleSlot.btn] ?? _defaultRailBtnStyle,
      styles?[RailStyleSlot.btnActive] ?? _defaultRailBtnActiveStyle,
      styles?[RailStyleSlot.content] ?? _defaultRailContentStyle,
    ];

    useStyle(stylesToUse);
  }

  late HTMLElement _element;

  void push(int index) {
    if (index < 0 || index >= items.length) {
      throw RangeError('Index $index is out of range for items.');
    }
    selectedIndex = index;

    final nav = _element.querySelector('.rail-nav');
    if (nav != null) {
      for (var i = 0; i < nav.children.length; i++) {
        final btn = nav.children.item(i) as HTMLElement;
        if (i == selectedIndex) {
          btn.classList.add('rail-btn-active');
        } else {
          btn.classList.remove('rail-btn-active');
        }
      }
    }

    final content = _element.querySelector('.rail-content');
    if (content != null) {
      for (var i = 0; i < content.children.length; i++) {
        content.children.item(i)?.remove();
      }
      content.append(items[selectedIndex].render());
    }

    onItemSelected?.call(index);
  }

  void _clear() {
    for (var i = 0; i < _element.children.length; i++) {
      _element.children.item(i)?.remove();
    }
  }

  void _renderContent() {
    _clear();
    final nav = document.createElement('nav') as HTMLElement;
    nav.className = 'rail-nav';

    for (var i = 0; i < rails.length; i++) {
      final btn = rails[i].render();
      btn.classList.add('rail-btn');
      if (i == selectedIndex) {
        btn.classList.add('rail-btn-active');
      }
      btn.onClick.listen((_) {
        if (i != selectedIndex) {
          push(i);
        }
      });
      nav.append(btn);
    }

    final content = document.createElement('div');
    content.className = 'rail-content';
    content.append(items[selectedIndex].render());

    // Layout logic
    final axisValue = axis ?? RailAxis.horizontal;
    final positionValue = position ?? RailPosition.bottom;

    if (axisValue == RailAxis.vertical) {
      final layout = document.createElement('div') as HTMLElement;
      layout.style.display = 'flex';
      if (positionValue == RailPosition.left) {
        layout.append(nav);
        layout.append(content);
        nav.style.flexDirection = 'column';
        nav.style.marginRight = '1rem';
      } else {
        layout.append(content);
        layout.append(nav);
        nav.style.flexDirection = 'column';
        nav.style.marginLeft = '1rem';
      }
      _element.append(layout);
    } else {
      if (positionValue == RailPosition.top) {
        _element.append(nav);
        _element.append(content);
        nav.style.marginBottom = '1rem';
      } else {
        _element.append(content);
        _element.append(nav);
        nav.style.marginTop = '1rem';
      }
    }
  }

  @override
  HTMLElement render() {
    _element = super.render();
    _renderContent();
    return _element;
  }

  static final Style _defaultRailNavStyle = Style('rail-nav', {
    Breakpoint.base: StyleBlock(
      styles: {
        Css.display: 'flex',
        Css.gap: '0.5rem',
        Css.margin: '0 0 1rem 0',
      },
    ),
  });

  static final Style _defaultRailBtnStyle = Style('rail-btn', {
    Breakpoint.base: StyleBlock(
      styles: {
        Css.backgroundColor: 'transparent',
        Css.color: '#374151',
        Css.border: 'none',
        Css.padding: '0.5rem 1rem',
        Css.fontWeight: '600',
        Css.fontSize: '1rem',
        Css.cursor: 'pointer',
        Css.transition: 'background 0.2s, color 0.2s',
        Css.borderRadius: '0.375rem',
      },
      states: {
        PseudoState.hover: {Css.backgroundColor: '#f3f4f6'},
        PseudoState.active: {Css.backgroundColor: '#e5e7eb'},
      },
    ),
  });

  static final Style _defaultRailBtnActiveStyle = Style('rail-btn-active', {
    Breakpoint.base: StyleBlock(
      styles: {
        Css.backgroundColor: '#2563eb',
        Css.color: '#fff',
        Css.fontWeight: '700',
        Css.border: 'none',
        Css.outline: 'none',
      },
    ),
  });

  static final Style _defaultRailContentStyle = Style('rail-content', {
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
