local lsp = vim.lsp

-- utility functions: override/extend builtin
local function preview_location_handler(_, _, result)
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end
  lsp.util.preview_location(result[1], { border = 'rounded' })
end

function PeekDefinition()
  local params = lsp.util.make_position_params()
  return lsp.buf_request(0, 'textDocument/definition', params, preview_location_handler)
end

lsp.handlers['textDocument/hover'] = lsp.with(lsp.handlers.hover, { border = 'rounded' })
lsp.handlers['textDocument/signatureHelp'] = lsp.with(lsp.handlers.hover, { border = 'rounded' })

-- autocompletion with snippet support
local function compl_attach(client, bufnr, fuzzy)
  --require('lsp_compl').attach(client, bufnr, { trigger_on_delete = true, server_side_fuzzy_completion = fuzzy })
end

local capabilities = lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- register texlab server
local function texlab_attach(client, bufnr)
  lsp.protocol.SymbolKind = {
    'file',
    'sec',
    'fold',
    '',
    'class',
    'float',
    'lib',
    'field',
    'label',
    'enum',
    'misc',
    'cmd',
    'thm',
    'equ',
    'strg',
    'arg',
    '',
    '',
    'PhD',
    '',
    '',
    'item',
    'book',
    'artl',
    'part',
    'coll',
  }
  lsp.protocol.CompletionItemKind = {
    'string',
    '',
    '',
    '',
    'field',
    '',
    'class',
    'misc',
    '',
    'library',
    'thesis',
    'argument',
    '',
    '',
    'snippet',
    'color',
    'file',
    '',
    'folder',
    '',
    '',
    'book',
    'article',
    'part',
    'collect',
  }
  compl_attach(client, bufnr, true)
end

require('lspconfig').texlab.setup {
  cmd = { vim.fn.stdpath 'data' .. '/lspconfig/texlab' },
  flags = { debounce_text_changes = 100 },
  settings = {
    texlab = {
      diagnosticsDelay = 100,
      latexFormatter = 'texlab',
      formatterLineLength = 0,
      forwardSearch = {
        executable = '/Applications/Skim.app/Contents/SharedSupport/displayline',
        args = { '-g', '%l', '%p', '%f' },
      },
    },
  },
  capabilities = capabilities,
  on_attach = texlab_attach,
}


local map = vim.api.nvim_set_keymap
local function lua(string)
  return ('<cmd>lua ' .. string .. '<cr>')
end

-- packer
map('n', '<leader>pu', '<cmd>PackerSync<cr>', { noremap = true })

-- snippets
map('i', '<tab>', lua 'return snippets.expand_or_advance()', { noremap = true })
map('i', '<s-tab>', lua 'return snippets.advance_snippet(-1)', { noremap = true })

-- telescope
map('n', '<c-e>', lua 'finder.fd()', { noremap = true })
map('n', '<c-g>', lua 'finder.rg()', { noremap = true })
map('n', '<c-b>', lua 'finder.buffers()', { noremap = true })
map('n', '<c-f>', lua 'finder.files()', { noremap = true })
map('n', '<c-h>', lua 'finder.mru()', { noremap = true })
map('n', '<leader>ec', lua "finder.fd{ cwd = vim.fn.stdpath('config') }", { noremap = true })
map('c', '<c-r>', '<Plug>(TelescopeFuzzyCommandSearch)', { noremap = true })

-- lsp
map('n', 'K', lua 'vim.lsp.buf.hover()', { noremap = true })
map('n', '<c-t>', lua 'finder.lsp_workspace_symbols()', { noremap = true })
map('n', '<leader>sd', lua 'vim.lsp.buf.definition()', { noremap = true })
map('n', '<leader>sr', lua 'finder.lsp_references()', { noremap = true })
map('n', '<leader>sn', lua 'vim.lsp.buf.rename()', { noremap = true })
map('n', '<leader>ss', lua 'finder.lsp_document_symbols()', { noremap = true })
map('n', '<leader>sf', lua 'vim.lsp.buf.formatting()', { noremap = true })
map('n', '<leader>sp', lua 'PeekDefinition()', { noremap = true })
map('n', '<leader>dn', lua 'vim.lsp.diagnostic.goto_next()', { noremap = true })
map('n', '<leader>dp', lua 'vim.lsp.diagnostic.goto_previous()', { noremap = true })
map('n', '<leader>dl', lua 'finder.lsp_diagnostics()', { noremap = true })
