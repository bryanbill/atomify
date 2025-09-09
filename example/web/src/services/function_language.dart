/// Custom Function Language Parser and Interpreter
/// A minimalistic, loosely-typed language for creating custom spreadsheet functions

import 'dart:math' as math;

/// Token types for the lexer
enum TokenType {
  // Keywords
  declare,
  accepts,
  let,
  set,
  when,
  elseWhen,
  elseDo,
  forEach,
  whileDo,
  returnValue,
  inKeyword,
  and,
  or,
  not,

  // Identifiers and literals
  identifier,
  number,
  string,
  boolean,

  // Operators
  plus,
  minus,
  multiply,
  divide,
  modulo,
  power,
  assign,
  equal,
  notEqual,
  greater,
  less,
  greaterEqual,
  lessEqual,

  // Delimiters
  semicolon,
  colon,
  comma,
  dot,
  leftParen,
  rightParen,
  leftBracket,
  rightBracket,

  // Type casting
  cast,

  // Special
  newline,
  eof,

  // Comments
  comment,
}

/// Token representation
class Token {
  final TokenType type;
  final String value;
  final int line;
  final int column;

  Token(this.type, this.value, this.line, this.column);

  @override
  String toString() => 'Token($type, "$value", $line:$column)';
}

/// Lexical analyzer
class Lexer {
  final String source;
  int position = 0;
  int line = 1;
  int column = 1;

  Lexer(this.source);

  List<Token> tokenize() {
    final tokens = <Token>[];

    while (!isAtEnd()) {
      final token = nextToken();
      if (token != null && token.type != TokenType.comment) {
        tokens.add(token);
      }
    }

    tokens.add(Token(TokenType.eof, '', line, column));
    return tokens;
  }

  Token? nextToken() {
    skipWhitespace();

    if (isAtEnd()) return null;

    final start = position;
    final startLine = line;
    final startColumn = column;
    final char = advance();

    switch (char) {
      case '\n':
        line++;
        column = 1;
        return Token(TokenType.newline, char, startLine, startColumn);
      case ';':
        return Token(TokenType.semicolon, char, startLine, startColumn);
      case ':':
        if (peek() == ':') {
          advance();
          return Token(TokenType.cast, '::', startLine, startColumn);
        }
        return Token(TokenType.colon, char, startLine, startColumn);
      case ',':
        return Token(TokenType.comma, char, startLine, startColumn);
      case '.':
        return Token(TokenType.dot, char, startLine, startColumn);
      case '(':
        return Token(TokenType.leftParen, char, startLine, startColumn);
      case ')':
        return Token(TokenType.rightParen, char, startLine, startColumn);
      case '[':
        return Token(TokenType.leftBracket, char, startLine, startColumn);
      case ']':
        return Token(TokenType.rightBracket, char, startLine, startColumn);
      case '+':
        return Token(TokenType.plus, char, startLine, startColumn);
      case '-':
        return Token(TokenType.minus, char, startLine, startColumn);
      case '*':
        return Token(TokenType.multiply, char, startLine, startColumn);
      case '/':
        if (peek() == '/') {
          // Single line comment
          while (peek() != '\n' && !isAtEnd()) advance();
          return Token(
            TokenType.comment,
            source.substring(start, position),
            startLine,
            startColumn,
          );
        }
        if (peek() == '*') {
          // Multi-line comment
          advance();
          while (!isAtEnd()) {
            if (current() == '*' && peekNext() == '/') {
              advance();
              advance();
              break;
            }
            if (advance() == '\n') {
              line++;
              column = 1;
            }
          }
          return Token(
            TokenType.comment,
            source.substring(start, position),
            startLine,
            startColumn,
          );
        }
        return Token(TokenType.divide, char, startLine, startColumn);
      case '%':
        return Token(TokenType.modulo, char, startLine, startColumn);
      case '^':
        return Token(TokenType.power, char, startLine, startColumn);
      case '=':
        if (peek() == '=') {
          advance();
          return Token(TokenType.equal, '==', startLine, startColumn);
        }
        return Token(TokenType.assign, char, startLine, startColumn);
      case '!':
        if (peek() == '=') {
          advance();
          return Token(TokenType.notEqual, '!=', startLine, startColumn);
        }
        break;
      case '>':
        if (peek() == '=') {
          advance();
          return Token(TokenType.greaterEqual, '>=', startLine, startColumn);
        }
        return Token(TokenType.greater, char, startLine, startColumn);
      case '<':
        if (peek() == '=') {
          advance();
          return Token(TokenType.lessEqual, '<=', startLine, startColumn);
        }
        return Token(TokenType.less, char, startLine, startColumn);
      case '"':
      case "'":
        return stringToken(char, startLine, startColumn);
      default:
        if (isDigit(char)) {
          position--;
          column--;
          return numberToken(startLine, startColumn);
        }
        if (isAlpha(char)) {
          position--;
          column--;
          return identifierToken(startLine, startColumn);
        }
        break;
    }

    throw Exception(
      'Unexpected character "$char" at line $startLine, column $startColumn',
    );
  }

  Token stringToken(String quote, int startLine, int startColumn) {
    final value = StringBuffer();

    while (peek() != quote && !isAtEnd()) {
      if (peek() == '\n') {
        line++;
        column = 1;
      }
      if (peek() == '\\') {
        advance();
        switch (peek()) {
          case 'n':
            value.write('\n');
            break;
          case 't':
            value.write('\t');
            break;
          case 'r':
            value.write('\r');
            break;
          case '\\':
            value.write('\\');
            break;
          case '"':
            value.write('"');
            break;
          case "'":
            value.write("'");
            break;
          default:
            value.write(advance());
            break;
        }
      } else {
        value.write(advance());
      }
    }

    if (isAtEnd()) {
      throw Exception(
        'Unterminated string at line $startLine, column $startColumn',
      );
    }

    advance(); // Consume closing quote
    return Token(TokenType.string, value.toString(), startLine, startColumn);
  }

