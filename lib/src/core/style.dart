import 'package:web/web.dart' as web;

enum Css {
  // Colors
  background,
  backgroundAttachment,
  backgroundBlendMode,
  backgroundClip,
  backgroundColor,
  backgroundImage,
  backgroundOrigin,
  backgroundPosition,
  backgroundRepeat,
  backgroundSize,
  color,
  opacity,

  // Dimensions
  width,
  height,
  minWidth,
  minHeight,
  maxWidth,
  maxHeight,

  // Margin & Padding
  margin,
  marginTop,
  marginRight,
  marginBottom,
  marginLeft,
  padding,
  paddingTop,
  paddingRight,
  paddingBottom,
  paddingLeft,

  // Borders
  border,
  borderTop,
  borderRight,
  borderBottom,
  borderLeft,
  borderColor,
  borderStyle,
  borderWidth,
  borderRadius,
  borderTopLeftRadius,
  borderTopRightRadius,
  borderBottomLeftRadius,
  borderBottomRightRadius,
  borderCollapse,
  borderSpacing,

  // Positioning
  position,
  top,
  right,
  bottom,
  left,
  zIndex,

  // Display & Visibility
  display,
  visibility,
  overflow,
  overflowX,
  overflowY,
  boxSizing,
  float,
  clear,

  // Flexbox
  flex,
  flexBasis,
  flexDirection,
  flexFlow,
  flexGrow,
  flexShrink,
  flexWrap,
  justifyContent,
  alignItems,
  alignContent,
  alignSelf,
  order,

  // Grid
  grid,
  gridArea,
  gridAutoColumns,
  gridAutoFlow,
  gridAutoRows,
  gridColumn,
  gridColumnEnd,
  gridColumnGap,
  gridColumnStart,
  gridGap,
  gridRow,
  gridRowEnd,
  gridRowGap,
  gridRowStart,
  gridTemplate,
  gridTemplateAreas,
  gridTemplateColumns,
  gridTemplateRows,

  // Typography
  font,
  fontFamily,
  fontSize,
  fontStyle,
  fontWeight,
  fontVariant,
  fontStretch,
  fontFeatureSettings,
  lineHeight,
  letterSpacing,
  wordSpacing,
  textAlign,
  textDecoration,
  textDecorationColor,
  textDecorationLine,
  textDecorationStyle,
  textIndent,
  textOverflow,
  textShadow,
  textTransform,
  whiteSpace,
  direction,
  unicodeBidi,
  verticalAlign,

  // Lists
  listStyle,
  listStyleImage,
  listStylePosition,
  listStyleType,

  // Backgrounds & Effects
  boxShadow,
  filter,
  backdropFilter,
  mixBlendMode,

  // Cursors & User Interaction
  cursor,
  pointerEvents,
  userSelect,
  resize,

  // Tables
  tableLayout,
  captionSide,
  emptyCells,

  // Transitions & Animations
  transition,
  transitionDelay,
  transitionDuration,
  transitionProperty,
  transitionTimingFunction,
  animation,
  animationDelay,
  animationDirection,
  animationDuration,
  animationFillMode,
  animationIterationCount,
  animationName,
  animationPlayState,
  animationTimingFunction,

  // Misc
  clip,
  clipPath,
  content,
  quotes,
  willChange,
  outline,
  outlineColor,
  outlineOffset,
  outlineStyle,
  outlineWidth,
  objectFit,
  objectPosition,
  shapeOutside,
  shapeMargin,
  shapeImageThreshold,
  tabSize,
  scrollbarColor,
  scrollbarWidth,
  gap,

  // Transforms
  transform,
  transformOrigin,
  transformStyle,
  perspective,
  backfaceVisibility,
  perspectiveOrigin,
  transformBox,
  transformRotate,
  transformScale,
  transformTranslate,
  transformSkew,
  transformMatrix,
}

enum Breakpoint { base, sm, md, lg, xl }

enum PseudoState {
  active,
  anyLink,
  blank,
  checked,
  current,
  defaultState,
  defined,
  dirLtr,
  dirRtl,
  disabled,
  empty,
  enabled,
  first,
  firstChild,
  firstOfType,
  focus,
  focusVisible,
  focusWithin,
  fullscreen,
  future,
  has,
  host,
  hostWithSelector,
  hostContext,
  hover,
  inRange,
  indeterminate,
  invalid,
  isSelector,
  lang,
  lastChild,
  lastOfType,
  left,
  link,
  localLink,
  modal,
  notSelector,
  nthChild,
  nthLastChild,
  nthLastOfType,
  nthOfType,
  onlyChild,
  onlyOfType,
  optional,
  outOfRange,
  past,
  paused,
  pictureInPicture,
  placeholderShown,
  playing,
  readOnly,
  readWrite,
  required,
  right,
  root,
  scope,
  target,
  targetWithin,
  userInvalid,
  userValid,
  valid,
  visited,
  whereSelector,
  before,
  after,
}

