import 'package:atomify/atomify.dart';
import 'package:meta/meta.dart';

/// The abstract base class for all Atomify views and components.
///
/// Views in Atomify are the fundamental building blocks for creating reusable,
/// composable UI components. Each view encapsulates its own rendering logic,
/// styling, and lifecycle management.
///
/// ## Key Concepts
///
/// - **Atomic Design**: Views are atomic components that can be composed together
/// - **Parameter-Based**: Views accept parameters through a Map for flexibility
/// - **Lifecycle Management**: Views have hooks for setup and cleanup
/// - **Style Encapsulation**: Each view manages its own styles
/// - **Type Safety**: Views provide compile-time guarantees for UI structure
///
/// ## Usage Example
///
/// ```dart
/// class UserCard extends View {
///   @override
///   Box render(Map<String, String> params) {
///     final name = params['name'] ?? 'Unknown User';
///     final email = params['email'] ?? '';
///
///     return Container(
///       className: 'user-card',
///       children: [
///         Text(name, variant: TextVariant.h3),
///         if (email.isNotEmpty) Text(email),
///         Button(
///           Text('View Profile'),
///           onClick: (e) => _handleViewProfile(params['id']),
///         ),
///       ],
///     );
///   }
///
///   @override
///   List<Cssify> get styles => [
///     Cssify.create('.user-card', {
///       'base': {
///         'style': {
///           'border': '1px solid #e0e0e0',
///           'border-radius': '8px',
///           'padding': '16px',
///           'background': '#ffffff',
///         },
///         'state': {
///           'hover': {'box-shadow': '0 4px 8px rgba(0,0,0,0.1)'},
///         }
///       }
///     }),
///   ];
///
///   @override
///   void beforeRender() {
///     // Initialize view state or validate parameters
///   }
///
///   @override
///   void afterRender() {
///     // Set up event listeners or perform post-render operations
///   }
/// }
/// ```
///
/// ## Best Practices
///
/// 1. **Parameter Validation**: Validate required parameters in `beforeRender()`
/// 2. **Null Safety**: Provide sensible defaults for optional parameters
/// 3. **Style Encapsulation**: Keep styles specific to the view
/// 4. **Accessibility**: Include proper ARIA attributes and semantic HTML
/// 5. **Performance**: Use lifecycle hooks efficiently
/// 6. **Testing**: Design views to be easily testable with mock parameters
///
/// ## Lifecycle
///
/// The view lifecycle follows this sequence:
/// 1. Constructor called
/// 2. `beforeRender()` called for setup
/// 3. `render()` called to create the Box tree
/// 4. DOM elements created and styled
/// 5. `afterRender()` called for post-render operations
///
/// @since 0.1.0
abstract class View {
  /// Set the unique identifier for this view.
  /// This identifier is used with Page and PageRef to manage navigation
  String get id;

  /// The [Box] instance that this view returns when rendered.
  Box? element;

  /// Renders the view with the given parameters and returns a Box.
  ///
  /// This is the core method that defines how the view should be rendered.
  /// It receives a map of string parameters that can be used to customize
  /// the view's appearance and behavior.
  ///
  /// The method should return a [Box] (or any Box subclass like Container,
  /// Text, Button, etc.) that represents the complete UI structure for
  /// this view.
  ///
  /// ## Parameter Guidelines
  ///
  /// - Use meaningful parameter names (e.g., 'userId', 'title', 'isEnabled')
  /// - Provide sensible defaults for optional parameters
  /// - Validate required parameters and throw descriptive errors if missing
  /// - Document expected parameters in the class documentation
  ///
  /// ## Error Handling
  ///
  /// If required parameters are missing or invalid, consider:
  /// - Returning an error state Box (e.g., Text('Error: Missing required parameter'))
  /// - Throwing a descriptive ArgumentError
  /// - Logging the error for debugging
  ///
  /// ## Example
  ///
  /// ```dart
  /// @override
  /// Box render(Map<String, String> params) {
  ///   final title = params['title'];
  ///   if (title == null || title.isEmpty) {
  ///     return Text('Error: Title parameter is required');
  ///   }
  ///
  ///   return Container(
  ///     children: [
  ///       Text(title, variant: TextVariant.h2),
  ///       Text(params['subtitle'] ?? ''),
  ///     ],
  ///   );
  /// }
  /// ```
  ///
  /// @param params A map of string parameters for customizing the view
  /// @returns A Box representing the rendered view
  /// @throws ArgumentError If required parameters are missing or invalid
  Box render(Map<String, String> params);

