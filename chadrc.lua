-- Just an example, supposed to be placed in /lua/custom/

local M = {}

M.map_name = {
  i = {},
  n = {},
  t= {},
  v = {},
  x = {},
}

M.lsp_server = { "clangd", "pyright", "html", "cssls", "bashls", "sumneko_lua", "luau_lsp" }

M.mappings = require("custom.mappings").map

M.ui = {
   -- theme = "gruvchad",
   -- hl_add = {
   hl_override = {
     BufferLineBufferSelected = {
       bold = true,
     },
     BufferlineIndicatorSelected = {
       fg = 'blue',
     },
   },
}

M.plugins = require("custom.plugins").plugs()

return M
