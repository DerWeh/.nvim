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


-- BEGIN: set up packer outomatically
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path })
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- regular configuration
require('packer').startup(function(use)
  use 'wbthomason/packer.nvim'

  -- Looks
  use({ "lukas-reineke/indent-blankline.nvim", tag = "*" })

  -- Mappings
  use({
    "kylechui/nvim-surround",
    tag = "*", -- Use for stability; omit to use `main` branch for the latest features
    config = function()
      require("nvim-surround").setup({})
    end
  })
  use({
    'numToStr/Comment.nvim',
    tag = "*",
    config = function()
      require('Comment').setup()
    end
  })
  use 'fedepujol/move.nvim'
  use({
    "folke/which-key.nvim",
    config = function()
      require("which-key").setup({})
    end
  })

  -- Language server
  use({
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    { "neovim/nvim-lspconfig", tag = "*" },
    config = function()
      require("mason").setup({})
      require("mason-lspconfig").setup({})
    end,
  })

  -- Git support
  use({
    'lewis6991/gitsigns.nvim',
    tag = "*",
    -- config = function()
    --   require('gitsigns').setup()
    -- end
  })

  use({
    'nvim-telescope/telescope.nvim',
    tag = '*',
    requires = { { 'nvim-lua/plenary.nvim' } }
  })

  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require('packer').sync()
  end
end)
-- END: packer


-- language server configuration
require("mason").setup()
require("mason-lspconfig").setup({})

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
      ["d"] = { "<CMD>Telescope lsp_document_diagnostics<CR>", "Diagnostic" },
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
    print('Starting language server', server)
    if server == "sumneko_lua" then
      lspconfig[server].setup({ on_attach = on_attach, settings = { Lua = { diagnostics = { globals = { 'vim' } } } } })
    else
      lspconfig[server].setup({ on_attach = on_attach })
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
