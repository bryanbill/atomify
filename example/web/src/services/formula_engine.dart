import 'custom_functions.dart';
import './function_language.dart';

class FormulaEngine {
  static String evaluateFormula(
    String formula,
    Map<String, String> cellValues,
  ) {
    if (!formula.startsWith('=')) {
      return formula;
    }

    // Remove '=' and trim
    final expr = formula.substring(1).trim();

    // Check for custom function call (e.g. FUNCNAME(...))
    final match = RegExp(r'^(\w+)\((.*)\)$').firstMatch(expr);
    if (match != null) {
      final funcName = match.group(1)!;
      final argsStr = match.group(2)!;
      final args = argsStr.isEmpty
          ? <dynamic>[]
          : argsStr.split(',').map((s) => s.trim()).toList();

      // Get custom function definition
      final customFunc = CustomFunctionManager.getFunction(funcName);
      if (customFunc != null) {
        // Use FunctionLanguage to parse and execute
        try {
          final result = FunctionLanguage.runCode(
            customFunc.source,
            args,
            cellValues,
          );
          return result.toString();
        } catch (e) {
          return '#ERROR: $e';
        }
      }
    }

    // Fallback: arithmetic evaluation
    return _evaluateArithmetic(expr, cellValues);
  }

  static List<String> _expandRange(String range) {
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

  static List<String> _getCellsInRange(String start, String end) {
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

  static int _getColumnIndex(String cellRef) {
    String col = cellRef.replaceAll(RegExp(r'\d'), '');
    int index = 0;
    for (int i = 0; i < col.length; i++) {
      index = index * 26 + (col.codeUnitAt(i) - 'A'.codeUnitAt(0) + 1);
    }
    return index;
  }

  static int _getRowIndex(String cellRef) {
    String row = cellRef.replaceAll(RegExp(r'[A-Z]'), '');
    return int.tryParse(row) ?? 1;
  }

  static String _getColumnName(int index) {
    String result = '';
    while (index > 0) {
      index--;
      result = String.fromCharCode('A'.codeUnitAt(0) + (index % 26)) + result;
      index ~/= 26;
    }
    return result;
  }

  static bool _isCellReference(String expression) {
    return RegExp(r'^[A-Z]+\d+$').hasMatch(expression);
  }

  static String _evaluateArithmetic(
    String expression,
    Map<String, String> cellValues,
  ) {
    // Very basic arithmetic evaluation
    // Replace cell references with values
    String processed = expression;
    RegExp cellRef = RegExp(r'[A-Z]+\d+');

    processed = processed.replaceAllMapped(cellRef, (match) {
      String cell = match.group(0)!;
      return cellValues[cell] ?? '0';
    });

    // This is a simplified evaluation - in a real app you'd use a proper expression parser
    try {
      // Handle basic operations like +, -, *, /
      if (processed.contains('+')) {
        List<String> parts = processed.split('+');
        double result = 0;
        for (String part in parts) {
          result += double.tryParse(part.trim()) ?? 0;
        }
        return result.toString();
      }
    } catch (e) {
      return '#ERROR';
    }

    return processed;
  }
}
