vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = 'yes'
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.winborder = 'rounded'
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.incsearch = true
vim.o.swapfile = false
vim.o.laststatus = 3 -- Global statusline

vim.api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
    pattern = {'*.sv', '*svh'}, callback = function()
        vim.bo.tabstop = 2
        vim.bo.shiftwidth = 2
    end,
})

vim.g.mapleader = ' '
local map = vim.keymap.set
map('n', '<leader>sf', ':update<CR> :source<CR>')
map('n', '<leader>w', ':write<CR>')
map('n', '<leader>q', ':quit<CR>')
map({'n', 'v', 'x'}, '<leader>y', '"+y<CR>')
map({'n', 'v', 'x'}, '<leader>d', '"+d<CR>')
map('n', '<leader>wd', vim.diagnostic.open_float)

vim.api.nvim_create_autocmd('FileType', {
    pattern = 'systemverilog',
    callback = function()
        map('i', "'", "'", { buffer = true })
    end,
})

vim.pack.add({
    { src = 'https://github.com/ellisonleao/gruvbox.nvim' },
    { src = 'https://github.com/mitander/flume.nvim' },
    { src = 'https://github.com/webhooked/kanso.nvim'},
    {
        src = 'https://github.com/nvim-mini/mini.icons',
        version = 'stable',
    },
    { src = 'https://github.com/nvim-mini/mini.statusline' },
    { src = 'https://github.com/stevearc/oil.nvim' },
    { src = 'https://github.com/nvim-mini/mini.pairs' },
    { src = 'https://github.com/nvim-mini/mini.pick' },
    { src = 'https://github.com/neovim/nvim-lspconfig' },
    { src = 'https://github.com/mason-org/mason.nvim' },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim' },
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter',
        version = 'main',
    },
    {
        src = 'https://github.com/saghen/blink.cmp',
        version = 'v1',
    },
    { src = 'https://github.com/obsidian-nvim/obsidian.nvim' },
    { src = 'https://github.com/nvim-orgmode/orgmode' },
})

require('gruvbox').setup()
vim.cmd.colorscheme('gruvbox')
--require('flume').setup()
--vim.cmd.colorscheme('flume')
--require('kanso').setup()
--vim.cmd.colorscheme('kanso')
--require('kanso').load('zen')
vim.cmd(':hi signcolumn guibg=NONE')
--vim.cmd(':hi WinSeparator guibg=NONE')

local status, _ = pcall(require, 'mini.statusline')
if not status then
    vim.cmd(':hi statusline guibg=NONE')
end

require('mini.icons').setup()
require('mini.statusline').setup()

require('mini.pairs').setup()

require('mini.pick').setup()
map('n', '<leader>f', ':Pick files<CR>')
map('n', '<leader>h', ':Pick help<CR>')

require('oil').setup()
map('n', '<leader>e', ':Oil<CR>')

vim.lsp.enable({'lua_ls', 'slang-server', 'clangd', 'rust-analyzer', 'texlab'})
map('n', '<leader>lf', vim.lsp.buf.format)
--vim.api.nvim_create_autocmd('LspAttach', {
    --callback = function(ev)
            --local client = vim.lsp.get_client_by_id(ev.data.client_id)
            --if client == nil then
               --print('client is nil')
               --return
            --end
            --if client:supports_method('textDocument/completion') then
                --vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
            --end
    --end,
--})
--vim.cmd('set completeopt+=noselect')

require('mason').setup()
require('mason-lspconfig').setup()

require('nvim-treesitter').install({
    'c', 'cpp', 'cmake', 'bash', 'systemverilog', 'vhdl', 'rust', 'yaml', 'markdown'
})
vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(event)
        if event.data.kind == 'update' and event.data.spec.name == 'nvim-treesitter' then
            vim.schedule(function()
                vim.notify('Updating treesitter parsers and queries.')
                vim.cmd('TSUpdate')
            end)
        end
    end,
})

require('blink.cmp').setup({
    completion = {
      menu = {
        draw = {
          components = {
            kind_icon = {
              text = function(ctx)
                local kind_icon, _, _ = require('mini.icons').get('lsp', ctx.kind)
                return kind_icon
              end,
              -- (optional) use highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end,
            },
            kind = {
              -- (optional) use highlights from mini.icons
              highlight = function(ctx)
                local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
                return hl
              end,
            }
          }
        }
      },
    list = {
        selection = {
            preselect = false
        }
    }
    },
    keymap = {
        ['<CR>'] = { 'accept', 'fallback' },
    },
})

require('obsidian').setup({
    legacy_commands = false,
    picker = {
        name = 'mini.pick'
    },
    workspaces = {
        {
            name = 'Embedded',
            path = '~/Data/personal/knowledge-base/Embedded/'
        },
    }
})

require('orgmode').setup({
    org_agenda_files = '~/orgfiles/**/*',
    org_default_notes_file = '~/orgfiles/refile.org',
})
vim.lsp.enable('org')

