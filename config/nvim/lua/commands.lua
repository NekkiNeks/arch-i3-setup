--  Выйти из vim целиком, из редактора и из дерева по команде :qa!
vim.api.nvim_create_user_command("Q", function()
    vim.cmd("qa!") -- quit all
end, {})
