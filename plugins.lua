local plugin_conf = require("custom.configs.other")

---@type NvPluginSpec[]
local plugins = {

    -- lsp {{{
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            --{ 'williamboman/mason-lspconfig.nvim'},
            -- format & linting
            {
                "jose-elias-alvarez/null-ls.nvim",
                config = function()
                    require "custom.configs.null-ls"
                end,
            },

            -- 自动补齐时在悬浮窗口显示函数原型
            {
                "ray-x/lsp_signature.nvim",
                config = function() require "lsp_signature".setup() end
            },
            {
                "SmiteshP/nvim-navic",
            },
        },
        config = function()
            require "plugins.configs.lspconfig"
            require("custom.configs.lspconfig").setup_lsp()
        end, -- Override to setup mason-lspconfig
    },

    {
        "williamboman/mason.nvim",
        opts = plugin_conf.mason
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        cmd = { "MasonToolsUpdate", "MasonToolsInstall" },
        dependencies = { 'williamboman/mason.nvim' },
        opts = function()
            return plugin_conf.mason_installer
        end,
        config = function(_, opts)
            require("mason-tool-installer").setup(opts)
        end, -- Override to setup mason-tool-installer.nvim
    },
    {
        "RubixDev/mason-update-all",
        cmd = { "MasonUpdateAll" },
        dependencies = { 'williamboman/mason.nvim' },
        config = function(_, opts)
            require('mason-update-all').setup(opts)
        end, -- Override to setup mason-update-all
    },
    {
        -- 利用 lsp 显示 函数列表
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
        config = function ()
            require("symbols-outline").setup()
        end
    },

-- }}}

