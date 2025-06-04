import 'package:ui/src/elements/box.dart';
import 'package:web/web.dart';

enum TextVariant {
  h1,
  h2,
  h3,
  h4,
  h5,
  h6,
  p,
  span,
  strong,
  em,
  small,
  code,
  blockquote,
  pre,
  u, // Underline
  sub, // Subscript
  sup, // Superscript
  mark, // Highlight
  del, // Strikethrough
  ins, // Inserted text
  kbd, // Keyboard input
  samp, // Sample output
}

String _variantToTag(TextVariant variant) {
  switch (variant) {
    case TextVariant.h1:
      return 'h1';
    case TextVariant.h2:
      return 'h2';
    case TextVariant.h3:
      return 'h3';
    case TextVariant.h4:
      return 'h4';
    case TextVariant.h5:
      return 'h5';
    case TextVariant.h6:
      return 'h6';
    case TextVariant.p:
      return 'p';
    case TextVariant.span:
      return 'span';
    case TextVariant.strong:
      return 'strong';
    case TextVariant.em:
      return 'em';
    case TextVariant.small:
      return 'small';
    case TextVariant.code:
      return 'code';
    case TextVariant.blockquote:
      return 'blockquote';
    case TextVariant.pre:
      return 'pre';
    case TextVariant.u:
      return 'u';
    case TextVariant.sub:
      return 'sub';
    case TextVariant.sup:
      return 'sup';
    case TextVariant.mark:
      return 'mark';
    case TextVariant.del:
      return 'del';
    case TextVariant.ins:
      return 'ins';
    case TextVariant.kbd:
      return 'kbd';
    case TextVariant.samp:
      return 'samp';
  }
}

class Text extends Box {
  final TextVariant variant;

  /// Creates a text element with the specified [text] content and [variant].
  Text(
    String text, {
    this.variant = TextVariant.p,
    super.id,
    super.className,
    super.attributes,
    super.style,
    String? tagName,
    super.onRender,
  }) : super(
         text: text,
         tagName: tagName ?? _variantToTag(variant),
       );

  @override
  HTMLElement render({String? newId}) {
    final element = super.render();
    return element;
  }
}

/// Applies the [fontFamily] and [fontUrl] to the document.
void useFont({
  /// The font family to use for the text elements
  /// Defaults to "League Spartan".
  String? fontFamily = "League Spartan",

  /// A valid Google Fonts URL for the specified [fontFamily].
  String? fontUrl =
      "https://fonts.googleapis.com/css2?family=League+Spartan:wght@400;600;700;800&display=swap",
}) {
  final head = document.head!;
  final link = document.createElement('link') as HTMLLinkElement;
  link.rel = 'stylesheet';
  link.href = fontUrl ?? '';
  head.append(link);

  // Set global font-family
  final style = document.createElement('style') as HTMLStyleElement;
  style.textContent = '''
    html, body {
      font-family: '$fontFamily', sans-serif;
    }
  ''';
  head.append(style);
}
