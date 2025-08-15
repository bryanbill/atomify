import 'package:atomify/atomify.dart';

final pageRef = PageRef();
void main() {
  App(
    developmentMode: true,
    initializationTimeout: Duration(seconds: 5),
    target: '#output',
    children: [
      Page(
        id: "dash",
        ref: pageRef,
        views: [SplashScreen(), SecondScreen(), TreeScreen()],
        onPageChange: (view) {},
        onRender: (e) {},
      ),
    ],
    onRender: (element, instance) {},
  ).run();
}

class SplashScreen extends View {
  @override
  String id = 'screen-splash';

  @override
  Box render(Map<String, String> params) {
    return Container(
      id: id,
      className: 'container',
      children: [
        Text(params.toString()),
        Button(
          Text('Go to Second Screen'),
          onClick: (e) {
            pageRef.push('screen-second');
          },
        ),
      ],
    );
  }

  @override
  List<Cssify> get styles => [
    Cssify.create('.container', {
      "base": {
        "style": {
          "width": "100%",
          "display": "flex",
          "flex-direction": "column",
          "align-items": "center",
          "justify-content": "center",
          "height": "100vh",
          "background-color": "red",
        },
      },
    }),
  ];
}

class SecondScreen extends View {
  @override
  String id = 'screen-second';

  @override
  Box render(Map<String, String> params) {
    return Container(
      id: id,
      className: 'container',
      children: [
        Text('This is the second screen'),
        Button(
          Text('Go to Tree Screen'),
          onClick: (e) {
            pageRef.push('screen-tree', params: {'name': 'Tree View'});
          },
        ),
      ],
    );
  }

  @override
  List<Cssify> get styles => [
    Cssify.create('.container', {
      "base": {
        "style": {
          "width": "100%",
          "display": "flex",
          "flex-direction": "column",
          "align-items": "center",
          "justify-content": "center",
          "height": "100vh",
          "background-color": "blue",
        },
      },
    }),
  ];

  @override
  void dispose() {
    super.dispose();
    print('Second Screen disposed: ${Stack.boxes.length} boxes remain.');
  }
}

class TreeScreen extends View {
  @override
  String get id => 'screen-tree';

  @override
  Box render(Map<String, String> params) {
    return Container(children: [Text(params['name'] ?? 'Unknown')]);
  }

  @override
  List<Cssify> get styles => [];
}
