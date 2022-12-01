local M = {}

local lspconfig = require "lspconfig"

M.capabilities = require("plugins.configs.lspconfig").capabilities
M.on_attach = function(client, bufnr)
    require("plugins.configs.lspconfig").on_attach(client, bufnr)
    -- require "lsp_signature".on_attach()
end

M.setup_lsp = function()
  for _, lsp in ipairs(require("custom.chadrc").lsp_server) do
    lspconfig[lsp].setup {
      on_attach = M.attach,
      capabilities = M.capabilities,
      -- flags = {
      --     debounce_text_changes = 150,
      -- },
    }
  end
end


M.mason_lspconfig = function()
  require("mason-lspconfig").setup()
  lsp_server = require("custom.chadrc").lsp_server

  vim.api.nvim_del_user_command("MasonInstallAll")
  vim.api.nvim_create_user_command("MasonInstallAll", function()
    vim.cmd("LspInstall " .. table.concat(lsp_server, " "))
  end, {})

  vim.api.nvim_create_user_command("LspInstallAll", function()
    vim.cmd("LspInstall " .. table.concat(lsp_server, " "))
  end, {})
  vim.api.nvim_create_user_command("LspUninstallAll", function()
    vim.cmd("LspUninstall " .. table.concat(lsp_server, " "))
  end, {})
end

vim.notify = require("notify")

-- Borders for LspInfo winodw
local win = require "lspconfig.ui.windows"
local _default_opts = win.default_opts

win.default_opts = function(options)
   local opts = _default_opts(options)
   opts.border = "single"
   return opts
end

-- Utility functions shared between progress reports for LSP and DAP

local client_notifs = {}

local function get_notif_data(client_id, token)
 if not client_notifs[client_id] then
   client_notifs[client_id] = {}
 end

 if not client_notifs[client_id][token] then
   client_notifs[client_id][token] = {}
 end

 return client_notifs[client_id][token]
end


local spinner_frames = { "⣾", "⣽", "⣻", "⢿", "⡿", "⣟", "⣯", "⣷" }

local function update_spinner(client_id, token)
 local notif_data = get_notif_data(client_id, token)

 if notif_data.spinner then
   local new_spinner = (notif_data.spinner + 1) % #spinner_frames
   notif_data.spinner = new_spinner

   notif_data.notification = vim.notify(nil, nil, {
     hide_from_history = true,
     icon = spinner_frames[new_spinner],
     replace = notif_data.notification,
   })

   vim.defer_fn(function()
     update_spinner(client_id, token)
   end, 100)
 end
end

local function format_title(title, client_name)
 return client_name .. (#title > 0 and ": " .. title or "")
end

local function format_message(message, percentage)
 return (percentage and percentage .. "%\t" or "") .. (message or "")
end

-- LSP integration
-- Make sure to also have the snippet with the common helper functions in your config!

vim.lsp.handlers["$/progress"] = function(_, result, ctx)
 local client_id = ctx.client_id

 local val = result.value

 if not val.kind then
   return
 end

 local notif_data = get_notif_data(client_id, result.token)

 if val.kind == "begin" then
   local message = format_message(val.message, val.percentage)

   notif_data.notification = vim.notify(message, "info", {
     title = format_title(val.title, vim.lsp.get_client_by_id(client_id).name),
     icon = spinner_frames[1],
     timeout = false,
     hide_from_history = false,
   })

   notif_data.spinner = 1
   update_spinner(client_id, result.token)
 elseif val.kind == "report" and notif_data then
   notif_data.notification = vim.notify(format_message(val.message, val.percentage), "info", {
     replace = notif_data.notification,
     hide_from_history = false,
   })
 elseif val.kind == "end" and notif_data then
   notif_data.notification =
     vim.notify(val.message and format_message(val.message) or "Complete", "info", {
       icon = "",
       replace = notif_data.notification,
       timeout = 3000,
     })

   notif_data.spinner = nil
 end
end

vim.lsp.handlers["window/showMessage"] = function(err, method, params, client_id)
    -- table from lsp severity to vim severity.
    local severity = {
        "error",
        "warn",
        "info",
        "info", -- map both hint and info to info?
    }
    vim.notify(method.message, severity[params.type])
end

return M
