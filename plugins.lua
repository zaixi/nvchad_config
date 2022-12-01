local M = {}
local plugin_conf = require("custom.plugins.other")
local Plug = require("custom.utils").Plug

local lazy_load = require("core.lazy_load")
table.insert(lazy_load.mason_cmds, "LspInstallAll")
table.insert(lazy_load.mason_cmds, "LspUninstallAll")

Plug {
  {
    "NvChad/ui",
    override_options = {
      statusline = {
        overriden_modules = plugin_conf.ui
      },
      tabufline = {
        enabled = false,
        lazyload = false,
        overriden_modules = nil,
      },
    },
  },
}

Plug {
    {"goolord/alpha-nvim", disable = false},
    {"numToStr/Comment.nvim", config = plugin_conf.comment},
    {
        "akinsho/bufferline.nvim",
        tag = "v2.*",
        config = plugin_conf.bufferline
    },
    {"lewis6991/impatient.nvim"},
    {"rcarriga/nvim-notify"},
    {"nvim-telescope/telescope.nvim", config = plugin_conf.telescope_conf},
--
--    -- 在状态栏显示当前函数名
--    {
--        "SmiteshP/nvim-gps",
--        event = "CursorMoved",
--        config = function() require("nvim-gps").setup() end
--    },
    -- 自动补齐时在悬浮窗口显示函数原型
    {
        "ray-x/lsp_signature.nvim",
        after = "nvim-lspconfig",
        config = function() require "lsp_signature".setup() end
    },

    {
        "ludovicchabant/vim-gutentags",
        run = function()
            local chmod_cmd = "! chmod +x " .. vim.fn.stdpath "data" .. '/site/pack/packer/opt/vim-gutentags/plat/unix/update_gtags.sh'
            vim.cmd("! pip3 install pygments")
            vim.cmd(chmod_cmd)
        end,
        setup = plugin_conf.gutentags,
    },
    {
        "zaixi/gutentags_plus",
        cmd = {'GscopeFind', 'GscopeSwitchLayout'},
    },
    -- 快速对齐，代替 Tabularize
    {"junegunn/vim-easy-align", cmd = "EasyAlign", config = plugin_conf.easy_align},
    -- 去除行尾空格
    {
        "ntpeters/vim-better-whitespace", opt = true,
        setup = function() require("core.lazy_load").on_file_open "vim-better-whitespace" end
    },
    -- 撤销树
    {"mbbill/undotree", cmd = "UndotreeToggle"},
    -- Doxygen风格注释
    {"vim-scripts/DoxygenToolkit.vim", cmd = {'Dox', 'DoxLic', 'DoxAuthor'}},
    {
        "tpope/vim-surround", opt = true,
        setup = function() require("core.lazy_load").on_file_open "vim-surround" end,
    },
    -- 重复上次操作
    {
        "tpope/vim-repeat", opt = true,
        setup = function() require("core.lazy_load").on_file_open "vim-repeat" end,
    },
    -- 多行编辑
    { "mg979/vim-visual-multi", event = "InsertLeave" },
    -- tmux 和 vim 导航
    { "christoomey/vim-tmux-navigator", cmd = {"TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight"} },
    -- 缩进可视化
    {
        "lukas-reineke/indent-blankline.nvim",
        opt= true,
        setup = function()
            require("core.lazy_load").on_file_open "indent-blankline.nvim"
        end,
        config = function ()
            require("indent_blankline").setup {}
        end
    },
    -- 显示匹配词
    { "andymass/vim-matchup",
        opt = true,
        setup = function()
            require("core.lazy_load").on_file_open "vim-matchup"
        end,
    },
    {
        "iamcco/markdown-preview.vim", cmd = {"MarkdownPreview"},
        setup = function()
            vim.cmd("let g:mkdp_command_for_global = 1")
        end
    },
    -- git diff 和 log
    { "sindrets/diffview.nvim", cmd = {"DiffviewClose", "DiffviewOpen", "DiffviewFileHistory"}, config = plugin_conf.diffview },
    -- git status
    { "tpope/vim-fugitive", cmd = {"Git", "Gdiffsplit", "Gstatus", "Gblame"} },
}



Plug {
    -- wilder.nvim 的依赖
    {'romgrk/fzy-lua-native'},
    -- 更好的命令行补全, 后续可以换成全 lua 配置
    {
        'gelguy/wilder.nvim',
        --run = ":UpdateRemotePlugins",
        run = function()
            vim.cmd("! pip3 install pynvim")
            vim.cmd(":UpdateRemotePlugins")
        end,
        after = "fzy-lua-native",
        event = 'CmdlineEnter', config = function() require("custom.plugins.wilder") end
    },
}