  Token numberToken(int startLine, int startColumn) {
    final start = position;

    while (isDigit(peek())) advance();

    if (peek() == '.' && isDigit(peekNext())) {
      advance(); // Consume '.'
      while (isDigit(peek())) advance();
    }

    final value = source.substring(start, position);
    return Token(TokenType.number, value, startLine, startColumn);
  }

  Token identifierToken(int startLine, int startColumn) {
    final start = position;

    while (isAlphaNumeric(peek())) advance();

    final value = source.substring(start, position);
    final type = getKeywordType(value);

    return Token(type, value, startLine, startColumn);
  }

  TokenType getKeywordType(String text) {
    switch (text.toLowerCase()) {
      case 'declare':
        return TokenType.declare;
      case 'accepts':
        return TokenType.accepts;
      case 'let':
        return TokenType.let;
      case 'set':
        return TokenType.set;
      case 'when':
        return TokenType.when;
      case 'else':
        return TokenType.elseDo;
      case 'for':
        return TokenType.forEach;
      case 'each':
        return TokenType.forEach;
      case 'while':
        return TokenType.whileDo;
      case 'return':
        return TokenType.returnValue;
      case 'in':
        return TokenType.inKeyword;
      case 'and':
        return TokenType.and;
      case 'or':
        return TokenType.or;
      case 'not':
        return TokenType.not;
      case 'true':
      case 'false':
        return TokenType.boolean;
      default:
        return TokenType.identifier;
    }
  }

  void skipWhitespace() {
    while (!isAtEnd() &&
        (current() == ' ' || current() == '\t' || current() == '\r')) {
      advance();
    }
  }

  bool isAtEnd() => position >= source.length;
  String current() => isAtEnd() ? '\0' : source[position];
  String peek() => position + 1 >= source.length ? '\0' : source[position + 1];
  String peekNext() =>
      position + 2 >= source.length ? '\0' : source[position + 2];

  String advance() {
    column++;
    return source[position++];
  }

  bool isDigit(String char) =>
      char.codeUnitAt(0) >= '0'.codeUnitAt(0) &&
      char.codeUnitAt(0) <= '9'.codeUnitAt(0);
  bool isAlpha(String char) =>
      (char.codeUnitAt(0) >= 'a'.codeUnitAt(0) &&
          char.codeUnitAt(0) <= 'z'.codeUnitAt(0)) ||
      (char.codeUnitAt(0) >= 'A'.codeUnitAt(0) &&
          char.codeUnitAt(0) <= 'Z'.codeUnitAt(0)) ||
      char == '_';
  bool isAlphaNumeric(String char) => isAlpha(char) || isDigit(char);
}

/// Abstract Syntax Tree nodes
abstract class ASTNode {
  dynamic accept(ASTVisitor visitor);
}

/// AST Visitor pattern
abstract class ASTVisitor {
  dynamic visitFunctionDeclaration(FunctionDeclaration node);
  dynamic visitParameterList(ParameterList node);
  dynamic visitVariableDeclaration(VariableDeclaration node);
  dynamic visitAssignment(Assignment node);
  dynamic visitConditional(Conditional node);
  dynamic visitLoop(Loop node);
  dynamic visitReturn(Return node);
  dynamic visitExpression(Expression node);
  dynamic visitBinaryOperation(BinaryOperation node);
  dynamic visitUnaryOperation(UnaryOperation node);
  dynamic visitFunctionCall(FunctionCall node);
  dynamic visitModuleAccess(ModuleAccess node);
  dynamic visitIdentifier(Identifier node);
  dynamic visitLiteral(Literal node);
  dynamic visitCastExpression(CastExpression node);
}

class FunctionDeclaration extends ASTNode {
  final String name;
  final ParameterList? parameters;
  final List<ASTNode> body;

  FunctionDeclaration(this.name, this.parameters, this.body);

  @override
  dynamic accept(ASTVisitor visitor) => visitor.visitFunctionDeclaration(this);
}

class ParameterList extends ASTNode {
  final List<String> parameters;

  ParameterList(this.parameters);

  @override
  dynamic accept(ASTVisitor visitor) => visitor.visitParameterList(this);
}

class VariableDeclaration extends ASTNode {
  final String name;
  final Expression? initialValue;

  VariableDeclaration(this.name, this.initialValue);

  @override
  dynamic accept(ASTVisitor visitor) => visitor.visitVariableDeclaration(this);
}

class Assignment extends ASTNode {
  final String name;
  final Expression value;

  Assignment(this.name, this.value);

  @override
  dynamic accept(ASTVisitor visitor) => visitor.visitAssignment(this);
}

class Conditional extends ASTNode {
  final Expression condition;
  final List<ASTNode> thenBranch;
  final List<ASTNode>? elseBranch;

  Conditional(this.condition, this.thenBranch, this.elseBranch);

  @override
  dynamic accept(ASTVisitor visitor) => visitor.visitConditional(this);
}

class Loop extends ASTNode {
  final String? variable; // For 'for each'
  final Expression? iterable; // For 'for each'
  final Expression? condition; // For 'while'
  final List<ASTNode> body;
  final bool isForEach;

  Loop.forEach(this.variable, this.iterable, this.body)
    : condition = null,
      isForEach = true;

  Loop.whileLoop(this.condition, this.body)
    : variable = null,
      iterable = null,
      isForEach = false;

  @override
  dynamic accept(ASTVisitor visitor) => visitor.visitLoop(this);
}

class Return extends ASTNode {
  final Expression value;

  Return(this.value);

  @override
  dynamic accept(ASTVisitor visitor) => visitor.visitReturn(this);
}

abstract class Expression extends ASTNode {
  @override
  dynamic accept(ASTVisitor visitor) => visitor.visitExpression(this);
}

class BinaryOperation extends Expression {
  final Expression left;
  final TokenType operator;
  final Expression right;

  BinaryOperation(this.left, this.operator, this.right);