-- treesitter {{{
-- treesitter 扩展
    {
        "nvim-treesitter/nvim-treesitter" ,
        opts = plugin_conf.treesitter,
        dependencies = {
            -- 显示函数名和if for 上下文
            {'romgrk/nvim-treesitter-context'},
            -- 突出显示光标下当前符号
            --{'nvim-treesitter/nvim-treesitter-refactor'},
            -- 与 numToStr / Comment.nvim 配合使用
            {"JoosepAlviste/nvim-ts-context-commentstring"},
            -- 状态栏显示的当前函数名, switch to SmiteshP/nvim-navic
            --{"SmiteshP/nvim-gps", config = function() require("nvim-gps").setup() end},
            -- {"nvim-treesitter/nvim-treesitter-textobjects"},
            -- 显示匹配词
            {
                "andymass/vim-matchup",
                init = function()
                    vim.g.matchup_matchparen_offscreen = { method = "popup" }
                end
            },
        },
    },
--}}}

    -- edit {{{
    -- 文件浏览器
    { "nvim-tree/nvim-tree.lua" , opts = plugin_conf.nvimtree },
    -- 撤销树
    { "mbbill/undotree", cmd = "UndotreeToggle" },
    -- 快速对齐，代替 Tabularize
    {"junegunn/vim-easy-align", cmd = "EasyAlign"},

    -- jk 退出插入模式
    {
        "max397574/better-escape.nvim",
        event = "InsertEnter",
        config = function()
            require("better_escape").setup {
                timeout = 400
            }
        end,
    },
    -- 添加/删除/更改包围符号
    -- The three "core" operations of add/delete/change can be done with the keymaps ys{motion}{char}, ds{char}, and cs{target}{replacement}, respectively. For the following examples, * will denote the cursor position:
    -- Old text                    Command         New text
------ ----------------------------------------------------------------------------
    -- surr*ound_words             ysiw)           (surround_words)
    -- *make strings               ys$"            "make strings"
    -- [delete ar*ound me!]        ds]             delete around me!
    -- remove <b>HTML t*ags</b>    dst             remove HTML tags
    -- 'change quot*es'            cs'"            "change quotes"
    -- <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>
    -- delete(functi*on calls)     dsf             function calls
    {"kylechui/nvim-surround", event = "VeryLazy", config = function() require("nvim-surround").setup({}) end},
    -- 重复上次操作
    { "tpope/vim-repeat", event = "VeryLazy" },
    -- 多行编辑
    { "mg979/vim-visual-multi", event = "InsertLeave" },
    -- 类似 EasyMotion 的移动插件
    {
        "phaazon/hop.nvim",
        cmd = {'HopChar1', 'HopChar1CurrentLine', 'HopPattern', 'HopWord'},
        config = function()
        -- you can configure Hop the way you like here; see :h hop-config
            require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
        end
    },
    -- }}}

    -- coding {{{
    -- 注释
    {
        "numToStr/Comment.nvim",
        keys = { "<leader/>" },
        config = plugin_conf.comment
    },
    -- Doxygen风格注释
    {"vim-scripts/DoxygenToolkit.vim", cmd = {'Dox', 'DoxLic', 'DoxAuthor'}},
    -- 去除行尾空格
    { "ntpeters/vim-better-whitespace", cmd = {"EnableWhitespace", "DisableWhitespace", "ToggleWhitespace", "StripWhitespace"}},
    -- markdown 预览
    {
        "iamcco/markdown-preview.nvim",
        cmd = {"MarkdownPreview", "MarkdownPreviewToggle"},
        lazy = false,
        build = function() vim.fn["mkdp#util#install"]() end,
        init = function()
            vim.g.mkdp_command_for_global=1
        end
    },
    -- }}}

    -- taglist {{{
    {
        -- "dhananjaylatkar/vim-gutentags",
        "ludovicchabant/vim-gutentags",
        lazy=false,
        build = function()
            local chmod_cmd = "! chmod +x " .. vim.fn.stdpath "data" .. "lazy/vim-gutentags/plat/unix/update_gtags.sh"
            vim.cmd("! pip3 install pygments")
            vim.cmd(chmod_cmd)
        end,
        init = plugin_conf.gutentags,

    },

    {
        "zaixi/gutentags_plus",
        cmd = {'GscopeFind', 'GscopeSwitchLayout'},
    },
    -- }}}

    -- 功能增强 {{{
    {"folke/which-key.nvim", config = plugin_conf.whichkey},
    -- tmux 和 vim 导航
    { "christoomey/vim-tmux-navigator", cmd = {"TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp", "TmuxNavigateRight"} },
    -- 缩进可视化
    {
        "lukas-reineke/indent-blankline.nvim",
        event = { "BufReadPost", "BufNewFile" },
        opts = plugin_conf.indent_blankline,
    },
    -- 翻译软件，需要安装 soimort/translate-shell
    { "uga-rosa/translate.nvim", cmd = "Translate", config = plugin_conf.translate},
    {"chentoast/marks.nvim", event = "CmdlineEnter", config = function() require'marks'.setup {} end },
    -- vim 中文文档
    {"yianwillis/vimcdoc", event = "BufRead",},
    -- sudo 读写文件
    {"lambdalisue/suda.vim", cmd = { "SudaWrite", "SudaRead"}},
    -- 轻松重新排列
    {"sindrets/winshift.nvim", cmd = 'WinShift '},
    -- 在不同窗口/标签上显示 A/B/C 等编号，然后字母直接跳转或交换位置
    {'t9md/vim-choosewin', cmd = {'ChooseWin', 'ChooseWinSwap'}},
    -- }}}

    -- telescope {{{
    {
        "nvim-telescope/telescope.nvim",
        opts = plugin_conf.telescope_conf,
        dependencies = {
            -- 增强 telescope 搜索性能
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && \
                    cmake --build build --config Release && \
                    cmake --install build --prefix build"
            },
            -- :Telescope ctags_outline outline 显示函数名 tag 列表
            { "fcying/telescope-ctags-outline.nvim"},
            { "zaixi/telescope-lsp-handlers.nvim"},
        },
    },

    -- }}}

    -- git {{{
    -- git diff 和 log
    { "sindrets/diffview.nvim", cmd = {"DiffviewClose", "DiffviewOpen", "DiffviewFileHistory"}, config = plugin_conf.diffview },
    -- git status
    { "tpope/vim-fugitive", cmd = {"Git", "Gdiffsplit"} },
    { "lewis6991/gitsigns.nvim" , opts = plugin_conf.gitsigns },
    -- }}}

    -- cmp/命令行补全 {{{
    { "hrsh7th/nvim-cmp" , opts = plugin_conf.cmp },
    -- 更好的命令行补全, 后续可以换成全 lua 配置
    {
        'gelguy/wilder.nvim',
        dependencies = {
            {'romgrk/fzy-lua-native'},
        },
        build = function()
            vim.cmd("! pip3 install pynvim")
            vim.cmd(":UpdateRemotePlugins")
        end,
        event = 'CmdlineEnter',
        config = function() require("custom.configs.wilder") end
    },
    -- }}}

    -- other {{{
    {"rcarriga/nvim-notify"},
    {
        "mrded/nvim-lsp-notify",
        dependencies = {
            {"rcarriga/nvim-notify"},
        },
        config = function()
            require('lsp-notify').setup({
                notify = require('notify'),
            })
        end
    },
    {
        -- 回车自动格式化当前行
        "skywind3000/vim-rt-format",
        enabled = false,
        build = 'pip3 install autopep8;pip3 install pynvim',
        event = "InsertEnter",
        config = function()
            vim.cmd "RTFormatEnable"
        end
    },
    -- }}}
}

return plugins
