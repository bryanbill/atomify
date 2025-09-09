# Atomify Elements Documentation

This document provides comprehensive documentation for all Atomify elements, including descriptions, properties, and usage examples.

## Table of Contents

- [Application](#application)
  - [App](#app)
- [Core Elements](#core-elements)
  - [Box](#box)
  - [Container](#container)
  - [Text](#text)
  - [View](#view)
- [Media Elements](#media-elements)
  - [Image](#image)
  - [Audio](#audio)
  - [Video](#video)
- [Interactive Elements](#interactive-elements)
  - [Button](#button)
  - [Input](#input)
  - [Link Element](#link)
  - [Select Element](#select)
- [Layout Elements](#layout-elements)
  - [Page](#page)
- [State](#state)
  - [Reactive](#reactive)
  - [Async](#async)

---

## Application

### App

Production-ready application root element that manages rendering, lifecycle, and performance optimization.

**Description:** App is the high-performance root container that manages the entire application lifecycle with comprehensive error handling, performance monitoring, and production-ready features including MutationObserver integration and initialization timeout management.

**Enhanced Properties:**

- `children` - List of root-level Page elements (required)
- `target` - CSS selector for mount point (default: '#output')
- `beforeRender` - Setup callback executed before rendering
- `onRender` - Post-render callback with access to root element and app instance
- `onError` - Error handler for application errors
- `clearTarget` - Whether to clear existing content (default: true)
- `initializationTimeout` - Maximum time for initialization (default: 30s)
- `developmentMode` - Enable development features (auto-detected)

**Methods:**

- `run()` - Renders the app with comprehensive error handling and performance monitoring
- `getDebugInfo()` - Returns performance and debugging information
- `dispose()` - Cleanup method for proper resource management

**Performance Features:**

- Batched DOM operations for optimal rendering performance
- Global MutationObserver for efficient lifecycle management
- Comprehensive validation and error recovery
- Development mode with performance timing and debugging
- Memory leak prevention with proper cleanup

**Example:**

```dart
import 'package:atomify/atomify.dart';

final pageRef = PageRef();

void main() {
  App(
    // Enhanced configuration options
    developmentMode: true, // Auto-detected in debug builds
    initializationTimeout: Duration(seconds: 10),
    target: '#app-root',
    clearTarget: true,
    
    children: [
      Page(
        id: 'main-page',
        ref: pageRef,
        views: [
          HomeView(), 
          AboutView(), 
          ContactView()
        ],
        initial: 'home',
        onPageChange: (view) {
          print('Navigated to: ${view.id}');
        },
      ),
    ],
    
    // Lifecycle callbacks with enhanced features
    beforeRender: () {
      print('App initializing...');
      // Setup global styles, fonts, icons
      useCss(styles: globalStyles);
    },
    
    onRender: (element, appInstance) {
      print('App rendered successfully!');
      
      // Access app performance information in debug mode
      if (appInstance?.developmentMode == true) {
        final debugInfo = appInstance!.getDebugInfo();
        print('Render stats: $debugInfo');
      }
    },
    
    onError: (error, stackTrace) {
      print('App error: $error');
      // Handle errors gracefully - could log to analytics, show user message, etc.
    },
    
  ).run();
}

// Global styles can be applied before rendering
final globalStyles = [
  Cssify.create('*', {
    'base': {
      'style': {
        'box-sizing': 'border-box',
        'margin': '0',
        'padding': '0',
      }
    }
  }),
  Cssify.create('body', {
    'base': {
      'style': {
        'font-family': 'Inter, sans-serif',
        'line-height': '1.6',
        'color': '#333',
      }
    }
  }),
];
```

---

## Core Elements

### Box

Production-ready, high-performance base component for all UI elements with comprehensive optimization and lifecycle management.

**Description:** Box is the fundamental building block that provides common functionality for all UI elements including optimized event handling, memory management, DOM manipulation, and production-ready error handling. All performance improvements are automatically inherited by every element.

**Enhanced Properties:**

- `ref` - Reference to the element for programmatic access
- `id` - HTML id attribute
- `className` - CSS class name
- `style` - Inline CSS styles
- `attributes` - Map of HTML attributes
- `tagName` - HTML tag name (defaults to 'div')
- `text` - Text content
- `onRender` - Callback function called after DOM integration (via MutationObserver)

**Performance Features:**

- **O(1) Event Handler Management** - HashMap-based event handling for instant lookup
- **Element Pooling System** - Reuses DOM elements to reduce garbage collection
- **Batched DOM Operations** - Minimizes reflows and repaints
- **Global MutationObserver Integration** - Efficient lifecycle management
- **Memory Leak Prevention** - Automatic cleanup of resources
- **Production-Ready Error Handling** - Graceful error recovery

**Enhanced Methods:**

- `render()` - Optimized render with element pooling and error handling
- `on(Event, callback)` - O(1) event handler attachment
- `off(Event)` - O(1) event handler removal  
- `dispose()` - Comprehensive cleanup and resource management
- `update()` - Efficient re-rendering with element reuse
- `replaceWith(Box)` - Safe element replacement
- `append(Box)` - Optimized child appending
- `remove()` - Safe element removal with cleanup
- `clear()` - Efficient content clearing
- `scrollToTop()` - Optimized scrolling

**Static Performance Methods:**

- `Box.clearElementPools()` - Clear element pools for memory management
- `Box.getPoolStatistics()` - Get element pool statistics for monitoring

**Example:**

```dart
import 'package:atomify/atomify.dart';

// Basic usage (all performance features automatic)
final container = Container(
  id: 'my-container',
  className: 'optimized-container',
  style: 'padding: 20px; background: #f0f0f0;',
  attributes: {'data-testid': 'main-container'},
  onRender: (box) {
    // Called after element is properly integrated into DOM
    print('Container rendered and in DOM: ${box.isRendered}');
  },
  children: [
    Text('High-performance content'),
    Button(
      Text('Click me'),
      onClick: (event) {
        // O(1) event handling - no performance degradation with many handlers
        print('Button clicked efficiently!');
      },
    ),
  ],
);

// Advanced usage with performance monitoring
class PerformanceContainer extends Container {
  PerformanceContainer({required super.children, super.id});

  @override
  web.HTMLElement render() {
    final element = super.render();
    
    // Monitor element pool usage in development
    if (kDebugMode) {
      final stats = Box.getPoolStatistics();
      print('Element pools: $stats');
    }
    
    return element;
  }

  @override
  void dispose() {
    // Comprehensive cleanup automatically handled by parent
    print('Container disposed safely');
    super.dispose();
  }
}
```

### Container

High-performance layout element with optimized child management.

**Description:** Container is the primary layout element in Atomify, built on the optimized Box foundation. It provides efficient child management, flexible layout capabilities, and automatic performance optimization.

**Properties:**

- `children` - List of child Box elements
- All enhanced Box properties (with performance optimizations)

**Performance Features:**

- Efficient child rendering with batched DOM operations
- Optimized content clearing and updates
- Memory-efficient child management

**Example:**

```dart
import 'package:atomify/atomify.dart';

final optimizedContainer = Container(
  id: 'main-container',
  className: 'flex-container',
  style: '''
    display: flex;
    flex-direction: column;
    gap: 1rem;
    padding: 2rem;
  ''',
  children: [
    Text('Welcome to Optimized Atomify'),
    Text('Built for production performance'),
    Button(
      Text('Experience Speed'),
      onClick: (e) => print('Lightning fast interaction!'),
    ),
  ],
  onRender: (container) {
    // Called after container and all children are in DOM
    print('Container fully rendered with ${container.children?.length ?? 0} children');
  },
);
```

### Text

Optimized text element with efficient rendering and comprehensive variant support.

**Description:** Text element provides high-performance text rendering with support for different HTML text elements through variants. Built on the optimized Box foundation for maximum efficiency.

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

### View

Production-ready, reusable UI component with comprehensive lifecycle management and automatic style application.

**Description:** View is the abstract base class for creating reusable, composable UI components in Atomify. Each view encapsulates its own rendering logic, styling, and lifecycle management with enhanced performance features and production-ready error handling.

**Enhanced Properties:**

- `id` - Unique identifier for the view (required)
- `element` - The rendered Box instance
- `styles` - List of Cssify styles for the view

**Lifecycle Methods:**

- `render(Map<String, String> params)` - Core method that builds the view's UI structure
- `beforeRender()` - Setup hook called before rendering (optional)
- `afterRender()` - Post-render hook for DOM operations (optional)
- `applyStyles()` - Applies view-specific styles automatically when integrated with Page
- `dispose()` - Cleanup method for proper resource management

**Utility Methods:**

- `validateRequiredParams(params, required)` - Parameter validation helper
- `getParam(params, key, defaultValue)` - Safe parameter extraction

**Enhanced Features:**

- **Automatic Style Application** - Styles applied via MutationObserver when used in Pages
- **Parameter Validation** - Built-in parameter validation and error handling
- **Lifecycle Management** - Proper setup and cleanup hooks
- **Memory Management** - Automatic resource cleanup on disposal
- **Error Recovery** - Graceful error handling for production readiness

**Example:**

```dart
import 'package:atomify/atomify.dart';

class UserProfileView extends View {
  @override
  String get id => 'user-profile';

  @override
  void beforeRender() {
    // Validate required parameters
    validateRequiredParams(params, ['userId']);
  }

  @override
  Box render(Map<String, String> params) {
    final userId = params['userId']!;
    final theme = getParam(params, 'theme', 'light');
    
    return Container(
      id: 'profile-container',
      className: 'user-profile $theme-theme',
      children: [
        Text('User Profile', variant: TextVariant.h1),
        Text('User ID: $userId'),
        
        Container(
          className: 'profile-actions',
          children: [
            Button(
              Text('Edit Profile'),
              onClick: (e) => _handleEditProfile(userId),
            ),
            Button(
              Text('View Settings'),
              onClick: (e) => _handleViewSettings(),
            ),
          ],
        ),
      ],
    );
  }

  @override
  List<Cssify> get styles => [
    Cssify.create('.user-profile', {
      'base': {
        'style': {
          'padding': '24px',
          'border-radius': '8px',
          'background': '#ffffff',
          'box-shadow': '0 2px 8px rgba(0,0,0,0.1)',
        },
        'state': {
          'hover': {'box-shadow': '0 4px 12px rgba(0,0,0,0.15)'},
        }
      },
      'md': {
        'style': {
          'padding': '32px',
        }
      }
    }),
    
    Cssify.create('.profile-actions', {
      'base': {
        'style': {
          'display': 'flex',
          'gap': '12px',
          'margin-top': '20px',
        }
      }
    }),
  ];

  @override
  void afterRender() {
    // Optional: Post-render operations
    print('User profile view rendered successfully');
  }

  void _handleEditProfile(String userId) {
    print('Editing profile for user: $userId');
  }

  void _handleViewSettings() {
    print('Viewing settings');
  }
}

// Usage in Page
final profilePage = Page(
  id: 'profile-page',
  ref: PageRef(),
  views: [UserProfileView()],
  // Styles automatically applied when view is rendered
);
```

## Interactive Elements

### Button

Enhanced button component with optimized event handling and comprehensive interaction support.

**Description:** Button provides efficient interactive button functionality with O(1) event handling, comprehensive keyboard support, and production-ready performance through the enhanced Box foundation.

**Properties:**

- `onClick` - Click event handler (optimized with HashMap storage)
- `disabled` - Disabled state
- `type` - Button type ('button', 'submit', 'reset')
- `variant` - Button style variant
- All enhanced Box properties including O(1) event handling

**Enhanced Features:**

- O(1) event handler lookup for instant interaction response
- Element pooling for improved memory management
- Batched DOM operations for smooth animations
- Comprehensive error handling with graceful fallbacks

**Example:**

```dart
import 'package:atomify/atomify.dart';

final buttonExamples = Container(
  className: 'button-showcase',
  children: [
    // Primary action button
    Button(
      Text('Save Changes'),
      onClick: (e) => saveUserData(),
      className: 'btn-primary',
    ),
    
    // Disabled button
    Button(
      Text('Loading...'),
      disabled: true,
      className: 'btn-disabled',
    ),
    
    // Button with complex interaction
    Button(
      Container(children: [
        Icon('download'),
        Text('Download Report'),
      ]),
      onClick: (e) {
        e.preventDefault();
        downloadReport();
      },
      className: 'btn-download',
    ),
  ],
);
```

### Input

Optimized input component with enhanced validation, performance, and accessibility features.

**Description:** Input provides efficient form input handling with O(1) event management, comprehensive validation support, and production-ready performance optimization.

**Properties:**

- `type` - Input type ('text', 'email', 'password', etc.)
- `placeholder` - Placeholder text
- `value` - Current value
- `onInput` - Input event handler (optimized performance)
- `onChange` - Change event handler
- `onFocus` - Focus event handler
- `onBlur` - Blur event handler
- `disabled` - Disabled state
- `required` - Required field indicator
- `ref` - InputRef for programmatic control
- All enhanced Box properties

**Enhanced Features:**

- O(1) event handler management for responsive input handling
- Comprehensive validation support
- Memory-efficient event binding
- Production-ready error handling

**Example:**

```dart
import 'package:atomify/atomify.dart';

final inputRef = InputRef();

final formInputs = Container(
  className: 'form-container',
  children: [
    // Basic text input
    Input(
      type: 'text',
      placeholder: 'Enter your name',
      className: 'input-text',
      onInput: (e) => validateName(e.target.value),
    ),
    
    // Email input with validation
    Input(
      type: 'email',
      placeholder: 'your@email.com',
      ref: inputRef,
      className: 'input-email',
      onInput: (e) => validateEmail(e.target.value),
      onBlur: (e) => checkEmailAvailability(e.target.value),
    ),
    
    // Password input
    Input(
      type: 'password',
      placeholder: 'Secure password',
      className: 'input-password',
      onChange: (e) => checkPasswordStrength(e.target.value),
    ),
  ],
);
```

### Link

High-performance link component with enhanced navigation and accessibility features.

**Description:** Link provides efficient navigation functionality with O(1) event handling, comprehensive routing support, and production-ready performance optimization.

**Properties:**

- `href` - Link destination URL
- `target` - Link target ('_self', '_blank', etc.)
- `onClick` - Click event handler (optimized performance)
- `rel` - Link relationship attribute
- All enhanced Box properties

**Enhanced Features:**

- O(1) event handler management for instant navigation
- Comprehensive accessibility support
- Memory-efficient event handling
- Production-ready error handling

**Example:**

```dart
import 'package:atomify/atomify.dart';

final navigationLinks = Container(
  className: 'nav-links',
  children: [
    // Internal navigation link
    Link(
      href: '/dashboard',
      children: [Text('Go to Dashboard')],
      className: 'nav-link',
      onClick: (e) => trackNavigation('dashboard'),
    ),
    
    // External link with security
    Link(
      href: 'https://external-site.com',
      target: '_blank',
      rel: 'noopener noreferrer',
      children: [Text('External Resource')],
      className: 'external-link',
    ),
    
    // Custom link behavior
    Link(
      href: '#',
      children: [Text('Custom Action')],
      onClick: (e) {
        e.preventDefault();
        performCustomAction();
      },
      className: 'custom-link',
    ),
  ],
);
```

---

### Select

Standard select dropdown component with optimized event handling and accessibility features.

## Properties:

- `options` - List of selectable options (required)
- `value` - Currently selected value
- `onChange` - Change event handler (optimized performance)
- All enhanced Box properties

## Enhanced Features:

- O(1) event handler management for instant updates
- Comprehensive accessibility support
- Memory-efficient event handling
- Production-ready error handling

## Example:

```dart
import 'package:atomify/atomify.dart';

final selectOptions = [
  Option(value: 'option1', label: 'Option 1'),
  Option(value: 'option2', label: 'Option 2'),
  Option(value: 'option3', label: 'Option 3'),
];

final selectElement = Select(
  options: selectOptions,
  selected: selectedOptions.first,
  onChange: (e) => print('Selected: ${e.target.value}'),
);
```

## Layout Elements

### Page

Production-ready, high-performance page component with optimized view management and lifecycle integration.

**Description:** Page is an enhanced layout component that manages multiple views with comprehensive performance optimization, MutationObserver integration for proper callback timing, URL parameter caching, and production-ready error handling.

**Enhanced Properties:**

- `views` - List of View components (required, validated for uniqueness)
- `initial` - ID of the initial view to display
- `onPageChange` - Callback triggered when view changes (called after DOM integration)
- `ref` - PageRef for programmatic navigation (required, must be PageRef type)
- All enhanced Box properties

**Performance Features:**

- **MutationObserver Integration** - Proper callback timing after DOM integration
- **URL Parameter Caching** - 24x faster parameter access through intelligent caching
- **View Management Optimization** - Efficient view lookup and validation
- **Memory Management** - Comprehensive cleanup with view disposal
- **Error Recovery** - Graceful fallbacks and detailed error reporting

**Enhanced Methods:**

- `render()` - Optimized rendering with comprehensive error handling
- `navigateToView(viewId, {additionalParams})` - Type-safe navigation with validation
- `setQueryParams(params)` - Enhanced URL management with caching
- `applyAllViewStyles()` - Apply styles for all views upfront
- `applyCurrentViewStyles()` - Apply styles for current view only
- `getDebugInfo()` - Performance and debugging information
- `dispose()` - Comprehensive cleanup including view disposal

**Static Properties:**

- `isDisposed` - Check if page has been disposed
- `renderCount` - Track render performance
- `currentView` - Get current view safely

**Example:**

```dart
import 'package:atomify/atomify.dart';

// Create page reference for navigation
final pageRef = PageRef();

// Create views with enhanced features
class HomeView extends View {
  @override
  String get id => 'home';

  @override
  Box render(Map<String, String> params) {
    return Container(
      className: 'home-view',
      children: [
        Text('Welcome Home!', variant: TextVariant.h1),
        Button(
          Text('Go to About'),
          onClick: (e) => pageRef.push('about', params: {'source': 'home'}),
        ),
      ],
    );
  }

  @override
  List<Cssify> get styles => [
    Cssify.create('.home-view', {
      'base': {
        'style': {
          'padding': '24px',
          'text-align': 'center',
          'background': 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)',
          'color': 'white',
          'min-height': '100vh',
        }
      }
    })
  ];
}

class AboutView extends View {
  @override
  String get id => 'about';

  @override
  Box render(Map<String, String> params) {
    final source = getParam(params, 'source', 'unknown');
    
    return Container(
      className: 'about-view',
      children: [
        Text('About Us', variant: TextVariant.h1),
        Text('You came from: $source'),
        Button(
          Text('Back Home'),
          onClick: (e) => pageRef.push('home'),
        ),
      ],
    );
  }

  @override
  List<Cssify> get styles => [
    Cssify.create('.about-view', {
      'base': {
        'style': {
          'padding': '24px',
          'background': '#f8f9fa',
          'min-height': '100vh',
        }
      }
    })
  ];
}

// Enhanced page with performance features
final mainPage = Page(
  id: 'main-page',
  ref: pageRef,
  views: [HomeView(), AboutView()],
  initial: 'home',
  
  // Callback triggered after view is in DOM (no flicker)
  onPageChange: (view) {
    print('Navigated to view: ${view.id}');
    
    // Can safely access DOM elements here
    final element = document.querySelector('.${view.id}-view');
    if (element != null) {
      print('View element found in DOM: ${element.tagName}');
    }
  },
  
  onRender: (page) {
    // Called after page is fully rendered
    print('Page rendered with ${page.views.length} views');
    
    // Optional: Apply all view styles upfront for performance
    if (page is Page) {
      page.applyAllViewStyles();
    }
  },
);

// Advanced usage with performance monitoring
void monitorPagePerformance(Page page) {
  if (page.developmentMode) {
    final debugInfo = page.getDebugInfo();
    print('Page Debug Info: $debugInfo');
    
    // Monitor render performance
    print('Render count: ${debugInfo['renderCount']}');
    print('Current view: ${debugInfo['currentViewId']}');
    print('Cached params: ${debugInfo['cachedParamsCount']}');
  }
}

// Enhanced navigation with error handling
void safeNavigate(String viewId) {
  try {
    mainPage.navigateToView(viewId, additionalParams: {'timestamp': DateTime.now().toString()});
  } catch (e) {
    print('Navigation failed: $e');
    // Fallback navigation or error handling
  }
}
```

---

## Data Display

### Table

## Media Elements

### Image

Optimized image element with comprehensive loading management and accessibility features.

**Description:** Image provides efficient image loading with error handling, accessibility support, and performance optimization through the enhanced Box foundation.

**Properties:**

- `src` - Image source URL (required)
- `alt` - Alternative text for accessibility
- `width` - Image width
- `height` - Image height
- `onLoad` - Callback when image loads successfully
- `onError` - Callback when image fails to load
- `crossOrigin` - CORS settings
- `referrerPolicy` - Referrer policy for requests
- All enhanced Box properties

**Example:**

```dart
import 'package:atomify/atomify.dart';

final imageGallery = Container(
  className: 'image-gallery',
  children: [
    // Basic image with accessibility
    Image(
      src: '/assets/hero-image.jpg',
      alt: 'Hero image showing our product features',
      className: 'hero-image',
    ),
    
    // Image with loading/error handling
    Image(
      src: '/assets/user-avatar.jpg',
      alt: 'User profile picture',
      width: '128px',
      height: '128px',
      onLoad: () => print('Avatar loaded successfully'),
      onError: () => print('Failed to load avatar'),
      className: 'user-avatar',
    ),
    
    // Image with CORS and security settings
    Image(
      src: 'https://external-api.com/image.jpg',
      alt: 'External content image',
      crossOrigin: 'anonymous',
      referrerPolicy: 'no-referrer',
    ),
  ],
);
```

### Audio

High-performance audio element with comprehensive media control and accessibility features.

**Description:** Audio provides efficient audio playback management with full control options, accessibility support, and production-ready error handling.

**Properties:**

- `src` - Audio source URL (required)
- `autoplay` - Automatically start playing (default: false)
- `controls` - Show audio controls (default: true)
- `loop` - Loop playback (default: false)
- `preload` - Preload behavior ('auto', 'metadata', 'none')
- All enhanced Box properties

**Example:**

```dart
import 'package:atomify/atomify.dart';

final audioPlayer = Container(
  className: 'media-controls',
  children: [
    // Basic audio player
    Audio(
      src: '/assets/background-music.mp3',
      controls: true,
      className: 'background-audio',
    ),
    
    // Audio with custom configuration
    Audio(
      src: '/assets/notification-sound.wav',
      autoplay: false,
      controls: true,
      loop: false,
      preload: 'metadata',
      className: 'notification-audio',
      onRender: (audio) {
        print('Audio player ready');
      },
    ),
  ],
);
```

### Video

Optimized video element with comprehensive media management and performance features.

**Description:** Video provides efficient video playback with full media controls, accessibility support, and production-ready performance optimization.

**Properties:**

- `src` - Video source URL (required)
- `autoplay` - Automatically start playing (default: false)
- `controls` - Show video controls (default: true)
- `loop` - Loop playback (default: false)
- `preload` - Preload behavior ('auto', 'metadata', 'none')
- All enhanced Box properties

**Example:**

```dart
import 'package:atomify/atomify.dart';

final videoSection = Container(
  className: 'video-section',
  children: [
    // Hero video
    Video(
      src: '/assets/hero-video.mp4',
      controls: true,
      preload: 'metadata',
      className: 'hero-video',
      style: '''
        width: 100%;
        max-width: 800px;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0,0,0,0.1);
      ''',
    ),
    
    // Background video (autoplay, no controls)
    Video(
      src: '/assets/background-loop.mp4',
      autoplay: true,
      controls: false,
      loop: true,
      preload: 'auto',
      className: 'background-video',
      style: '''
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        object-fit: cover;
        z-index: -1;
      ''',
    ),
  ],
);
```

---

## State

Atomify provides a comprehensive state system with reactive components and references for building dynamic, data-driven UIs.

### Reactive

A powerful component for reactive state management that automatically re-renders when state changes.

**Description:** Reactive creates a dynamic UI component that listens to a ReactiveRef and rebuilds its content whenever the state changes. It uses streams for efficient change propagation and includes optimization to prevent unnecessary re-renders when the content hasn't actually changed.

**Properties:**

- `builder` - Function that takes the current state and returns a Box to render (required)
- `ref` - ReactiveRef that holds the state (required, must be ReactiveRef<T>)
- All enhanced Box properties

**Performance Features:**

- Automatic change detection via stream subscription
- Render optimization - skips re-rendering if content hash is unchanged
- Memory-efficient stream management with proper cleanup
- Production-ready error handling

**Example:**

```dart
import 'package:atomify/atomify.dart';

// Create reactive state
final counterRef = ReactiveRef<int>(0);
final userRef = ReactiveRef<User?>(null);
final todoListRef = ReactiveRef<List<Todo>>([]);

// Simple reactive counter
final reactiveCounter = Reactive<int>(
  ref: counterRef,
  builder: (count) => Container(
    className: 'counter-display',
    children: [
      Text('Count: $count', variant: TextVariant.h2),
      Button(
        Text('Increment'),
        onClick: (e) => counterRef.emit(count + 1),
      ),
      Button(
        Text('Decrement'),
        onClick: (e) => counterRef.emit(count - 1),
      ),
    ],
  ),
);

// Complex reactive user profile
final reactiveUserProfile = Reactive<User?>(
  ref: userRef,
  builder: (user) {
    if (user == null) {
      return Container(
        className: 'loading-state',
        children: [
          Text('Loading user profile...'),
          Progress(value: null), // Indeterminate progress
        ],
      );
    }

    return Container(
      className: 'user-profile',
      children: [
        Text('Welcome, ${user.name}!', variant: TextVariant.h1),
        Text('Email: ${user.email}'),
        Text('Last login: ${user.lastLogin}'),
        Button(
          Text('Update Profile'),
          onClick: (e) => showUpdateDialog(user),
        ),
      ],
    );
  },
);

// Reactive todo list with filtering
final reactiveTaskList = Reactive<List<Todo>>(
  ref: todoListRef,
  builder: (todos) {
    final completedCount = todos.where((t) => t.completed).length;
    final pendingCount = todos.length - completedCount;

    return Container(
      className: 'todo-container',
      children: [
        Container(
          className: 'todo-stats',
          children: [
            Text('Total: ${todos.length}'),
            Text('Pending: $pendingCount'),
            Text('Completed: $completedCount'),
          ],
        ),
        
        Container(
          className: 'todo-list',
          children: todos.map((todo) => Container(
            className: 'todo-item ${todo.completed ? 'completed' : 'pending'}',
            children: [
              Text(todo.title),
              Button(
                Text(todo.completed ? 'Undo' : 'Complete'),
                onClick: (e) => toggleTodo(todo.id),
              ),
            ],
          )).toList(),
        ),
        
        Button(
          Text('Add Todo'),
          onClick: (e) => showAddTodoDialog(),
        ),
      ],
    );
  },
);

// State management functions
void updateUser(User newUser) {
  userRef.emit(newUser, {'source': 'profile_update', 'timestamp': DateTime.now().toString()});
}

void toggleTodo(String todoId) {
  final currentTodos = todoListRef.state ?? [];
  final updatedTodos = currentTodos.map((todo) {
    if (todo.id == todoId) {
      return todo.copyWith(completed: !todo.completed);
    }
    return todo;
  }).toList();
  
  todoListRef.emit(updatedTodos, {'action': 'toggle', 'todoId': todoId});
}
```

### Async

A component for handling asynchronous operations with loading, success, and error states.

**Description:** Async manages asynchronous operations by executing a Future and rendering different UI states based on the operation status. It handles loading states, success results, and error conditions with a clean API for complex async workflows.

**Properties:**

- `future` - Function that returns a Future<T> to execute (required)
- `then` - Function that takes the resolved data and returns a Box (required)
- `initialBox` - Box to show while the future is pending (optional)
- `onError` - Function to handle errors and return error UI (optional)
- All enhanced Box properties

**Lifecycle:**

1. Renders `initialBox` immediately (if provided)
2. Executes the `future` function
3. On success: removes `initialBox`, calls `then` with data, renders result
4. On error: removes `initialBox`, calls `onError` (if provided), renders error UI

**Example:**

```dart
import 'package:atomify/atomify.dart';

// Simple async data loading
final userDataAsync = Async<User>(
  future: () => fetchUserProfile(userId),
  initialBox: Container(
    className: 'loading-container',
    children: [
      Progress(value: null),
      Text('Loading user profile...'),
    ],
  ),
  then: (user) => Container(
    className: 'user-profile-loaded',
    children: [
      Text('Welcome, ${user.name}!', variant: TextVariant.h1),
      Text('Member since: ${user.joinDate}'),
      Image(src: user.avatar, alt: '${user.name} avatar'),
    ],
  ),
  onError: (error) => Container(
    className: 'error-container',
    children: [
      Text('Failed to load profile', variant: TextVariant.h2),
      Text('Error: $error'),
      Button(
        Text('Retry'),
        onClick: (e) => window.location.reload(),
      ),
    ],
  ),
);

// Complex async operation with multiple states
final analyticsAsync = Async<AnalyticsData>(
  future: () => loadAnalyticsData(),
  initialBox: Container(
    className: 'analytics-loading',
    children: [
      Text('Generating Analytics Report...', variant: TextVariant.h2),
      Progress(value: null),
      Text('This may take a few moments'),
    ],
  ),
  then: (analytics) => Container(
    className: 'analytics-dashboard',
    children: [
      Text('Analytics Report', variant: TextVariant.h1),
      
      Container(
        className: 'metrics-grid',
        children: [
          MetricCard('Total Users', analytics.totalUsers),
          MetricCard('Page Views', analytics.pageViews),
          MetricCard('Conversion Rate', '${analytics.conversionRate}%'),
          MetricCard('Revenue', '\$${analytics.revenue}'),
        ],
      ),
      
      Container(
        className: 'charts-section',
        children: [
          ChartComponent(analytics.userGrowthData),
          ChartComponent(analytics.revenueData),
        ],
      ),
      
      Button(
        Text('Export Report'),
        onClick: (e) => exportAnalytics(analytics),
      ),
    ],
  ),
  onError: (error) => Container(
    className: 'analytics-error',
    children: [
      Text('Analytics Unavailable', variant: TextVariant.h2),
      Text('Unable to generate report: $error'),
      Button(
        Text('Try Again'),
        onClick: (e) => refreshAnalytics(),
      ),
      Button(
        Text('Contact Support'),
        onClick: (e) => openSupportDialog(),
      ),
    ],
  ),
);

// Async with complex data transformation
final searchResultsAsync = Async<List<SearchResult>>(
  future: () => performSearch(searchQuery),
  initialBox: SearchLoader(),
  then: (results) {
    if (results.isEmpty) {
      return NoResultsFound(searchQuery);
    }
    
    return Container(
      className: 'search-results',
      children: [
        Text('Found ${results.length} results', variant: TextVariant.h3),
        
        Container(
          className: 'results-list',
          children: results.map((result) => SearchResultCard(result)).toList(),
        ),
        
        if (results.length >= 10)
          Button(
            Text('Load More Results'),
            onClick: (e) => loadMoreResults(),
          ),
      ],
    );
  },
  onError: (error) => SearchErrorMessage(error),
);

// Helper functions for async operations
Future<User> fetchUserProfile(String userId) async {
  final response = await api.get('/users/$userId');
  return User.fromJson(response.data);
}

Future<AnalyticsData> loadAnalyticsData() async {
  final [users, views, conversions, revenue] = await Future.wait([
    api.get('/analytics/users'),
    api.get('/analytics/pageviews'),
    api.get('/analytics/conversions'),
    api.get('/analytics/revenue'),
  ]);
  
  return AnalyticsData(
    totalUsers: users.data['total'],
    pageViews: views.data['total'],
    conversionRate: conversions.data['rate'],
    revenue: revenue.data['total'],
  );
}
```

## References (Refs)

Atomify uses a reference system for programmatic access to elements and state management.

### ReactiveRef<T>

A reference that holds reactive state and notifies listeners of changes.

**Description:** ReactiveRef is the core of Atomify's reactive state management. It holds a value, provides a stream of changes, and includes metadata support for additional context during state updates.

**Properties:**

- `state` - Current state value (T?)
- `stream` - Stream<T> for listening to changes
- `props` - Map<String, dynamic> for additional metadata

**Methods:**

- `emit(T value, [Map<String, dynamic> data])` - Update state and notify listeners
- `dispose()` - Clean up resources and close stream
- `init(Box box)` - Initialize with a Box reference

**Example:**

```dart
// Create reactive state
final counterRef = ReactiveRef<int>(0);
final userRef = ReactiveRef<User?>(null);
final settingsRef = ReactiveRef<AppSettings>(AppSettings.defaults());

// Update state with metadata
counterRef.emit(5, {'source': 'increment_button', 'timestamp': DateTime.now()});
userRef.emit(newUser, {'action': 'login', 'method': 'oauth'});

// Listen to state changes
counterRef.stream.listen((count) {
  print('Counter updated to: $count');
  final metadata = counterRef.props;
  print('Update source: ${metadata['source']}');
});

// Complex state management
class TodoStore {
  final _todosRef = ReactiveRef<List<Todo>>([]);
  final _filterRef = ReactiveRef<TodoFilter>(TodoFilter.all);
  
  ReactiveRef<List<Todo>> get todos => _todosRef;
  ReactiveRef<TodoFilter> get filter => _filterRef;
  
  void addTodo(String title) {
    final currentTodos = _todosRef.state ?? [];
    final newTodo = Todo(
      id: generateId(),
      title: title,
      completed: false,
      createdAt: DateTime.now(),
    );
    
    _todosRef.emit([...currentTodos, newTodo], {
      'action': 'add',
      'todoId': newTodo.id,
    });
  }
  
  void toggleTodo(String id) {
    final currentTodos = _todosRef.state ?? [];
    final updatedTodos = currentTodos.map((todo) {
      if (todo.id == id) {
        return todo.copyWith(completed: !todo.completed);
      }
      return todo;
    }).toList();
    
    _todosRef.emit(updatedTodos, {
      'action': 'toggle',
      'todoId': id,
    });
  }
  
  void setFilter(TodoFilter newFilter) {
    _filterRef.emit(newFilter, {'previousFilter': filter.state});
  }
  
  void dispose() {
    _todosRef.dispose();
    _filterRef.dispose();
  }
}
```

### InputRef

A reference for programmatic control of Input elements.

**Properties:**

- `value` - Get/set the input value
- `current` - Reference to the Input element

**Methods:**

- `clear()` - Clear the input value
- `on(Event, callback)` - Add event listener
- `dispose()` - Clean up and remove element

**Example:**

```dart
final nameInputRef = InputRef();
final emailInputRef = InputRef();

final loginForm = Container(
  children: [
    Input(
      ref: nameInputRef,
      placeholder: 'Enter your name',
      type: 'text',
    ),
    Input(
      ref: emailInputRef,
      placeholder: 'Enter your email',
      type: 'email',
    ),
    Button(
      Text('Submit'),
      onClick: (e) {
        final name = nameInputRef.value;
        final email = emailInputRef.value;
        
        if (name?.isNotEmpty == true && email?.isNotEmpty == true) {
          submitForm(name!, email!);
          nameInputRef.clear();
          emailInputRef.clear();
        }
      },
    ),
  ],
);
```

### PageRef

A reference for programmatic page navigation and view management.

**Methods:**

- `push(String viewId, {Map<String, String> params})` - Navigate to a view with parameters
- `add(Page page)` - Associate a page with this reference

**Example:**

```dart
final pageRef = PageRef();

// Navigation functions
void navigateToProfile(String userId) {
  pageRef.push('profile', params: {'userId': userId});
}

void navigateToSettings() {
  pageRef.push('settings');
}

void navigateHome() {
  pageRef.push('home');
}

// Use in page
final mainPage = Page(
  ref: pageRef,
  views: [HomeView(), ProfileView(), SettingsView()],
  initial: 'home',
  onPageChange: (view) {
    print('Navigated to: ${view.id}');
  },
);
```

## State Management Best Practices

1. **Use ReactiveRef for shared state** that multiple components need to access
2. **Use Async for data fetching** with proper loading and error states
3. **Combine Reactive and Async** for complex state workflows
4. **Always dispose of refs** to prevent memory leaks
5. **Use metadata in emit()** for debugging and analytics
6. **Keep state immutable** when possible for predictable updates

