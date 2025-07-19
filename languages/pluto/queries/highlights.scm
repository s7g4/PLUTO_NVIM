; Comments
(comment) @comment

; Strings
(string) @string
(raw_string) @string
(ansi_c_quoting) @string

; Numbers
(number) @number

; Variables and identifiers
(variable_name) @variable
(word) @variable

; Commands and function calls
(command_name) @function
(command) @function.call

; Operators
"=" @operator
"+" @operator
"-" @operator
"*" @operator
"/" @operator
"%" @operator
"==" @operator
"!=" @operator
"<" @operator
">" @operator
"<=" @operator
">=" @operator
"&&" @operator
"||" @operator
"!" @operator
"&" @operator
"|" @operator

; Parentheses and brackets
"(" @punctuation.bracket
")" @punctuation.bracket
"[" @punctuation.bracket
"]" @punctuation.bracket
"{" @punctuation.bracket
"}" @punctuation.bracket

; Special bash constructs that might apply to Pluto
(expansion) @variable.special
(command_substitution) @embedded

; Keywords (if any match bash patterns)
"if" @keyword
"then" @keyword
"else" @keyword
"fi" @keyword
"for" @keyword
"while" @keyword
"do" @keyword
"done" @keyword
"function" @keyword

; Punctuation
";" @punctuation.delimiter
"," @punctuation.delimiter

; Boolean-like values
"true" @constant.builtin
"false" @constant.builtin