class Breakpoints {
  static Map<Breakpoint, String> media = {
    Breakpoint.sm: '@media (min-width: 640px)',
    Breakpoint.md: '@media (min-width: 768px)',
    Breakpoint.lg: '@media (min-width: 1024px)',
    Breakpoint.xl: '@media (min-width: 1280px)',
  };

  static void configure(Map<Breakpoint, String> custom) {
    media = {...media, ...custom};
  }
}

/// Structure for styles per breakpoint and pseudo state
class StyleBlock {
  final Map<Css, String> styles;
  final Map<PseudoState, Map<Css, String>> states;

  StyleBlock({
    Map<Css, String>? styles,
    Map<PseudoState, Map<Css, String>>? states,
  }) : styles = styles ?? {},
       states = states ?? {};
}

class Style {
  final String name;
  final Map<Breakpoint, StyleBlock> blocks;

  /// Example usage:
  /// Style('btn', {
  ///   Breakpoint.base: StyleBlock(
  ///     styles: {Css.color: 'red'},
  ///     states: {PseudoState.hover: {Css.color: 'blue'}}
  ///   ),
  ///   Breakpoint.md: StyleBlock(
  ///     styles: {Css.fontSize: '2rem'},
  ///     states: {PseudoState.hover: {Css.color: 'green'}}
  ///   ),
  /// })
  Style(this.name, Map<Breakpoint, StyleBlock> blocks)
    : blocks = {for (final entry in blocks.entries) entry.key: entry.value};

  /// Helper for legacy/short syntax
  factory Style.legacy(
    String name,
    Map<Css, String> baseStyles, {
    Map<Css, String>? sm,
    Map<Css, String>? md,
    Map<Css, String>? lg,
    Map<Css, String>? xl,
    Map<PseudoState, Map<Css, String>>? baseStates,
    Map<PseudoState, Map<Css, String>>? smStates,
    Map<PseudoState, Map<Css, String>>? mdStates,
    Map<PseudoState, Map<Css, String>>? lgStates,
    Map<PseudoState, Map<Css, String>>? xlStates,
  }) {
    return Style(name, {
      Breakpoint.base: StyleBlock(styles: baseStyles, states: baseStates),
      if (sm != null || smStates != null)
        Breakpoint.sm: StyleBlock(styles: sm, states: smStates),
      if (md != null || mdStates != null)
        Breakpoint.md: StyleBlock(styles: md, states: mdStates),
      if (lg != null || lgStates != null)
        Breakpoint.lg: StyleBlock(styles: lg, states: lgStates),
      if (xl != null || xlStates != null)
        Breakpoint.xl: StyleBlock(styles: xl, states: xlStates),
    });
  }

  void set(Css prop, String value, {Breakpoint breakpoint = Breakpoint.base}) {
    blocks.putIfAbsent(breakpoint, () => StyleBlock()).styles[prop] = value;
  }

  void setState(
    PseudoState state,
    Css prop,
    String value, {
    Breakpoint breakpoint = Breakpoint.base,
  }) {
    blocks
            .putIfAbsent(breakpoint, () => StyleBlock())
            .states
            .putIfAbsent(state, () => {})[prop] =
        value;
  }

  String? get(Css prop, {Breakpoint breakpoint = Breakpoint.base}) {
    return blocks[breakpoint]?.styles[prop];
  }

  Map<Css, String> toMap({Breakpoint breakpoint = Breakpoint.base}) {
    final styles = blocks[breakpoint]?.styles ?? {};
    for (var entry in styles.entries) {
      validate(entry.key, entry.value);
    }
    return Map.unmodifiable(styles);
  }

