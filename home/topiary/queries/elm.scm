(string_constant_expr) @leaf

(line_comment) @leaf @append_hardline @prepend_hardline @allow_blank_line_before

(module_declaration) @append_hardline
(module_declaration (module) @append_space)

(import_clause) @prepend_hardline @allow_blank_line_before
(import_clause (import) @append_space)
(as_clause (as) @append_space @prepend_space)

(exposing_list) @prepend_space
(exposing_list (exposing) @append_space)

"," @append_spaced_softline @prepend_antispace

"(" @append_antispace
")" @prepend_antispace
(
    "(" @append_spaced_softline @append_indent_start
    . _ . _+ .
    ")" @prepend_spaced_softline @prepend_indent_end
)

(
    "[" @append_spaced_softline @append_indent_start
    .
    [
        (parenthesized_expr)? @do_nothing
        (list_expr)? @do_nothing
        (record_expr)? @do_nothing
        (tuple_expr) @do_nothing
        _+
    ]
    .
    "]" @prepend_spaced_softline @prepend_indent_end
)

(
    "{" @append_spaced_softline @append_indent_start
    . _* .
    "|"? @do_nothing
    . _* .
    "}" @prepend_spaced_softline @prepend_indent_end
)

(
    "{" @append_space
    . _* .
    "|" @append_spaced_softline @append_indent_start
    . _* .
    "}" @prepend_spaced_softline @prepend_indent_end
)

[ (colon) (arrow) (eq) ] @append_space @prepend_space

(type_alias_declaration) @prepend_hardline @allow_blank_line_before
(type_alias_declaration (type) @append_space)
(type_alias_declaration (alias) @append_space)

(type_alias_declaration (eq) @prepend_spaced_softline @prepend_indent_start)
(type_alias_declaration) @append_hardline @append_indent_end

(type_alias_declaration _* typeVariable: _ @prepend_space)
(type_variable) @prepend_space @append_space

(type_declaration) @prepend_hardline @append_hardline @allow_blank_line_before
(type_declaration (type) @append_space)

(type_declaration (eq) @prepend_spaced_softline @prepend_indent_start @append_space)
(type_declaration) @append_indent_end

(type_declaration _* typeName: _ @prepend_space)

(union_variant) @append_spaced_softline @prepend_space
(union_variant name: _ @append_space)

(type_ref) @append_space @prepend_space

(type_annotation) @append_hardline @allow_blank_line_before

(value_declaration (eq) @prepend_spaced_softline @prepend_indent_start)
(value_declaration) @prepend_hardline @append_hardline @append_indent_end
(
    (type_annotation)? @do_nothing
    .
    (value_declaration) @allow_blank_line_before
)

[(record_pattern) (lower_pattern) (anything_pattern)] @prepend_space
("(" @prepend_space . (pattern))

(function_declaration_left . (_) . pattern: _ @prepend_indent_start) @append_indent_end
(function_declaration_left . (_) . pattern: (_) @prepend_space)

(case_of_expr (case) @append_space)
(case_of_expr (of) @prepend_space @append_hardline @append_indent_start)
(case_of_expr) @append_indent_end @append_hardline

(case_of_branch) @prepend_hardline @append_hardline @allow_blank_line_before

(case_of_branch (arrow) @prepend_spaced_softline @prepend_indent_start)
(case_of_branch) @append_indent_end

(operator) @prepend_spaced_softline @append_space
(record_expr "|" @prepend_space @append_spaced_softline)

(function_call_expr
    .
    target: _ @append_space
    .
    arg: _
)

(function_call_expr
    target: _ @append_antispace
    (#match? @append_antispace "cls|class|classList")
)

(function_call_expr
    _*
    arg: _
    .
    arg: _ @prepend_space
)

(backslash) @append_antispace

(let_in_expr) @append_hardline
(let_in_expr
    "let" @append_hardline @append_indent_start
    . _* .
    "in" @prepend_hardline @prepend_indent_end
)
(let_in_expr
    "in" @append_space
    .
    [
        (parenthesized_expr)
        (list_expr)
        (record_expr)
        (tuple_expr)
    ]
)
(let_in_expr
    "in" @append_hardline @append_indent_start
    .
    [
        (parenthesized_expr)
        (list_expr)
        (record_expr)
        (tuple_expr)
    ]? @do_nothing
) @append_indent_end

(if_else_expr
    _*
    .
    "if" @append_space @append_indent_start
    .
    (_) @append_hardline
) @append_indent_end
(if_else_expr
    _*
    .
    "then" @append_space
    .
    (_) @append_hardline
)
(if_else_expr
    _*
    .
    "else" @append_space
    .
    (_) @append_hardline
)

; TODO: multiline function calls
