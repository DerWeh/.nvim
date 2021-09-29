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
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end
  require "lsp_signature".on_attach() 

  -- Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=false }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  -- buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<LocalLeader>r', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  -- buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap('n', '<LocalLeader>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)

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
