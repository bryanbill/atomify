import 'package:atomify/atomify.dart';
import '../models/cell_data.dart';

class SheetsBottomBar extends View {
  final ReactiveRef<SheetsState> stateRef;
  final Function() onNewSheet;
  final Function(String sheetId) onSheetSelect;
  final Function(String sheetId, String newName) onSheetRename;

  SheetsBottomBar({
    required this.stateRef,
    required this.onNewSheet,
    required this.onSheetSelect,
    required this.onSheetRename,
  });

  @override
  String get id => 'sheets-bottom-bar';

  @override
  Box render(Map<String, String> params) {
    return Container(
      className:
          'fixed bottom-0 left-0 right-0 bg-white border-t border-gray-300 z-40',
      children: [
        Reactive<SheetsState>(
          ref: stateRef,
          builder: (state) => Container(
            className: 'flex items-center px-4 py-2 overflow-x-auto',
            children: [
              // New sheet button
              Button(
                Container(
                  className: 'flex items-center space-x-2',
                  children: [
                    I(className: 'fas fa-plus text-sm'),
                    Text('New Sheet', className: 'text-sm'),
                  ],
                ),
                className:
                    'px-3 py-2 text-sm bg-gray-100 border border-gray-300 rounded hover:bg-gray-200 mr-4',
                onClick: (event) => onNewSheet(),
              ),

              // Sheet tabs
              Container(
                className: 'flex space-x-1',
                children: state.sheets
                    .map(
                      (sheet) => _buildSheetTab(
                        sheet,
                        state.activeSheetId == sheet.id,
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Box _buildSheetTab(SheetData sheet, bool isActive) {
    return Container(
      className: 'flex items-center',
      children: [
        Input(
          type: 'text',
          value: sheet.name,
          className:
              'cursor-pointer text-center px-3 py-2 text-sm border ${isActive ? 'border-blue-500' : 'border-gray-300'} rounded bg-white w-[104px]',
          id: 'sheet-name-input-${sheet.id}',
          onRender: (input) {
            input.on(Event.blur, (event) {
              onSheetRename(sheet.id, (event.target as HTMLInputElement).value);
            });

            input.on(Event.click, (event) {
              onSheetSelect(sheet.id);
            });

            // right click to rename
            input.on(Event.contextMenu, (event) {
              event.preventDefault();
              final newName = window.prompt(
                'Enter new sheet name:',
                sheet.name,
              );
              if (newName != null && newName.trim().isNotEmpty) {
                onSheetRename(sheet.id, newName.trim());
              }
            });
          },
        ),
      ],
    );
  }

  void _handleSheetTabClick(
    String sheetId,
    ReactiveRef<bool> isEditingRef,
    event,
  ) {
    onSheetSelect(sheetId);

    // Check for double-click to enter edit mode
    // In a real implementation, you'd track click timing properly
    // For now, we'll use a simple approach
    Future.delayed(Duration(milliseconds: 300), () {
      // This is a simplified double-click detection
      // In production, you'd use proper event handling
    });
  }

  void _confirmRename(
    String sheetId,
    String newName,
    ReactiveRef<bool> isEditingRef,
  ) {
    if (newName.trim().isNotEmpty) {
      onSheetRename(sheetId, newName.trim());
    }
    isEditingRef.emit(false);
  }

  void _cancelRename(
    ReactiveRef<bool> isEditingRef,
    ReactiveRef<String> nameRef,
    String originalName,
  ) {
    nameRef.emit(originalName);
    isEditingRef.emit(false);
  }

  @override
  List<Cssify> get styles => [
    Cssify.create('.sheets-tabs', {
      'base': {
        'style': {'scrollbar-width': 'thin'},
      },
    }),
  ];
}
