local M = {}

M.ui = function()
  M.statusline = require "nvchad_ui.statusline.modules"

  return {
    LSP_progress = function()
      local function gutentags_status()
        msg = vim.fn['gutentags#statusline']()
        if msg ~= '' then
          msg = "Gen. " .. msg
        end
        return msg
      end

      local function nvim_gps()
        if vim.o.columns < 140 or not package.loaded["nvim-gps"] then
          return ""
        end
        local gps = require "nvim-gps"
        if not gps.is_available() then
          return ""
        end
        return gps.get_location()
      end

      local info = nvim_gps()
      if info ~= "" then
        info = info .. "  " .. gutentags_status()
      else
        info = gutentags_status()
      end
      if info ~= "" then
        info = "%#St_gitIcons#" .. info
      end
      return info

      --return ("%#St_gitIcons#" .. nvim_gps() .. "  " .. gutentags_status()) or ""
    end,

    cursor_position = function()
      local current_col = vim.fn.col "."
      old_info = M.statusline.cursor_position()
      old_info = vim.fn.split(old_info)
      return old_info[1] .. old_info[2] .. " " .. current_col .. ":" .. old_info[3] .. " "
    end,
  }
end


M.diffview = function ()
    local plenary = require("plenary")
    local actions = require("diffview.actions")
    require("diffview").setup({
        file_history_panel = {
            win_config = {
                height = 10,
            },
        },
        keymaps = {
            file_panel = {
                ["<c-u>"] = actions.scroll_view(-0.25), -- Scroll the view up
                ["<c-d>"] = actions.scroll_view(0.25),  -- Scroll the view down
            },
            file_history_panel = {
                ["<c-u>"] = actions.scroll_view(-0.25), -- Scroll the view up
                ["<c-d>"] = actions.scroll_view(0.25),  -- Scroll the view down
            }
        }
    })
end

M.whichkey = function()
  local present, wk = pcall(require, "which-key")

  if not present then
    return
  end

  require "plugins.configs.whichkey"

  wk.setup({
    window = {
        border = "rounded", -- none/single/double/shadow
    },
  })

  local map_name = require("core.utils").load_config().map_name or {}
  for modes, name in pairs(map_name) do
    if next(name) ~= nil then
      wk.register(name, { mode = modes })
    end
  end
end

M.nvimtree = {
  reload_on_bufenter = true,
  renderer = {
    icons = {
      glyphs = {
        folder = {
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
          arrow_open = "",
          arrow_closed = "",
        },
      },
    },
  },
}

M.treesitter = {
    -- ensure_installed = {
        --     "lua",
        --     "vim",
        -- },
    ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ignore_install = { "fusion", "jsonc", "php", "norg", "tlaplus" }, -- List of parsers to ignore installing
    highlight = {
        enable = true,
        use_languagetree = true,
    },
    refactor = {
        highlight_definitions = {
            enable = true,
            -- Set to false if you have an `updatetime` of ~100.
            clear_on_cursor_move = true,
        },
    },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = 'v',
            node_incremental = 'v',
            node_decremental = 'V',
            scope_incremental = '<TAB>',
        }
    },
    context_commentstring = {
        enable = true,
        enable_autocmd = false,
    },
}

M.gitsigns = {
    signs = {
        add = { hl = "DiffAdd", text = "", numhl = "GitSignsAddNr" },
        change = { hl = "DiffChange", text = "│", numhl = "GitSignsChangeNr" },
        delete = { hl = "DiffDelete", text = "", numhl = "GitSignsDeleteNr" },
        topdelete = { hl = "DiffDelete", text = "‾", numhl = "GitSignsDeleteNr" },
        changedelete = { hl = "DiffChangeDelete", text = "~", numhl = "GitSignsChangeNr" },
    },
    current_line_blame_opts = {
        virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    },
    current_line_blame_formatter = '<abbrev_sha>: <author>, <author_time:%Y-%m-%d> - <summary>',
}

M.comment = function()
   local present, nvim_comment = pcall(require, "Comment")

   if not present then
      return
   end

   local comment = {
     pre_hook = function(ctx)
       local U = require 'Comment.utils'

       local location = nil
       if ctx.ctype == U.ctype.block then
         location = require('ts_context_commentstring.utils').get_cursor_location()
       elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
         location = require('ts_context_commentstring.utils').get_visual_start_location()
       end

       return require('ts_context_commentstring.internal').calculate_commentstring {
         key = ctx.ctype == U.ctype.line and '__default' or '__multiline',
         location = location,
       }
     end,
   }

   nvim_comment.setup(comment)
end