  @override
  dynamic accept(ASTVisitor visitor) => visitor.visitBinaryOperation(this);
}

class UnaryOperation extends Expression {
  final TokenType operator;
  final Expression operand;

  UnaryOperation(this.operator, this.operand);

  @override
  dynamic accept(ASTVisitor visitor) => visitor.visitUnaryOperation(this);
}

class FunctionCall extends Expression {
  final String name;
  final List<Expression> arguments;

  FunctionCall(this.name, this.arguments);

  @override
  dynamic accept(ASTVisitor visitor) => visitor.visitFunctionCall(this);
}

class ModuleAccess extends Expression {
  final String module;
  final String member;
  final List<Expression> arguments;

  ModuleAccess(this.module, this.member, this.arguments);

  @override
  dynamic accept(ASTVisitor visitor) => visitor.visitModuleAccess(this);
}

class Identifier extends Expression {
  final String name;

  Identifier(this.name);

  @override
  dynamic accept(ASTVisitor visitor) => visitor.visitIdentifier(this);
}

class Literal extends Expression {
  final dynamic value;

  Literal(this.value);

  @override
  dynamic accept(ASTVisitor visitor) => visitor.visitLiteral(this);
}

class CastExpression extends Expression {
  final Expression expression;
  final String type;

  CastExpression(this.expression, this.type);

  @override
  dynamic accept(ASTVisitor visitor) => visitor.visitCastExpression(this);
}

/// Parser for the custom function language
class Parser {
  final List<Token> tokens;
  int current = 0;

  Parser(this.tokens);

  FunctionDeclaration parseFunction() {
    consume(TokenType.declare, "Expected 'declare'");
    final name = consume(TokenType.identifier, "Expected function name").value;
    consume(TokenType.semicolon, "Expected ';' after function name");

    ParameterList? parameters;
    if (match(TokenType.accepts)) {
      parameters = parseParameters();
      consume(TokenType.semicolon, "Expected ';' after parameters");
    }

    final body = <ASTNode>[];
    while (!check(TokenType.returnValue) && !isAtEnd()) {
      skipNewlines();
      if (check(TokenType.returnValue) || isAtEnd()) break;
      body.add(parseStatement());
    }

    consume(TokenType.returnValue, "Expected 'return' statement");
    final returnValue = Return(parseExpression());
    consume(TokenType.semicolon, "Expected ';' after return statement");

    body.add(returnValue);
    return FunctionDeclaration(name, parameters, body);
  }

  ParameterList parseParameters() {
    final parameters = <String>[];

    do {
      if (!check(TokenType.identifier)) break;
      parameters.add(advance().value);
    } while (match(TokenType.comma));

    return ParameterList(parameters);
  }

  ASTNode parseStatement() {
    skipNewlines();

    if (match(TokenType.let)) {
      return parseVariableDeclaration();
    }
    if (match(TokenType.set)) {
      return parseAssignment();
    }
    if (match(TokenType.when)) {
      return parseConditional();
    }
    if (match(TokenType.forEach)) {
      return parseForLoop();
    }
    if (match(TokenType.whileDo)) {
      return parseWhileLoop();
    }

    // Expression statement
    final expr = parseExpression();
    if (!check(TokenType.newline) &&
        !check(TokenType.semicolon) &&
        !isAtEnd()) {
      consume(TokenType.semicolon, "Expected ';' after expression");
    }
    return expr;
  }

  VariableDeclaration parseVariableDeclaration() {
    final name = consume(TokenType.identifier, "Expected variable name").value;
    Expression? initialValue;

    if (match(TokenType.assign)) {
      initialValue = parseExpression();
    }

    if (!check(TokenType.newline) &&
        !check(TokenType.semicolon) &&
        !isAtEnd()) {
      consume(TokenType.semicolon, "Expected ';' after variable declaration");
    }

    return VariableDeclaration(name, initialValue);
  }

  Assignment parseAssignment() {
    final name = consume(TokenType.identifier, "Expected variable name").value;
    consume(TokenType.assign, "Expected '=' in assignment");
    final value = parseExpression();

    if (!check(TokenType.newline) &&
        !check(TokenType.semicolon) &&
        !isAtEnd()) {
      consume(TokenType.semicolon, "Expected ';' after assignment");
    }

    return Assignment(name, value);
  }

  Conditional parseConditional() {
    final condition = parseExpression();
    consume(TokenType.colon, "Expected ':' after condition");
    skipNewlines();

    final thenBranch = <ASTNode>[];
    while (!check(TokenType.elseDo) &&
        !check(TokenType.when) &&
        !check(TokenType.returnValue) &&
        !isAtEnd()) {
      if (peek().type == TokenType.elseDo ||
          (peek().type == TokenType.identifier &&
              peekNext().type == TokenType.when)) {
        break;
      }
      skipNewlines();
      if (!check(TokenType.elseDo) &&
          !check(TokenType.when) &&
          !check(TokenType.returnValue) &&
          !isAtEnd()) {
        thenBranch.add(parseStatement());
      }
    }

    List<ASTNode>? elseBranch;
    if (match(TokenType.elseDo)) {
      if (match(TokenType.when)) {
        // else when - recursive conditional
        elseBranch = [parseConditional()];
      } else {
        consume(TokenType.colon, "Expected ':' after 'else'");
        skipNewlines();
        elseBranch = <ASTNode>[];
        while (!check(TokenType.when) &&
            !check(TokenType.returnValue) &&
            !isAtEnd()) {
          skipNewlines();
          if (!check(TokenType.when) &&
              !check(TokenType.returnValue) &&
              !isAtEnd()) {
            elseBranch.add(parseStatement());
          }
        }
      }
    }

    return Conditional(condition, thenBranch, elseBranch);
  }

