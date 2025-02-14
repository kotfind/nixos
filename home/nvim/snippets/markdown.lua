local function selection_or_insert(_, snip)
    local selection = {}
    for _, line in ipairs(snip.env.LS_SELECT_RAW) do
        table.insert(selection, line)
    end

    local res = {}
    if next(selection) ~= nil then
        table.insert(res, t(selection))
    else
        table.insert(res, i(1))
    end

    return sn(nil, res)
end

return {
    -- Code
    s('c', fmt([[
        `{body}`
    ]], {
        body = d(1, selection_or_insert, {}),
    })),

    -- Code
    s('C', fmt([[
        ```{lang}
        {body}
        ```
    ]], {
        lang = i(1, 'lang'),
        body = d(2, selection_or_insert, {}),
    })),
}
