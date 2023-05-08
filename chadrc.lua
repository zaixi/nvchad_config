---@type ChadrcConfig
local M = {}

M.map_name = {
    i = {},
    n = {},
    t= {},
    v = {},
    x = {},
}

M.lsp_server = { "clangd", "pyright", "html", "cssls", "bashls", "lua_ls", "awk_ls", "marksman"}
M.Mason_server = { "clangd", "pyright", "html-lsp", "css-lsp", "bash-language-server", "lua-language-server", "awk-language-server", "marksman"}

-- Path to overriding theme and highlights files
local highlights = require "custom.highlights"

M.ui = {
  theme = "onedark",
  theme_toggle = { "onedark", "one_light" },

  hl_override = highlights.override,
  hl_add = highlights.add,

  statusline = {
    overriden_modules = function()
        return require("custom.configs.other").ui()
    end,
  },
  tabufline = {
    lazyload = false,
  },
  nvdash = {
        load_on_startup = true,
    },
}

M.plugins = "custom.plugins"

-- check core.mappings for table structure
M.mappings = require("custom.mappings").map

return M