  Loop parseForLoop() {
    consume(TokenType.identifier, "Expected 'each' after 'for'"); // each
    final variable = consume(
      TokenType.identifier,
      "Expected variable name",
    ).value;
    consume(TokenType.inKeyword, "Expected 'in'");
    final iterable = parseExpression();
    consume(TokenType.colon, "Expected ':' after for expression");
    skipNewlines();

    final body = <ASTNode>[];
    while (!check(TokenType.when) &&
        !check(TokenType.returnValue) &&
        !isAtEnd()) {
      skipNewlines();
      if (!check(TokenType.when) &&
          !check(TokenType.returnValue) &&
          !isAtEnd()) {
        body.add(parseStatement());
      }
    }

    return Loop.forEach(variable, iterable, body);
  }

  Loop parseWhileLoop() {
    final condition = parseExpression();
    consume(TokenType.colon, "Expected ':' after while condition");
    skipNewlines();

    final body = <ASTNode>[];
    while (!check(TokenType.when) &&
        !check(TokenType.returnValue) &&
        !isAtEnd()) {
      skipNewlines();
      if (!check(TokenType.when) &&
          !check(TokenType.returnValue) &&
          !isAtEnd()) {
        body.add(parseStatement());
      }
    }

    return Loop.whileLoop(condition, body);
  }

  Expression parseExpression() {
    return parseLogicalOr();
  }

  Expression parseLogicalOr() {
    Expression expr = parseLogicalAnd();

    while (match(TokenType.or)) {
      final operator = previous().type;
      final right = parseLogicalAnd();
      expr = BinaryOperation(expr, operator, right);
    }

    return expr;
  }

  Expression parseLogicalAnd() {
    Expression expr = parseEquality();

    while (match(TokenType.and)) {
      final operator = previous().type;
      final right = parseEquality();
      expr = BinaryOperation(expr, operator, right);
    }

    return expr;
  }

  Expression parseEquality() {
    Expression expr = parseComparison();

    while (match(TokenType.notEqual, TokenType.equal)) {
      final operator = previous().type;
      final right = parseComparison();
      expr = BinaryOperation(expr, operator, right);
    }

    return expr;
  }

  Expression parseComparison() {
    Expression expr = parseTerm();

    while (match(
      TokenType.greater,
      TokenType.greaterEqual,
      TokenType.less,
      TokenType.lessEqual,
    )) {
      final operator = previous().type;
      final right = parseTerm();
      expr = BinaryOperation(expr, operator, right);
    }

    return expr;
  }

  Expression parseTerm() {
    Expression expr = parseFactor();

    while (match(TokenType.minus, TokenType.plus)) {
      final operator = previous().type;
      final right = parseFactor();
      expr = BinaryOperation(expr, operator, right);
    }

    return expr;
  }

  Expression parseFactor() {
    Expression expr = parseUnary();

    while (match(TokenType.divide, TokenType.multiply, TokenType.modulo)) {
      final operator = previous().type;
      final right = parseUnary();
      expr = BinaryOperation(expr, operator, right);
    }

    return expr;
  }

  Expression parseUnary() {
    if (match(TokenType.not, TokenType.minus)) {
      final operator = previous().type;
      final right = parseUnary();
      return UnaryOperation(operator, right);
    }

    return parsePower();
  }

  Expression parsePower() {
    Expression expr = parseCall();

    if (match(TokenType.power)) {
      final operator = previous().type;
      final right = parseUnary(); // Right-associative
      expr = BinaryOperation(expr, operator, right);
    }

    return expr;
  }

  Expression parseCall() {
    Expression expr = parsePrimary();

    while (true) {
      if (match(TokenType.leftParen)) {
        expr = finishCall(expr);
      } else if (match(TokenType.dot)) {
        final name = consume(
          TokenType.identifier,
          "Expected method name after '.'",
        ).value;
        if (expr is Identifier) {
          // Module access like Math.pow()
          if (match(TokenType.leftParen)) {
            final args = parseArguments();
            expr = ModuleAccess((expr as Identifier).name, name, args);
          } else {
            // Property access - treat as module constant
            expr = ModuleAccess((expr as Identifier).name, name, []);
          }
        }
      } else if (match(TokenType.cast)) {
        final type = consume(
          TokenType.identifier,
          "Expected type name after '::'",
        ).value;
        expr = CastExpression(expr, type);
      } else {
        break;
      }
    }

    return expr;
  }

  Expression finishCall(Expression callee) {
    final arguments = parseArguments();

    if (callee is Identifier) {
      return FunctionCall(callee.name, arguments);
    }

    throw Exception('Invalid function call');
  }

  List<Expression> parseArguments() {
    final arguments = <Expression>[];

    if (!check(TokenType.rightParen)) {
      do {
        arguments.add(parseExpression());
      } while (match(TokenType.comma));
    }

    consume(TokenType.rightParen, "Expected ')' after arguments");
    return arguments;
  }

  Expression parsePrimary() {
    if (match(TokenType.boolean)) {
      return Literal(previous().value.toLowerCase() == 'true');
    }

    if (match(TokenType.number)) {
      final value = previous().value;
      return Literal(
        value.contains('.') ? double.parse(value) : int.parse(value),
      );
    }

    if (match(TokenType.string)) {
      return Literal(previous().value);
    }

    if (match(TokenType.identifier)) {
      return Identifier(previous().value);
    }

    if (match(TokenType.leftParen)) {
      final expr = parseExpression();
      consume(TokenType.rightParen, "Expected ')' after expression");
      return expr;
    }

    throw Exception('Unexpected token: ${peek().value}');
  }

  bool match([
    TokenType? type1,
    TokenType? type2,
    TokenType? type3,
    TokenType? type4,
  ]) {
    final types = [
      type1,
      type2,
      type3,
      type4,
    ].where((t) => t != null).cast<TokenType>();
    for (final type in types) {
      if (check(type)) {
        advance();
        return true;
      }
    }
    return false;
  }

  Token consume(TokenType type, String message) {
    if (check(type)) return advance();
    throw Exception('$message. Got ${peek().type} at line ${peek().line}');
  }

  bool check(TokenType type) {
    if (isAtEnd()) return false;
    return peek().type == type;
  }

