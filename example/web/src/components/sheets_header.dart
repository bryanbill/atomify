import 'package:atomify/atomify.dart';
import '../models/cell_data.dart';
import '../services/custom_functions.dart';
import 'code_editor_modal.dart';

class SheetsHeader extends View {
  final ReactiveRef<SheetsState> stateRef;
  final ReactiveRef<String> activeCellRef;
  final ReactiveRef<String> formulaRef;
  final Function(String) onFormulaSubmit;
  final Function(String, Map<String, dynamic>) onCellStyleChange;

  // Modal state for code editor
  final ReactiveRef<bool> codeModalVisibleRef = ReactiveRef<bool>(false);

  SheetsHeader({
    required this.stateRef,
    required this.activeCellRef,
    required this.formulaRef,
    required this.onFormulaSubmit,
    required this.onCellStyleChange,
  });

  @override
  String get id => 'sheets-header';

  @override
  Box render(Map<String, String> params) {
    return Container(
      className:
          'fixed top-0 left-0 right-0 bg-white border-b border-gray-300 z-50 ',
      children: [
        // Main toolbar
        Container(
          className:
              'flex flex-col  justify-between p-2 border-b border-gray-200 '
              'space-y-2',
          children: [
            Container(
              className:
                  "flex justify-between w-full overflow-x-auto space-x-4",
              children: [
                // file operations
                Container(
                  className: "flex items-center space-x-3",
                  children: [
                    Container(
                      className: 'flex items-center space-x-3 flex-1 max-w-lg ',
                      children: [
                        // Active cell reference
                        Container(
                          className: 'flex items-center space-x-2',
                          children: [
                            Reactive<String>(
                              ref: activeCellRef,
                              builder: (activeCell) => Container(
                                className:
                                    'px-2 py-1 text-sm border border-gray-300 rounded bg-gray-50 min-w-16 text-center',
                                children: [Text(activeCell)],
                              ),
                            ),
                          ],
                        ),

                        // Formula bar
                        Container(
                          className: 'flex items-center space-x-2 flex-1',
                          children: [
                            I(
                              className:
                                  'fas fa-function text-sm text-gray-600',
                            ),
                            Reactive<String>(
                              ref: formulaRef,
                              builder: (formula) => Input(
                                type: 'text',
                                value: formula,
                                placeholder: 'Enter formula or value...',
                                className:
                                    'flex-1 px-3 py-1 text-sm border border-gray-300 '
                                    'rounded focus:outline-none focus:ring-2 '
                                    'focus:ring-blue-500',
                                onChanged: (value) {
                                  onFormulaSubmit(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),

                Reactive<SheetsState>(
                  builder: (state) {
                    return Container(
                      className: 'flex items-center space-x-2',
                      children: [
                        Button(
                          I(className: 'fas fa-print text-sm'),
                          className:
                              'px-3 py-1 border border-gray-300 rounded hover:bg-gray-100',
                          onClick: (event) => print('File menu clicked'),
                        ),
                        Button(
                          I(className: 'fas fa-database text-sm'),
                          className:
                              'px-3 py-1 border border-gray-300 rounded hover:bg-gray-100',
                          onClick: (event) => print('File menu clicked'),
                        ),
                        Button(
                          I(className: 'fas fa-code text-sm'),
                          className:
                              'px-3 py-1 border border-gray-300 rounded hover:bg-gray-100',
                          onClick: (event) => _openCodeEditor(),
                        ),

                        Container(
                          className: 'w-px h-6 bg-gray-300',
                          children: [],
                        ),

                        // Font formatting
                        Button(
                          Container(
                            className: 'flex items-center space-x-1',
                            children: [
                              I(className: 'fas fa-bold text-sm'),
                              Text('B'),
                            ],
                          ),
                          className:
                              'px-3 py-1 text-sm border border-gray-300 rounded hover:bg-gray-100',
                          onClick: (event) => _handleFormat('bold'),
                        ),
                        Button(
                          Container(
                            className: 'flex items-center space-x-1',
                            children: [
                              I(className: 'fas fa-italic text-sm'),
                              Text('I'),
                            ],
                          ),
                          className:
                              'px-3 py-1 text-sm border border-gray-300 rounded hover:bg-gray-100',
                          onClick: (event) => _handleFormat('italic'),
                        ),
                        Button(
                          Container(
                            className: 'flex items-center space-x-1',
                            children: [
                              I(className: 'fas fa-underline text-sm'),
                              Text('U'),
                            ],
                          ),
                          className:
                              'px-3 py-1 text-sm border border-gray-300 rounded hover:bg-gray-100',
                          onClick: (event) => _handleFormat('underline'),
                        ),

                        // Divider
                        Container(
                          className: 'w-px h-6 bg-gray-300',
                          children: [],
                        ),

                        // Text alignment
                        Button(
                          I(className: 'fas fa-align-left text-sm'),
                          className:
                              'px-3 py-1 border border-gray-300 rounded hover:bg-gray-100',
                          onClick: (event) => _handleAlign('left'),
                        ),
                        Button(
                          I(className: 'fas fa-align-center text-sm'),
                          className:
                              'px-3 py-1 border border-gray-300 rounded hover:bg-gray-100',
                          onClick: (event) => _handleAlign('center'),
                        ),
                        Button(
                          I(className: 'fas fa-align-right text-sm'),
                          className:
                              'px-3 py-1 border border-gray-300 rounded hover:bg-gray-100',
                          onClick: (event) => _handleAlign('right'),
                        ),
                      ],
                    );
                  },
                  ref: stateRef,
                ),
              ],
            ),

            // Right side - Cell reference and formula bar
          ],
        ),

        // Code Editor Modal
        CodeEditorModal(
          isVisibleRef: codeModalVisibleRef,
          onFunctionSave: _handleFunctionSave,
        ).render({}),
      ],
    );
  }

  void _openCodeEditor() {
    codeModalVisibleRef.emit(true);
  }

  void _handleFunctionSave(CustomFunction function) {
    try {
      CustomFunctionManager.addFunction(
        function.source.split(';').first.replaceFirst('declare ', '').trim(),
        function,
      );
    } catch (e) {
      print('Error saving custom function: $e');
      // You could show an error toast here
    }
  }

  void _handleFormat(String format) {
    final currentState = stateRef.state!;
    final activeCell = activeCellRef.state!;

    // Get current cell or create new one
    final activeSheet = currentState.sheets.firstWhere(
      (s) => s.id == currentState.activeSheetId,
      orElse: () => currentState.sheets.first,
    );

    final currentCellData = activeSheet.cells[activeCell];
    final currentStyles =
        currentCellData?.styles ??
        {
          "font": {
            "bold": false,
            "italic": false,
            "underline": false,
            "strikethrough": false,
            "color": "#000000",
            "size": 14,
            "family": "Arial",
          },
          "fill": {"type": "solid", "color": "#FFFFFF"},
        };

    // Create updated styles
    final updatedStyles = Map<String, dynamic>.from(currentStyles);
    final fontStyles = Map<String, dynamic>.from(updatedStyles['font'] ?? {});

    // Toggle the formatting
    switch (format) {
      case 'bold':
        fontStyles['bold'] = !(fontStyles['bold'] ?? false);
        break;
      case 'italic':
        fontStyles['italic'] = !(fontStyles['italic'] ?? false);
        break;
      case 'underline':
        fontStyles['underline'] = !(fontStyles['underline'] ?? false);
        break;
      case 'strikethrough':
        fontStyles['strikethrough'] = !(fontStyles['strikethrough'] ?? false);
        break;
    }

    updatedStyles['font'] = fontStyles;

    // Apply the style change
    onCellStyleChange(activeCell, updatedStyles);
  }

  void _handleAlign(String alignment) {
    final currentState = stateRef.state!;
    final activeCell = activeCellRef.state!;

    // Get current cell or create new one
    final activeSheet = currentState.sheets.firstWhere(
      (s) => s.id == currentState.activeSheetId,
      orElse: () => currentState.sheets.first,
    );

    final currentCellData = activeSheet.cells[activeCell];
    final currentStyles =
        currentCellData?.styles ??
        {
          "font": {
            "bold": false,
            "italic": false,
            "underline": false,
            "strikethrough": false,
            "color": "#000000",
            "size": 14,
            "family": "Arial",
          },
          "fill": {"type": "solid", "color": "#FFFFFF"},
        };

    // Create updated styles
    final updatedStyles = Map<String, dynamic>.from(currentStyles);

    // Add alignment to styles
    updatedStyles['alignment'] = {
      'horizontal': alignment,
      'vertical': 'middle',
    };

    // Apply the style change
    onCellStyleChange(activeCell, updatedStyles);
  }

  @override
  List<Cssify> get styles => [];
}
