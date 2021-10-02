-- Key-mappings using which-key

local wk = require("which-key")
wk.register({ -- normal mode mappings
  ["<space>"] = {
    name = "Telescope",
    ["s"] = {"<CMD>Telescope buffers<CR>", "buffer"},
    ["/"] = {"<CMD>Telescope live_grep<CR>", "live grep"},
    ["f"] = {"<CMD>Telescope find_files<CR>", "Files"},
    ["r"] = {"<CMD>Telescope oldfiles<CR>", "Recent files" },
    ["q"] = {"<CMD>Telescope quickfix<CR>", "Quickfix"},
    ["l"] = {"<CMD>Telescope loclist<CR>", "Location"},
    ["t"] = {"<CMD>TodoTelescope<cr>", "TODOs"},
    ["r"] = {"<CMD>Telescope resume<cr>", "Resume Telescope"},
    ["ms"] = {"<CMD>lua require'telescope.builtin'.symbols{sources={'math'}}<cr>", "MathSymbols"},
    ["g"] = {
      name = 'mod',
      ["/"] = {"<cmd>Telescope grep_string<cr>", "grep word"},
      },
    },
  ["<leader>"] = {
    ["s"] = {
      name = "Send to iron",
      ["s"] = {"<Plug>(iron-send-lines)", "Send line"},
      ["m"] = {"<Plug>(iron-send-motion)", "Send Motion"},  -- TODO: write issue
      ["i"] = {"<CMD>Iron! %matplotlib", "Interactive plot"},
      ["<C-c>"] = {"<Plug>(iron-interrupt)", "interrupt"},
      ["<C-l>"] = {"<Plug>(iron-clear)", "clear"},
      ["Q"] = {"<Plug>(iron-exit)", "Quit"},
			["."] = {"<Plug>(iron-repeat-cmd)", "repeat"},
    },
    ["/"] = {"<CMD>Telescope current_buffer_fuzzy_find<CR>", "Fuzzy search"},
    ["ct"] = {"<Plug>Colorizer", "ColorToggle"},
    ["w"] = {
      name = "Wiki",
      ["w"] = {"<Plug>VimwikiIndex", "edit"},
      ["t"] = {"<Plug>VimwikiTabIndex", "new Tab"},
      ["s"] = {"<Plug>VimwikiUISelect", "Select"},
      },
    ["h"] = {"<CMD>nohl<CR>", "remove search Highlight"},
    },
  ["<C-w>"] = {
    -- name = "Window",
    ["r"] = {"<Plug>(golden_ratio_resize)", "golden Ratio"},
    ["f"] = {"<C-w><Bar><C-w>_", "Full size"},
    },
  ["c"] = {
    -- name = "Create split",
    ["<C-j>"] = {"<CMD>below sp new<cr>", "split below"},
    ["<C-k>"] = {"<CMD>above sp new<cr>", "split above"},
    ["<C-h>"] = {"<CMD>lefta sp new<cr>", "split left"},
    ["<C-l>"] = {"<CMD>rightb sp new<cr>", "split right"},
    },
  ["d"] = {
    -- name = "Delete split",
    ["<C-j>"] = {"<C-w>j<C-w>c", "delete below"},
    ["<C-k>"] = {"<C-w>k<C-w>c", "delete above"},
    ["<C-h>"] = {"<C-w>h<C-w>c", "delete left"},
    ["<C-l>"] = {"<C-w>l<C-w>c", "delete right"},
    },
  ["<F1>"] = {"<CMD>Telescope help_tags<CR>", "Help"},
  ["<F8>"] = {"<CMD>Tagbar<CR>", "Tagbar"},
  ["<F9>"] = {"<CMD>MundoToggle<CR>", "Undo History"},
  })
wk.register({ -- visual mode mappings
  ["++"] = {"y:call VMATH_Analyse()<CR>gv", "statistics"},
  ["<Leader>ll"] = {":<C-u>call unicoder#selection()<CR>", "Latex unicode"},
  ["<leader>s"] = {":Iron<CR>", "Send iron"},
  }, {mode = 'v'})