  Token advance() {
    if (!isAtEnd()) current++;
    return previous();
  }

  bool isAtEnd() => peek().type == TokenType.eof;
  Token peek() => tokens[current];
  Token peekNext() =>
      current + 1 < tokens.length ? tokens[current + 1] : tokens.last;
  Token previous() => tokens[current - 1];

  void skipNewlines() {
    while (match(TokenType.newline)) {
      // Skip newlines
    }
  }
}

/// Runtime environment for variable storage and function execution
class Environment {
  final Map<String, dynamic> _variables = {};
  final Environment? _parent;

  Environment([this._parent]);

  void define(String name, dynamic value) {
    _variables[name] = value;
  }

  dynamic get(String name) {
    if (_variables.containsKey(name)) {
      return _variables[name];
    }

    if (_parent != null) {
      return _parent!.get(name);
    }

    throw Exception('Undefined variable: $name');
  }

  void assign(String name, dynamic value) {
    if (_variables.containsKey(name)) {
      _variables[name] = value;
      return;
    }

    if (_parent != null) {
      _parent!.assign(name, value);
      return;
    }

    throw Exception('Undefined variable: $name');
  }

  bool isDefined(String name) {
    return _variables.containsKey(name) || (_parent?.isDefined(name) ?? false);
  }
}

/// Standard library modules
class StandardLibrary {
  static final Map<String, Map<String, Function>> modules = {
    'Math': _mathModule(),
    'Fetch': _fetchModule(),
    'Regexp': _regexpModule(),
    'Collections': _collectionsModule(),
  };

  static Map<String, Function> _mathModule() => {
    // Basic operations
    'round': (List<dynamic> args) => _validateArgs(args, 1, 2, () {
      final number = _toNumber(args[0]);
      final decimals = args.length > 1 ? _toNumber(args[1]).toInt() : 0;
      final factor = math.pow(10, decimals);
      return (number * factor).round() / factor;
    }),
    'floor': (List<dynamic> args) =>
        _validateArgs(args, 1, 1, () => _toNumber(args[0]).floor()),
    'ceil': (List<dynamic> args) =>
        _validateArgs(args, 1, 1, () => _toNumber(args[0]).ceil()),
    'abs': (List<dynamic> args) =>
        _validateArgs(args, 1, 1, () => _toNumber(args[0]).abs()),
    'sign': (List<dynamic> args) =>
        _validateArgs(args, 1, 1, () => _toNumber(args[0]).sign),
    'min': (List<dynamic> args) =>
        args.isEmpty ? 0 : args.map(_toNumber).reduce(math.min),
    'max': (List<dynamic> args) =>
        args.isEmpty ? 0 : args.map(_toNumber).reduce(math.max),

    // Power & root functions
    'pow': (List<dynamic> args) => _validateArgs(
      args,
      2,
      2,
      () => math.pow(_toNumber(args[0]), _toNumber(args[1])),
    ),
    'sqrt': (List<dynamic> args) =>
        _validateArgs(args, 1, 1, () => math.sqrt(_toNumber(args[0]))),
    'cbrt': (List<dynamic> args) =>
        _validateArgs(args, 1, 1, () => math.pow(_toNumber(args[0]), 1 / 3)),

    // Trigonometric functions
    'sin': (List<dynamic> args) =>
        _validateArgs(args, 1, 1, () => math.sin(_toNumber(args[0]))),
    'cos': (List<dynamic> args) =>
        _validateArgs(args, 1, 1, () => math.cos(_toNumber(args[0]))),
    'tan': (List<dynamic> args) =>
        _validateArgs(args, 1, 1, () => math.tan(_toNumber(args[0]))),
    'asin': (List<dynamic> args) =>
        _validateArgs(args, 1, 1, () => math.asin(_toNumber(args[0]))),
    'acos': (List<dynamic> args) =>
        _validateArgs(args, 1, 1, () => math.acos(_toNumber(args[0]))),
    'atan': (List<dynamic> args) =>
        _validateArgs(args, 1, 1, () => math.atan(_toNumber(args[0]))),
    'atan2': (List<dynamic> args) => _validateArgs(
      args,
      2,
      2,
      () => math.atan2(_toNumber(args[0]), _toNumber(args[1])),
    ),

    // Logarithmic functions
    'log': (List<dynamic> args) =>
        _validateArgs(args, 1, 1, () => math.log(_toNumber(args[0]))),
    'log10': (List<dynamic> args) => _validateArgs(
      args,
      1,
      1,
      () => math.log(_toNumber(args[0])) / math.ln10,
    ),
    'log2': (List<dynamic> args) => _validateArgs(
      args,
      1,
      1,
      () => math.log(_toNumber(args[0])) / math.ln2,
    ),
    'exp': (List<dynamic> args) =>
        _validateArgs(args, 1, 1, () => math.exp(_toNumber(args[0]))),

    // Random functions
    'random': (List<dynamic> args) =>
        _validateArgs(args, 0, 0, () => math.Random().nextDouble()),
    'random_int': (List<dynamic> args) => _validateArgs(args, 2, 2, () {
      final min = _toNumber(args[0]).toInt();
      final max = _toNumber(args[1]).toInt();
      return min + math.Random().nextInt(max - min + 1);
    }),

    // Constants (as functions for consistency)
    'PI': (List<dynamic> args) => math.pi,
    'E': (List<dynamic> args) => math.e,
  };

  static Map<String, Function> _fetchModule() => {
    // Note: These would be implemented with actual HTTP client in a real app
    'get': (List<dynamic> args) =>
        throw Exception('Fetch operations not implemented in demo'),
    'post': (List<dynamic> args) =>
        throw Exception('Fetch operations not implemented in demo'),
    'put': (List<dynamic> args) =>
        throw Exception('Fetch operations not implemented in demo'),
    'delete': (List<dynamic> args) =>
        throw Exception('Fetch operations not implemented in demo'),
    'json': (List<dynamic> args) =>
        throw Exception('Fetch operations not implemented in demo'),
    'text': (List<dynamic> args) =>
        throw Exception('Fetch operations not implemented in demo'),
  };

