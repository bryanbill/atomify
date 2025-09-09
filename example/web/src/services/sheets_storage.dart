import '../models/cell_data.dart';

class SheetsStorage {
  static const String _storageKey = 'sheets_data';

  // In a real implementation, this would use IndexedDB
  // For now, we'll use browser localStorage as a simple storage
  static Map<String, dynamic> _storage = {};

  static Future<SheetsState> loadSheets() async {
    try {
      // Simulate async storage operation
      await Future.delayed(Duration(milliseconds: 100));

      if (_storage.containsKey(_storageKey)) {
        final data = _storage[_storageKey] as Map<String, dynamic>;
        return SheetsState(
          sheets: (data['sheets'] as List)
              .map((sheet) => SheetData.fromJson(sheet))
              .toList(),
          activeSheetId: data['activeSheetId'],
          selectedRange: data['selectedRange'] ?? 'A1',
          activeCell: data['activeCell'] ?? 'A1',
        );
      }
    } catch (e) {
      print('Error loading sheets: $e');
    }

    // Return default state if no data found
    return SheetsState();
  }

  static Future<void> saveSheets(SheetsState state) async {
    try {
      await Future.delayed(Duration(milliseconds: 50));

      _storage[_storageKey] = {
        'sheets': state.sheets.map((sheet) => sheet.toJson()).toList(),
        'activeSheetId': state.activeSheetId,
        'selectedRange': state.selectedRange,
        'activeCell': state.activeCell,
      };
    } catch (e) {
      print('Error saving sheets: $e');
    }
  }

  static Future<void> saveCellData(String sheetId, CellData cellData) async {
    try {
      final state = await loadSheets();
      final sheet = state.sheets.firstWhere((s) => s.id == sheetId);
      sheet.cells[cellData.address] = cellData;
      await saveSheets(state);
    } catch (e) {
      print('Error saving cell data: $e');
    }
  }
}
