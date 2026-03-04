local opts = { noremap = true, silent = true }

-- Открыть/закрыть дерево nvim-tree
vim.api.nvim_set_keymap('n', '<leader>t', ':NvimTreeToggle<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>е', ':NvimTreeToggle<CR>', opts)

-- Взаимодействие с Telescope
vim.api.nvim_set_keymap('n', '<leader>ff', ':Telescope find_files<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fg', ':Telescope live_grep<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fb', ':Telescope buffers<CR>', opts)
vim.api.nvim_set_keymap('n', '<leader>fh', ':Telescope help_tags<CR>', opts)

-- Биндинги для комбинаций с Ctrl
-- Ctrl+в → Ctrl+d
vim.api.nvim_set_keymap('n', '<C-в>', '<C-d>', opts)
-- Ctrl+г → Ctrl+u
vim.api.nvim_set_keymap('n', '<C-г>', '<C-u>', opts)