  static Map<String, Function> _regexpModule() => {
    'test': (List<dynamic> args) => _validateArgs(args, 2, 2, () {
      final pattern = args[0].toString();
      final text = args[1].toString();
      return RegExp(pattern).hasMatch(text);
    }),
    'match': (List<dynamic> args) => _validateArgs(args, 2, 2, () {
      final pattern = args[0].toString();
      final text = args[1].toString();
      final match = RegExp(pattern).firstMatch(text);
      return match?.group(0) ?? '';
    }),
    'match_all': (List<dynamic> args) => _validateArgs(args, 2, 2, () {
      final pattern = args[0].toString();
      final text = args[1].toString();
      return RegExp(
        pattern,
      ).allMatches(text).map((m) => m.group(0) ?? '').toList();
    }),
    'replace': (List<dynamic> args) => _validateArgs(args, 3, 3, () {
      final pattern = args[0].toString();
      final replacement = args[1].toString();
      final text = args[2].toString();
      return text.replaceAll(RegExp(pattern), replacement);
    }),
    'split': (List<dynamic> args) => _validateArgs(args, 2, 2, () {
      final pattern = args[0].toString();
      final text = args[1].toString();
      return text.split(RegExp(pattern));
    }),

    // Common patterns
    'email': () => r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    'phone': () => r'^[\+]?[1-9][\d]{0,15}$',
    'url': () => r'^https?:\/\/[^\s/$.?#].[^\s]*$',
    'number': () => r'-?\d+(?:\.\d+)?',
    'word': () => r'\b\w+\b',
  };

  static Map<String, Function> _collectionsModule() => {
    'create_list': (List<dynamic> args) => List.from(args),
    'append': (List<dynamic> args) => _validateArgs(args, 2, 2, () {
      final list = _toList(args[0]);
      list.add(args[1]);
      return list;
    }),
    'prepend': (List<dynamic> args) => _validateArgs(args, 2, 2, () {
      final list = _toList(args[0]);
      list.insert(0, args[1]);
      return list;
    }),
    'insert': (List<dynamic> args) => _validateArgs(args, 3, 3, () {
      final list = _toList(args[0]);
      final index = _toNumber(args[1]).toInt();
      list.insert(index, args[2]);
      return list;
    }),
    'remove': (List<dynamic> args) => _validateArgs(args, 2, 2, () {
      final list = _toList(args[0]);
      list.remove(args[1]);
      return list;
    }),
    'remove_at': (List<dynamic> args) => _validateArgs(args, 2, 2, () {
      final list = _toList(args[0]);
      final index = _toNumber(args[1]).toInt();
      list.removeAt(index);
      return list;
    }),
    'clear': (List<dynamic> args) => _validateArgs(args, 1, 1, () {
      final list = _toList(args[0]);
      list.clear();
      return list;
    }),

    // Querying
    'contains': (List<dynamic> args) => _validateArgs(args, 2, 2, () {
      final list = _toList(args[0]);
      return list.contains(args[1]);
    }),
    'index_of': (List<dynamic> args) => _validateArgs(args, 2, 2, () {
      final list = _toList(args[0]);
      return list.indexOf(args[1]);
    }),
    'first': (List<dynamic> args) => _validateArgs(args, 1, 1, () {
      final list = _toList(args[0]);
      return list.isEmpty ? null : list.first;
    }),
    'last': (List<dynamic> args) => _validateArgs(args, 1, 1, () {
      final list = _toList(args[0]);
      return list.isEmpty ? null : list.last;
    }),
    'slice': (List<dynamic> args) => _validateArgs(args, 3, 3, () {
      final list = _toList(args[0]);
      final start = _toNumber(args[1]).toInt();
      final end = _toNumber(args[2]).toInt();
      return list.sublist(start, math.min(end, list.length));
    }),
    'reverse': (List<dynamic> args) => _validateArgs(args, 1, 1, () {
      final list = _toList(args[0]);
      return List.from(list.reversed);
    }),

    // Transformation
    'sort': (List<dynamic> args) => _validateArgs(args, 1, 1, () {
      final list = _toList(args[0]);
      final sorted = List.from(list);
      sorted.sort();
      return sorted;
    }),
    'sort_desc': (List<dynamic> args) => _validateArgs(args, 1, 1, () {
      final list = _toList(args[0]);
      final sorted = List.from(list);
      sorted.sort((a, b) => b.toString().compareTo(a.toString()));
      return sorted;
    }),
    'unique': (List<dynamic> args) => _validateArgs(args, 1, 1, () {
      final list = _toList(args[0]);
      return list.toSet().toList();
    }),
    'flatten': (List<dynamic> args) => _validateArgs(args, 1, 1, () {
      final list = _toList(args[0]);
      final flattened = <dynamic>[];
      for (final item in list) {
        if (item is List) {
          flattened.addAll(item);
        } else {
          flattened.add(item);
        }
      }
      return flattened;
    }),

    // Set operations
    'union': (List<dynamic> args) => _validateArgs(args, 2, 2, () {
      final list1 = _toList(args[0]);
      final list2 = _toList(args[1]);
      return (list1.toSet()..addAll(list2.toSet())).toList();
    }),
    'intersection': (List<dynamic> args) => _validateArgs(args, 2, 2, () {
      final list1 = _toList(args[0]);
      final list2 = _toList(args[1]);
      final set2 = list2.toSet();
      return list1.where((item) => set2.contains(item)).toList();
    }),
    'difference': (List<dynamic> args) => _validateArgs(args, 2, 2, () {
      final list1 = _toList(args[0]);
      final list2 = _toList(args[1]);
      final set2 = list2.toSet();
      return list1.where((item) => !set2.contains(item)).toList();
    }),

    // Aggregation
    'chunk': (List<dynamic> args) => _validateArgs(args, 2, 2, () {
      final list = _toList(args[0]);
      final size = _toNumber(args[1]).toInt();
      final chunks = <List<dynamic>>[];
      for (int i = 0; i < list.length; i += size) {
        chunks.add(list.sublist(i, math.min(i + size, list.length)));
      }
      return chunks;
    }),
  };

