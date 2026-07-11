vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.expandtab = true
vim.o.smartindent = true
vim.o.winborder = "rounded"
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.incsearch = true
vim.o.swapfile = false

vim.g.mapleader = " "
local map = vim.keymap.set
map('n', '<leader>sf', ':update<CR> :source<CR>')
map('n', '<leader>w', ':write<CR>')
map('n', '<leader>q', ':quit<CR>')
map({'n', 'v', 'x'}, '<leader>y', '"+y<CR>')
map({'n', 'v', 'x'}, '<leader>d', '"+d<CR>')
map('n', 'wd', vim.diagnostic.open_float)

vim.pack.add({
    { src = "https://github.com/ellisonleao/gruvbox.nvim" },
    { src = "https://github.com/stevearc/oil.nvim" },
    { src = "https://github.com/nvim-mini/mini.pick" },
    { src = "https://github.com/neovim/nvim-lspconfig" },
    { src = "https://github.com/mason-org/mason.nvim" },
    { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
    { src = "https://github.com/romus204/tree-sitter-manager.nvim" }
})

require("gruvbox").setup()
vim.cmd.colorscheme("gruvbox")
vim.cmd(":hi signcolumn guibg=NONE")
vim.cmd(":hi statusline guibg=NONE")

require("mini.pick").setup()
map('n', '<leader>f', ":Pick files<CR>")
map('n', '<leader>h', ":Pick help<CR>")

require("oil").setup()
map('n', '<leader>e', ":Oil<CR>")


vim.lsp.enable({"lua_ls", "slang-server"})
map('n', '<leader>lf', vim.lsp.buf.format)
vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev)
            local client = vim.lsp.get_client_by_id(ev.data.client_id)
            if client == nil then
               print("client is nil")
               return
            end
            if client:supports_method('textDocument/completion') then
                vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
            end
    end,
})
vim.cmd('set completeopt+=noselect')

require("mason").setup()
require("mason-lspconfig").setup()

require("tree-sitter-manager").setup({
  auto_install = true,
  -- Use built-in Neovim treesitter parsers
  noauto_install = {
    "c", "lua", "markdown", "markdown_inline", "query", "vim", "vimdoc"
  },
})

