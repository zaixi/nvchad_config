local M = {}

M.ui = function()
  statusline = require "nvchad_ui.statusline.default"
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
        if vim.o.columns < 140 or not package.loaded["nvim-navic"] then
          return ""
        end
        local gps = require("nvim-navic")
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
      info = statusline.LSP_progress() .. "  " .. info
      return info

      --return ("%#St_gitIcons#" .. nvim_gps() .. "  " .. gutentags_status()) or ""
    end,

    cursor_position = function()
      local current_col = vim.fn.col "."
      old_info = statusline.cursor_position()
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

M.whichkey = function(_, opts)
  local wk = require("which-key")

  local default = {
    window = {
        border = "rounded", -- none/single/double/shadow
    },
  }

  -- require "plugins.configs.whichkey"
  dofile(vim.g.base46_cache .. "whichkey")
  wk.setup(vim.tbl_deep_extend("force", opts, default))

  local map_name = require("custom.chadrc").map_name or {}
  for modes, name in pairs(map_name) do
    if next(name) ~= nil then
      wk.register(name, { mode = modes })
    end
  end

end

M.nvimtree = {
  git = {
    enable = true,
  },
  reload_on_bufenter = true,
  renderer = {
    highlight_git = true,
    icons = {
      show = {
        git = true,
      },
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

M.mason = {
  ensure_installed = require("custom.chadrc").Mason_server,
}

M.mason_installer = {
    ensure_installed = require("custom.chadrc").Mason_server,
}

M.treesitter = {
    ensure_installed = {
        "c",
        "lua",
        "vim",
        "vimdoc",
        "query",
        "python",
        "markdown",
        "bash",
        "json",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "markdown_inline",
    },
    -- ensure_installed = "all", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    ignore_install = { "fusion", "jsonc", "php", "norg", "tlaplus" }, -- List of parsers to ignore installing
    highlight = {
        enable = true,
        use_languagetree = true,
    },
    indent = {
        enable = true,
        -- disable = {
        --   "python"
        -- },
    },
    refactor = {
        highlight_definitions = {
            enable = true,
            -- Set to false if you have an `updatetime` of ~100.
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
    matchup = {
        enable = true,
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
    local comment = {
        pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
    }

    require('Comment').setup(comment)
end

M.telescope_conf = {
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
    extensions_list = { "themes", "terms", "fzf", "lsp_handlers"},
    extensions = {
        fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        },
        lsp_handlers = {
            fname_width = 0.9,
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
            " 关闭保存时自动更新
            let g:gutentags_generate_on_write = 0

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
    -- require("core.lazy_load").on_file_open "vim-gutentags"
end

M.gutentags_plus = function()
end

M.translate = function()
    local options = {
        default = {
            command = "translate_shell",
            output = "floating",
            parse_before = "trim,natural",
            parse_after = "window",
        },
        silent = true,
    }
    require("translate").setup(options)
end

M.indent_blankline = {
    -- for example, context is off by default, use this to turn it on
    show_current_context = true,
    show_current_context_start = true,
}

M.cmp = {
    formatting = {
        format = function(_, item)
            local ELLIPSIS_CHAR = '…'
            local MAX_LABEL_WIDTH = 40
            local MIN_LABEL_WIDTH = 20
            local label = item.abbr
            local truncated_label = vim.fn.strcharpart(label, 0, MAX_LABEL_WIDTH)
            if truncated_label ~= label then
                item.abbr = truncated_label .. ELLIPSIS_CHAR
            elseif string.len(label) < MIN_LABEL_WIDTH then
                local padding = string.rep(' ', MIN_LABEL_WIDTH - string.len(label))
                item.abbr = label .. padding
            end

            local cmp_ui = require("core.utils").load_config().ui.cmp
            local cmp_style = cmp_ui.style
            local icons = require("nvchad_ui.icons").lspkind
            local icon = (cmp_ui.icons and icons[item.kind]) or ""

            if cmp_style == "atom" or cmp_style == "atom_colored" then
                icon = " " .. icon .. " "
                item.menu = cmp_ui.lspkind_text and "   (" .. item.kind .. ")" or ""
                item.kind = icon
            else
                icon = cmp_ui.lspkind_text and (" " .. icon .. " ") or icon
                item.kind = string.format("%s %s", icon, cmp_ui.lspkind_text and item.kind or "")
            end

            return item
        end,
    },
}

return M
