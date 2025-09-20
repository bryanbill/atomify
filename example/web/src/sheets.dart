import 'package:atomify/atomify.dart';
import 'models/cell_data.dart';
import 'services/storage/sheets_storage.dart';
import 'services/formula/formula_engine.dart';
import 'services/custom_functions.dart';
import 'components/sheets_header.dart';
import 'components/spreadsheet_grid.dart';
import 'components/sheets_bottom_bar.dart';
import 'services/language/modules/dom_bridge.dart';

class Sheets extends View {
  final ReactiveRef<SheetsState> stateRef = ReactiveRef<SheetsState>(
    SheetsState(),
  );
  final ReactiveRef<String> activeCellRef = ReactiveRef<String>('A1');
  final ReactiveRef<String> formulaRef = ReactiveRef<String>('');

  @override
  String get id => 'sheets';

  @override
  void beforeRender() {
    _loadCustomFunctions();
  }

  void _loadCustomFunctions() async {
    try {
      await CustomFunctionManager.loadFunctions();
      print('Custom functions loaded successfully');
    } catch (e) {
      print('Error loading custom functions: $e');
    }
  }

  @override
  Box render(Map<String, String> params) {
    return Async<SheetsState>(
      future: () => SheetsStorage.loadSheets(),
      then: (loadedState) {
        // Initialize the state with loaded data
        stateRef.emit(loadedState);
        activeCellRef.emit(loadedState.activeCell);

        // Load formula for active cell
        final activeSheet = loadedState.sheets.firstWhere(
          (s) => s.id == loadedState.activeSheetId,
          orElse: () => loadedState.sheets.first,
        );
        final cellData = activeSheet.cells[loadedState.activeCell];
        formulaRef.emit(
          (cellData?.formula != null && cellData!.formula.isNotEmpty
                  ? cellData.formula
                  : cellData?.value) ??
              '',
        );

        DOMBridge.initialize(
          initialState: stateRef.state!,
          onStateUpdate: (state) => stateRef.emit(state),
          onCellEdit: _handleCellEdit,
          onCellSelect: _handleCellSelect,
          onSheetSelect: _handleSheetSelect,
        );

        return _buildSheetsUI();
      },
      initialBox: Container(
        className: 'h-screen flex items-center justify-center bg-white',
        children: [
          Container(
            className: 'text-center',
            children: [
              Text(
                'Loading Sheets...',
                variant: TextVariant.h3,
                className: 'text-gray-600 mb-4',
              ),
              Container(
                className:
                    'animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500 mx-auto',
                children: [],
              ),
            ],
          ),
        ],
      ),
      onError: (error) => Container(
        className: 'h-screen flex items-center justify-center bg-white',
        children: [
          Container(
            className: 'text-center text-red-600',
            children: [
              Text('Error loading sheets: $error', variant: TextVariant.p),
              Text(
                'Creating new sheet...',
                variant: TextVariant.small,
                className: 'text-gray-500 mt-2',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Box _buildSheetsUI() {
    return Container(
      className: 'h-screen flex flex-col bg-white sheets-app relative',
      children: [
        // Header (fixed at top)
        Container(
          className: 'absolute top-0 left-0 right-0 z-50',
          children: [
            SheetsHeader(
              stateRef: stateRef,
              activeCellRef: activeCellRef,
              formulaRef: formulaRef,
              onFormulaSubmit: _handleFormulaSubmit,
              onCellStyleChange: _handleCellStyleChange,
            ).render({}),
          ],
        ),

        // Main content area (with top padding for header)
        Container(
          className: 'flex-1 flex flex-col',
          style: 'margin-top: 52px;', // Space for header and footer
          children: [
            // Spreadsheet grid
            SpreadsheetGrid(
              stateRef: stateRef,
              onCellSelect: _handleCellSelect,
              onCellEdit: _handleCellEdit,
              onRangeSelect: _handleRangeSelect,
            ).render({}),
          ],
        ),

        // Bottom bar (fixed at bottom)
        Container(
          className: 'absolute bottom-0 left-0 right-0 z-50',
          children: [
            SheetsBottomBar(
              stateRef: stateRef,
              onNewSheet: _handleNewSheet,
              onSheetSelect: _handleSheetSelect,
              onSheetRename: _handleSheetRename,
            ).render({}),
          ],
        ),
      ],
    );
  }

  void _handleCellSelect(String cellAddress) {
    activeCellRef.emit(cellAddress);

    // Update state
    final currentState = stateRef.state!;
    final updatedState = SheetsState(
      sheets: currentState.sheets,
      activeSheetId: currentState.activeSheetId,
      selectedRange: cellAddress,
      activeCell: cellAddress,
    );
    stateRef.emit(updatedState);

    // Load cell formula/value
    final activeSheet = currentState.sheets.firstWhere(
      (s) => s.id == currentState.activeSheetId,
      orElse: () => currentState.sheets.first,
    );
    final cellData = activeSheet.cells[cellAddress];
    formulaRef.emit(
      (cellData?.formula != null && cellData!.formula.isNotEmpty
              ? cellData.formula
              : cellData?.value) ??
          '',
    );

    _saveState(updatedState);
  }

  Future<void> _handleCellEdit(String cellAddress, String value) async {
    print("Editing cell $cellAddress with value: $value");

    final currentState = stateRef.state!;
    final activeSheet = currentState.sheets.firstWhere(
      (s) => s.id == currentState.activeSheetId,
      orElse: () => currentState.sheets.first,
    );

    // Create or update cell data
    final evaluatedValue = value.startsWith('=')
        ? await FormulaEngine.evaluateFormula(
            value,
            _getCellValues(activeSheet),
          )
        : value;

    final cellData = CellData(
      isEditing: true,
      address: cellAddress,
      value: evaluatedValue,
      formula: value.startsWith('=') ? value : '',
    );

    activeSheet.cells[cellAddress] = cellData;

    _saveState(currentState);
  }

  void _handleRangeSelect(String range) {
    activeCellRef.emit(range);

    final currentState = stateRef.state!;
    final updatedState = SheetsState(
      sheets: currentState.sheets,
      activeSheetId: currentState.activeSheetId,
      selectedRange: range,
      activeCell: range.split(':').first, // First cell in range
    );
    stateRef.emit(updatedState);
    _saveState(updatedState);
  }

  void _handleFormulaSubmit(String formula) {
    final currentState = stateRef.state!;
    _handleCellEdit(currentState.activeCell, formula);
  }

  void _handleCellStyleChange(String cellAddress, Map<String, dynamic> styles) {
    final currentState = stateRef.state!;
    final activeSheet = currentState.sheets.firstWhere(
      (s) => s.id == currentState.activeSheetId,
      orElse: () => currentState.sheets.first,
    );

    // Get existing cell data or create new one
    final existingCell = activeSheet.cells[cellAddress];
    final updatedCell = CellData(
      address: cellAddress,
      value: existingCell?.value ?? '',
      formula: existingCell?.formula ?? '',
      styles: styles,
    );

    // Update the cell
    activeSheet.cells[cellAddress] = updatedCell;

    // Emit updated state
    stateRef.emit(currentState);
    _saveState(currentState);
  }

  void _handleNewSheet() {
    final currentState = stateRef.state!;
    final newSheetId = (currentState.sheets.length + 1).toString();
    final newSheet = SheetData(
      id: newSheetId,
      name: 'Sheet$newSheetId',
      isActive: false,
    );

    final updatedSheets = [...currentState.sheets, newSheet];
    final updatedState = SheetsState(
      sheets: updatedSheets,
      activeSheetId: currentState.activeSheetId,
      selectedRange: currentState.selectedRange,
      activeCell: currentState.activeCell,
    );

    stateRef.emit(updatedState);
    _saveState(updatedState);
  }

  void _handleSheetSelect(String sheetId) {
    final currentState = stateRef.state!;

    // Update active sheet
    for (var sheet in currentState.sheets) {
      sheet.isActive = sheet.id == sheetId;
    }

    final updatedState = SheetsState(
      sheets: currentState.sheets,
      activeSheetId: sheetId,
      selectedRange: 'A1',
      activeCell: 'A1',
    );

    stateRef.emit(updatedState);
    activeCellRef.emit('A1');
    formulaRef.emit('');
    _saveState(updatedState);
  }

  void _handleSheetRename(String sheetId, String newName) {
    final currentState = stateRef.state!;
    final sheet = currentState.sheets.firstWhere((s) => s.id == sheetId);
    sheet.name = newName;

    stateRef.emit(currentState);
    _saveState(currentState);
  }

  Map<String, String> _getCellValues(SheetData sheet) {
    return sheet.cells.map((key, value) => MapEntry(key, value.value));
  }

  void _saveState(SheetsState state) async {
    try {
      await SheetsStorage.saveSheets(state);
    } catch (e) {
      print('Error saving state: $e');
    }
  }

  @override
  List<Cssify> get styles => [];

  @override
  void dispose() {
    stateRef.dispose();
    activeCellRef.dispose();
    formulaRef.dispose();
    super.dispose();
  }
}
