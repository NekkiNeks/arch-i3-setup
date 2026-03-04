--  из nvim
vim.api.nvim_create_user_command("Q", function()
  vim.cmd("qa!")  -- quit all
end, {})

vim.api.nvim_create_autocmd({ "InsertLeave", "BufLeave", "FocusLost" }, {
  pattern = "*",
  callback = function()
    if vim.bo.modified and vim.bo.filetype ~= "NvimTree" then
      vim.cmd("silent! write")
    end
  end,
})
