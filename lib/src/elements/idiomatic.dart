import 'package:ui/src/ui.dart';
import 'package:web/web.dart' as web;

class I extends Box {
  String? cite;
  String? datetime;
  String? lang;
  String? dir;
  String? title;
  String? accessKey;
  String? contentEditable;
  String? inputMode;
  String? spellCheck;
  String? tabIndex;
  String? translate;

  I({
    this.cite,
    this.datetime,
    this.lang,
    this.dir,
    this.title,
    this.accessKey,
    this.contentEditable,
    this.inputMode,
    this.spellCheck,
    this.tabIndex,
    this.translate,
    super.id,
    super.className,
    super.attributes,
    super.style,
    super.text,
    super.onRender,
  }) : super(tagName: 'i');

  @override
  web.HTMLElement render() {
    final element = super.render();
    if (cite != null) element.setAttribute('cite', cite!);
    if (datetime != null) element.setAttribute('datetime', datetime!);
    if (lang != null) element.setAttribute('lang', lang!);
    if (dir != null) element.setAttribute('dir', dir!);
    if (title != null) element.setAttribute('title', title!);
    if (accessKey != null) element.setAttribute('accesskey', accessKey!);
    if (contentEditable != null) {
      element.setAttribute('contenteditable', contentEditable!);
    }
    if (inputMode != null) element.setAttribute('inputmode', inputMode!);
    if (spellCheck != null) element.setAttribute('spellcheck', spellCheck!);
    if (tabIndex != null) element.setAttribute('tabindex', tabIndex!);
    if (translate != null) element.setAttribute('translate', translate!);
    return element;
  }
}

enum IconPack { material, lineIcons, fontAwesome, other }

useIcon({IconPack pack = IconPack.lineIcons, String? fontURL}) {
  switch (pack) {
    case IconPack.material:
      if (fontURL != null) {
        // Load Material Icons font from the provided URL
        web.document.head!.append(
          web.HTMLLinkElement()
            ..rel = 'stylesheet'
            ..href = fontURL,
        );
      } else {
        web.document.head!.append(
          web.HTMLLinkElement()
            ..rel = 'stylesheet'
            ..href = 'https://fonts.googleapis.com/icon?family=Material+Icons',
        );
      }

      break;
    case IconPack.lineIcons:
      if (fontURL != null) {
        // Load Line Icons font from the provided URL
        web.document.head!.append(
          web.HTMLLinkElement()
            ..rel = 'stylesheet'
            ..href = fontURL,
        );
      } else {
        web.document.head!.append(
          web.HTMLLinkElement()
            ..rel = 'stylesheet'
            ..href = 'https://cdn.lineicons.com/5.0/lineicons.css',
        );
      }
      break;
    case IconPack.fontAwesome:
      if (fontURL != null) {
        // Load Font Awesome Icons font from the provided URL
        web.document.head!.append(
          web.HTMLLinkElement()
            ..rel = 'stylesheet'
            ..href = fontURL,
        );
      } else {
        web.document.head!.append(
          web.HTMLLinkElement()
            ..rel = 'stylesheet'
            ..href =
                'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css',
        );
      }
      break;
    case IconPack.other:
      if (fontURL != null) {
        // Load custom icon font from the provided URL
        web.document.head!.append(
          web.HTMLLinkElement()
            ..rel = 'stylesheet'
            ..href = fontURL,
        );
      }
      break;
  }
}