  // Helper functions
  static T _validateArgs<T>(
    List<dynamic> args,
    int minArgs,
    int maxArgs,
    T Function() fn,
  ) {
    if (args.length < minArgs || args.length > maxArgs) {
      throw Exception(
        'Expected $minArgs-$maxArgs arguments, got ${args.length}',
      );
    }
    return fn();
  }

  static num _toNumber(dynamic value) {
    if (value is num) return value;
    if (value is String) {
      final parsed = num.tryParse(value);
      if (parsed != null) return parsed;
    }
    throw Exception('Cannot convert $value to number');
  }

  static List<dynamic> _toList(dynamic value) {
    if (value is List) return value;
    throw Exception('Expected list, got ${value.runtimeType}');
  }
}

/// Language runtime interpreter
class Interpreter implements ASTVisitor {
  final Environment globals = Environment();
  Environment environment;
  final Map<String, String> cellValues;

  Interpreter(this.cellValues) : environment = Environment() {
    // Add built-in functions to global environment
    _addBuiltinFunctions();
  }

  void _addBuiltinFunctions() {
    globals.define(
      'cell',
      (String address) => cellValues[address.toUpperCase()] ?? '',
    );
    globals.define(
      'range',
      (String start, String end) => _getCellRange(start, end),
    );
    globals.define(
      'set_cell',
      (String address, dynamic value) => _setCellValue(address, value),
    );
    globals.define('row', () => 1); // Placeholder
    globals.define('column', () => 'A'); // Placeholder
    globals.define('length', (dynamic collection) => _getLength(collection));
    globals.define('sum', (dynamic collection) => _sum(collection));
    globals.define('avg', (dynamic collection) => _average(collection));
    globals.define('max', (dynamic collection) => _max(collection));
    globals.define('min', (dynamic collection) => _min(collection));
    globals.define('count', (dynamic collection) => _count(collection));
    globals.define(
      'round',
      (num number, [int decimals = 0]) => _round(number, decimals),
    );
    globals.define('abs', (num number) => number.abs());
    globals.define('error', (String message) => throw Exception(message));

    environment = Environment(globals);
  }

  dynamic interpret(FunctionDeclaration function, List<dynamic> arguments) {
    // Create new environment for function execution
    final functionEnv = Environment(environment);

    // Bind parameters to arguments
    if (function.parameters != null) {
      final params = function.parameters!.parameters;
      if (arguments.length != params.length) {
        throw Exception(
          'Expected ${params.length} arguments, got ${arguments.length}',
        );
      }

      for (int i = 0; i < params.length; i++) {
        functionEnv.define(params[i], arguments[i]);
      }
    }

    final previous = environment;
    try {
      environment = functionEnv;

      dynamic result;
      for (final statement in function.body) {
        result = statement.accept(this);
        if (statement is Return) {
          return result;
        }
      }

      return result;
    } finally {
      environment = previous;
    }
  }

  @override
  dynamic visitFunctionDeclaration(FunctionDeclaration node) {
    // Function declarations are handled at a higher level
    return null;
  }

  @override
  dynamic visitParameterList(ParameterList node) {
    return node.parameters;
  }

  @override
  dynamic visitVariableDeclaration(VariableDeclaration node) {
    dynamic value;
    if (node.initialValue != null) {
      value = node.initialValue!.accept(this);
    }
    environment.define(node.name, value);
    return value;
  }

  @override
  dynamic visitAssignment(Assignment node) {
    final value = node.value.accept(this);
    environment.assign(node.name, value);
    return value;
  }

  @override
  dynamic visitConditional(Conditional node) {
    final condition = node.condition.accept(this);

    if (_isTruthy(condition)) {
      dynamic result;
      for (final statement in node.thenBranch) {
        result = statement.accept(this);
      }
      return result;
    } else if (node.elseBranch != null) {
      dynamic result;
      for (final statement in node.elseBranch!) {
        result = statement.accept(this);
      }
      return result;
    }

    return null;
  }

  @override
  dynamic visitLoop(Loop node) {
    if (node.isForEach) {
      final iterable = node.iterable!.accept(this);
      final collection = _toIterable(iterable);

      for (final item in collection) {
        environment.define(node.variable!, item);

        for (final statement in node.body) {
          statement.accept(this);
        }
      }
    } else {
      while (_isTruthy(node.condition!.accept(this))) {
        for (final statement in node.body) {
          statement.accept(this);
        }
      }
    }

    return null;
  }

  @override
  dynamic visitReturn(Return node) {
    return node.value.accept(this);
  }

  @override
  dynamic visitExpression(Expression node) {
    return node.accept(this);
  }

  @override
  dynamic visitBinaryOperation(BinaryOperation node) {
    final left = node.left.accept(this);
    final right = node.right.accept(this);

    switch (node.operator) {
      case TokenType.minus:
        return _toNumber(left) - _toNumber(right);
      case TokenType.plus:
        if (left is String || right is String) {
          return left.toString() + right.toString();
        }
        return _toNumber(left) + _toNumber(right);
      case TokenType.divide:
        final rightNum = _toNumber(right);
        if (rightNum == 0) throw Exception('Division by zero');
        return _toNumber(left) / rightNum;
      case TokenType.multiply:
        return _toNumber(left) * _toNumber(right);
      case TokenType.modulo:
        return _toNumber(left) % _toNumber(right);
      case TokenType.power:
        return math.pow(_toNumber(left), _toNumber(right));
      case TokenType.greater:
        return _compare(left, right) > 0;
      case TokenType.greaterEqual:
        return _compare(left, right) >= 0;
      case TokenType.less:
        return _compare(left, right) < 0;
      case TokenType.lessEqual:
        return _compare(left, right) <= 0;
      case TokenType.notEqual:
        return !_isEqual(left, right);
      case TokenType.equal:
        return _isEqual(left, right);
      case TokenType.and:
        return _isTruthy(left) && _isTruthy(right);
      case TokenType.or:
        return _isTruthy(left) || _isTruthy(right);
      default:
        throw Exception('Unknown binary operator: ${node.operator}');
    }
  }

