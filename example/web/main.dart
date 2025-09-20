import 'dart:js_interop';

import 'package:atomify/atomify.dart';
import 'src/sheets.dart';
import 'package:web/web.dart' as web;
final pageRef = PageRef();
void main() {
  App(
    developmentMode: true,
    initializationTimeout: Duration(seconds: 5),
    target: '#output',
    beforeRender: () => useCss(
      styles: [
        Cssify.create('.sheets-app', {
          'base': {
            'style': {
              'font-family': 'Inter, system-ui, sans-serif',
              'user-select': 'none',
            },
          },
        }),
      ],
    ),
    children: [
      Page(
        id: "views",
        ref: pageRef,
        views: [Sheets()],
        onPageChange: (view) {},
        onRender: (e) {},
      ),
    ],
    onRender: (element, instance) {
      // disable context menu
      element.addEventListener(
        'contextmenu',
        (web.Event e) {
         e.preventDefault();
        }.toJS,
      );
    },
  ).run();
}
