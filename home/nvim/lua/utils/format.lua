local M = {}

---@param name string name of formatter
---@return string? abs_path absolute path to given formatter
local function resolve_cmd(name)
    local cats_paths = nixCats.extra.formatters[name]
    if cats_paths == nil then
        error('formatter "' .. name .. '" is not specified in nixCats')
    end

    local path = require('utils.path').resolve_cmd_path(cats_paths)
    if path ~= nil then
        return path.path
    else
        return nil
    end
end

--- Populates formatters with values from formatters_by_ft
---@param formatters table
---@param formatters_by_ft table<string, string[]>
---@return nil
local function populate_formatters(formatters, formatters_by_ft)
    for _, fmts in pairs(formatters_by_ft) do
        for _, fmt in ipairs(fmts) do
            if formatters[fmt] == nil then
                formatters[fmt] = {}
            end
        end
    end
end

---@param formatters table
---@param non_exe_formatters string[] formatters, that don't have an executable; like 'injected'
---@return string[] disables_formatters formatters, whose executable was not found
local function formatters_inject_cmd(formatters, non_exe_formatters)
    local disables_formatters = {}

    for name, _ in pairs(formatters) do
        if vim.tbl_contains(non_exe_formatters, name) then
            goto next_formatter
        end

        local cmd = resolve_cmd(name)
        if cmd ~= nil then
            formatters[name].command = cmd
        else
            formatters[name] = nil
            table.insert(disables_formatters, name)
        end

        ::next_formatter::
    end

    return disables_formatters
end

---@param formatters_by_ft table<string, string[]>
---@param disables_formatters string[] disables_formatters return value of formatters_inject_cmd()
---@return nil
local function remove_disabled_formatters(formatters_by_ft, disables_formatters)
    for ft, fmts in pairs(formatters_by_ft) do
        local new_fmts = {}

        for _, fmt in ipairs(fmts) do
            if not vim.tbl_contains(formatters_by_ft, disables_formatters) then
                table.insert(new_fmts, fmt)
            end
        end

        formatters_by_ft[ft] = new_fmts
    end
end

---@param config table conform.nvim config
---@param non_exe_formatters string[] formatters, that don't have an executable; like 'injected'
---@return nil
function M.setup_conform(config, non_exe_formatters)
    populate_formatters(config.formatters, config.formatters_by_ft)

    local disabled_formatters =
        formatters_inject_cmd(config.formatters, non_exe_formatters)

    remove_disabled_formatters(config.formatters_by_ft, disabled_formatters)

    require('conform').setup(config)
end

return M
