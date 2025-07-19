; Comments - fold multi-line comments
(comment) @fold

; Parenthesized expressions - fold complex nested expressions
(parenthesized_expression) @fold

; Command arguments - fold when they span multiple lines
(command
  arguments: (argument_list) @fold
  (#match? @fold ".*\\n.*"))

; Complex assignments - fold multi-line right-hand sides
(assignment
  right: (_) @fold
  (#match? @fold ".*\\n.*"))

; Binary operations - fold complex nested operations
(binary_operation
  left: (_) @fold
  (#match? @fold ".*\\n.*"))

(binary_operation
  right: (_) @fold
  (#match? @fold ".*\\n.*"))

; Multiple assignment targets - fold when many variables
(assignment
  left: (_ (_ _)+) @fold) ; Fold when 3+ variables in assignment

; Fold argument lists with 4+ arguments
(argument_list
  (_ _ _ _+) @fold) ; Fold when 4+ arguments

; Fold deeply nested parentheses (3+ levels)
(parenthesized_expression
  (parenthesized_expression
    (parenthesized_expression) @fold))

; Fold long string literals (can be useful for embedded content)
(string) @fold
(#match? @fold ".*\\n.*")

; Fold consecutive comments (comment blocks)
(comment) @fold
(#match? @fold "^#.*\\n#")
