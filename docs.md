# Atomify Elements Documentation

This document provides comprehensive documentation for all Atomify elements, including descriptions, properties, and usage examples.

## Table of Contents

- [Core Elements](#core-elements)
  - [Box](#box)
  - [Container](#container)
  - [Text](#text)
- [Interactive Elements](#interactive-elements)
  - [Button](#button)
  - [Input](#input)
  - [Link](#link)
- [Layout Elements](#layout-elements)
  - [Page](#page)
- [Data Display Elements](#data-display-elements)
  - [Table](#table)
  - [TableHead](#tablehead)
  - [TableBody](#tablebody)
  - [TableFoot](#tablefoot)
  - [TableRow](#tablerow)
  - [TableCell](#tablecell)
  - [TableHeaderCell](#tableheadercell)
  - [TableCaption](#tablecaption)
- [Feedback Elements](#feedback-elements)
  - [Progress](#progress)
- [Reactive Elements](#reactive-elements)
  - [Reactive](#reactive)
  - [Async](#async)
- [Idiomatic Elements](#idiomatic-elements)
  - [I (Italic/Icon)](#i-italicicon)
- [Application](#application)
  - [App](#app)

---

## Core Elements

### Box

The fundamental building block of all Atomify elements. Every element in Atomify inherits from `Box`.

**Description:** Box is the base class that provides common functionality for all UI elements including styling, attributes, event handling, and DOM manipulation.

**Properties:**
- `ref` - Reference to the element for programmatic access
- `id` - HTML id attribute
- `className` - CSS class name
- `style` - Inline CSS styles
- `attributes` - Map of HTML attributes
- `tagName` - HTML tag name (defaults to 'div')
- `text` - Text content
- `onRender` - Callback function called after rendering

**Example:**
```dart
import 'package:atomify/atomify.dart';

// Basic box (though you'd typically use Container instead)
final box = Container(
  children: [],
  id: 'my-box',
  className: 'custom-box',
  style: 'padding: 20px; background: #f0f0f0;',
  attributes: {'data-testid': 'main-box'},
);
```

### Container

A layout element that holds and organizes other elements.

**Description:** Container is the primary layout element in Atomify, used to group and organize child elements. It renders as a `<div>` element and provides flexible layout capabilities.

**Properties:**
- `children` - List of child Box elements
- All Box properties (id, className, style, etc.)

**Example:**
```dart
import 'package:atomify/atomify.dart';

final container = Container(
  id: 'main-container',
  className: 'flex-container',
  style: '''
    display: flex;
    flex-direction: column;
    gap: 1rem;
    padding: 2rem;
  ''',
  children: [
    Text('Welcome to Atomify'),
    Text('A simple UI library'),
    Button(Text('Get Started')),
  ],
);
```

### Text

Displays text content with various semantic variants.

**Description:** Text element provides flexible text rendering with support for different HTML text elements through variants. It handles typography and semantic text display.

**Properties:**
- `text` - The text content to display
- `variant` - TextVariant enum for different HTML elements
- All Box properties

**TextVariant Options:**
- `h1`, `h2`, `h3`, `h4`, `h5`, `h6` - Heading elements
- `p` - Paragraph (default)
- `span` - Inline text
- `strong` - Bold text
- `em` - Emphasized text
- `small` - Small text
- `code` - Inline code
- `pre` - Preformatted text
- `blockquote` - Block quote
- `u` - Underlined text
- `sub` - Subscript
- `sup` - Superscript
- `mark` - Highlighted text
- `del` - Deleted text
- `ins` - Inserted text
- `kbd` - Keyboard input
- `samp` - Sample output

**Example:**
```dart
import 'package:atomify/atomify.dart';

final textElements = Container(
  children: [
    Text('Main Title', variant: TextVariant.h1),
    Text('Subtitle', variant: TextVariant.h2),
    Text('This is a paragraph with regular text.'),
    Text('Important note', variant: TextVariant.strong),
    Text('Code example', variant: TextVariant.code),
    Text('Press Ctrl+C', variant: TextVariant.kbd),
  ],
);
```

---

## Interactive Elements

### Button

A clickable button element for user interactions.

**Description:** Button provides interactive functionality with click handling, disabled states, and flexible content through a label Box.

**Properties:**
- `label` - Box element to display as button content
- `disabled` - Boolean to disable the button
- `onClick` - Click event handler
- `onPressed` - Alternative click event handler
- All Box properties

**Example:**
```dart
import 'package:atomify/atomify.dart';

final buttons = Container(
  children: [
    // Simple text button
    Button(
      Text('Click me'),
      onClick: (event) => print('Button clicked!'),
    ),
    
    // Button with icon and text
    Button(
      Container(
        style: 'display: flex; align-items: center; gap: 8px;',
        children: [
          I(className: 'icon-user'),
          Text('Profile'),
        ],
      ),
      className: 'profile-btn',
      onClick: (event) => print('Profile clicked'),
    ),
    
    // Disabled button
    Button(
      Text('Disabled'),
      disabled: true,
      className: 'disabled-btn',
    ),
  ],
);
```

### Input

Form input element for user data entry.

**Description:** Input provides various input types for form data collection with validation, event handling, and ref support for programmatic access.

**Properties:**
- `value` - Current input value
- `placeholder` - Placeholder text
- `type` - Input type (text, email, password, etc.)
- `disabled` - Boolean to disable input
- `onChanged` - Value change handler
- `onInput` - Input event handler
- `onFocus` - Focus event handler
- `onBlur` - Blur event handler
- All Box properties

**Example:**
```dart
import 'package:atomify/atomify.dart';

final inputRef = InputRef();

final form = Container(
  children: [
    Input(
      placeholder: 'Enter your name',
      type: 'text',
      onChanged: (value) => print('Name: $value'),
    ),
    
    Input(
      placeholder: 'Enter email',
      type: 'email',
      className: 'email-input',
      onFocus: (event) => print('Email focused'),
      onBlur: (event) => print('Email blurred'),
    ),
    
    Input(
      ref: inputRef,
      placeholder: 'Password',
      type: 'password',
    ),
    
    Button(
      Text('Submit'),
      onClick: (event) {
        print('Password: ${inputRef.value}');
        inputRef.clear();
      },
    ),
  ],
);
```

### Link

Hyperlink element for navigation.

**Description:** Link creates anchor elements for navigation with support for external links, targets, and accessibility attributes.

**Properties:**
- `child` - Box element to display as link content
- `href` - URL destination (required)
- `target` - Link target (_blank, _self, etc.)
- `rel` - Relationship attribute (noopener, noreferrer, etc.)
- All Box properties

**Example:**
```dart
import 'package:atomify/atomify.dart';

final navigation = Container(
  children: [
    // Internal link
    Link(
      child: Text('Home'),
      href: '/home',
    ),
    
    // External link
    Link(
      child: Text('Visit GitHub'),
      href: 'https://github.com',
      target: '_blank',
      rel: 'noopener noreferrer',
    ),
    
    // Link with custom content
    Link(
      child: Container(
        style: 'display: flex; align-items: center; gap: 8px;',
        children: [
          I(className: 'icon-external'),
          Text('External Site'),
        ],
      ),
      href: 'https://example.com',
      target: '_blank',
      className: 'external-link',
    ),
  ],
);
```

---

## Layout Elements

### Page

Multi-page navigation container with routing support.

**Description:** Page manages multiple page states with navigation, query parameter handling, and history management for single-page applications.

**Properties:**
- `pages` - List of Box elements representing different pages
- `currentPageIndex` - Index of currently active page
- `onPageChange` - Callback when page changes
- `id` - Required unique identifier for routing
- All Box properties

**Example:**
```dart
import 'package:atomify/atomify.dart';

final pageRef = PageRef();

final multiPageApp = Page(
  id: 'main-app',
  ref: pageRef,
  currentPageIndex: 0,
  onPageChange: (index, {page}) {
    print('Changed to page $index');
  },
  pages: [
    Container(
      id: 'home',
      children: [
        Text('Home Page', variant: TextVariant.h1),
        Text('Welcome to the home page!'),
        Button(
          Text('Go to About'),
          onClick: (e) => pageRef.goTo('about'),
        ),
      ],
    ),
    Container(
      id: 'about',
      children: [
        Text('About Page', variant: TextVariant.h1),
        Text('Learn more about us.'),
        Button(
          Text('Go to Contact'),
          onClick: (e) => pageRef.goTo('contact'),
        ),
      ],
    ),
    Container(
      id: 'contact',
      children: [
        Text('Contact Page', variant: TextVariant.h1),
        Text('Get in touch with us.'),
        Button(
          Text('Go Home'),
          onClick: (e) => pageRef.goTo('home'),
        ),
      ],
    ),
  ],
);
```

---

## Data Display Elements

### Table

HTML table element for structured data display.

**Description:** Table provides structured data display with support for headers, body, footer, and accessibility features.

**Properties:**
- `children` - List of table child elements (TableHead, TableBody, TableFoot)
- All Box properties

**Example:**
```dart
import 'package:atomify/atomify.dart';

final dataTable = Table(
  className: 'data-table',
  children: [
    TableCaption(
      children: [Text('Sales Report 2024')],
    ),
    TableHead(
      children: [
        TableRow(
          children: [
            TableHeaderCell(
              children: [Text('Product')],
              scope: 'col',
            ),
            TableHeaderCell(
              children: [Text('Q1 Sales')],
              scope: 'col',
            ),
            TableHeaderCell(
              children: [Text('Q2 Sales')],
              scope: 'col',
            ),
          ],
        ),
      ],
    ),
    TableBody(
      children: [
        TableRow(
          children: [
            TableHeaderCell(
              children: [Text('Widget A')],
              scope: 'row',
            ),
            TableCell(children: [Text('1,000')]),
            TableCell(children: [Text('1,200')]),
          ],
        ),
        TableRow(
          children: [
            TableHeaderCell(
              children: [Text('Widget B')],
              scope: 'row',
            ),
            TableCell(children: [Text('800')]),
            TableCell(children: [Text('950')]),
          ],
        ),
      ],
    ),
  ],
);
```

### TableHead

Table header section element.

**Description:** Groups table header content, typically containing header rows and cells.

**Properties:**
- `children` - List of TableRow elements
- All Box properties

### TableBody

Table body section element.

**Description:** Contains the main data rows of a table.

**Properties:**
- `children` - List of TableRow elements
- All Box properties

### TableFoot

Table footer section element.

**Description:** Groups table footer content, typically for summary rows.

**Properties:**
- `children` - List of TableRow elements
- All Box properties

### TableRow

Table row element.

**Description:** Represents a row in a table, containing cells.

**Properties:**
- `children` - List of TableCell or TableHeaderCell elements
- All Box properties

### TableCell

Standard table cell element.

**Description:** Represents a data cell in a table row.

**Properties:**
- `children` - List of Box elements for cell content
- `colspan` - Number of columns to span
- `rowspan` - Number of rows to span
- `headers` - Reference to header cells
- All Box properties

### TableHeaderCell

Table header cell element.

**Description:** Represents a header cell in a table with semantic meaning.

**Properties:**
- `children` - List of Box elements for cell content
- `scope` - Scope attribute (col, row, colgroup, rowgroup)
- `colspan` - Number of columns to span
- `rowspan` - Number of rows to span
- `abbr` - Abbreviation for header
- `headers` - Reference to other header cells
- All Box properties

### TableCaption

Table caption element.

**Description:** Provides a title or description for the table.

**Properties:**
- `children` - List of Box elements for caption content
- All Box properties

---

## Feedback Elements

### Progress

Progress indicator element.

**Description:** Displays progress for tasks, loading states, or completion status with full accessibility support.

**Properties:**
- `value` - Current progress value
- `max` - Maximum progress value
- `form` - Associated form id
- `name` - Form control name
- `label` - Accessibility label
- `ariaValueText` - Accessible value description
- `ariaLabel` - Accessible label
- `ariaLabelledBy` - Reference to labeling element
- `ariaDescribedBy` - Reference to description element
- `fallback` - Fallback text for unsupported browsers
- All Box properties

**Example:**
```dart
import 'package:atomify/atomify.dart';

final progressExamples = Container(
  children: [
    // Basic progress bar
    Progress(
      value: 0.7,
      max: 1.0,
      className: 'progress-bar',
    ),
    
    // Accessible progress with labels
    Progress(
      value: 45.0,
      max: 100.0,
      ariaLabel: 'File upload progress',
      ariaValueText: '45 percent complete',
      className: 'upload-progress',
    ),
    
    // Indeterminate progress
    Progress(
      className: 'loading-spinner',
      fallback: 'Loading...',
    ),
  ],
);
```

---

## Reactive Elements

### Reactive

Reactive element that rebuilds based on state changes.

**Description:** Reactive elements automatically update their UI when referenced reactive state changes, enabling dynamic and responsive interfaces.

**Properties:**
- `ref` - ReactiveRef containing the state
- `builder` - Function that builds UI based on current state
- All Box properties

**Example:**
```dart
import 'package:atomify/atomify.dart';

final counterRef = ReactiveRef<int>(0);

final reactiveCounter = Container(
  children: [
    Reactive<int>(
      ref: counterRef,
      builder: (count) => Container(
        children: [
          Text('Count: $count', variant: TextVariant.h2),
          Text('${count * 2}', className: 'doubled'),
        ],
      ),
    ),
    
    Button(
      Text('Increment'),
      onClick: (e) => counterRef.emit(counterRef.state! + 1),
    ),
    
    Button(
      Text('Decrement'),
      onClick: (e) => counterRef.emit(counterRef.state! - 1),
    ),
    
    Button(
      Text('Reset'),
      onClick: (e) => counterRef.emit(0),
    ),
  ],
);
```

### Async

Asynchronous element for handling Future-based operations.

**Description:** Async elements manage asynchronous operations with loading states, success handling, and error management.

**Properties:**
- `future` - Function returning Future to execute
- `then` - Function to build UI with successful result
- `initialBox` - Element to show while loading
- `onError` - Function to build UI for error states
- All Box properties

**Example:**
```dart
import 'package:atomify/atomify.dart';

final asyncUserData = Async<Map<String, dynamic>>(
  future: () => fetchUserData(),
  initialBox: Container(
    children: [
      Text('Loading user data...'),
      Progress(className: 'loading-progress'),
    ],
  ),
  then: (userData) => Container(
    children: [
      Text('Welcome, ${userData['name']}!', variant: TextVariant.h2),
      Text('Email: ${userData['email']}'),
      Text('Joined: ${userData['joinDate']}'),
    ],
  ),
  onError: (error) => Container(
    children: [
      Text('Error loading user data', variant: TextVariant.h3),
      Text('Error: $error'),
      Button(
        Text('Retry'),
        onClick: (e) => window.location.reload(),
      ),
    ],
  ),
);

Future<Map<String, dynamic>> fetchUserData() async {
  // Simulate API call
  await Future.delayed(Duration(seconds: 2));
  return {
    'name': 'John Doe',
    'email': 'john@example.com',
    'joinDate': '2024-01-15',
  };
}
```

---

## Idiomatic Elements

### I (Italic/Icon)

Italic text element, commonly used for icons.

**Description:** The I element provides italic text styling and is commonly used for icon fonts and semantic emphasis.

**Properties:**
- `cite` - Citation reference
- `datetime` - Date/time reference
- `lang` - Language attribute
- `dir` - Text direction
- `title` - Tooltip text
- `accessKey` - Keyboard shortcut
- `contentEditable` - Editable content flag
- `inputMode` - Input mode hint
- `spellCheck` - Spell check flag
- `tabIndex` - Tab order
- `translate` - Translation flag
- All Box properties

**Example:**
```dart
import 'package:atomify/atomify.dart';

final iconExamples = Container(
  children: [
    // Icon-only
    I(className: 'lni lni-home'),
    
    // Icon with text
    Container(
      style: 'display: flex; align-items: center; gap: 8px;',
      children: [
        I(className: 'lni lni-user'),
        Text('Profile'),
      ],
    ),
    
    // Semantic italic text
    I(
      text: 'emphasized text',
      title: 'This text is emphasized',
    ),
    
    // Icon button
    Button(
      Container(
        children: [
          I(className: 'lni lni-download'),
          Text('Download'),
        ],
      ),
      onClick: (e) => print('Download clicked'),
    ),
  ],
);
```

---

## Application

### App

Application root element that manages rendering and lifecycle.

**Description:** App is the root container that manages the entire application lifecycle, rendering, and global setup.

**Properties:**
- `children` - List of root-level Box elements
- `onRender` - Callback after rendering
- `beforeRender` - Callback before rendering

**Methods:**
- `run({String target = 'body', Function(Element)? onRender})` - Renders the app to target element

**Example:**
```dart
import 'package:atomify/atomify.dart';

void main() {
  App(
    children: [
      Container(
        id: 'app-root',
        className: 'main-app',
        children: [
          // Header
          Container(
            className: 'header',
            children: [
              Text('My Atomify App', variant: TextVariant.h1),
              Container(
                className: 'nav',
                children: [
                  Link(child: Text('Home'), href: '/'),
                  Link(child: Text('About'), href: '/about'),
                  Link(child: Text('Contact'), href: '/contact'),
                ],
              ),
            ],
          ),
          
          // Main content
          Container(
            className: 'main-content',
            children: [
              Text('Welcome to Atomify!'),
              Button(
                Text('Get Started'),
                onClick: (e) => print('Getting started...'),
              ),
            ],
          ),
          
          // Footer
          Container(
            className: 'footer',
            children: [
              Text('© 2024 Atomify App'),
            ],
          ),
        ],
      ),
    ],
    beforeRender: () {
      // Setup fonts, CSS, icons, etc.
      useFont(fontFamily: 'Inter');
      useIcon(pack: IconPack.lineIcons);
      print('App initializing...');
    },
  ).run(
    target: '#app',
    onRender: (element) {
      print('App rendered successfully!');
    },
  );
}
```

---

## Best Practices

### 1. Element Composition
```dart
// Good: Compose elements for reusability
Container buildUserCard(Map<String, dynamic> user) {
  return Container(
    className: 'user-card',
    children: [
      Text(user['name'], variant: TextVariant.h3),
      Text(user['email']),
      Button(
        Text('View Profile'),
        onClick: (e) => viewProfile(user['id']),
      ),
    ],
  );
}
```

### 2. Reactive State Management
```dart
// Good: Use reactive patterns for dynamic UIs
final todosRef = ReactiveRef<List<Todo>>([]);

Reactive<List<Todo>>(
  ref: todosRef,
  builder: (todos) => Container(
    children: todos.map((todo) => buildTodoItem(todo)).toList(),
  ),
)
```

### 3. Accessibility
```dart
// Good: Include accessibility attributes
Progress(
  value: 0.75,
  max: 1.0,
  ariaLabel: 'Upload progress',
  ariaValueText: '75% complete',
)
```

### 4. Error Handling
```dart
// Good: Handle async operations with error states
Async<UserData>(
  future: () => fetchUserData(),
  initialBox: Text('Loading...'),
  then: (data) => buildUserProfile(data),
  onError: (error) => Text('Failed to load: $error'),
)
```

This comprehensive documentation covers all Atomify elements with detailed descriptions, properties, and practical examples. Each element is designed to be composable, accessible, and easy to use while maintaining the library's atomic design principles.
