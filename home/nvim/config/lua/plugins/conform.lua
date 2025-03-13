local function setup_conform()
    local formatters_by_ft = {}
    local formatters = {}

    local formatter_config = {
        ['__default__'] = function(formatter)
            formatters[formatter.name] = {
                command = formatter.path,
            }
        end,

        ['__none__'] = function(formatter)
            formatters[formatter.name] = {
                command = { lsp_format = 'never' },
            }
        end,

        ['typstyle'] = function(formatter)
            formatters[formatter.name] = {
                command = formatter.path,
                append_args = { '--tab-width', '4' },
            }
        end,

        ['ktfmt'] = function(formatter)
            formatters[formatter.name] = {
                command = formatter.path,
                append_args = { '--kotlinlang-style' },
            }
        end,

        ['astyle'] = function(formatter)
            formatters[formatter.name] = {
                command = formatter.path,
                args = {},
                stdin = true,
                cwd = util.root_file {
                    '.editorconfig',
                    'flake.nix',
                    '.git',
                },
            }
        end,
    }

    for lang, lang_data in pairs(LangCfg) do
        local formatter = lang_data.formatter
        if formatter ~= nil then
            formatters_by_ft[lang] = { formatter.name }

            local cfg = formatter_config[formatter.name]
            if cfg ~= nil then
                cfg(formatter)
            else
                formatter_config['__default__'](formatter)
            end
        end
    end

    require('conform').setup {
        formatters_by_ft = formatters_by_ft,
        formatters = formatters,
        format_after_save = {
            timeout_ms = 10000,
            lsp_format = 'fallback',
        },
    }
end

return {
    {
        'stevearc/conform.nvim',
        config = setup_conform,
    },
}
