-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

vim.keymap.set("n", "<F12>", function()
  require("mini.comment").toggle_lines(vim.fn.line("."), vim.fn.line("."))
end, { desc = "Toggle line comment" })
vim.keymap.set("i", "<F12>", function()
  vim.cmd("stopinsert")
  require("mini.comment").toggle_lines(vim.fn.line("."), vim.fn.line("."))
  vim.schedule(function()
    vim.cmd("startinsert")
  end)
end, { desc = "Toggle line comment (insert mode)" })
