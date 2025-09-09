class CellData {
  final String address; // e.g., "A1"
  String value;
  String formula;
  bool isSelected;
  bool isEditing;
  Map<String, dynamic> styles = {};

  CellData({
    required this.address,
    this.value = '',
    this.formula = '',
    this.isSelected = false,
    this.isEditing = false,
    this.styles = const {
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
    },
  });

  Map<String, dynamic> toJson() => {
    'address': address,
    'value': value,
    'formula': formula,
    'styles': styles,
  };

  factory CellData.fromJson(Map<String, dynamic> json) => CellData(
    address: json['address'],
    value: json['value'] ?? '',
    formula: json['formula'] ?? '',
    styles:
        json['styles'] ??
        const {
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
        },
  );

  CellData copyWith({
    String? value,
    String? formula,
    bool? isSelected,
    bool? isEditing,
    Map<String, dynamic>? styles,
  }) {
    return CellData(
      address: address,
      value: value ?? this.value,
      formula: formula ?? this.formula,
      isSelected: isSelected ?? this.isSelected,
      isEditing: isEditing ?? this.isEditing,
      styles: styles ?? this.styles,
    );
  }
}

class SheetData {
  String id;
  String name;
  Map<String, CellData> cells;
  bool isActive;

  SheetData({
    required this.id,
    required this.name,
    Map<String, CellData>? cells,
    this.isActive = false,
  }) : cells = cells ?? {};

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'cells': cells.map((key, value) => MapEntry(key, value.toJson())),
  };

  factory SheetData.fromJson(Map<String, dynamic> json) => SheetData(
    id: json['id'],
    name: json['name'],
    cells: (json['cells'] as Map<String, dynamic>? ?? {}).map(
      (key, value) => MapEntry(key, CellData.fromJson(value)),
    ),
  );
}

class SheetsState {
  List<SheetData> sheets;
  String? activeSheetId;
  String selectedRange;
  String activeCell;

  SheetsState({
    List<SheetData>? sheets,
    this.activeSheetId,
    this.selectedRange = 'A1',
    this.activeCell = 'A1',
  }) : sheets = sheets ?? [SheetData(id: '1', name: 'Sheet1', isActive: true)];
}
