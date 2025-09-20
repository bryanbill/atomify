import 'dart:js_interop';

import 'package:atomify/atomify.dart';
import '../services/custom_functions.dart';
import '../services/language/slang.dart';

class CodeEditorModal extends View {
  final ReactiveRef<bool> isVisibleRef;
  final Function(CustomFunction) onFunctionSave;
  final CustomFunction? editingFunction;

  final ReactiveRef<String> errorMessageRef = ReactiveRef<String>('');

  CodeEditorModal({
    required this.isVisibleRef,
    required this.onFunctionSave,
    this.editingFunction,
  });

  @override
  String get id => 'code-editor-modal';

  @override
  void beforeRender() {}

  String functionBody = '';

  @override
  Box render(Map<String, String> params) {
    return Reactive<bool>(
      ref: isVisibleRef,
      builder: (isVisible) {
        if (!isVisible) return Container(children: []);

        return Container(
          className: 'fixed inset-0 z-50 flex items-center justify-center',
          children: [
            // Backdrop
            Button(
              Text(''),
              className: 'absolute inset-0 bg-black bg-opacity-50',
              onClick: (event) => _closeModal(),
            ),

            // Modal content
            Container(
              className:
                  'relative bg-white rounded-lg shadow-xl max-w-4xl w-full mx-4 max-h-[90vh] overflow-hidden',
              children: [
                // Content
                Container(
                  className: 'p-6 overflow-y-auto max-h-[calc(90vh-140px)]',
                  children: [
                    // Error message
                    Reactive<String>(
                      ref: errorMessageRef,
                      builder: (error) {
                        if (error.isEmpty) return Container(children: []);
                        return Container(
                          className:
                              'mb-4 p-3 bg-red-100 border border-red-400 text-red-700 rounded',
                          children: [Text(error)],
                        );
                      },
                    ),

                    // Form
                    Container(
                      className: 'space-y-6',
                      children: [
                        Container(
                          children: [
                            Container(
                              children: [
                                Textarea(
                                  value: functionBody,
                                  placeholder: _getBodyPlaceholder(),
                                  className:
                                      'w-full h-64 px-3 py-2 font-mono text-sm border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500 resize-none',
                                  onChanged: (value) {
                                    functionBody = value;
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                // Footer
                Container(
                  className:
                      'flex items-center justify-between p-4 border-t border-gray-200',
                  children: [
                    Button(
                      Text('Cancel'),
                      className:
                          'px-4 py-2 text-gray-700 bg-gray-100 hover:bg-gray-200 rounded-md',
                      onClick: (event) => _closeModal(),
                    ),
                    Container(
                      className: 'flex space-x-3',
                      children: [
                        Button(
                          Text('Test Function'),
                          className:
                              'px-4 py-2 text-blue-700 bg-blue-100 hover:bg-blue-200 rounded-md',
                          onClick: (event) => _testFunction(),
                        ),
                        Button(
                          Text(
                            editingFunction != null
                                ? 'Update Function'
                                : 'Save Function',
                          ),
                          className:
                              'px-4 py-2 text-white bg-blue-600 hover:bg-blue-700 rounded-md',
                          onClick: (event) => _saveFunction(),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  String _getBodyPlaceholder() {
    return '''
if (rate <= 0 || time <= 0) {
    return 0;
}

var result = principal * Math.pow(1 + rate / 100, time);
return result;''';
  }

  void _testFunction() {
    final body = functionBody;

    if (body.isEmpty) {
      errorMessageRef.emit('Function body is required.');
      return;
    }

    try {
      // Test with dummy values

      final testCells = <String, String>{'A1': '100', 'B1': '200'};

      final result = Slang.run(functionBody, [
        '100',
        '200',
      ], testCells);

      errorMessageRef.emit('✅ Test successful! Result: $result');
    } catch (e) {
      errorMessageRef.emit('❌ Test failed: $e');
    }
  }

  void _saveFunction() {
    final body = functionBody;

    if (body.isEmpty) {
      errorMessageRef.emit('Function body is required.');
      return;
    }

    try {
      final function = CustomFunction(source: body);

      onFunctionSave(function);
      _closeModal();
    } catch (e) {
      errorMessageRef.emit('Error saving function: $e');
    }
  }

  void _closeModal() {
    isVisibleRef.emit(false);
    _resetForm();
  }

  void _resetForm() {
    functionBody = '';
    errorMessageRef.emit('');
  }

  @override
  List<Cssify> get styles => [
    Cssify.create('.code-editor-modal', {
      'base': {
        'style': {
          'font-family': 'Inter, -apple-system, BlinkMacSystemFont, sans-serif',
        },
      },
    }),
  ];
}
