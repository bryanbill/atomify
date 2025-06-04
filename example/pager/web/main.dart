import 'package:ui/ui.dart';

void main() {
  final pageRef = PageRef();
  final nestedPageRef = PageRef();
  final tabRef = TabRef();
  final railRef = RailRef();
  App(
    children: [
      Text("Welcome to Navigation Examples", className: "header"),
      Button(
        Text("Next Page"),
        onClick: (e) {
          pageRef.push((pageRef.currentPageIndex + 1) % pageRef.pages.length);
        },
      ),
      Page(
        id: 'pager',
        ref: pageRef,
        pages: [
          Container(
            style: Style('page-1', {
              Breakpoint.base: StyleBlock(
                styles: {Css.backgroundColor: "lightgreen", Css.color: "black"},
              ),
            }),
            className: "page",
            children: [
              // Nested Page Example
              Button(
                Text("Go to Nested Page"),
                onClick: (e) {
                  nestedPageRef.push(
                    (nestedPageRef.currentPageIndex + 1) %
                        nestedPageRef.pages.length,
                  );
                },
              ),
              Page(
                id: 'page-nested',
                ref: nestedPageRef,
                pages: [
                  Container(
                    style: Style('nested-page-1', {
                      Breakpoint.base: StyleBlock(
                        styles: {
                          Css.backgroundColor: "lightyellow",
                          Css.color: "black",
                        },
                      ),
                    }),
                    className: "page",
                    children: [Text("Nested Page 1")],
                  ),
                  Container(
                    style: Style('nested-page-2', {
                      Breakpoint.base: StyleBlock(
                        styles: {
                          Css.backgroundColor: "lightpink",
                          Css.color: "black",
                        },
                      ),
                    }),
                    className: "page",
                    children: [Text("Nested Page 2")],
                  ),
                ],
              ),
            ],
          ),
          Container(
            style: Style('page-2', {
              Breakpoint.base: StyleBlock(
                styles: {Css.backgroundColor: "blue", Css.color: "black"},
              ),
            }),
            className: "page",
            children: [
              Tab(
                id: 'tab',
                ref: tabRef,
                orientation: TabAxis.horizontal,
                position: TabPosition.top,
                tabStyles: {
                  TabStyleSlot.header: Style('tab-header', {
                    Breakpoint.base: StyleBlock(
                      styles: {
                        Css.display: "flex",
                        Css.justifyContent: "space-around",
                        Css.padding: "0.5rem",
                        Css.backgroundColor: "lightgray",
                      },
                    ),
                  }),
                  TabStyleSlot.btn: Style('tab-btn', {
                    Breakpoint.base: StyleBlock(
                      styles: {
                        Css.backgroundColor: "transparent",
                        Css.color: "#374151",
                        Css.border: "none",
                        Css.padding: "0.5rem 1rem",
                      },
                    ),
                  }),
                },
                tabs: [
                  Button(
                    Text("Tab 1"),
                    onClick: (e) {
                      tabRef.push(0);
                    },
                  ),
                  Button(
                    Text("Tab 2"),
                    onClick: (e) {
                      tabRef.push(1);
                    },
                  ),
                  Button(
                    Text("Tab 3"),
                    onClick: (e) {
                      tabRef.push(2);
                    },
                  ),
                ],
                children: [
                  Container(
                    style: Style('tab-content-1', {
                      Breakpoint.base: StyleBlock(
                        styles: {
                          Css.backgroundColor: "lightgray",
                          Css.color: "black",
                        },
                      ),
                    }),
                    className: "tab-content",
                    children: [Text("Content for Tab 1")],
                  ),
                  Container(
                    style: Style('tab-content-2', {
                      Breakpoint.base: StyleBlock(
                        styles: {
                          Css.backgroundColor: "lightblue",
                          Css.color: "black",
                        },
                      ),
                    }),
                    className: "tab-content",
                    children: [Text("Content for Tab 2")],
                  ),
                  Container(
                    style: Style('tab-content-3', {
                      Breakpoint.base: StyleBlock(
                        styles: {
                          Css.backgroundColor: "lightgreen",
                          Css.color: "black",
                        },
                      ),
                    }),
                    className: "tab-content",
                    children: [Text("Content for Tab 3")],
                  ),
                ],
              ),
            ],
          ),
          Container(
            style: Style('page-3', {
              Breakpoint.base: StyleBlock(
                styles: {Css.backgroundColor: "lightcoral", Css.color: "black"},
              ),
            }),
            className: "page",
            children: [
              Rail(
                rails: [
                  Button(Text("R1"), onClick: (e) => railRef.push(0)),
                  Button(Text("R2"), onClick: (e) => railRef.push(1)),
                ],
                axis: RailAxis.horizontal,
                position: RailPosition.top,
                ref: railRef,
                items: [
                  Text("Content for Rail Item 1"),
                  Text("Content for Rail Item 2"),
                ],
              ),
            ],
          ),
        ],
      ),
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
  Style("page", {
    Breakpoint.base: StyleBlock(
      styles: {
        Css.display: "flex",
        Css.flexDirection: "column",
        Css.alignItems: "center",
        Css.justifyContent: "center",
        Css.height: "80vh",
        Css.width: "100%",
      },
    ),
  }),
];
