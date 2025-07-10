# 🧪 Atomify

> **Small. Reactive. Simple.**

Atomify is an idiomatic Dart library for building web applications with a laser focus on simplicity and reactivity. True to its name, Atomify breaks down UI development into atomic, composable elements that are both lightweight and powerful.

## ✨ Why Atomify?

- **🪶 Minimal Footprint**: Built to be lightweight without sacrificing functionality
- **⚡ Reactive by Design**: State changes automatically trigger UI updates
- **🧩 Atomic Components**: Everything is a composable `Box` - from simple text to complex layouts
- **📦 Zero Dependencies**: Only depends on `web` and `cssify` packages
- **🎯 Idiomatic Dart**: Leverages Dart's strengths for clean, readable code

## 🚀 Quick Start

### Installation

Add Atomify to your `pubspec.yaml`:

```yaml
dependencies:
  atomify: ^0.1.0
```

### Hello World

```dart
import 'package:atomify/atomify.dart';

void main() {
  App(
    children: [
      Container(
        children: [
          Text('Hello, Atomify! 👋'),
        ],
      ),
    ],
  ).run();
}
```

## 🧱 Core Concepts

### Everything is a Box

In Atomify, every UI element inherits from `Box`. This atomic approach ensures consistency and composability:

```dart
// Text is a Box
Text('Hello World')

// Button is a Box  
Button(Text('Click me'), onClick: (e) => print('Clicked!'))

// Container is a Box that holds other Boxes
Container(
  children: [
    Text('Title'),
    Button(Text('Action')),
  ],
)
```

### Reactive State Management

Atomify makes reactivity effortless with `ReactiveRef` and `Reactive` widgets:

```dart
void main() {
  final counterRef = ReactiveRef<int>(0);
  
  App(
    children: [
      Container(
        children: [
          Reactive<int>(
            ref: counterRef,
            initialState: 0,
            builder: (count) => Text('Count: $count'),
          ),
          Button(
            Text('Increment'),
            onClick: (e) => counterRef.emit((counterRef.state ?? 0) + 1),
          ),
        ],
      ),
    ],
  ).run();
}
```

### Page Navigation

Built-in page routing that's simple yet powerful:

```dart
final pageRef = PageRef();

Page(
  ref: pageRef,
  pages: [
    Container(id: 'home', children: [Text('Home Page')]),
    Container(id: 'about', children: [Text('About Page')]),
  ],
)

// Navigate programmatically
pageRef.goTo('about');
```

## 🎨 Styling

Atomify integrates seamlessly with the `cssify` package for type-safe CSS:

```dart
import 'package:atomify/atomify.dart';
import 'package:cssify/cssify.dart';

List<Cssify> styles = [
    Cssify.create(".my-container", {
        "base": {
            "style": {
                "background-color": "#f0f0f0",
                "padding": "20px",
                "border-radius": "8px",
            },
            "state": {
                "hover": {
                    "background-color": "#e0e0e0",
                },
            }
        },
        "md": {
            "style": {
                "padding": "30px",
            }
        },
    })
];

useCss(styles);
Container(
  className: 'my-container',
  children: [
    Text('Styled content'),
  ],
);
```

## 📦 Available Elements

Atomify provides a rich set of atomic elements:

- **Layout**: `Container`, `Box`
- **Text**: `Text`
- **Interactive**: `Button`, `Input`, `Link`
- **Data**: `Table`
- **Async**: `Async` (for handling Future data)
- **Progress**: `Progress` indicators
- **Reactive**: `Reactive` (for state-driven UI)

## 🧩 Creating your own Box
To create your own custom Box, simply extend the `Box` class and implement the `render` method:

```dart
import 'package:atomify/atomify.dart';

class CustomBox extends Box {
  // Pass child 
  final Box? child;
  ... // Define any properties you need
  CustomBox({
    this.child,
    super.id,
    super.className,
    ... other properties,
  }): super(tag: 'custom-box');

  @override
  HTMLElement render() {
    final element = super.render();

    if(child != null) {
      element.append(child!.render());
    }

    return element;
  }
}



## 🏗️ Architecture

```
App
├── Container (Layout)
│   ├── Text (Content)
│   ├── Button (Interactive)
│   └── Reactive (State-driven)
│       └── Builder Function
└── Page (Navigation)
    ├── Route 1
    ├── Route 2
    └── Route N
```

## 🎯 Real-World Example

```dart
import 'package:atomify/atomify.dart';

void main() {
  final todoRef = ReactiveRef<List<String>>([]);
  final inputRef = InputRef();

  App(
    children: [
      Container(
        className: 'todo-app',
        children: [
          Text('📝 Todo App', className: 'title'),
          
          Container(
            className: 'input-section',
            children: [
              Input(
                ref: inputRef,
                placeholder: 'Add a new task...',
              ),
              Button(
                Text('Add'),
                onClick: (e) {
                  final value = inputRef.value;
                  if (value.isNotEmpty) {
                    todoRef.value = [...todoRef.value, value];
                    inputRef.clear();
                  }
                },
              ),
            ],
          ),
          
          Reactive<List<String>>(
            ref: todoRef,
            builder: (todos) => Container(
              className: 'todo-list',
              children: todos.map((todo) => 
                Container(
                  className: 'todo-item',
                  children: [Text(todo)],
                )
              ).toList(),
            ),
          ),
        ],
      ),
    ],
  ).run(target: "#root", beforeRender: (){
    // Optional: Any setup before rendering
  });
}
```

## 📚 Philosophy

Atomify embraces the principle that **simple tools create powerful applications**. By focusing on:

1. **Atomic Design**: Small, reusable components
2. **Reactive Patterns**: Automatic UI updates from state changes  
3. **Minimal API Surface**: Less to learn, more to build
4. **Type Safety**: Leverage Dart's strong typing

We enable developers to build robust web applications without the complexity traditionally associated with web frameworks.

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guide](CONTRIBUTING.md) for details.

## 📄 License

MIT License - see [LICENSE](LICENSE) for details.

---

<div align="center">
  <strong>Built with ❤️ and Dart</strong><br>
  <em>Making web development atomic, one component at a time.</em>
</div>