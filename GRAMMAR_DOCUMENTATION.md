# Pluto Grammar Documentation 📚

This document provides comprehensive documentation for every function, rule, and component in the Pluto language grammar.

## Table of Contents

1. [Grammar Overview](#grammar-overview)
2. [Helper Functions](#helper-functions)
3. [Grammar Rules](#grammar-rules)
4. [Query Files](#query-files)
5. [Configuration Files](#configuration-files)

---

## Grammar Overview

The Pluto language grammar is defined in `grammar.js` using the Tree-sitter grammar format. It supports:

- **Statements**: Assignments, commands, control flow
- **Expressions**: Arithmetic, logical, comparison operations
- **Data Types**: Numbers, strings, booleans, arrays, objects
- **Control Flow**: If statements, loops, functions
- **Type System**: Optional type annotations

---

## Helper Functions

### `sepByNewline($, rule)`

**Purpose**: Creates a rule that matches multiple instances of a rule separated by newlines.

**Parameters**:
- `$`: Grammar context object
- `rule`: The rule to be repeated

**Returns**: A sequence that matches:
1. The initial rule
2. Zero or more repetitions of (separator + rule)
3. Optional trailing separator

**Usage**:
```javascript
source_file: $ => sepByNewline($, $._statement)
```

**Example Input**:
```pluto
x = 42
print "hello"
run command
```

### `PRECEDENCE` Object

**Purpose**: Defines operator precedence levels for expression parsing.

**Structure**:
```javascript
const PRECEDENCE = {
  command: 1,        // Lowest precedence - commands
  argument: 2,       // Command arguments
  expression: 3,     // General expressions
  assignment: 5,     // Variable assignments
  conditional: 7,    // Ternary operations
  logical_or: 8,     // || operator
  logical_and: 9,    // && operator
  equality: 10,      // ==, !=, ===, !==
  comparison: 11,    // <, >, <=, >=
  bitwise_or: 12,    // | operator
  bitwise_xor: 13,   // ^ operator
  bitwise_and: 14,   // & operator
  shift: 15,         // <<, >>, >>>
  add: 16,           // +, - operators
  mult: 17,          // *, /, % operators
  power: 18,         // ** operator
  unary: 19,         // !, ~, typeof, not
  postfix: 20,       // ++, --, ?, !
  primary: 21,       // Highest precedence - literals
};
```

**Why This Matters**: Ensures expressions are parsed in the correct order:
```pluto
# This: x + y * z
# Parses as: x + (y * z)  [mult higher than add]
# Not as: (x + y) * z
```

### `createBinaryOp($, operators, precedence)`

**Purpose**: Creates binary operation rules with proper precedence and associativity.

**Parameters**:
- `$`: Grammar context object
- `operators`: Array of operator strings (e.g., `['+', '-']`)
- `precedence`: String key from PRECEDENCE object

**Returns**: Array of left-associative binary operation rules

**Structure**:
```javascript
prec.left(PRECEDENCE[precedence], seq(
  field('left', $._expression),
  field('operator', alias(token(operator), $.operator)),
  field('right', $._expression)
))
```

**Usage Example**:
```javascript
// Creates rules for +, - operators with add precedence
...createBinaryOp($, ['+', '-'], 'add')
```

---

## Grammar Rules

### Core Structure

#### `source_file`

**Purpose**: Root rule that defines the entire file structure.

**Definition**:
```javascript
source_file: $ => sepByNewline($, $._statement)
```

**Explanation**: A source file consists of statements separated by newlines.

**Example**:
```pluto
x = 42
print "hello"
run command
```

#### `_statement`

**Purpose**: Defines what constitutes a valid statement in Pluto.

**Definition**:
```javascript
_statement: $ => choice(
  $.assignment,
  $.block_comment_statement,
  prec.right(PRECEDENCE.command, $.command),
  $.if_statement,
  $.while_loop,
  $.for_loop,
  $.function_definition
)
```

**Explanation**: A statement can be any of:
- Variable assignment
- Block comment
- Command execution
- Control flow structures
- Function definitions

### Assignment Rules

#### `assignment`

**Purpose**: Handles variable assignments with optional type annotations.

**Definition**:
```javascript
assignment: $ => prec.right(PRECEDENCE.assignment, seq(
  field("left", seq(
    $.identifier,
    repeat(seq($.identifier))
  )),
  optional(field("type", $.type_annotation)),
  token('='),
  field("right", $._expression)
))
```

**Features**:
- **Single assignment**: `x = 42`
- **Multiple assignment**: `x y = "hello"`
- **Type annotations**: `name: string = "Pluto"`

**Fields**:
- `left`: Target variable(s)
- `type`: Optional type annotation
- `right`: Value expression

### Command Rules

#### `command`

**Purpose**: Represents executable commands with optional arguments.

**Definition**:
```javascript
command: $ => prec.left(PRECEDENCE.command, seq(
  field("name", $.identifier),
  optional(field("arguments", $.argument_list))
))
```

**Examples**:
```pluto
print "hello"           # Simple command
run x y z              # Command with arguments
exec (x + 1) "file"    # Command with expression
```

**Fields**:
- `name`: Command identifier
- `arguments`: Optional argument list

#### `argument_list`

**Purpose**: Handles space-separated command arguments.

**Definition**:
```javascript
argument_list: $ => prec(PRECEDENCE.argument, repeat1(
  choice(
    $.parenthesized_expression,
    $.binary_operation,
    $.string,
    $.number,
    $.boolean,
    prec.dynamic(-1, $.identifier)
  )
))
```

**Features**:
- Supports various argument types
- Handles expressions in parentheses
- Prevents reserved keywords as arguments

### Expression Rules

#### `_expression`

**Purpose**: Defines the hierarchy of expressions.

**Definition**:
```javascript
_expression: $ => choice(
  $.conditional_expression,
  $.binary_operation,
  $.unary_operation,
  $.postfix_operation,
  $.parenthesized_expression,
  $.array_literal,
  $.object_literal,
  $.string,
  $.number,
  $.boolean,
  $.identifier,
)
```

**Explanation**: Expressions can be:
- Conditional (ternary) operations
- Binary operations
- Unary operations
- Postfix operations
- Parenthesized expressions
- Literals (arrays, objects, primitives)
- Variable references

#### `binary_operation`

**Purpose**: Handles all binary operations with proper precedence.

**Definition**:
```javascript
binary_operation: $ => choice(
  // Logical operators
  ...createBinaryOp($, ['||'], 'logical_or'),
  ...createBinaryOp($, ['&&'], 'logical_and'),
  
  // Equality operators
  ...createBinaryOp($, ['==', '!=', '===', '!=='], 'equality'),
  
  // Comparison operators
  ...createBinaryOp($, ['<', '>', '<=', '>='], 'comparison'),
  
  // Bitwise operators
  ...createBinaryOp($, ['|'], 'bitwise_or'),
  ...createBinaryOp($, ['^'], 'bitwise_xor'),
  ...createBinaryOp($, ['&'], 'bitwise_and'),
  
  // Shift operators
  ...createBinaryOp($, ['<<', '>>', '>>>'], 'shift'),
  
  // Arithmetic operators
  ...createBinaryOp($, ['+', '-'], 'add'),
  ...createBinaryOp($, ['*', '/', '%'], 'mult'),
  ...createBinaryOp($, ['**'], 'power'),
  
  // String operations
  ...createBinaryOp($, ['++'], 'add'),
  ...createBinaryOp($, ['in'], 'comparison'),
  ...createBinaryOp($, ['matches'], 'comparison'),
)
```

**Operator Categories**:
- **Logical**: `||`, `&&`
- **Equality**: `==`, `!=`, `===`, `!==`
- **Comparison**: `<`, `>`, `<=`, `>=`, `in`, `matches`
- **Bitwise**: `|`, `^`, `&`
- **Shift**: `<<`, `>>`, `>>>`
- **Arithmetic**: `+`, `-`, `*`, `/`, `%`, `**`
- **String**: `++` (concatenation)

#### `unary_operation`

**Purpose**: Handles prefix unary operations.

**Definition**:
```javascript
unary_operation: $ => prec.right(PRECEDENCE.unary, seq(
  field('operator', alias(choice(
    token('-'),
    token('+'),
    token('!'),
    token('~'),
    token('++'),
    token('--'),
    token('typeof'),
    token('not')
  ), $.operator)),
  field('argument', $._expression)
))
```

**Operators**:
- **Arithmetic**: `-`, `+` (negation, positive)
- **Logical**: `!`, `not` (logical negation)
- **Bitwise**: `~` (bitwise NOT)
- **Increment/Decrement**: `++`, `--` (prefix)
- **Type**: `typeof` (type checking)

#### `postfix_operation`

**Purpose**: Handles postfix unary operations.

**Definition**:
```javascript
postfix_operation: $ => prec.left(PRECEDENCE.postfix, seq(
  field('operand', $._expression),
  field('operator', alias(choice(
    token('++'),
    token('--'),
    token('?'),
    token('!')
  ), $.operator))
))
```

**Operators**:
- **Increment/Decrement**: `++`, `--` (postfix)
- **Optional**: `?` (optional chaining)
- **Non-null**: `!` (non-null assertion)

### Data Type Rules

#### `number`

**Purpose**: Matches numeric literals in various formats.

**Definition**:
```javascript
number: $ => token(choice(
  // Scientific notation
  /\d+[eE][+-]?\d+/,
  /\d*\.\d+[eE][+-]?\d+/,
  // Hexadecimal
  /0[xX][0-9a-fA-F]+/,
  // Binary
  /0[bB][01]+/,
  // Octal
  /0[oO][0-7]+/,
  // BigInt
  /\d+n/,
  // Decimals
  /\d*\.\d+/,
  // Integers
  /\d+/
))
```

**Supported Formats**:
- **Integers**: `42`, `0`
- **Decimals**: `3.14`, `0.5`
- **Scientific**: `1.5e10`, `2E-5`
- **Hexadecimal**: `0xFF`, `0x1A`
- **Binary**: `0b1010`, `0B110`
- **Octal**: `0o777`, `0O123`
- **BigInt**: `123n`, `0xFFn`

#### `string`

**Purpose**: Matches string literals with escape sequences.

**Definition**:
```javascript
string: $ => choice(
  // Double quoted strings
  token(seq(
    '"',
    repeat(choice(
      /[^"\\$]+/,
      /\\./
    )),
    '"'
  )),
  // Single quoted strings
  token(seq(
    "'",
    repeat(choice(
      /[^'\\]+/,
      /\\./
    )),
    "'"
  ))
)
```

**Features**:
- **Double quotes**: `"hello world"`
- **Single quotes**: `'hello world'`
- **Escape sequences**: `"hello\nworld"`
- **Unicode support**: Full Unicode character support

#### `boolean`

**Purpose**: Matches boolean literals.

**Definition**:
```javascript
boolean: $ => token(choice('true', 'false'))
```

**Values**:
- `true`: Boolean true
- `false`: Boolean false

#### `array_literal`

**Purpose**: Matches array literals with comma-separated elements.

**Definition**:
```javascript
array_literal: $ => seq(
  token('['),
  optional(seq(
    $._expression,
    repeat(seq(token(','), $._expression)),
    optional(token(','))
  )),
  token(']')
)
```

**Features**:
- **Empty arrays**: `[]`
- **Element lists**: `[1, 2, 3]`
- **Mixed types**: `[42, "hello", true]`
- **Trailing comma**: `[1, 2, 3,]`

#### `object_literal`

**Purpose**: Matches object literals with key-value pairs.

**Definition**:
```javascript
object_literal: $ => prec(2, seq(
  token('{'),
  optional(seq(
    $.object_pair,
    repeat(seq(token(','), $.object_pair)),
    optional(token(','))
  )),
  token('}')
))
```

**Features**:
- **Empty objects**: `{}`
- **Key-value pairs**: `{name: "Alice", age: 30}`
- **Computed keys**: `{[key]: value}`
- **Trailing comma**: `{a: 1, b: 2,}`

#### `object_pair`

**Purpose**: Defines key-value pairs in objects.

**Definition**:
```javascript
object_pair: $ => seq(
  field('key', choice($.identifier, $.string, $.computed_property)),
  token(':'),
  field('value', $._expression)
)
```

**Key Types**:
- **Identifier**: `name: "value"`
- **String**: `"key": "value"`
- **Computed**: `[expression]: "value"`

### Control Flow Rules

#### `if_statement`

**Purpose**: Handles conditional statements with optional else clauses.

**Definition**:
```javascript
if_statement: $ => prec.right(seq(
  token('if'),
  field('condition', $._expression),
  field('consequence', choice($.block, $._statement)),
  optional(seq(
    token('else'),
    field('alternative', choice($.block, $._statement, $.if_statement))
  ))
))
```

**Features**:
- **Simple if**: `if condition { ... }`
- **If-else**: `if condition { ... } else { ... }`
- **If-else if**: `if c1 { ... } else if c2 { ... }`
- **Single statements**: `if condition statement`

#### `while_loop`

**Purpose**: Handles while loop constructs.

**Definition**:
```javascript
while_loop: $ => seq(
  token('while'),
  field('condition', $._expression),
  field('body', choice($.block, $._statement))
)
```

**Features**:
- **Block body**: `while condition { ... }`
- **Single statement**: `while condition statement`

#### `for_loop`

**Purpose**: Handles for-in loop constructs.

**Definition**:
```javascript
for_loop: $ => seq(
  token('for'),
  field('variable', $.identifier),
  token('in'),
  field('iterable', $._expression),
  field('body', choice($.block, $._statement))
)
```

**Features**:
- **Array iteration**: `for item in array { ... }`
- **Object iteration**: `for key in object { ... }`
- **Single statement**: `for item in array statement`

#### `function_definition`

**Purpose**: Handles function definitions with parameters and return types.

**Definition**:
```javascript
function_definition: $ => seq(
  token('function'),
  field('name', $.identifier),
  token('('),
  optional($.parameter_list),
  token(')'),
  optional(seq(token('->'), $.type_expression)),
  $.block
)
```

**Features**:
- **Simple function**: `function name() { ... }`
- **With parameters**: `function name(a, b) { ... }`
- **With types**: `function name(a: number) -> string { ... }`
- **Default parameters**: `function name(a = 42) { ... }`

### Type System Rules

#### `type_annotation`

**Purpose**: Handles optional type annotations on variables and parameters.

**Definition**:
```javascript
type_annotation: $ => seq(
  token(':'),
  $.type_expression
)
```

**Usage**:
```pluto
name: string = "Alice"
age: number = 30
```

#### `type_expression`

**Purpose**: Defines the type expression hierarchy.

**Definition**:
```javascript
type_expression: $ => choice(
  $.identifier,
  $.generic_type,
  $.union_type,
  $.array_type,
  $.function_type
)
```

**Type Categories**:
- **Basic types**: `string`, `number`, `boolean`
- **Generic types**: `Array<string>`, `Map<string, number>`
- **Union types**: `string | number`, `boolean | null`
- **Array types**: `string[]`, `number[]`
- **Function types**: `(string) => number`

### Comment Rules

#### `comment`

**Purpose**: Handles single-line comments.

**Definition**:
```javascript
comment: $ => token(seq('#', /.*/))
```

**Usage**:
```pluto
# This is a comment
x = 42  # End-of-line comment
```

#### `block_comment`

**Purpose**: Handles multi-line block comments.

**Definition**:
```javascript
block_comment: $ => token(seq(
  '/*',
  /[^*]*\*+([^/*][^*]*\*+)*/,
  '/'
))
```

**Usage**:
```pluto
/*
 * This is a
 * multi-line comment
 */
```

### Lexical Rules

#### `identifier`

**Purpose**: Matches variable and function names.

**Definition**:
```javascript
identifier: $ => token(prec(-1, /[a-zA-Z_\u00a1-\uffff][a-zA-Z0-9_\u00a1-\uffff]*/))
```

**Features**:
- **ASCII letters**: `a-z`, `A-Z`
- **Unicode letters**: Full Unicode support
- **Numbers**: Can contain digits (not at start)
- **Underscores**: Can start with or contain `_`

**Valid Examples**:
- `variable`
- `_private`
- `camelCase`
- `PascalCase`
- `with123`
- `café` (Unicode)

#### `reserved_keyword`

**Purpose**: Defines keywords that cannot be used as identifiers.

**Definition**:
```javascript
reserved_keyword: $ => choice(
  'if', 'else', 'while', 'for', 'function', 'return', 'break', 'continue',
  'try', 'catch', 'finally', 'throw', 'import', 'export', 'from',
  'class', 'extends', 'super', 'static', 'public', 'private', 'protected',
  // ... many more keywords
)
```

**Purpose**: Prevents reserved words from being used as variable names or command arguments.

---

## Query Files

### `queries/highlights.scm`

**Purpose**: Defines syntax highlighting rules for the Pluto language.

**Key Sections**:

#### Keywords and Operators
```scheme
["="] @keyword.operator
(operator) @operator
```

#### Punctuation
```scheme
["(" ")"] @punctuation.bracket
["{" "}"] @punctuation.brace
["[" "]"] @punctuation.bracket
```

#### Data Types
```scheme
(string) @string
(number) @number
(boolean) @constant.builtin
(comment) @comment
```

#### Variables and Functions
```scheme
(identifier) @variable
(command name: (identifier) @function.call)
(assignment left: (identifier) @variable.parameter)
```

#### Built-in Functions
```scheme
(command
  name: (identifier) @function.builtin
  (#match? @function.builtin "^(print|echo|run|exec|exit|quit|help)$"))
```

### `queries/fold.scm`

**Purpose**: Defines code folding rules for collapsing code blocks.

**Rules**:
```scheme
; Function bodies
(function_definition body: (block) @fold)

; If statement blocks
(if_statement consequence: (block) @fold)
(if_statement alternative: (block) @fold)

; Loop bodies
(while_loop body: (block) @fold)
(for_loop body: (block) @fold)

; Object and array literals
(object_literal) @fold
(array_literal) @fold
```

### `queries/injections.scm`

**Purpose**: Defines language injections for syntax highlighting within strings.

**Rules**:
```scheme
; JSON in strings
(string) @injection.content
(#match? @injection.content "^[\"'][{[].*[}\\]][\"']$")
(#set! injection.language "json")

; Bash commands
(command
  name: (identifier) @_name
  arguments: (argument_list (string) @injection.content)
  (#match? @_name "^(run|exec|shell)$")
  (#set! injection.language "bash"))
```

---

## Configuration Files

### `tree-sitter.json`

**Purpose**: Metadata and configuration for the tree-sitter grammar.

**Structure**:
```json
{
  "name": "pluto",
  "version": "0.1.0",
  "description": "Tree-sitter grammar for the PLUTO scripting language",
  "repository": "https://github.com/s7g4/zed-pluto",
  "grammars": [
    {
      "name": "pluto",
      "scope": "source.pluto",
      "file-types": ["pluto"],
      "injection-regex": "^pluto$"
    }
  ],
  "bindings": {
    "c": true,
    "node": true,
    "python": true,
    "rust": true
  }
}
```

### `languages/pluto/config.toml`

**Purpose**: Language configuration for the editor.

**Structure**:
```toml
name = "Pluto"
grammar = "pluto"
file_extensions = ["pluto"]
line_comments = ["#"]
```

### `package.json`

**Purpose**: Node.js package configuration for the grammar.

**Key Fields**:
- `name`: Package name
- `version`: Package version
- `description`: Package description
- `main`: Entry point
- `tree-sitter`: Tree-sitter configuration

---

## Grammar Conflicts and Resolution

### Conflict Resolution

The grammar defines several conflicts that are resolved through precedence:

```javascript
conflicts: $ => [
  [$.binary_operation, $.postfix_operation],
  [$.binary_operation, $.unary_operation, $.postfix_operation],
  [$.argument_list, $._expression],
  [$.conditional_expression, $.unary_operation, $.postfix_operation],
  [$.conditional_expression, $.binary_operation, $.postfix_operation],
  [$._statement, $.if_statement],
  [$.assignment, $.argument_list],
  [$._expression],
]
```

### Precedence Handling

The grammar uses precedence to resolve ambiguities:

1. **Expression vs. Statement**: Expressions have higher precedence than statements
2. **Operator Precedence**: Mathematical precedence rules are followed
3. **Associativity**: Left-associative for most operators, right-associative for assignment

---

This comprehensive documentation covers every aspect of the Pluto language grammar, from helper functions to complex expression parsing. Each rule is designed to handle the specific syntax and semantics of the Pluto language while maintaining compatibility with Tree-sitter's parsing requirements.
