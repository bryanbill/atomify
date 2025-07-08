import 'package:ui/src/ui.dart';

class Table extends Box {
  final List<Box> children;
  Table({
    this.children = const [],
    super.id,
    super.className,
    super.style,
    super.attributes,
    super.onRender,
  }) : super(tagName: 'table');
  @override
  render() {
    final element = super.render();
    for (final child in children) {
      element.append(child.render());
    }
    return element;
  }
}

class TableHead extends Box {
  final List<Box> children;
  TableHead({
    this.children = const [],
    super.id,
    super.className,
    super.style,
    super.attributes,
    super.onRender,
  }) : super(tagName: 'thead');
  @override
  render() {
    final element = super.render();
    for (final child in children) {
      element.append(child.render());
    }
    return element;
  }
}

class TableBody extends Box {
  final List<Box> children;
  TableBody({
    this.children = const [],
    super.id,
    super.className,
    super.style,
    super.attributes,
    super.onRender,
  }) : super(tagName: 'tbody');
  @override
  render() {
    final element = super.render();
    for (final child in children) {
      element.append(child.render());
    }
    return element;
  }
}

class TableFoot extends Box {
  final List<Box> children;
  TableFoot({
    this.children = const [],
    super.id,
    super.className,
    super.style,
    super.attributes,
    super.onRender,
  }) : super(tagName: 'tfoot');
  @override
  render() {
    final element = super.render();
    for (final child in children) {
      element.append(child.render());
    }
    return element;
  }
}

class TableRow extends Box {
  final List<Box> children;
  TableRow({
    this.children = const [],
    super.id,
    super.className,
    super.style,
    super.attributes,
    super.onRender,
  }) : super(tagName: 'tr');
  @override
  render() {
    final element = super.render();
    for (final child in children) {
      element.append(child.render());
    }
    return element;
  }
}

class TableCell extends Box {
  final List<Box> children;
  TableCell({
    super.text,
    this.children = const [],
    int? colspan,
    int? rowspan,
    String? headers,
    super.id,
    super.className,
    super.style,
    Map<String, String>? attributes,
    super.onRender,
  }) : super(
         tagName: 'td',
         attributes: {
           if (colspan != null) 'colspan': colspan.toString(),
           if (rowspan != null) 'rowspan': rowspan.toString(),
           if (headers != null) 'headers': headers,
           ...?attributes,
         },
       );
  @override
  render() {
    final element = super.render();
    for (final child in children) {
      element.append(child.render());
    }
    return element;
  }
}

class TableHeaderCell extends Box {
  final List<Box> children;
  TableHeaderCell({
    super.text,
    this.children = const [],
    String? scope, // e.g. 'col', 'row', 'colgroup', 'rowgroup'
    int? colspan,
    int? rowspan,
    String? abbr,
    String? headers,
    super.id,
    super.className,
    super.style,
    Map<String, String>? attributes,
    super.onRender,
  }) : super(
         tagName: 'th',
         attributes: {
           if (scope != null) 'scope': scope,
           if (colspan != null) 'colspan': colspan.toString(),
           if (rowspan != null) 'rowspan': rowspan.toString(),
           if (abbr != null) 'abbr': abbr,
           if (headers != null) 'headers': headers,
           ...?attributes,
         },
       );
  @override
  render() {
    final element = super.render();
    for (final child in children) {
      element.append(child.render());
    }
    return element;
  }
}

class TableCaption extends Box {
  final List<Box> children;
  TableCaption({
    super.text,
    this.children = const [],
    super.id,
    super.className,
    super.style,
    super.attributes,
    super.onRender,
  }) : super(tagName: 'caption');
  @override
  render() {
    final element = super.render();
    for (final child in children) {
      element.append(child.render());
    }
    return element;
  }
}
