; Keywords and Operators
[
  "="
] @keyword.operator

; Arithmetic Operators
(operator) @operator

; Parentheses and Brackets
[
  "("
  ")"
] @punctuation.bracket

; Data Types with better specificity
(string) @string
(number) @number
(boolean) @constant.builtin
(comment) @comment

; Variables with context awareness
(identifier) @variable

; Function Calls with distinction
(command
  name: (identifier) @function.call)

; Assignment with parameter highlighting
(assignment
  left: (identifier) @variable.parameter)

; Multiple assignment targets
(assignment
  left: (identifier) @variable.parameter
  left: (identifier) @variable.parameter)

; Binary operations with operator highlighting
(binary_operation
  left: (_) @variable
  operator: _ @operator
  right: (_) @variable)

; Unary operations
(unary_operation
  operator: _ @operator
  argument: (_) @variable)

; Enhanced command arguments with type-specific highlighting
(argument_list
  (identifier) @variable.argument
  (string) @string.special
  (number) @number.special
  (boolean) @constant.builtin.boolean)

; Nested expressions in parentheses
(parenthesized_expression 
  "(" @punctuation.bracket 
  ")" @punctuation.bracket)

; Specific command types for better semantic highlighting
(command
  name: (identifier) @function.builtin
  (#match? @function.builtin "^(print|echo|run|exec|exit|quit|help)$"))

; Assignment operators
(assignment "=" @operator.assignment)

; Special handling for built-in values
(boolean) @constant.builtin

; Error handling for malformed expressions
(ERROR) @error
