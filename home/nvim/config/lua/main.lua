-- This file is imported from init.lua

function _G.executable(cmd)
    return vim.fn.executable(cmd) == 1
end

require 'keymaps'
require 'options'
require 'silicon'
require 'run_app'
