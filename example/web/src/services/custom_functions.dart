/// Custom Function Definition and Management
import 'function_language.dart';

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
      // In a real app, load from localStorage or IndexedDB
      // For now, we'll use in-memory storage with some defaults
      _addDefaultFunctions();
    } catch (e) {
      print('Error loading custom functions: $e');
    }
  }

  /// Save custom functions to storage
  static Future<void> saveFunctions() async {
    try {
      // In a real app, save to localStorage or IndexedDB
      final functionsJson = _functions.map(
        (key, value) => MapEntry(key, value.toJson()),
      );
      print('Saving ${functionsJson.length} custom functions');
    } catch (e) {
      print('Error saving custom functions: $e');
    }
  }

  /// Add or update a custom function
  static void addFunction(String name, CustomFunction function) {
    _functions[name.toUpperCase()] = function;
    saveFunctions();
  }

  /// Remove a custom function
  static bool removeFunction(String name) {
    final removed = _functions.remove(name.toUpperCase()) != null;
    if (removed) {
      saveFunctions();
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
      FunctionLanguage.parseFunction(source);
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
      return FunctionLanguage.runCode(function.source, arguments, cellValues);
    } catch (e) {
      throw Exception('Error executing function $name: $e');
    }
  }

  /// Simple function interpreter (supports basic operations)
  static dynamic _interpretFunction(String body, Map<String, dynamic> context) {
    // This is a simplified interpreter. In a real implementation,
    // you might want to use a proper JS engine or expression evaluator

    // For demo purposes, we'll handle simple cases
    final lines = body
        .split('\n')
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();

    dynamic result;
    for (String line in lines) {
      if (line.startsWith('return ')) {
        String expression = line.substring(7).replaceAll(';', '').trim();
        result = _evaluateExpression(expression, context);
        break;
      }
      // Handle variable assignments if needed
    }

    return result ?? 0;
  }

  /// Evaluate simple expressions
  static dynamic _evaluateExpression(
    String expression,
    Map<String, dynamic> context,
  ) {
    // Replace variables with their values
    String processed = expression;

    // Replace parameter names with their values
    context.forEach((key, value) {
      if (value is! Function) {
        processed = processed.replaceAll(
          RegExp('\\b$key\\b'),
          value.toString(),
        );
      }
    });

    // Handle function calls like SUM(a, b, c)
    processed = processed.replaceAllMapped(RegExp(r'(\w+)\(([^)]*)\)'), (
      match,
    ) {
      String funcName = match.group(1)!;
      String argsStr = match.group(2)!;

      if (context.containsKey(funcName) && context[funcName] is Function) {
        List<String> args = argsStr.split(',').map((s) => s.trim()).toList();
        List<dynamic> values = args
            .map((arg) => double.tryParse(arg) ?? arg)
            .toList();
        return context[funcName](values).toString();
      }
      return match.group(0)!;
    });

    // Simple arithmetic evaluation
    try {
      return double.tryParse(processed) ?? processed;
    } catch (e) {
      return processed;
    }
  }

  static bool _isReservedName(String name) {
    final reserved = {
      'SUM',
      'AVG',
      'MAX',
      'MIN',
      'COUNT',
      'IF',
      'AND',
      'OR',
      'NOT',
      'CELL',
      'ROW',
      'COLUMN',
      'INDEX',
      'MATCH',
      'VLOOKUP',
      'HLOOKUP',
    };
    return reserved.contains(name.toUpperCase());
  }

  static void _addDefaultFunctions() {
    addFunction(
      'DOUBLE',
      CustomFunction(
        source: 'declare DOUBLE;\naccepts value;\nreturn value * 2;',
      ),
    );
    addFunction(
      'PERCENTAGE',
      CustomFunction(
        source:
            'declare PERCENTAGE;\naccepts part, whole;\nreturn (part / whole) * 100;',
      ),
    );
    addFunction(
      'COMPOUND_INTEREST',
      CustomFunction(
        source:
            'declare COMPOUND_INTEREST;\naccepts principal, rate, time;\nreturn principal * Math.pow(1 + rate / 100, time);',
      ),
    );
  }
}