  /// Returns the list of CSS styles that should be applied to this view.
  ///
  /// This getter provides the CSS styles that are specific to this view.
  /// The styles are defined using the Cssify library, which provides
  /// type-safe CSS generation with support for responsive breakpoints
  /// and pseudo-states.
  ///
  /// ## Style Organization
  ///
  /// - **Encapsulation**: Keep styles specific to this view
  /// - **Naming**: Use class names that are prefixed with the view name
  /// - **Responsive**: Utilize breakpoints for mobile-first design
  /// - **States**: Include hover, focus, and other interactive states
  /// - **Accessibility**: Ensure sufficient color contrast and focus indicators
  ///
  /// ## Example
  ///
  /// ```dart
  /// @override
  /// List<Cssify> get styles => [
  ///   // Base component styles
  ///   Cssify.create('.my-view', {
  ///     'base': {
  ///       'style': {
  ///         'display': 'flex',
  ///         'flex-direction': 'column',
  ///         'gap': '12px',
  ///         'padding': '16px',
  ///       },
  ///       'state': {
  ///         'hover': {'background-color': '#f5f5f5'},
  ///         'focus-within': {'outline': '2px solid #0066cc'},
  ///       }
  ///     },
  ///     'md': {
  ///       'style': {
  ///         'flex-direction': 'row',
  ///         'padding': '24px',
  ///       }
  ///     }
  ///   }),
  ///
  ///   // Child element styles
  ///   Cssify.create('.my-view__title', {
  ///     'base': {
  ///       'style': {
  ///         'font-size': '1.5rem',
  ///         'font-weight': '600',
  ///         'color': '#333333',
  ///       }
  ///     }
  ///   }),
  /// ];
  /// ```
  ///
  /// @returns A list of Cssify objects defining the view's styles
  List<Cssify> get styles;

  /// Called before the view is rendered.
  ///
  /// This lifecycle hook is invoked before the `render()` method is called.
  /// It's the ideal place to perform setup operations, validate parameters,
  /// initialize state, or prepare resources needed for rendering.
  ///
  /// ## Common Use Cases
  ///
  /// - **Parameter validation**: Check that required parameters are present
  /// - **State initialization**: Set up internal state or reactive variables
  /// - **Resource loading**: Preload images, fonts, or other assets
  /// - **Analytics**: Track view rendering events
  /// - **Permission checks**: Verify user permissions before rendering
  ///
  /// ## Error Handling
  ///
  /// If setup fails, consider throwing an exception or setting an error state
  /// that the `render()` method can check and handle appropriately.
  ///
  /// ## Example
  ///
  /// ```dart
  /// @override
  /// void beforeRender() {
  ///   // Validate required configuration
  ///   if (!_isConfigured) {
  ///     throw StateError('View must be configured before rendering');
  ///   }
  ///
  ///   // Initialize reactive state
  ///   _loadingState.value = true;
  ///
  ///   // Log analytics
  ///   _analytics.trackViewRender(runtimeType.toString());
  ///
  ///   // Load required assets
  ///   _preloadCriticalAssets();
  /// }
  /// ```
  ///
  /// @throws StateError If the view is not in a valid state for rendering
  /// @throws ArgumentError If required parameters are missing or invalid
  void beforeRender() {}

