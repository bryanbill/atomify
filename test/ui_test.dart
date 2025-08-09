import 'package:test/test.dart';
import 'package:atomify/atomify.dart';

void main() {
  group('Box Tests', () {
    test('should create a basic Box with default properties', () {
      final box = Container(children: []);
      expect(box.tagName, equals('div'));
      expect(box.id, isNull);
      expect(box.className, isNull);
      expect(box.style, isNull);
    });

    test('should create a Box with custom properties', () {
      final box = Container(
        children: [],
        id: 'test-id',
        className: 'test-class',
        style: 'color: red;',
      );
      expect(box.id, equals('test-id'));
      expect(box.className, equals('test-class'));
      expect(box.style, equals('color: red;'));
    });
  });

  group('Container Tests', () {
    test('should create a Container with children', () {
      final container = Container(children: [Text('Hello'), Text('World')]);
      expect(container.children.length, equals(2));
      expect(container.tagName, equals('div'));
    });

    test('should create empty Container', () {
      final container = Container(children: []);
      expect(container.children.length, equals(0));
    });

    test('should create Container with attributes', () {
      final container = Container(
        children: [],
        id: 'container-id',
        className: 'container-class',
        attributes: {'data-test': 'value'},
      );
      expect(container.id, equals('container-id'));
      expect(container.className, equals('container-class'));
      expect(container.attributes?['data-test'], equals('value'));
    });
  });

  group('Text Tests', () {
    test('should create a Text element with content', () {
      final text = Text('Hello World');
      expect(text.text, equals('Hello World'));
      expect(text.tagName, equals('p'));
    });

    test('should create Text with different variants', () {
      final h1 = Text('Title', variant: TextVariant.h1);
      final span = Text('Inline', variant: TextVariant.span);
      final strong = Text('Bold', variant: TextVariant.strong);

      expect(h1.variant, equals(TextVariant.h1));
      expect(span.variant, equals(TextVariant.span));
      expect(strong.variant, equals(TextVariant.strong));
    });

    test('should create Text with custom styling', () {
      final text = Text(
        'Styled text',
        className: 'text-class',
        style: 'font-size: 16px;',
      );
      expect(text.text, equals('Styled text'));
      expect(text.className, equals('text-class'));
      expect(text.style, equals('font-size: 16px;'));
    });
  });

  group('Button Tests', () {
    test('should create a Button with label', () {
      final button = Button(Text('Click me'));
      expect(button.label, isA<Text>());
      expect(button.disabled, equals(false));
      expect(button.tagName, equals('button'));
    });

    test('should create a disabled Button', () {
      final button = Button(Text('Disabled'), disabled: true);
      expect(button.disabled, equals(true));
    });

    test('should create Button with custom attributes', () {
      final button = Button(
        Text('Custom'),
        id: 'btn-id',
        className: 'btn-class',
        attributes: {'data-action': 'submit'},
      );
      expect(button.id, equals('btn-id'));
      expect(button.className, equals('btn-class'));
      expect(button.attributes?['data-action'], equals('submit'));
    });
  });

  group('Input Tests', () {
    test('should create a basic Input', () {
      final input = Input();
      expect(input.type, equals('text'));
      expect(input.disabled, equals(false));
      expect(input.tagName, equals('input'));
    });

    test('should create Input with custom properties', () {
      final input = Input(
        value: 'initial',
        placeholder: 'Enter text',
        type: 'email',
        disabled: true,
      );
      expect(input.value, equals('initial'));
      expect(input.placeholder, equals('Enter text'));
      expect(input.type, equals('email'));
      expect(input.disabled, equals(true));
    });

    test('should create Input with styling', () {
      final input = Input(
        id: 'input-id',
        className: 'input-class',
        style: 'border: 1px solid red;',
      );
      expect(input.id, equals('input-id'));
      expect(input.className, equals('input-class'));
      expect(input.style, equals('border: 1px solid red;'));
    });
  });

  group('Link Tests', () {
    test('should create a Link with href', () {
      final link = Link(child: Text('Visit'), href: 'https://example.com');
      expect(link.href, equals('https://example.com'));
      expect(link.child, isA<Text>());
      expect(link.tagName, equals('a'));
    });

    test('should create Link with target and rel', () {
      final link = Link(
        child: Text('External'),
        href: 'https://example.com',
        target: '_blank',
        rel: 'noopener',
      );
      expect(link.target, equals('_blank'));
      expect(link.rel, equals('noopener'));
    });

    test('should handle empty href properly', () {
      // The assertion is in the constructor, so we test during construction
      expect(
        () => Link(child: Text('Test'), href: ''),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('Progress Tests', () {
    test('should create a basic Progress element', () {
      final progress = Progress();
      expect(progress.tagName, equals('progress'));
      expect(progress.value, isNull);
      expect(progress.max, isNull);
    });

    test('should create Progress with value and max', () {
      final progress = Progress(value: 0.7, max: 1.0);
      expect(progress.value, equals(0.7));
      expect(progress.max, equals(1.0));
    });

    test('should create Progress with accessibility attributes', () {
      final progress = Progress(
        value: 0.5,
        max: 1.0,
        ariaLabel: 'Loading progress',
        ariaValueText: '50% complete',
      );
      expect(progress.ariaLabel, equals('Loading progress'));
      expect(progress.ariaValueText, equals('50% complete'));
    });
  });

  group('Table Tests', () {
    test('should create a basic Table', () {
      final table = Table(children: []);
      expect(table.tagName, equals('table'));
      expect(table.children.length, equals(0));
    });

    test('should create Table with header, body, and footer', () {
      final table = Table(
        children: [
          TableHead(children: []),
          TableBody(children: []),
          TableFoot(children: []),
        ],
      );
      expect(table.children.length, equals(3));
      expect(table.children[0], isA<TableHead>());
      expect(table.children[1], isA<TableBody>());
      expect(table.children[2], isA<TableFoot>());
    });

    test('should create TableRow with TableCell', () {
      final row = TableRow(
        children: [
          TableCell(children: [Text('Cell 1')]),
          TableCell(children: [Text('Cell 2')]),
        ],
      );
      expect(row.tagName, equals('tr'));
      expect(row.children.length, equals(2));
      expect(row.children[0], isA<TableCell>());
    });

    test('should create TableHeaderCell with attributes', () {
      final headerCell = TableHeaderCell(
        children: [Text('Header')],
        scope: 'col',
      );
      expect(headerCell.tagName, equals('th'));
      expect(headerCell.attributes?['scope'], equals('col'));
    });

    test('should create TableCell with colspan and rowspan', () {
      final cell = TableCell(
        children: [Text('Spanning cell')],
        colspan: 2,
        rowspan: 3,
      );
      expect(cell.attributes?['colspan'], equals('2'));
      expect(cell.attributes?['rowspan'], equals('3'));
    });
  });

  group('Async Tests', () {
    test('should create an Async element', () {
      final async = Async<String>(
        future: () => Future.value('test data'),
        then: (data) => Text(data),
      );
      expect(async.tagName, equals('div'));
      expect(async.future, isA<Future<String> Function()>());
      expect(async.then, isA<Box Function(String)>());
    });

    test('should create Async with initial box', () {
      final async = Async<String>(
        future: () => Future.value('loaded'),
        then: (data) => Text(data),
        initialBox: Text('Loading...'),
      );
      expect(async.initialBox, isA<Text>());
      expect(async.initialBox?.text, equals('Loading...'));
    });

    test('should create Async with error handler', () {
      final async = Async<String>(
        future: () => Future.error('Test error'),
        then: (data) => Text(data),
        onError: (error) => Text('Error: $error'),
      );
      expect(async.onError, isNotNull);
    });
  });

  group('Reactive Tests', () {
    test('should create a Reactive element', () {
      final ref = ReactiveRef<int>(0);
      final reactive = Reactive<int>(
        ref: ref,
        builder: (count) => Text('Count: $count'),
      );
      expect(reactive.tagName, equals('div'));
      expect(reactive.ref, equals(ref));
      expect(reactive.builder, isA<Box Function(int)>());
    });

    test('should create Reactive with custom styling', () {
      final ref = ReactiveRef<String>('initial');
      final reactive = Reactive<String>(
        ref: ref,
        builder: (value) => Text(value),
        id: 'reactive-id',
        className: 'reactive-class',
      );

      expect(reactive.id, equals('reactive-id'));
      expect(reactive.className, equals('reactive-class'));
    });
  });

  group('Page Tests', () {
    test('should create a Page with routes', () {
      final page = Page(
        id: 'main-page',
        pages: [
          PageItem(id: 'home', render: (p) => Text('Home')),
          PageItem(id: 'about', render: (p) => Text('About')),
        ],
      );
      expect(page.id, equals('main-page'));
      expect(page.pages.length, equals(2));
      expect(page.currentPageIndex, equals(0));
    });

    test('should create Page with custom current page', () {
      final page = Page(
        id: 'nav-page',
        pages: [
          PageItem(id: 'first', render: (p) => Text('First')),
          PageItem(id: 'second', render: (p) => Text('Second')),
        ],
        currentPageIndex: 1,
      );
      expect(page.currentPageIndex, equals(1));
    });

    test('should throw error for invalid page index', () {
      expect(
        () => Page(
          id: 'invalid-page',
          pages: [PageItem(id: 'only', render: (p) => Text('Only'))],
          currentPageIndex: 5,
        ),
        throwsArgumentError,
      );
    });
  });

  group('Idiomatic Elements Tests', () {
    test('should create an I (italic) element', () {
      final italic = I(text: 'italic text', className: 'icon-class');
      expect(italic.tagName, equals('i'));
      expect(italic.text, equals('italic text'));
      expect(italic.className, equals('icon-class'));
    });

    test('should create I element with custom attributes', () {
      final italic = I(
        cite: 'https://example.com',
        title: 'Icon title',
        lang: 'en',
      );
      expect(italic.cite, equals('https://example.com'));
      expect(italic.title, equals('Icon title'));
      expect(italic.lang, equals('en'));
    });
  });

  group('App Tests', () {
    test('should create an App with children', () {
      final app = App(
        children: [
          Container(children: [Text('Main content')]),
        ],
      );
      expect(app.children.length, equals(1));
      expect(app.children[0], isA<Container>());
    });

    test('should create App with beforeRender callback', () {
      var callbackCalled = false;
      App(
        children: [Text('Test')],
        beforeRender: () {
          callbackCalled = true;
        },
      );
      expect(callbackCalled, isTrue);
    });
  });

  group('Ref Tests', () {
    test('should create a BoxRef', () {
      final ref = BoxRef<Container>();
      expect(ref.current, isNull);
    });

    test('should create InputRef', () {
      final ref = InputRef();
      expect(ref.current, isNull);
    });

    test('should create ReactiveRef with initial value', () {
      final ref = ReactiveRef<String>('initial');
      expect(ref.state, equals('initial'));
    });

    test('should create PageRef', () {
      final ref = PageRef();
      expect(ref.current, isNull);
    });

    test('should initialize BoxRef with box', () {
      final container = Container(children: []);
      final ref = BoxRef<Container>(container);
      expect(ref.current, equals(container));
    });
  });

  group('Stack Tests', () {
    test('should push and pop boxes from stack', () {
      final initialCount = Stack.boxes.length;
      final box = Container(children: []);

      // Box should be automatically pushed to stack during creation
      expect(Stack.boxes.length, equals(initialCount + 1));

      final poppedBox = Stack.pop();
      expect(poppedBox, equals(box));
      expect(Stack.boxes.length, equals(initialCount));
    });

    test('should peek at top box without removing it', () {
      final initialCount = Stack.boxes.length;
      final box = Container(children: []);

      final peekedBox = Stack.peek();
      expect(peekedBox, equals(box));
      expect(Stack.boxes.length, equals(initialCount + 1));
    });

    test('should find box by query', () {
      final box = Container(
        children: [],
        id: 'findable-box',
        className: 'find-class',
      );

      final foundById = Stack.find('findable-box');
      final foundByClass = Stack.find('find-class');

      expect(foundById, equals(box));
      expect(foundByClass, equals(box));
    });

    test('should throw exception when popping from empty stack', () {
      // Clear the stack first
      while (!Stack.isEmpty) {
        Stack.pop();
      }

      expect(() => Stack.pop(), throwsException);
    });
  });

  group('Integration Tests', () {
    test('should create complex nested structure', () {
      final app = App(
        children: [
          Container(
            id: 'main',
            className: 'main-container',
            children: [
              Text('App Title', variant: TextVariant.h1),
              Container(
                className: 'nav',
                children: [
                  Link(child: Text('Home'), href: '/home'),
                  Link(child: Text('About'), href: '/about'),
                ],
              ),
              Container(
                className: 'content',
                children: [
                  Text('Welcome to Atomify!'),
                  Button(
                    Text('Get Started'),
                    onClick: (e) => print('Button clicked'),
                  ),
                ],
              ),
            ],
          ),
        ],
      );

      expect(app.children.length, equals(1));
      final mainContainer = app.children[0] as Container;
      expect(mainContainer.id, equals('main'));
      expect(mainContainer.children.length, equals(3));
    });

    test('should create reactive todo list structure', () {
      final todoRef = ReactiveRef<List<String>>(['Task 1', 'Task 2']);
      final inputRef = InputRef();

      final todoApp = Container(
        className: 'todo-app',
        children: [
          Text('Todo List', variant: TextVariant.h2),
          Input(ref: inputRef, placeholder: 'Add new task...'),
          Button(
            Text('Add Task'),
            onClick: (e) {
              // Would normally add to todoRef.value
            },
          ),
          Reactive<List<String>>(
            ref: todoRef,
            builder:
                (todos) => Container(
                  className: 'todo-list',
                  children:
                      todos
                          .map(
                            (todo) => Container(
                              className: 'todo-item',
                              children: [Text(todo)],
                            ),
                          )
                          .toList(),
                ),
          ),
        ],
      );

      expect(todoApp.children.length, equals(4));
      expect(todoApp.children[0], isA<Text>());
      expect(todoApp.children[1], isA<Input>());
      expect(todoApp.children[2], isA<Button>());
      expect(todoApp.children[3], isA<Reactive<List<String>>>());
    });
  });

  group('Edge Cases and Advanced Tests', () {
    test('should handle null values gracefully', () {
      final container = Container(
        children: [],
        id: null,
        className: null,
        style: null,
      );
      expect(container.id, isNull);
      expect(container.className, isNull);
      expect(container.style, isNull);
    });

    test('should handle Text with empty string', () {
      final text = Text('');
      expect(text.text, equals(''));
    });

    test('should create nested containers', () {
      final nested = Container(
        children: [
          Container(
            children: [
              Container(children: [Text('Deep nested')]),
            ],
          ),
        ],
      );
      expect(nested.children.length, equals(1));
      final level1 = nested.children[0] as Container;
      expect(level1.children.length, equals(1));
      final level2 = level1.children[0] as Container;
      expect(level2.children.length, equals(1));
    });

    test('should handle Input with different types', () {
      final inputs = [
        Input(type: 'text'),
        Input(type: 'email'),
        Input(type: 'password'),
        Input(type: 'number'),
        Input(type: 'url'),
        Input(type: 'tel'),
      ];

      expect(inputs[0].type, equals('text'));
      expect(inputs[1].type, equals('email'));
      expect(inputs[2].type, equals('password'));
      expect(inputs[3].type, equals('number'));
      expect(inputs[4].type, equals('url'));
      expect(inputs[5].type, equals('tel'));
    });

    test('should handle Progress with different value ranges', () {
      final progress1 = Progress(value: 0.0, max: 1.0);
      final progress2 = Progress(value: 0.5, max: 1.0);
      final progress3 = Progress(value: 1.0, max: 1.0);
      final progress4 = Progress(value: 50.0, max: 100.0);

      expect(progress1.value, equals(0.0));
      expect(progress2.value, equals(0.5));
      expect(progress3.value, equals(1.0));
      expect(progress4.value, equals(50.0));
      expect(progress4.max, equals(100.0));
    });

    test('should handle all TextVariant types', () {
      final variants = [
        Text('H1', variant: TextVariant.h1),
        Text('H2', variant: TextVariant.h2),
        Text('H3', variant: TextVariant.h3),
        Text('H4', variant: TextVariant.h4),
        Text('H5', variant: TextVariant.h5),
        Text('H6', variant: TextVariant.h6),
        Text('Paragraph', variant: TextVariant.p),
        Text('Span', variant: TextVariant.span),
        Text('Strong', variant: TextVariant.strong),
        Text('Emphasis', variant: TextVariant.em),
        Text('Small', variant: TextVariant.small),
        Text('Code', variant: TextVariant.code),
        Text('Pre', variant: TextVariant.pre),
        Text('Blockquote', variant: TextVariant.blockquote),
      ];

      expect(variants.length, equals(14));
      expect(variants[0].variant, equals(TextVariant.h1));
      expect(variants[6].variant, equals(TextVariant.p));
      expect(variants[8].variant, equals(TextVariant.strong));
      expect(variants[11].variant, equals(TextVariant.code));
    });
  });

  group('Performance and Memory Tests', () {
    test('should handle large lists efficiently', () {
      final largeList = List.generate(1000, (i) => Text('Item $i'));
      final container = Container(children: largeList);

      expect(container.children.length, equals(1000));
      expect(container.children[0].text, equals('Item 0'));
      expect(container.children[999].text, equals('Item 999'));
    });

    test('should create and dispose refs properly', () {
      final ref = ReactiveRef<int>(0);
      expect(ref.state, equals(0));

      ref.emit(42);
      expect(ref.state, equals(42));

      // Test that ref can be disposed
      ref.dispose();
      expect(() => ref.emit(50), throwsStateError);
    });

    test('should handle multiple reactive refs', () {
      final ref1 = ReactiveRef<String>('first');
      final ref2 = ReactiveRef<int>(1);
      final ref3 = ReactiveRef<bool>(true);

      expect(ref1.state, equals('first'));
      expect(ref2.state, equals(1));
      expect(ref3.state, equals(true));

      ref1.emit('updated');
      ref2.emit(2);
      ref3.emit(false);

      expect(ref1.state, equals('updated'));
      expect(ref2.state, equals(2));
      expect(ref3.state, equals(false));
    });
  });

  group('Accessibility Tests', () {
    test('should create accessible Progress element', () {
      final progress = Progress(
        value: 0.75,
        max: 1.0,
        ariaLabel: 'File upload progress',
        ariaValueText: '75% complete',
        ariaLabelledBy: 'progress-label',
        ariaDescribedBy: 'progress-description',
      );

      expect(progress.ariaLabel, equals('File upload progress'));
      expect(progress.ariaValueText, equals('75% complete'));
      expect(progress.ariaLabelledBy, equals('progress-label'));
      expect(progress.ariaDescribedBy, equals('progress-description'));
    });

    test('should create accessible table structure', () {
      final table = Table(
        children: [
          TableCaption(children: [Text('Sales Data 2024')]),
          TableHead(
            children: [
              TableRow(
                children: [
                  TableHeaderCell(children: [Text('Product')], scope: 'col'),
                  TableHeaderCell(children: [Text('Sales')], scope: 'col'),
                ],
              ),
            ],
          ),
          TableBody(
            children: [
              TableRow(
                children: [
                  TableHeaderCell(children: [Text('Q1')], scope: 'row'),
                  TableCell(children: [Text(r'$1,000')]),
                ],
              ),
            ],
          ),
        ],
      );

      expect(table.children.length, equals(3));
      expect(table.children[0], isA<TableCaption>());
      expect(table.children[1], isA<TableHead>());
      expect(table.children[2], isA<TableBody>());
    });
  });
}
