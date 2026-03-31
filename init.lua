vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.diffopt:append("vertical")

vim.opt.expandtab = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2

vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.inccommand = 'split'

vim.g.maplocalleader = "\\"
vim.g.mapleader = ","

vim.opt.mouse = ""
vim.opt.background = "light"
vim.opt.termguicolors = true

vim.opt.cursorline = true

vim.opt.spell = true


-- BEGIN: set up lazy automatically
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- regular configuration
require("lazy").setup({

  -- Looks
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {}, version = "~3" },
  { "RRethy/vim-illuminate" },

  -- Mappings
  {
    "kylechui/nvim-surround",
    version = "~3",
    event = "VeryLazy",
    config = true,
  },
  { 'fedepujol/move.nvim', opts = { char = { enable = true } }, version = "~2" },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    version = "~3",
  },

  -- Text objects
  { "wellle/targets.vim", tag = "v0.5.0" }, --arguments
  { "michaeljsmith/vim-indent-object", version = "~1" },

  -- Language server
  { "mason-org/mason.nvim", config = true, version = "^2.0" },
  {
    "mason-org/mason-lspconfig.nvim",
    config = true,
    version = "^2.0",
    dependencies = {
      {"mason-org/mason.nvim", version="^2.0"},
      {"neovim/nvim-lspconfig", version="^2.1"},
    },
  },

  -- Git support
  { 'lewis6991/gitsigns.nvim', version = "^1.0" },
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "sindrets/diffview.nvim",
      "nvim-telescope/telescope.nvim",
      "rbong/vim-flog",  -- optional: nicer git graph
    },
    opts = { graph_style = "unicode" },
    version = "~v2",
  },

  -- auto completion
  {
    'saghen/blink.cmp',
    dependencies = { 'rafamadriz/friendly-snippets' },
    version = '1.*',
    opts = {
      -- completion = { documentation = { auto_show = false } },
    },
    opts_extend = { "sources.default" }
  },

  {
    'nvim-telescope/telescope.nvim',
    version = '~0.1',
    dependencies = { { 'nvim-lua/plenary.nvim' } }
  },

  { 'Vigemus/iron.nvim', }
})
-- END: lazy

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_augroup("LspMappings", { clear = true })
vim.api.nvim_create_autocmd('LspAttach', {
  group = "LspMappings",
  callback = function(args)
    -- print('Starting language server')
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local wk = require("which-key")
    wk.add({
      silent = false, buffer = bufnr,
      {"gD", vim.lsp.buf.declaration, desc = "Go Declaration" },
      {"gd", vim.lsp.buf.definition, desc = "Go Definition" },
      {"<C-s>", vim.lsp.buf.signature_help, desc = "Signature" },
      {"gr", group = "LSP"},
      {"grh", function() vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled()) end, desc = "toggle inlay Hints" },
      {"grr", "<CMD>Telescope lsp_references<CR>", desc = "references" },
      {"gO", "<CMD>Telescope lsp_document_symbols<CR>", desc = "LSP Symbols" },
      {"grd", "<CMD>Telescope diagnostics<CR>", desc = "Diagnostic" },
      {"grD", "<CMD>Telescope lsp_definitions<CR>", desc = "go type Defintion" },
      {"grf", group = "File" },
      {"grff", function() vim.lsp.buf.format({ async = false }) end, desc = "Format" },
      {"grw", group = "Workspace" },
      {"grwa", vim.lsp.buf.add_workspace_folder, desc = "Add folder" },
      {"grwr", vim.lsp.buf.remove_workspace_folder, desc = "Remove folder" },
      {"grwl", "<CMD>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", desc = "List folder" },
    })
    if client:supports_method("textDocument/implementation") then
      wk.add({
        silent = false, buffer = bufnr,
        { "gri", vim.lsp.buf.implementation(), desc = "Go Implementation" },
      })
    end
  end
})

vim.lsp.config("lua_ls", { settings = { Lua = { diagnostics = { globals = { 'vim' } } } } })


-- Key-mappings using which-key
local wk = require("which-key")
wk.add({ -- normal mode mappings
  {"<space>", group = "Telescope"},
  {"<space>s", "<CMD>Telescope buffers<CR>", desc = "buffer" },
  {"<space>/", "<CMD>Telescope live_grep<CR>", desc = "live grep" },
  {"<space>f", "<CMD>Telescope find_files<CR>", desc = "Files" },
  {"<space>o", "<CMD>Telescope oldfiles<CR>", desc = "Recent files" },
  {"<space>q", "<CMD>Telescope quickfix<CR>", desc = "Quickfix" },
  {"<space>l", "<CMD>Telescope loclist<CR>", desc = "Location" },
  {"<space>r", "<CMD>Telescope resume<CR>", desc = "Resume Telescope" },
  -- END: Telescope
  {"<space>g", group = "mod"},
  {"<space>g/", "<CMD>Telescope grep_string<CR>", desc = "grep word" },
  -- END: mod
  {"<leader>/", "<CMD>Telescope current_buffer_fuzzy_find<CR>", desc = "Fuzzy search" },
  -- {"<leader>h", "<CMD>nohlsearch<CR>", desc = "remove search Highlight" },
  {"<C-w>f", "<C-w><Bar><C-w>_", desc = "Full size"},
  {"<F1>", "<CMD>Telescope help_tags<CR>", desc = "Help" },
  {'<A-j>', '<CMD>MoveLine(1)<CR>', desc = 'Move down' },
  {'<A-k>', '<CMD>MoveLine(-1)<CR>', desc = 'Move up' },
  {'<A-h>', '<CMD>MoveHChar(-1)<CR>', desc = 'Move left' },
  {'<A-l>', '<CMD>MoveHChar(1)<CR>', desc = 'Move right' },
})
wk.add({ -- visual mode mappings
  mode = "v",
  {'<A-j>', ":MoveBlock(1)<CR>", desc = 'Move down' },
  {'<A-k>', ":MoveBlock(-1)<CR>", desc = 'Move up' },
  {'<A-h>', ":MoveHBlock(-1)<CR>", desc = 'Move left' },
  {'<A-l>', ":MoveHBlock(1)<CR>", desc = 'Move right' },
})
wk.add({ -- insert mode mappings
  mode = "i",
  {'<C-z>', "<c-g>u<Esc>[s1z=`]a<c-g>u", desc = "Correct last error" },
  {'<C-l>', "<Right>", desc = "Move right" },
})
wk.add({ -- terminal mode mappings
  mode = "t",
  {'<ESC>', "<C-\\><C-n>", desc = "Exit terminal mode" },
  {'<leader><ESC>', "<ESC>", desc = "Send <ESC> to terminal" },
})
wk.add({ -- Git mappings
  mode = "n",
  { "<leader>g",  group = "Git" },
  { "<leader>gg", "<CMD>Neogit<CR>",         desc = "neoGit" },
  { "<leader>gl", "<CMD>Neogit log<CR>",     desc = "git Log" },
  { "<leader>gc", "<CMD>Neogit commit<CR>",  desc = "git Commit" },
  { "<leader>gd", "<CMD>DiffviewOpen<CR>",   desc = "git Diff" },
  { "<leader>gb", "<CMD>Gitsigns blame<CR>", desc = "git Blame" },
})