  /// Called after the view has been rendered and added to the DOM.
  ///
  /// This lifecycle hook is invoked after the `render()` method has completed
  /// and the resulting Box has been converted to DOM elements and added to
  /// the document. It's the perfect place to perform post-render operations
  /// that require access to the rendered DOM elements.
  ///
  /// ## Common Use Cases
  ///
  /// - **DOM manipulation**: Set up complex interactions that require direct DOM access
  /// - **Event listeners**: Attach global or document-level event listeners
  /// - **Third-party integration**: Initialize external libraries or widgets
  /// - **Performance monitoring**: Measure render time and performance metrics
  /// - **Accessibility**: Set focus or announce content to screen readers
  /// - **Animation**: Start CSS animations or transitions
  ///
  /// ## Important Notes
  ///
  /// - The DOM elements are fully constructed and styled at this point
  /// - Use this hook for operations that can't be done through Box properties
  /// - Be careful with memory leaks when setting up listeners
  /// - Consider cleanup in a corresponding disposal method
  ///
  /// ## Example
  ///
  /// ```dart
  /// @override
  /// void afterRender() {
  ///   // Initialize a third-party chart library
  ///   _initializeChart();
  ///
  ///   // Set up keyboard shortcuts
  ///   document.addEventListener('keydown', _handleGlobalKeydown);
  ///
  ///   // Focus the first input for accessibility
  ///   final firstInput = document.querySelector('.my-view input');
  ///   firstInput?.focus();
  ///
  ///   // Start entrance animations
  ///   final container = document.querySelector('.my-view');
  ///   container?.classes.add('animate-in');
  ///
  ///   // Track completion
  ///   _analytics.trackViewRendered(runtimeType.toString());
  /// }
  /// ```
  void afterRender() {}

  /// Validates that required parameters are present and valid.
  ///
  /// This utility method can be called from `beforeRender()` or `render()`
  /// to ensure that all required parameters are provided. It throws
  /// descriptive errors for missing or invalid parameters.
  ///
  /// ## Example
  ///
  /// ```dart
  /// @override
  /// void beforeRender() {
  ///   validateRequiredParams(_lastParams, ['userId', 'title']);
  /// }
  ///
  /// @override
  /// Box render(Map<String, String> params) {
  ///   validateRequiredParams(params, ['userId', 'title']);
  ///   // ... rest of render logic
  /// }
  /// ```
  ///
  /// @param params The parameters map to validate
  /// @param required List of required parameter names
  /// @throws ArgumentError If any required parameter is missing or empty
  @protected
  void validateRequiredParams(
    Map<String, String> params,
    List<String> required,
  ) {
    for (final param in required) {
      if (!params.containsKey(param)) {
        throw ArgumentError.notNull('Required parameter "$param" is missing');
      }
      if (params[param]?.isEmpty == true) {
        throw ArgumentError.value(
          params[param],
          param,
          'Required parameter "$param" cannot be empty',
        );
      }
    }
  }

  /// Safely gets a parameter with a default value.
  ///
  /// This utility method provides a null-safe way to extract parameters
  /// from the params map with fallback defaults.
  ///
  /// ## Example
  ///
  /// ```dart
  /// @override
  /// Box render(Map<String, String> params) {
  ///   final title = getParam(params, 'title', 'Untitled');
  ///   final maxItems = int.tryParse(getParam(params, 'maxItems', '10')) ?? 10;
  ///   final isEnabled = getParam(params, 'enabled', 'true') == 'true';
  ///
  ///   // ... use the parameters
  /// }
  /// ```
  ///
  /// @param params The parameters map
  /// @param key The parameter key to look up
  /// @param defaultValue The default value if the parameter is missing or empty
  /// @returns The parameter value or the default value
  @protected
  String getParam(Map<String, String> params, String key, String defaultValue) {
    final value = params[key];
    return (value?.isNotEmpty == true) ? value! : defaultValue;
  }

  /// Applies the view's styles to the document.
  ///
  /// This method injects the CSS styles returned by the `styles` getter
  /// into the document head. It's typically called automatically by the
  /// framework, but can be called manually if needed.
  ///
  /// The method is idempotent - calling it multiple times won't duplicate
  /// styles in the document.
  ///
  /// @protected
  void applyStyles() {
    final viewStyles = styles;
    if (viewStyles.isNotEmpty) {
      useCss(styles: viewStyles, target: "#${element?.id}");
    }
  }

  /// Disposes of the view and cleans up resources.
  void dispose() {
    element?.dispose();
  }

  /// Gets a human-readable string representation of this view.
  ///
  /// Useful for debugging, logging, and development tools.
  ///
  /// @returns A string representation including the view type
  @override
  String toString() {
    return '$runtimeType(view)';
  }
}