M.telescope_conf = function()
    vim.cmd "bufdo e"
    require "plugins.configs.telescope"
    require("telescope").load_extension("notify")
    local make_entry = require('telescope.make_entry')

    local telescope = require("telescope")
    telescope.setup {
        defaults = {
            prompt_prefix = " ",
            selection_caret = " ",
            mappings = {
                i = {
                    ['<c-e>'] = require('telescope.actions.layout').toggle_preview,
                },
            },
            layout_config = {
                center = {
                    anchor = 'S',
                    prompt_position = "top",
                    height = 0.4,
                    preview_cutoff = 0
                },
            },
        },
        extensions = {
            fzf = {
                fuzzy = true,                    -- false will only do exact matching
                override_generic_sorter = true,  -- override the generic sorter
                override_file_sorter = true,     -- override the file sorter
                case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            },
            ctags_outline = {
                --ctags option
                ctags = {'ctags'},
                --ctags filetype option
                ft_opt = {
                    vim = '--vim-kinds=fk',
                    lua = '--lua-kinds=fk',
                },
            },
            lsp_handlers = {
                location = {
                },
                definitions = {
                    handlers = "lua vim.cmd('GscopeFind g ' .. vim.fn.expand('<cword>'))",
                },
                references = {
                    handlers = "lua vim.cmd('GscopeFind c ' .. vim.fn.expand('<cword>'))",
                },
            },
        },
    }

    function make_entry.gen_from_quickfix(opts)
      opts = opts or {}

      local entry_display = require "telescope.pickers.entry_display"
      local utils = require "telescope.utils"
      local displayer = entry_display.create {
        separator = "▏",
        items = {
          { width = 8 },
          { width = 0.618 },
          { remaining = true },
        },
      }

      local make_display = function(entry)
        local filename = utils.transform_path(opts, entry.filename)

        local line_info = { table.concat({ entry.lnum, entry.col }, ":"), "TelescopeResultsLineNr" }

        if opts.trim_text then
          entry.text = entry.text:gsub("^%s*(.-)%s*$", "%1")
        end

        return displayer {
          line_info,
          filename,
          entry.text:gsub(".* | ", ""),
        }
      end

      return function(entry)
        local filename = entry.filename or vim.api.nvim_buf_get_name(entry.bufnr)

        return {
          valid = true,

          value = entry,
          ordinal = (not opts.ignore_filename and filename or "") .. " " .. entry.text,
          display = make_display,

          bufnr = entry.bufnr,
          filename = filename,
          lnum = entry.lnum,
          col = entry.col,
          text = entry.text,
          start = entry.start,
          finish = entry.finish,
        }
      end
    end
end
--
M.gutentags = function()
    -- require("core.lazy_load").lazy_load {
    --     events = { "BufNewFile", "BufRead", "TabEnter" },
    --     augroup_name = "GutentagsLazy",
    --     plugins = "vim-gutentags",
    --
    --     condition = function ()
            vim.cmd [[
            let $GTAGSLABEL = 'native-pygments'
            if filereadable(expand("$HOME/.gtags.conf"))
                let $GTAGSCONF = expand("$HOME/.gtags.conf")
            endif
            " gutentags 搜索工程目录的标志，当前文件路径向上递归直到碰到这些文件/目录名
            let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']
            let g:gutentags_plus_nomap = 1
            let g:gutentags_plus_use_telescope = 1
            let g:gutentags_define_advanced_commands = 1
            " let g:gutentags_debug = 1

            " 所生成的数据文件的名称
            let g:gutentags_ctags_tagfile = '.tags'

            " 同时开启 ctags 和 gtags 支持：
            let g:gutentags_modules = []
            if executable('gtags-cscope') && executable('gtags')
                let g:gutentags_modules += ['gtags_cscope']
            elseif executable('ctags')
                 let g:gutentags_modules += ['ctags']
            endif

            " 将自动生成的 ctags/gtags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
            let g:gutentags_cache_dir = expand('~/.cache/tags')

            " 配置 ctags 的参数，老的 Exuberant-ctags 不能有 --extra=+q，注意
            let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
            let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
            let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

            " 如果使用 universal ctags 需要增加下面一行，老的 Exuberant-ctags 不能加下一行
            let g:gutentags_ctags_extra_args += ['--output-format=e-ctags']

            " 禁用 gutentags 自动加载 gtags 数据库的行为
            let g:gutentags_auto_add_gtags_cscope = 0
            ]]
    --     end
    -- }
    require("core.lazy_load").on_file_open "vim-gutentags"
end

M.gutentags_plus = function()
end

M.translate = function()
    local options = {
        default = {
            command = "translate_shell",
            output = "floating",
            parse_before = "trim",
            parse_after = "window",
        },
        silent = true,
    }
    require("translate").setup(options)
end

M.cmp = function()
  return {
    formatting = {
      format = function(entry, vim_item)
        local ELLIPSIS_CHAR = '…'
        local MAX_LABEL_WIDTH = 40
        local MIN_LABEL_WIDTH = 20
        local label = vim_item.abbr
        local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
        if truncated_label ~= label then
          vim_item.abbr = truncated_label .. ELLIPSIS_CHAR
        elseif string.len(label) < MIN_LABEL_WIDTH then
          local padding = string.rep(' ', MIN_LABEL_WIDTH - string.len(label))
          vim_item.abbr = label .. padding
        end
        local icons = require("nvchad_ui.icons").lspkind
        vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
        return vim_item
      end,
    },
  }
end

M.bufferline = function ()
    local present, bufferline = pcall(require, "bufferline")

    if not present then
        return
    end

    require("base46").load_highlight "bufferline"

    vim.cmd [[

        function! Toggle_theme(a,b,c,d)
            lua require('base46').toggle_theme()
        endfunction

        function! Quit_vim(a,b,c,d)
            qa
        endfunction
    ]]

    local options = {
        options = {
            offsets = { { filetype = "NvimTree", text = "", padding = 1 } },
            buffer_close_icon = "",
            modified_icon = "",
            close_icon = "",
            show_close_icon = false,
            left_trunc_marker = " ",
            right_trunc_marker = " ",
            max_name_length = 20,
            max_prefix_length = 13,
            tab_size = 20,
            show_tab_indicators = true,
            enforce_regular_tabs = false,
            show_buffer_close_icons = true,
            separator_style = "thin",
            themable = true,

            -- top right buttons in bufferline
            custom_areas = {
                right = function()
                    return {
                        { text = "%@Toggle_theme@" .. vim.g.toggle_theme_icon .. "%X" },
                        { text = "%@Quit_vim@ %X" },
                    }
                end,
            },
        },
    }

    bufferline.setup(options)
end

return M
