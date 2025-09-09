import 'dart:js_interop';

import 'package:atomify/atomify.dart';
import '../models/cell_data.dart';

double savedScrollLeft = 0;
double savedScrollTop = 0;

@JS()
external void setupScrollSync();

class SpreadsheetGrid extends View {
  final ReactiveRef<SheetsState> stateRef;
  final Function(String cellAddress) onCellSelect;
  final Function(String cellAddress, String value) onCellEdit;
  final Function(String range) onRangeSelect;

  SpreadsheetGrid({
    required this.stateRef,
    required this.onCellSelect,
    required this.onCellEdit,
    required this.onRangeSelect,
  });

  @override
  String get id => 'spreadsheet-grid';

  static const int VISIBLE_ROWS = 100;
  static const int VISIBLE_COLS = 26;
  static const int ROW_HEIGHT = 32; // Fixed row height
  static const int COL_WIDTH = 80; // Fixed column width
  static const int ROW_HEADER_WIDTH = 64; // Fixed row header width

  @override
  Box render(Map<String, String> params) {
    return Container(
      className: 'flex-1 relative',

      children: [
        Reactive<SheetsState>(
          ref: stateRef,
          builder: (state) => Container(
            className: 'h-full w-full relative',
            children: [
              // Fixed header row at the top
              Container(
                className:
                    'absolute top-0 left-0 right-0 flex bg-white border-b border-gray-300 z-30',
                style: 'height: 32px;',
                children: [
                  // Corner cell (fixed at top-left)
                  Container(
                    className:
                        'bg-gray-200 border-r border-gray-300 flex items-center '
                        'justify-center border-b border-gray-300',
                    style:
                        'width: 64px; height: 32px; min-width: 64px; max-width: 64px;',
                    children: [Text('')],
                  ),
                  // Scrollable column headers
                  Container(
                    id: 'column-headers-scroll',
                    className: 'flex overflow-x-hidden flex-1',
                    children: [
                      Container(
                        className: 'flex',
                        style: 'width: 2080px;', // 26 columns * 80px
                        children: List.generate(VISIBLE_COLS, (index) {
                          String colName = _getColumnName(index + 1);
                          return Container(
                            className:
                                'bg-gray-100 border-r border-gray-300 flex items-center justify-center hover:bg-gray-200 cursor-pointer',
                            style:
                                'width: 80px; height: 32px; min-width: 80px; max-width: 80px;',
                            children: [
                              Button(
                                Text(
                                  colName,
                                  className:
                                      'text-xs font-medium text-gray-700',
                                ),
                                className:
                                    'w-full h-full flex items-center justify-center hover:bg-gray-200',
                                onClick: (event) => _selectColumn(colName),
                              ),
                            ],
                          );
                        }),
                      ),
                    ],
                    onRender: (box) {
                      box.element!.scrollTo(savedScrollLeft.toJS, 0);
                    },
                  ),
                ],
              ),

              // Main scrollable area with top padding for header
              Container(
                id: 'main-scroll-container',
                className: 'absolute inset-0 h-[90vh] overflow-auto bg-gray-50',
                style:
                    'padding-top: 32px; padding-bottom: ${ROW_HEIGHT + 24}px;',
                children: [
                  Container(
                    className: 'relative',
                    style:
                        'min-width: 2144px;', // Keep original width without margin here
                    children: List.generate(VISIBLE_ROWS, (rowIndex) {
                      int rowNumber = rowIndex + 1;
                      return _buildRow(state, rowNumber);
                    }),
                  ),
                ],
                onRender: (container) {
                  container.element!.scrollTo(
                    savedScrollLeft.toJS,
                    savedScrollTop,
                  );

                  container.element!.onscroll = (JSAny event) {
                    savedScrollTop = container.element!.scrollTop;
                    savedScrollLeft = container.element!.scrollLeft;
                  }.toJS;

                  setupScrollSync();
                },
              ),
            ],
          ),
        ),
      ],
    );
  }

  Box _buildRow(SheetsState state, int rowNumber) {
    return Container(
      className: 'flex sheets-row border-b border-gray-200',
      style: 'height: 32px; min-height: 32px; max-height: 32px;',
      children: [
        // Row header (sticky on left)
        Container(
          className:
              'sticky bg-gray-100 border-r border-gray-300 flex items-center justify-center hover:bg-gray-200 cursor-pointer flex-shrink-0',
          style:
              'width: 64px; height: 32px; min-width: 64px; max-width: 64px; background-color: #f3f4f6; left: 0; z-index: 10;',
          children: [
            Button(
              Text(
                '$rowNumber',
                className: 'text-xs font-medium text-gray-700',
              ),
              className:
                  'w-full h-full flex items-center justify-center hover:bg-gray-200',
              onClick: (event) => _selectRow(rowNumber),
            ),
          ],
        ),

        // Row cells
        Container(
          className: 'flex',
          children: List.generate(VISIBLE_COLS, (colIndex) {
            String colName = _getColumnName(colIndex + 1);
            String cellAddress = '$colName$rowNumber';
            return _buildCell(state, cellAddress);
          }),
        ),
      ],
    );
  }

