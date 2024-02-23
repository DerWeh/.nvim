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
    version = "~2",
    event = "VeryLazy",
    config = true,
  },
  { 'numToStr/Comment.nvim', opts = {}, lazy = false },
  { 'fedepujol/move.nvim', opts = {} },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
  },

  -- Text objects
  { "wellle/targets.vim", tag = "v0.5.0" }, --arguments
  { "michaeljsmith/vim-indent-object", version = "~1" },

  -- Language server
  { "williamboman/mason.nvim", config = true },
  { "williamboman/mason-lspconfig.nvim", config = true },
  { "neovim/nvim-lspconfig", version = "~0.1.7" },

  -- Git support
  { 'lewis6991/gitsigns.nvim', version = "~0.7" },

  -- auto completion
  'hrsh7th/cmp-nvim-lsp',
  { 'ray-x/lsp_signature.nvim', config = true },
  -- 'hrsh7th/cmp-nvim-lsp-signature-help',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  { 'hrsh7th/nvim-cmp', version = "0.0.1" },
  -- snippet engine
  { "L3MON4D3/LuaSnip", version = "~2" },

  {
    'nvim-telescope/telescope.nvim',
    version = '~0.1',
    dependencies = { { 'nvim-lua/plenary.nvim' } }
  },

  { 'hkupty/iron.nvim', }
})
-- END: lazy

-- setup cmp
-- Set up nvim-cmp.
local cmp = require('cmp')
cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  window = {
    -- completion = cmp.config.window.bordered(),
    -- documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_signature_help' },
    { name = 'luasnip' }, -- For luasnip users.
    { name = 'buffer' },
    { name = 'path' },
  })
})
-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()


-- language server configuration

