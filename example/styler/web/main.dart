import 'package:ui/ui.dart';

void main() {
  App(
    children: [
      Text("Welcome to the Styler Example", className: "header"),
      Container(className: "container", children: [Text("Hello, World!")]),
    ],
    beforeRender: () {
      useFont(fontFamily: "League Spartans");
      useStyle(appStyles);
    },
  ).run(target: '#output', onRender: (box) {});
}

List<Style> appStyles = [
  Style('container', {
    Breakpoint.base: StyleBlock(
      styles: {
        Css.display: "flex",
        Css.flexDirection: "column",
        Css.alignItems: "center",
      },
      states: {
        PseudoState.hover: {Css.backgroundColor: "lightblue"},
      },
    ),
    Breakpoint.md: StyleBlock(
      styles: {Css.flexDirection: "row", Css.justifyContent: "space-around"},
    ),
  }),

  Style('header', {
    Breakpoint.base: StyleBlock(
      styles: {
        Css.fontSize: "2rem",
        Css.textAlign: "center",
        Css.marginBottom: "1rem",
        Css.color: "red",
      },
    ),
  }),
];