  Box _buildCell(SheetsState state, String cellAddress) {
    final activeSheet = state.sheets.firstWhere(
      (s) => s.id == state.activeSheetId,
      orElse: () => state.sheets.first,
    );

    final cellData = activeSheet.cells[cellAddress];
    final isSelected = state.activeCell == cellAddress;
    final isInRange = _isInSelectedRange(cellAddress, state.selectedRange);

    String cellValue = cellData?.value ?? '';

    final styles = cellData?.styles ?? {};
    final cellStyle = _buildCellStyle(styles);
    final textStyle = _buildTextStyle(styles);

    return Container(
      className: 'sheets-cell',
      style:
          'width: 80px; height: 32px; min-width: 80px; max-width: 80px; ${cellStyle}',
      children: [
        Input(
          type: 'text',
          value: cellValue,
          className:
              'border-0 w-full h-full px-2 text-xs focus:outline-none cursor-cell',
          id: 'cell-input-$cellAddress',
          style:
              '${textStyle} ${_buildInputBackgroundStyle(styles, isSelected, isInRange)}',
          onRender: (input) {
            if (state.activeCell == cellAddress) {
              input.on(Event.blur, (e) {
                onCellEdit(
                  cellAddress,
                  (input.element as HTMLInputElement).value,
                );

                onCellSelect(cellAddress);
              });

              return;
            }

            input.on(Event.click, (e) {
              onCellSelect(cellAddress);
            });
          },
        ),
      ],
    );
  }

  /// Builds CSS style string for cell container based on cell styles
  String _buildCellStyle(Map<String, dynamic> styles) {
    List<String> cssStyles = [];

    // Handle fill (background) styles
    if (styles.containsKey('fill')) {
      final fill = styles['fill'] as Map<String, dynamic>? ?? {};
      final type = fill['type'] as String? ?? 'solid';
      final color = fill['color'] as String? ?? '#FFFFFF';

      if (type == 'solid' && color != '#FFFFFF') {
        cssStyles.add('background-color: $color');
      }
    }

    // Handle border styles if they exist
    if (styles.containsKey('border')) {
      final border = styles['border'] as Map<String, dynamic>? ?? {};
      if (border.isNotEmpty) {
        final borderColor = border['color'] as String? ?? '#d1d5db';
        final borderWidth = border['width'] as int? ?? 1;
        final borderStyle = border['style'] as String? ?? 'solid';
        cssStyles.add('border: ${borderWidth}px $borderStyle $borderColor');
      }
    } else {
      // Default border
      cssStyles.add('border: 1px solid #d1d5db');
    }

    return '${cssStyles.join('; ')};';
  }

  /// Builds CSS style string for text based on font styles
  String _buildTextStyle(Map<String, dynamic> styles) {
    List<String> cssStyles = [];

    // Handle font styles
    if (styles.containsKey('font')) {
      final font = styles['font'] as Map<String, dynamic>? ?? {};

      // Font family
      final family = font['family'] as String? ?? 'Arial';
      cssStyles.add('font-family: $family');

      // Font size
      final size = font['size'] as int? ?? 14;
      cssStyles.add('font-size: ${size}px');

      // Font color
      final color = font['color'] as String? ?? '#000000';
      cssStyles.add('color: $color');

      // Font weight (bold)
      final bold = font['bold'] as bool? ?? false;
      if (bold) {
        cssStyles.add('font-weight: bold');
      }

      // Font style (italic)
      final italic = font['italic'] as bool? ?? false;
      if (italic) {
        cssStyles.add('font-style: italic');
      }

      // Text decoration (underline, strikethrough)
      List<String> decorations = [];
      final underline = font['underline'] as bool? ?? false;
      final strikethrough = font['strikethrough'] as bool? ?? false;

      if (underline) decorations.add('underline');
      if (strikethrough) decorations.add('line-through');

      if (decorations.isNotEmpty) {
        cssStyles.add('text-decoration: ${decorations.join(' ')}');
      }
    }

    // Handle alignment styles
    if (styles.containsKey('alignment')) {
      final alignment = styles['alignment'] as Map<String, dynamic>? ?? {};

      // Horizontal alignment
      final horizontal = alignment['horizontal'] as String? ?? 'left';
      cssStyles.add('text-align: $horizontal');

      // Vertical alignment
      final vertical = alignment['vertical'] as String? ?? 'middle';
      switch (vertical) {
        case 'top':
          cssStyles.add('vertical-align: top');
          break;
        case 'bottom':
          cssStyles.add('vertical-align: bottom');
          break;
        case 'middle':
        default:
          cssStyles.add('vertical-align: middle');
          break;
      }
    }

    return cssStyles.join('; ') + ';';
  }