  /// Injects the CSS for all breakpoints and pseudo states into the document head.
  /// Optionally, you can specify a target element to append the styles to.
  /// If no target is specified, it defaults to the document head.
  void injectCss({String? target}) {
    String camelToKebab(String input) => input.replaceAllMapped(
      RegExp(r'[A-Z]'),
      (m) => '-${m.group(0)!.toLowerCase()}',
    );

    final styleElement =
        web.document.createElement('style') as web.HTMLStyleElement;
    final buffer = StringBuffer();

    blocks.forEach((bp, block) {
      final selectorPrefix = '.$name';
      final media = bp == Breakpoint.base ? null : Breakpoints.media[bp];

      // Base styles for this breakpoint
      if (block.styles.isNotEmpty) {
        final cssString = block.styles.entries
            .map((entry) => '${camelToKebab(entry.key.name)}: ${entry.value};')
            .join(' ');
        if (media != null) {
          buffer.writeln('$media { $selectorPrefix { $cssString } }');
        } else {
          buffer.writeln('$selectorPrefix { $cssString }');
        }
      }

      // Pseudo state styles for this breakpoint
      block.states.forEach((state, styles) {
        final pseudo = _pseudoSelector(state);
        final cssString = styles.entries
            .map((entry) => '${camelToKebab(entry.key.name)}: ${entry.value};')
            .join(' ');
        final selector = '$selectorPrefix$pseudo';
        if (media != null) {
          buffer.writeln('$media { $selector { $cssString } }');
        } else {
          buffer.writeln('$selector { $cssString }');
        }
      });
    });

    styleElement.textContent = buffer.toString();
    if (target != null) {
      final targetElement = web.document.querySelector(target);
      if (targetElement != null) {
        targetElement.append(styleElement);
      } else {
        throw ArgumentError(
          'Target element "$target" not found in the document.',
        );
      }
    } else {
      web.document.head!.append(styleElement);
    }
  }

  static String _pseudoSelector(PseudoState state) {
    switch (state) {
      case PseudoState.active:
        return ':active';
      case PseudoState.anyLink:
        return ':any-link';
      case PseudoState.blank:
        return ':blank';
      case PseudoState.checked:
        return ':checked';
      case PseudoState.current:
        return ':current';
      case PseudoState.defaultState:
        return ':default';
      case PseudoState.defined:
        return ':defined';
      case PseudoState.dirLtr:
        return ':dir(ltr)';
      case PseudoState.dirRtl:
        return ':dir(rtl)';
      case PseudoState.disabled:
        return ':disabled';
      case PseudoState.empty:
        return ':empty';
      case PseudoState.enabled:
        return ':enabled';
      case PseudoState.first:
        return ':first';
      case PseudoState.firstChild:
        return ':first-child';
      case PseudoState.firstOfType:
        return ':first-of-type';
      case PseudoState.focus:
        return ':focus';
      case PseudoState.focusVisible:
        return ':focus-visible';
      case PseudoState.focusWithin:
        return ':focus-within';
      case PseudoState.fullscreen:
        return ':fullscreen';
      case PseudoState.future:
        return ':future';
      case PseudoState.has:
        return ':has(*)'; // Placeholder, requires argument for selector
      case PseudoState.host:
        return ':host';
      case PseudoState.hostWithSelector:
        return ':host(*)'; // Placeholder, requires argument for selector
      case PseudoState.hostContext:
        return ':host-context(*)'; // Placeholder, requires argument for selector
      case PseudoState.hover:
        return ':hover';
      case PseudoState.inRange:
        return ':in-range';
      case PseudoState.indeterminate:
        return ':indeterminate';
      case PseudoState.invalid:
        return ':invalid';
      case PseudoState.isSelector:
        return ':is(*)'; // Placeholder, requires argument for selector
      case PseudoState.lang:
        return ':lang(*)'; // Placeholder, requires argument for language
      case PseudoState.lastChild:
        return ':last-child';
      case PseudoState.lastOfType:
        return ':last-of-type';
      case PseudoState.left:
        return ':left';
      case PseudoState.link:
        return ':link';
      case PseudoState.localLink:
        return ':local-link';
      case PseudoState.modal:
        return ':modal';
      case PseudoState.notSelector:
        return ':not(*)'; // Placeholder, requires argument for selector
      case PseudoState.nthChild:
        return ':nth-child(*)'; // Placeholder, requires argument for n
      case PseudoState.nthLastChild:
        return ':nth-last-child(*)'; // Placeholder, requires argument for n
      case PseudoState.nthLastOfType:
        return ':nth-last-of-type(*)'; // Placeholder, requires argument for n
      case PseudoState.nthOfType:
        return ':nth-of-type(*)'; // Placeholder, requires argument for n
      case PseudoState.onlyChild:
        return ':only-child';
      case PseudoState.onlyOfType:
        return ':only-of-type';
      case PseudoState.optional:
        return ':optional';
      case PseudoState.outOfRange:
        return ':out-of-range';
      case PseudoState.past:
        return ':past';
      case PseudoState.paused:
        return ':paused';
      case PseudoState.pictureInPicture:
        return ':picture-in-picture';
      case PseudoState.placeholderShown:
        return ':placeholder-shown';
      case PseudoState.playing:
        return ':playing';
      case PseudoState.readOnly:
        return ':read-only';
      case PseudoState.readWrite:
        return ':read-write';
      case PseudoState.required:
        return ':required';
      case PseudoState.right:
        return ':right';
      case PseudoState.root:
        return ':root';
      case PseudoState.scope:
        return ':scope';
      case PseudoState.target:
        return ':target';
      case PseudoState.targetWithin:
        return ':target-within';
      case PseudoState.userInvalid:
        return ':user-invalid';
      case PseudoState.userValid:
        return ':user-valid';
      case PseudoState.valid:
        return ':valid';
      case PseudoState.visited:
        return ':visited';
      case PseudoState.whereSelector:
        return ':where(*)'; // Placeholder, requires argument for selector
      case PseudoState.before:
        return '::before';
      case PseudoState.after:
        return '::after';
    }
  }

