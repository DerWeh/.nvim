require('which-key').setup { }
require('nvim-autopairs').setup{}
require('telescope').setup {
    extensions = {
        media_files = {
            find_cmd = "rg"
        }
    }
}
require('telescope').load_extension('media_files')
require('todo-comments').setup({})
require('gitsigns').setup({})

require('feline').setup {
  -- preset = 'default',
  colors = {
    bg = '#DDDDDD',
    fg = '#2B2B2B',
    black     = '#33BBEE',
    skyblue   = '#33BBEE',
    cyan      = '#009090',
    green     = '#009988',
    oceanblue = '#5fafff',
    magenta   = '#C26BDB',
    orange    = '#FF9000',
    red       = '#CC3311',
    violet    = '#9E93E8',
    white     = '#E9E9E9',
    yellow    = '#DDAA33'
  }
}

-- setup auto-completion with coq
require("coq_3p") {
  { src = "nvimlua", short_name = "nLUA" },
  { src = "vimtex", short_name = "vTEX" },
  { src = "bc", short_name = "MATH", precision = 6 },
}
-- Setup lspconfig + coq
local lsp = require "lspconfig"
local coq = require "coq"

local on_attach = function(client, bufnr)
  require "lsp_signature".on_attach() 
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local wk = require("which-key")
  wk.register({
    -- ["gd"] = {"<CMD>lua vim.lsp.buf.declaration()<CR>", "Go Declaration"},
    ["gD"] = {"<CMD>lua vim.lsp.buf.definition()<CR>", "Go Defintion"},
    ["K"] = {"<CMD>lua vim.lsp.buf.hover()<CR>", "documentation"},
    -- ['gI'] = {'<CMD>lua vim.lsp.buf.implementation()<CR>', "Go Implementation"},
    ["<C-k>"] = {"<CMD>lua vim.lsp.buf.signature_help()<CR>", "Signature"},
    ["[d"] = {"<CMD>lua vim.lsp.diagnostic.goto_prev()<CR>", "prev Diagnostic"},
    ["]d"] = {"<CMD>lua vim.lsp.diagnostic.goto_next()<CR>", "next Diagnostic"},
    ["<LocalLeader>"] = {
      name = "Language",
      ["n"] = {"<CMD>Telescope lsp_references<CR>", "references"},
      ["s"] = {"<CMD>Telescope lsp_document_symbols<CR>", "Symbols"},
      ["r"] = {"<CMD>lua vim.lsp.buf.rename()<CR>", "Rename"},
      ["f"] = {
        name = 'File',
        ["f"] = {"<CMD>lua vim.lsp.buf.formatting()<CR>", "Format"},
      },
      ["D"] = {"<CMD>lua vim.lsp.buf.type_definition()<CR>", "go type Defintion"},
      ["w"] = {
        name = "Workspace",
        ["a"] = {"<CMD>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add folder"},
        ["r"] = {"<CMD>lua vim.lsp.buf.remove_workspace_folder()<CR>", "Remove folder"},
        ["l"] = {"<CMD>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", "List folder"},
      },
      ["ca"] = {"<CMD>lua vim.lsp.buf.code_action()<CR>", "Code Action"},
      ["e"] = {"<CMD>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", "show diagnostics"},
    },
  }, {silent = false, buffer = bufnr})
  wk.register({
    ["<LocalLeader>"] = {
      name = "Language",
      ["f"] = {"<CMD>'<,'>lua vim.lsp.buf.range_formatting()<CR>", "Format"},
    },
  }, {mode = "v", silent = false, buffer = bufnr})
end

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { 'pylsp' }
for _, server in ipairs(servers) do
  lsp[server].setup {
    coq.lsp_ensure_capabilities(vim.lsp.protocol.make_client_capabilities()),
    -- capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end