  /// Builds background style for input element considering selection state
  String _buildInputBackgroundStyle(
    Map<String, dynamic> styles,
    bool isSelected,
    bool isInRange,
  ) {
    List<String> cssStyles = [];

    // Priority: selection state > range state > custom fill
    if (isSelected) {
      cssStyles.add('background-color: #DBEAFE'); // blue-100
      cssStyles.add('border: 1px solid #3B82F6'); // blue-500
    } else if (isInRange) {
      cssStyles.add('background-color: #EFF6FF'); // blue-50
    } else {
      // Apply custom fill if no selection
      if (styles.containsKey('fill')) {
        final fill = styles['fill'] as Map<String, dynamic>? ?? {};
        final type = fill['type'] as String? ?? 'solid';
        final color = fill['color'] as String? ?? '#FFFFFF';

        if (type == 'solid') {
          cssStyles.add('background-color: $color');
        }
      } else {
        cssStyles.add('background-color: #FFFFFF'); // default white
      }
    }

    return '${cssStyles.join('; ')};';
  }

  void _selectColumn(String colName) {
    String range = '${colName}1:$colName$VISIBLE_ROWS';
    onRangeSelect(range);
  }

  void _selectRow(int rowNumber) {
    String range = 'A$rowNumber:Z$rowNumber';
    onRangeSelect(range);
  }

  bool _isInSelectedRange(String cellAddress, String range) {
    if (range.contains(':')) {
      List<String> parts = range.split(':');
      if (parts.length == 2) {
        // expand the range and check if cellAddress is within it
        List<String> expandedCells = _expandRange(range);
        return expandedCells.contains(cellAddress);
      }
    }
    return cellAddress == range;
  }

  List<String> _expandRange(String range) {
    // Handle ranges like A1:A10
    if (range.contains(':')) {
      List<String> parts = range.split(':');
      if (parts.length == 2) {
        String start = parts[0];
        String end = parts[1];
        return _getCellsInRange(start, end);
      }
    }

    // Single cell
    return [range];
  }

  List<String> _getCellsInRange(String start, String end) {
    List<String> cells = [];

    // Parse start and end cells
    var startCol = _getColumnIndex(start);
    var startRow = _getRowIndex(start);
    var endCol = _getColumnIndex(end);
    var endRow = _getRowIndex(end);

    for (int col = startCol; col <= endCol; col++) {
      for (int row = startRow; row <= endRow; row++) {
        cells.add('${_getColumnName(col)}$row');
      }
    }

    return cells;
  }

  int _getColumnIndex(String cellRef) {
    String col = cellRef.replaceAll(RegExp(r'\d'), '');
    int index = 0;
    for (int i = 0; i < col.length; i++) {
      index = index * 26 + (col.codeUnitAt(i) - 'A'.codeUnitAt(0) + 1);
    }
    return index;
  }

  int _getRowIndex(String cellRef) {
    String row = cellRef.replaceAll(RegExp(r'[A-Z]'), '');
    return int.tryParse(row) ?? 1;
  }

  String _getColumnName(int index) {
    String result = '';
    while (index > 0) {
      index--;
      result = String.fromCharCode('A'.codeUnitAt(0) + (index % 26)) + result;
      index ~/= 26;
    }
    return result;
  }

  @override
  List<Cssify> get styles => [
    Cssify.create('.spreadsheet-grid', {
      'base': {
        'style': {'font-family': 'monospace'},
      },
    }),
    Cssify.create('.sheets-grid-container', {
      'base': {
        'style': {
          'overflow': 'auto',
          'position': 'absolute',
          'top': '32px',
          'bottom': '60px',
          'left': '0',
          'right': '0',
        },
      },
    }),
    Cssify.create('.sheets-row-header', {
      'base': {
        'style': {
          'width': '64px',
          'height': '32px',
          'min-width': '64px',
          'max-width': '64px',
          'position': 'sticky',
          'left': '0',
          'z-index': '30',
        },
      },
    }),
    Cssify.create('.sheets-col-header', {
      'base': {
        'style': {
          'width': '80px',
          'height': '32px',
          'min-width': '80px',
          'max-width': '80px',
        },
      },
    }),
    Cssify.create('.sheets-cell', {
      'base': {
        'style': {
          'width': '80px',
          'height': '32px',
          'min-width': '80px',
          'max-width': '80px',
        },
      },
    }),
    Cssify.create('.sheets-corner', {
      'base': {
        'style': {
          'width': '64px',
          'height': '32px',
          'min-width': '64px',
          'max-width': '64px',
          'position': 'sticky',
          'left': '0',
          'z-index': '50',
        },
      },
    }),
    Cssify.create('.sheets-header-row', {
      'base': {
        'style': {
          'height': '32px',
          'position': 'absolute',
          'top': '0',
          'left': '0',
          'right': '0',
          'z-index': '40',
        },
      },
    }),
    Cssify.create('.sheets-row', {
      'base': {
        'style': {'height': '32px', 'min-height': '32px', 'max-height': '32px'},
      },
    }),
  ];
}
