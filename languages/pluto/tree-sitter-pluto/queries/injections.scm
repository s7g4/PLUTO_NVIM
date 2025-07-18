; JSON injection in strings - detect JSON patterns
(string) @injection.content
(#match? @injection.content "^[\"']\\s*[{\\[].*[}\\]]\\s*[\"']$")
(#set! injection.language "json")

; YAML injection in strings
(string) @injection.content
(#match? @injection.content "^[\"']\\s*---.*[\"']$")
(#set! injection.language "yaml")

; XML/HTML injection in strings
(string) @injection.content
(#match? @injection.content "^[\"']\\s*<.*>.*[\"']$")
(#set! injection.language "html")

; SQL injection in strings
(string) @injection.content
(#match? @injection.content "^[\"']\\s*(SELECT|INSERT|UPDATE|DELETE|CREATE|DROP|ALTER)\\s+.*[\"']$")
(#set! injection.language "sql")

; Regular expression injection
(string) @injection.content
(#match? @injection.content "^[\"']/.*/.?[\"']$")
(#set! injection.language "regex")

; Bash/shell injection in command strings
(command
  name: (identifier) @_name
  arguments: (argument_list
    (string) @injection.content))
(#match? @_name "^(sh|bash|exec|run|shell|cmd|powershell)$")
(#set! injection.language "bash")

; Python injection for specific commands
(command
  name: (identifier) @_name
  arguments: (argument_list
    (string) @injection.content))
(#match? @_name "^(python|py|python3)$")
(#set! injection.language "python")

; JavaScript injection
(command
  name: (identifier) @_name
  arguments: (argument_list
    (string) @injection.content))
(#match? @_name "^(node|js|javascript)$")
(#set! injection.language "javascript")

; Environment variable injection - ${VAR} and $VAR patterns
(string) @injection.content
(#match? @injection.content "\\$\\{[A-Z_][A-Z0-9_]*\\}")
(#set! injection.language "bash")

(string) @injection.content
(#match? @injection.content "\\$[A-Z_][A-Z0-9_]*")
(#set! injection.language "bash")

; URL injection
(string) @injection.content
(#match? @injection.content "^[\"']https?://.*[\"']$")
(#set! injection.language "url")

; File path injection (useful for syntax highlighting paths)
(string) @injection.content
(#match? @injection.content "^[\"'][./~].*\\.[a-zA-Z0-9]+[\"']$")
(#set! injection.language "filepath")

; Markdown injection in strings
(string) @injection.content
(#match? @injection.content "^[\"'].*[#*`].*[\"']$")
(#set! injection.language "markdown")

; CSS injection
(string) @injection.content
(#match? @injection.content "^[\"']\\s*[.#]?[a-zA-Z-]+\\s*\\{.*\\}.*[\"']$")
(#set! injection.language "css")

; Config file injection (INI/TOML-like)
(string) @injection.content
(#match? @injection.content "^[\"']\\s*\\[[^\\]]+\\].*[\"']$")
(#set! injection.language "toml")
