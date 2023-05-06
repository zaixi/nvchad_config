local wilder = require('wilder')
wilder.setup({
    modes = {'/', '?', ':'},
    -- 默认开启 wilder
    enable_cmdline_enter = 1
})

wilder.set_option('pipeline', {
    wilder.debounce(10),
    wilder.branch(
    -- wilder.python_file_finder_pipeline({
    --     file_command = {'rg', '--files'},
    --     filters = {'fuzzy_filter', 'difflib_sorter'},
    -- }),
    wilder.substitute_pipeline({
        pipeline = wilder.python_search_pipeline({
            skip_cmdtype_check = 1,
            pattern = wilder.python_fuzzy_pattern({
                start_at_boundary = 0,
            }),
        }),
    }),
    wilder.cmdline_pipeline({
        fuzzy = 1,
        fuzzy_filter = wilder.lua_fzy_filter(),
    }),
    {
        -- wilder#check({_, x -> empty(x)}),
        wilder.check(vim.fn.empty(x)),
        wilder.history(),
    },
    wilder.python_search_pipeline({
        pattern = wilder.python_fuzzy_pattern({
            start_at_boundary = 0,
        }),
    })
    ),
})

local highlighters = {
    wilder.pcre2_highlighter(),
    wilder.lua_fzy_highlighter(),
}

local popupmenu_renderer = wilder.popupmenu_renderer(wilder.popupmenu_border_theme({
    pumblend = 20,
    border = 'rounded',
    empty_message = wilder.popupmenu_empty_message_with_spinner(),
    highlighter = highlighters,
    highlights = {
        -- accent = wilder.make_hl('WilderAccent', 'Pmenu', {{}, {}, {foreground="'#f4468f'"}, }),
        accent = wilder.make_hl('WilderAccent', 'Pmenu', 'DevIconSass'),
    },
    left = {
        ' ',
        wilder.popupmenu_devicons(),
        wilder.popupmenu_buffer_flags({
            flags = ' a + ',
            icons = {['+'] = '', ['a'] = '', ['h'] = ''},
        }),
    },
    right = {
        ' ',
        wilder.popupmenu_scrollbar(),
    },
}))

local wildmenu_renderer = wilder.wildmenu_renderer({
    highlighter = highlighters,
    separator = ' · ',
    left = {' ', wilder.wildmenu_spinner(), ' '},
    right = {' ', wilder.wildmenu_index()},
})

wilder.set_option('renderer', wilder.renderer_mux({
    [':'] = popupmenu_renderer,
    ['/'] = wildmenu_renderer,
    substitute = wildmenu_renderer,
}))
