-- example file i.e lua/custom/init.lua

-- load your globals, autocmds here or anything .__.

local M = {}

vim.cmd('source ' .. vim.fn.stdpath("config") .. '/lua/custom/edit.vim')

local core_modules = {
   "custom.options",
   --"custom.autocmds",
   --"custom.keymaps",
--   "custom.plugins",
}

for _, module in ipairs(core_modules) do
   local ok, err = pcall(require, module)
   if not ok then
      error("Error loading " .. module .. "\n\n" .. err)
   end
end

local autocmd = vim.api.nvim_create_autocmd

-- Use relative & absolute line numbers in 'n' & 'i' modes respectively
autocmd("InsertEnter", {
   callback = function()
      vim.opt.relativenumber = false
   end,
})
autocmd("InsertLeave", {
   callback = function()
      vim.opt.relativenumber = true
   end,
})

-- Open a file from its last left off position
autocmd("BufReadPost", {
   callback = function()
      --if not vim.fn.expand("%:p"):match ".git" and vim.fn.line "'\"" > 1 and vim.fn.line "'\"" <= vim.fn.line "$" then
      if vim.fn.line "'\"" > 1 and vim.fn.line "'\"" <= vim.fn.line "$" then
         vim.cmd "normal! g`\""
         vim.cmd "normal zz"
         -- autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
      end
     --  if not vim.fn.expand("%:p"):match ".git" and vim.fn.line "'\"" > 1 and vim.fn.line "'\"" <= vim.fn.line "$" then
     --     vim.cmd "normal! g'\""
     --     vim.cmd "normal zz"
     -- end

   end,
})

-- File extension specific tabbing
autocmd("Filetype", {
   pattern = "python",
   callback = function()
      vim.opt_local.expandtab = true
      vim.opt_local.tabstop = 4
      vim.opt_local.shiftwidth = 4
      vim.opt_local.softtabstop = 4
   end,
})

-- Highlight yanked text
autocmd("TextYankPost", {
   callback = function()
      vim.highlight.on_yank { higroup = "Visual", timeout = 200 }
   end,
})

-- Enable spellchecking in markdown, text and gitcommit files
autocmd("FileType", {
   pattern = { "gitcommit", "markdown", "text" },
   callback = function()
      vim.opt_local.spell = true
   end,
})

vim.schedule(function()
    vim.cmd [[ clearjumps ]]
end)

return M
