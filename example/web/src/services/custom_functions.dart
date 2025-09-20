/// Custom Function Definition and Management
import 'language/slang.dart';
import 'storage/sheets_storage.dart';

class CustomFunction {
  final String source;
  final DateTime createdAt;
  final DateTime? updatedAt;

  CustomFunction({required this.source, DateTime? createdAt, this.updatedAt})
    : createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'source': source,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt?.toIso8601String(),
  };

  factory CustomFunction.fromJson(Map<String, dynamic> json) => CustomFunction(
    source: json['source'],
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: json['updatedAt'] != null
        ? DateTime.parse(json['updatedAt'])
        : null,
  );

  CustomFunction copyWith({String? source, DateTime? updatedAt}) {
    return CustomFunction(
      source: source ?? this.source,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
    );
  }

  @override
  String toString() => 'CustomFunction(source: $source)';
}

/// Custom Function Manager - handles storage and execution
class CustomFunctionManager {
  static final Map<String, CustomFunction> _functions = {};

  /// Load custom functions from storage
  static Future<void> loadFunctions() async {
    try {
      final storedFunctions = await SheetsStorage.loadAllFunctions();
      _functions.clear();

      for (final functionData in storedFunctions) {
        final function = CustomFunction.fromJson(functionData);
        _functions[functionData['name'].toString().toUpperCase()] = function;
      }

      // Add default functions if none exist
      if (_functions.isEmpty) {
        await _addDefaultFunctions();
      }
    } catch (e) {
      print('Error loading custom functions: $e');
      await _addDefaultFunctions();
    }
  }

  /// Save custom functions to storage
  static Future<void> saveFunctions() async {
    try {
      for (final entry in _functions.entries) {
        await SheetsStorage.saveFunction(entry.key, entry.value.toJson());
      }
      print('Saved ${_functions.length} custom functions');
    } catch (e) {
      print('Error saving custom functions: $e');
    }
  }

  /// Add or update a custom function
  static Future<void> addFunction(String name, CustomFunction function) async {
    _functions[name.toUpperCase()] = function;
    await SheetsStorage.saveFunction(name.toUpperCase(), function.toJson());
  }

  /// Remove a custom function
  static Future<bool> removeFunction(String name) async {
    final upperName = name.toUpperCase();
    final removed = _functions.remove(upperName) != null;
    if (removed) {
      await SheetsStorage.deleteFunction(upperName);
    }
    return removed;
  }

  /// Get a custom function by name
  static CustomFunction? getFunction(String name) {
    return _functions[name.toUpperCase()];
  }

  /// Get all custom functions
  static List<CustomFunction> getAllFunctions() {
    return _functions.values.toList();
  }

  /// Check if a function exists
  static bool hasFunction(String name) {
    return _functions.containsKey(name.toUpperCase());
  }

  /// Validate function syntax
  static bool isValidFunction(String source) {
    // Basic validation: must contain 'declare', 'accepts', and 'return'
    if (!source.contains('declare') ||
        !source.contains('accepts') ||
        !source.contains('return')) {
      return false;
    }
    // Try parsing
    try {
      Slang.parseFunction(source);
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Execute a custom function with given arguments
  static dynamic executeFunction(
    String name,
    List<dynamic> arguments,
    Map<String, String> cellValues,
  ) {
    final function = getFunction(name);
    if (function == null) {
      throw Exception('Function $name not found');
    }
    try {
      return Slang.run(function.source, arguments, cellValues);
    } catch (e) {
      throw Exception('Error executing function $name: $e');
    }
  }

  static Future<void> _addDefaultFunctions() async {
    await addFunction(
      'DOUBLE',
      CustomFunction(
        source: 'declare DOUBLE;\naccepts value;\nreturn value * 2;',
      ),
    );
    await addFunction(
      'PERCENTAGE',
      CustomFunction(
        source:
            'declare PERCENTAGE;\naccepts part, whole;\nreturn (part / whole) * 100;',
      ),
    );
    await addFunction(
      'COMPOUND_INTEREST',
      CustomFunction(
        source:
            'declare COMPOUND_INTEREST;\naccepts principal, rate, time;\nreturn principal * Math.pow(1 + rate / 100, time);',
      ),
    );
  }
}