require('gitsigns').setup({
  on_attach = function(bufnr)
    local function map(mode, lhs, rhs, gs_opts)
      gs_opts = vim.tbl_extend('force', { noremap = true, silent = true }, gs_opts or {})
      vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, gs_opts)
    end

    wk.add({ -- Navigation
      {']c', function() if vim.wo.diff then vim.cmd.normal({']c', bang = true}) else require('gitsigns').nav_hunk('next') end end, desc = "Next change" },
      {'[c', function() if vim.wo.diff then vim.cmd.normal({'[c', bang = true}) else require('gitsigns').nav_hunk('prev') end end, desc = "Prev change" },
    })

    wk.add({ -- Actions
      {"<leader>h", group = "Hunk", mode = {"n", "v"} },
      {"<leader>hs", "<CMD>Gitsigns stage_hunk<CR>", desc = "Hunk Stage", mode = {"n", "v"} },
      {"<leader>hS", "<CMD>Gitsigns stage_buffer<CR>", desc = "Stage buffer" },
      {"<leader>hr", "<CMD>Gitsigns reset_hunk<CR>", desc = "Hunk Reset" },
      {"<leader>hR", "<CMD>Gitsigns reset_buffer<CR>", desc = "Reset buffer" },
      {"<leader>hu", '<CMD>Gitsigns undo_stage_hunk<CR>', desc = "Hunk Undo" },
      {"<leader>hp", '<CMD>Gitsigns preview_hunk<CR>', desc = "Hunk Preview" },
      {"<leader>hb", '<CMD>lua require"gitsigns".blame_line{full=true}<CR>', desc = "Hunk Blame" },
      {"<leader>hd", '<CMD>Gitsigns diffthis<CR>', desc = "Hunk Diff" },
      {"<leader>hD", '<CMD>lua require"gitsigns".diffthis("~")<CR>', desc = "Hunk Diff" },
      {"<leader>t", group = "toggle"},
      {"<leader>tb", '<CMD>Gitsigns toggle_current_line_blame<CR>', desc = "Toggle Blame" },
      {"<leader>td", '<CMD>Gitsigns toggle_deleted<CR>', desc = "Toggle Delete" },
    })

    -- Text object
    map('o', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
    map('x', 'ih', ':<C-U>Gitsigns select_hunk<CR>')
  end
})

local iron = require("iron.core")
iron.setup {
  config = {
    scratch_repl = true,
    repl_open_cmd = "topleft vsplit",
    repl_definition = {
      python = require("iron.fts.python").ipython,
    }
  },
  -- keymaps = {
  --   send_motion = "<space>sc",
  --   visual_send = "<space>sc",
  --   repeat_cmd = "<space>s.",
  --   cr = "<space>s<cr>",
  --   interrupt = "<space>s<space>",
  --   exit = "<space>sq",
  --   clear = "<space>cl",
  -- }
}
wk.add({
  {"<leader>s", group = "Send"},
  {"<leader>s", "<CMD>lua require('iron.core').visual_send()<CR>", desc = "Send Visual", mode = "v" },
  {"<leader>ss", "<CMD>lua require('iron.core').send_line()<CR>", desc = "Send Line" },
  {"<leader>sm", "<CMD>lua require('iron.core').run_motion('send_motion')<CR>", desc = "Send Motion" },
  {"<leader>sf", "<CMD>lua require('iron.core').send_file()<CR>", desc = "Send File" },
  {"<leader>sQ", "<CMD>lua require('iron.core').close_repl()<CR>", desc = "Quit" },
  {"<leader>sc", "<CMD>lua require('iron.core').send(nil, string.char(03))<CR>", desc = "Interrupt" },
  {"<leader>sl", "<CMD>lua require('iron.core').send(nil, string.char(12))<CR>", desc = "clar" },
})
-- autocmds
vim.api.nvim_create_augroup("highlight_yank", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = "highlight_yank",
  callback = function() vim.highlight.on_yank { higroup = "IncSearch", timeout = 700 } end
})
vim.api.nvim_create_augroup("spell", { clear = true})
vim.api.nvim_create_autocmd("TermOpen", {
  group = "spell",
  callback = function () vim.opt_local.spell = false end
})