local lspconfig = require('lspconfig')
-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  print('Starting language server')
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local wk = require("which-key")
  wk.register({
    ["gD"] = { vim.lsp.buf.declaration, "Go Declaration" },
    ["gd"] = { vim.lsp.buf.definition, "Go Declaration" },
    ["K"] = { vim.lsp.buf.hover, "documentation" },
    -- ['gi'] = { vim.lsp.buf.implementation(), "Go Implementation"},
    ["<C-k>"] = { vim.lsp.buf.signature_help, "Signature" },
    ["<LocalLeader>"] = {
      name = "Language",
      ["n"] = { "<CMD>Telescope lsp_references<CR>", "references" },
      ["s"] = { "<CMD>Telescope lsp_document_symbols<CR>", "Symbols" },
      ["d"] = { "<CMD>Telescope diagnostics<CR>", "Diagnostic" },
      ["r"] = { vim.lsp.buf.rename, "Rename" },
      ["D"] = { vim.lsp.buf.type_definition, "go type Defintion" },
      ["ca"] = { vim.lsp.buf.code_action, "Code Action" },
      ["f"] = {
        name = 'File',
        ["f"] = { function() vim.lsp.buf.format({ async = false }) end, "Format" },
      },
      ["w"] = {
        name = "Workspace",
        ["a"] = { vim.lsp.buf.add_workspace_folder, "Add folder" },
        ["r"] = { vim.lsp.buf.remove_workspace_folder, "Remove folder" },
        ["l"] = { "<CMD>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "List folder" },
      },
    },
  }, { silent = false, buffer = bufnr })
  -- vim.keymap.set('n', '<space>wl', function()
  --   print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  -- end, bufopts)
end
require('mason-lspconfig').setup_handlers({
  function(server)
    if server == "sumneko_lua" then
      lspconfig[server].setup({ on_attach = on_attach, capabilities = capabilities,
        settings = { Lua = { diagnostics = { globals = { 'vim' } } } }
      })
    elseif server == "pylsp" then
      lspconfig[server].setup({ on_attach = on_attach, capabilities = capabilities,
        settings = { pylsp = { plugins = {
          pycodestyle = { maxLineLength = 100 },
          pydocstyle = { enabled = true, convention = 'numpy' }
        } } } })
    else
      lspconfig[server].setup({ on_attach = on_attach, capabilities = capabilities })
    end
  end,
})


-- Key-mappings using which-key
local wk = require("which-key")
wk.register({ -- normal mode mappings
  ["<space>"] = {
    name = "Telescope",
    ["s"] = { "<CMD>Telescope buffers<CR>", "buffer" },
    ["/"] = { "<CMD>Telescope live_grep<CR>", "live grep" },
    ["f"] = { "<CMD>Telescope find_files<CR>", "Files" },
    ["o"] = { "<CMD>Telescope oldfiles<CR>", "Recent files" },
    ["q"] = { "<CMD>Telescope quickfix<CR>", "Quickfix" },
    ["l"] = { "<CMD>Telescope loclist<CR>", "Location" },
    ["r"] = { "<CMD>Telescope resume<cr>", "Resume Telescope" },
    ["g"] = {
      name = 'mod',
      ["/"] = { "<cmd>Telescope grep_string<cr>", "grep word" },
    },
  },
  ["<leader>"] = {
    ["/"] = { "<CMD>Telescope current_buffer_fuzzy_find<CR>", "Fuzzy search" },
    -- ["h"] = { "<CMD>nohl<CR>", "remove search Highlight" },
  },
  ["<C-w>"] = {
    -- name = "Window",
    ["f"] = { "<C-w><Bar><C-w>_", "Full size" },
  },
  ["<F1>"] = { "<CMD>Telescope help_tags<CR>", "Help" },
  ['<A-j>'] = { '<CMD>MoveLine(1)<CR>', 'Move down' },
  ['<A-k>'] = { '<CMD>MoveLine(-1)<CR>', 'Move up' },
  ['<A-h>'] = { '<CMD>MoveHChar(-1)<CR>', 'Move left' },
  ['<A-l>'] = { '<CMD>MoveHChar(1)<CR>', 'Move right' },
})
wk.register({ -- visual mode mappings
  ['<A-j>'] = { ":MoveBlock(1)<CR>", 'Move down' },
  ['<A-k>'] = { ":MoveBlock(-1)<CR>", 'Move up' },
  ['<A-h>'] = { ":MoveHBlock(-1)<CR>", 'Move left' },
  ['<A-l>'] = { ":MoveHBlock(1)<CR>", 'Move right' },
}, { mode = 'v' })
wk.register({ -- insert mode mappings
  ['<C-z>'] = { "<c-g>u<Esc>[s1z=`]a<c-g>u", "Correct last error" },
  ['<C-l>'] = { "<Right>", "Move right" },
}, { mode = 'i' })
wk.register({ -- terminal mode mappings
  ['<ESC>'] = { "<C-\\><C-n>", "Exit terminal mode" },
  ['<leader><ESC>'] = { "<ESC>", "Send <ESC> to terminal" },
}, { mode = 't' })


require('gitsigns').setup({
  on_attach = function(bufnr)
    local function map(mode, lhs, rhs, gs_opts)
      gs_opts = vim.tbl_extend('force', { noremap = true, silent = true }, gs_opts or {})
      vim.api.nvim_buf_set_keymap(bufnr, mode, lhs, rhs, gs_opts)
    end

    wk.register({ -- Navigation
      [']c'] = { "&diff ? ']c' : '<cmd>Gitsigns next_hunk<CR>'", "Next change" },
      ['[c'] = { "&diff ? '[c' : '<cmd>Gitsigns prev_hunk<CR>'", "Prev change" },
    }, { expr = true })

    wk.register({ -- Actions
      ["<leader>h"] = {
        name = "Hunk",
        ["s"] = { "<cmd>Gitsigns stage_hunk<CR>", "Hunk Stage" },
        ["S"] = { "<cmd>Gitsigns stage_buffer<CR>", "Stage buffer" },
        ["r"] = { "<cmd>Gitsigns reset_hunk<CR>", "Hunk Reset" },
        ["R"] = { "<cmd>Gitsigns reset_buffer<CR>", "Reset buffer" },
        ["u"] = { '<cmd>Gitsigns undo_stage_hunk<CR>', "Hunk Undo" },
        ["p"] = { '<cmd>Gitsigns preview_hunk<CR>', "Hunk Preview" },
        ["b"] = { '<cmd>lua require"gitsigns".blame_line{full=true}<CR>', "Hunk Blame" },
        ["d"] = { '<cmd>Gitsigns diffthis<CR>', "Hunk Diff" },
        ["D"] = { '<cmd>lua require"gitsigns".diffthis("~")<CR>', "Hunk Diff" },
      },
      ["<leader>t"] = {
        name = "toggle",
        ["b"] = { '<cmd>Gitsigns toggle_current_line_blame<CR>', "Toggle Blame" },
        ["d"] = { '<cmd>Gitsigns toggle_deleted<CR>', "Toggle Delete" },
      }
    })
    wk.register({
      ["<leader>h"] = {
        name = "Hunk",
        ["s"] = { ':Gitsigns stage_hunk<CR>', "Hunk Stage" },
      }
    }, { mode = 'v' })

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
wk.register({
  ["<leader>s"] = {
    name = "Send",
    ["s"] = { "<CMD>lua require('iron.core').send_line()<CR>", "Send Line" },
    ["m"] = { "<CMD>lua require('iron.core').run_motion('send_motion')<CR>", "Send Motion" },
    ["f"] = { "<CMD>lua require('iron.core').send_file()<CR>", "Send File" },
    ["Q"] = { "<CMD>lua require('iron.core').close_repl()<CR>", "Quit" },
    ["c"] = { "<CMD>lua require('iron.core').send(nil, string.char(03))<CR>", "Interrupt" },
    ["l"] = { "<CMD>lua require('iron.core').send(nil, string.char(12))<CR>", "clar" },
  }
})
wk.register({
  ["<leader>s"] = { "<CMD>lua require('iron.core').visual_send()<CR>", "Send Visual" }
}, { mode = 'v' })
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