  void validate(Css prop, String value) {
    // Validation logic for CSS properties

    final numberWithUnit = RegExp(
      r'^-?\d+(\.\d+)?(px|em|rem|%|vh|vw|vmin|vmax|ch|ex|cm|mm|in|pt|pc)?$',
    );
    final colorPattern = RegExp(
      r'^(#[0-9a-fA-F]{3,8}|rgba?\([^)]+\)|hsla?\([^)]+\)|[a-zA-Z]+)$',
    );
    final integerPattern = RegExp(r'^-?\d+$');
    final urlPattern = RegExp(r'^url\([^)]+\)$');
    final keywordPattern = RegExp(r'^[a-zA-Z\-]+$');

    bool isValid = false;

    switch (prop) {
      // Color properties
      case Css.backgroundColor:
      case Css.color:
      case Css.borderColor:
      case Css.outlineColor:
      case Css.textDecorationColor:
      case Css.scrollbarColor:
        isValid = colorPattern.hasMatch(value);
        break;

      // Numeric with units
      case Css.width:
      case Css.height:
      case Css.minWidth:
      case Css.minHeight:
      case Css.maxWidth:
      case Css.maxHeight:
      case Css.margin:
      case Css.marginTop:
      case Css.marginRight:
      case Css.marginBottom:
      case Css.marginLeft:
      case Css.padding:
      case Css.paddingTop:
      case Css.paddingRight:
      case Css.paddingBottom:
      case Css.paddingLeft:
      case Css.borderWidth:
      case Css.borderRadius:
      case Css.borderTopLeftRadius:
      case Css.borderTopRightRadius:
      case Css.borderBottomLeftRadius:
      case Css.borderBottomRightRadius:
      case Css.fontSize:
      case Css.lineHeight:
      case Css.letterSpacing:
      case Css.wordSpacing:
      case Css.top:
      case Css.right:
      case Css.bottom:
      case Css.left:
      case Css.outlineWidth:
      case Css.outlineOffset:
      case Css.gap:
      case Css.gridGap:
      case Css.gridColumnGap:
      case Css.gridRowGap:
      case Css.tabSize:
        isValid = numberWithUnit.hasMatch(value);
        break;

      // Integer only
      case Css.zIndex:
      case Css.order:
      case Css.animationIterationCount:
        isValid = integerPattern.hasMatch(value) || value == 'infinite';
        break;

      // URL values
      case Css.backgroundImage:
      case Css.listStyleImage:
      case Css.cursor:
      case Css.clipPath:
      case Css.shapeOutside:
        isValid = urlPattern.hasMatch(value) || keywordPattern.hasMatch(value);
        break;

      // Opacity (0-1)
      case Css.opacity:
        final num? op = num.tryParse(value);
        isValid = op != null && op >= 0 && op <= 1;
        break;

      // Keywords (for most other properties)
      default:
        isValid =
            keywordPattern.hasMatch(value) ||
            numberWithUnit.hasMatch(value) ||
            colorPattern.hasMatch(value) ||
            urlPattern.hasMatch(value);
    }

    if (!isValid) {
      throw ArgumentError('Invalid value "$value" for property ${prop.name}');
    }
  }

  @override
  String toString() {
    return blocks.entries
        .map(
          (e) =>
              '${e.key}: { ${e.value.styles.entries.map((e) => '${e.key.name}: ${e.value};').join(' ')} }',
        )
        .join(' | ');
  }
}

/// Global way of defining all styles
void useStyle(List<Style> styles, {String? target}) {
  for (var style in styles) {
    style.injectCss(target: target);
  }
}