Plug {
    -- 翻译软件，需要安装 soimort/translate-shell
    {
        "uga-rosa/translate.nvim",
        cmd = "Translate",
        config = plugin_conf.translate,
    },
    -- 类似 EasyMotion 的移动插件
    {
        "phaazon/hop.nvim",
        cmd = {'HopChar1', 'HopChar1CurrentLine', 'HopPattern', 'HopWord'},
        config = function()
            -- you can configure Hop the way you like here; see :h hop-config
            require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
        end
    },
    {"chentoast/marks.nvim", event = "CmdlineEnter", config = function() require'marks'.setup {} end },
    -- vim 中文文档
    {"yianwillis/vimcdoc", event = "BufRead",},
    -- sudo 读写文件
    {"lambdalisue/suda.vim", cmd = { "SudaWrite", "SudaRead"}},
    -- 轻松重新排列 windows
    {"sindrets/winshift.nvim", cmd = 'WinShift '},
    -- 在不同窗口/标签上显示 A/B/C 等编号，然后字母直接跳转或交换位置
    {'t9md/vim-choosewin', cmd = {'ChooseWin', 'ChooseWinSwap'}}
}

-- treesitter 扩展
Plug {
     -- 显示函数名和if for 上下文
     {"romgrk/nvim-treesitter-context", after = "nvim-treesitter"},
     -- 突出显示光标下当前符号
     {"nvim-treesitter/nvim-treesitter-refactor", after = "nvim-treesitter"},
   -- 与 numToStr / Comment.nvim 配合使用
   {"JoosepAlviste/nvim-ts-context-commentstring", after = "nvim-treesitter"},
   -- 与 numToStr / Comment.nvim 配合使用
   -- {"nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter"},
     -- 状态栏显示的当前函数名
     {"SmiteshP/nvim-gps", after = "nvim-treesitter", config = function() require("nvim-gps").setup() end}
}

-- telescope 扩展
Plug {
    {-- 增强 telescope 搜索性能
        "nvim-telescope/telescope-fzf-native.nvim",
        run = "make",
        after = "telescope.nvim",
        config = function()
            require("telescope").load_extension "fzf"
        end
    },
    {-- :Telescope ctags_outline outline 显示函数名 tag 列表
        "fcying/telescope-ctags-outline.nvim",
        after = "telescope.nvim",
        config = function()
            require('telescope').load_extension('ctags_outline')
        end
    },
    {--
        "zaixi/telescope-lsp-handlers.nvim",
        after = "telescope.nvim",
        config = function()
            require('telescope').load_extension('lsp_handlers')
        end
    }
}


Plug {
    -- 利用 lsp 显示 函数列表
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    config = function ()
        require("symbols-outline").setup()
    end
}

Plug {
    -- 回车自动格式化当前行
    "skywind3000/vim-rt-format",
    disable = true,
    run = 'pip3 install autopep8;pip3 install pynvim',
    event = "InsertEnter",
    config = function()
        vim.cmd "RTFormatEnable"
    end
}

Plug {
  "folke/which-key.nvim" ,
  disable = false,
  config = plugin_conf.whichkey
}

Plug {
  { "kyazdani42/nvim-tree.lua" , override_options = plugin_conf.nvimtree },
  { "nvim-treesitter/nvim-treesitter" , override_options = plugin_conf.treesitter },
  { "lewis6991/gitsigns.nvim" , override_options = plugin_conf.gitsigns },
  { "hrsh7th/nvim-cmp" , override_options = plugin_conf.cmp },
}

Plug {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "custom.plugins.lspconfig".setup_lsp()
    end
  },
  {
    "williamboman/mason.nvim",
    override_options = function()
      return {
          ensure_installed = require("custom.chadrc").lsp_server
        }
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    after = "mason.nvim",
    run = function()
      vim.cmd(":LspInstallAll")
    end,
    config = function()
      require "custom.plugins.lspconfig".mason_lspconfig()
    end
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    disable = true,
    after = "nvim-lspconfig",
    config = function()
      local present, null_ls = pcall(require, "null-ls")

      if not present then
        return
      end

      local b = null_ls.builtins

      local sources = {

        -- webdev stuff
        b.formatting.deno_fmt,
        b.formatting.prettier,

        -- Lua
        --b.formatting.stylua,

        -- Shell
        b.formatting.shfmt,
        b.diagnostics.shellcheck.with { diagnostics_format = "#{m} [#{c}]" },

        -- C/C++
        b.formatting.clang_format,
        b.diagnostics.cpplint
      }

      null_ls.setup {
        debug = true,
        sources = sources,
      }
    end,
  },
}


M.plugs = function ()
  --return {}
    return require("custom.utils").plugs
end

return M