  @override
  dynamic visitUnaryOperation(UnaryOperation node) {
    final operand = node.operand.accept(this);

    switch (node.operator) {
      case TokenType.minus:
        return -_toNumber(operand);
      case TokenType.not:
        return !_isTruthy(operand);
      default:
        throw Exception('Unknown unary operator: ${node.operator}');
    }
  }

  @override
  dynamic visitFunctionCall(FunctionCall node) {
    final arguments = node.arguments.map((arg) => arg.accept(this)).toList();

    final function = environment.get(node.name);
    if (function is Function) {
      return Function.apply(function, arguments);
    }

    throw Exception('Unknown function: ${node.name}');
  }

  @override
  dynamic visitModuleAccess(ModuleAccess node) {
    final module = StandardLibrary.modules[node.module];
    if (module == null) {
      throw Exception('Unknown module: ${node.module}');
    }

    final member = module[node.member];
    if (member == null) {
      throw Exception('Unknown member ${node.member} in module ${node.module}');
    }

    if (member is Function) {
      final arguments = node.arguments.map((arg) => arg.accept(this)).toList();
      return Function.apply(member, [arguments]);
    } else {
      // Module constant
      return member;
    }
  }

  @override
  dynamic visitIdentifier(Identifier node) {
    return environment.get(node.name);
  }

  @override
  dynamic visitLiteral(Literal node) {
    return node.value;
  }

  @override
  dynamic visitCastExpression(CastExpression node) {
    final value = node.expression.accept(this);
    return _cast(value, node.type);
  }

  // Helper methods
  bool _isTruthy(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is num) return value != 0;
    if (value is String) return value.isNotEmpty;
    return true;
  }

  bool _isEqual(dynamic left, dynamic right) {
    if (left == null && right == null) return true;
    if (left == null) return false;
    return left == right;
  }

  int _compare(dynamic left, dynamic right) {
    if (left is num && right is num) {
      return left.compareTo(right);
    }
    if (left is String && right is String) {
      return left.compareTo(right);
    }
    return left.toString().compareTo(right.toString());
  }

  num _toNumber(dynamic value) {
    if (value is num) return value;
    if (value is String) {
      final parsed = num.tryParse(value);
      if (parsed != null) return parsed;
    }
    if (value is bool) return value ? 1 : 0;
    throw Exception('Cannot convert $value to number');
  }

  Iterable<dynamic> _toIterable(dynamic value) {
    if (value is Iterable) return value;
    if (value is String) return value.split('');
    throw Exception('Cannot iterate over $value');
  }

  dynamic _cast(dynamic value, String type) {
    switch (type.toLowerCase()) {
      case 'number':
        return _toNumber(value);
      case 'text':
        return value.toString();
      case 'boolean':
        return _isTruthy(value);
      case 'list':
        if (value is List) return value;
        return [value];
      default:
        throw Exception('Unknown cast type: $type');
    }
  }

  // Built-in function implementations
  List<dynamic> _getCellRange(String start, String end) {
    // Simplified range implementation
    return [
      cellValues[start.toUpperCase()] ?? '',
      cellValues[end.toUpperCase()] ?? '',
    ];
  }

  void _setCellValue(String address, dynamic value) {
    cellValues[address.toUpperCase()] = value.toString();
  }

  int _getLength(dynamic collection) {
    if (collection is List) return collection.length;
    if (collection is String) return collection.length;
    return 0;
  }

  num _sum(dynamic collection) {
    if (collection is! List) return 0;
    return collection.fold<num>(0, (sum, item) {
      try {
        return sum + _toNumber(item);
      } catch (e) {
        return sum;
      }
    });
  }

  num _average(dynamic collection) {
    if (collection is! List || collection.isEmpty) return 0;
    return _sum(collection) / collection.length;
  }

  dynamic _max(dynamic collection) {
    if (collection is! List || collection.isEmpty) return 0;
    return collection.fold(collection.first, (max, item) {
      try {
        final num1 = _toNumber(max);
        final num2 = _toNumber(item);
        return num1 > num2 ? max : item;
      } catch (e) {
        return max;
      }
    });
  }

  dynamic _min(dynamic collection) {
    if (collection is! List || collection.isEmpty) return 0;
    return collection.fold(collection.first, (min, item) {
      try {
        final num1 = _toNumber(min);
        final num2 = _toNumber(item);
        return num1 < num2 ? min : item;
      } catch (e) {
        return min;
      }
    });
  }

  int _count(dynamic collection) {
    if (collection is! List) return 0;
    return collection
        .where((item) => item != null && item.toString().isNotEmpty)
        .length;
  }

  num _round(num number, int decimals) {
    final factor = math.pow(10, decimals);
    return (number * factor).round() / factor;
  }
}

/// Main language processor
class FunctionLanguage {
  static FunctionDeclaration parseFunction(String source) {
    final lexer = Lexer(source);
    final tokens = lexer.tokenize();
    final parser = Parser(tokens);
    return parser.parseFunction();
  }

  static dynamic executeFunction(
    FunctionDeclaration function,
    List<dynamic> arguments,
    Map<String, String> cellValues,
  ) {
    final interpreter = Interpreter(cellValues);
    return interpreter.interpret(function, arguments);
  }

  static dynamic runCode(
    String source,
    List<dynamic> arguments,
    Map<String, String> cellValues,
  ) {
    try {
      final function = parseFunction(source);
      return executeFunction(function, arguments, cellValues);
    } catch (e) {
      return 'ERROR: $e';
    }
  }
}
