vim.opt.rtp:prepend(vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h"))

vim.cmd.colorscheme('catppuccin')
local function set_transparent() -- set UI component to transparent
  local groups = {
    "Normal",
    "NormalNC",
    "EndOfBuffer",
    "NormalFloat",
    "FloatBorder",
    "SignColumn",
    "StatusLine",
    "StatusLineNC",
    "TabLine",
    "TabLineFill",
    "TabLineSel",
    "ColorColumn",
  }
  for _, g in ipairs(groups) do
    vim.api.nvim_set_hl(0, g, { bg = "none" })
  end
  vim.api.nvim_set_hl(0, "TabLineFill", { bg = "none", fg = "#767676" })
end

set_transparent()

require("vim._core.ui2").enable({})

require("options")
require("keymaps")
require("commands")
require("pack")
require("treesitter")
require("lsp")
require("statusline")

--vim.o.signcolumn = "yes:1"
--vim.o.confirm = true

--vim.cmd.packadd('nvim.undotree')
--vim.cmd.packadd('nvim.difftool')

--vim.pack.add({
--  'https://github.com/neovim/nvim-lspconfig',
--})


-- Highlight yanked text
local augroup = vim.api.nvim_create_augroup("UserConfig", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  callback = function()
    vim.highlight.on_yank()
  end,
})


-- return to last cursor position
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  desc = "Restore last cursor position",
  callback = function()
    if vim.o.diff then -- except in diff mode
      return
    end

    local last_pos = vim.api.nvim_buf_get_mark(0, '"') -- {line, col}
    local last_line = vim.api.nvim_buf_line_count(0)

    local row = last_pos[1]
    if row < 1 or row > last_line then
      return
    end

    pcall(vim.api.nvim_win_set_cursor, 0, last_pos)
  end,
})



-- Format on save (ONLY real file buffers, ONLY when efm is attached)
vim.api.nvim_create_autocmd("BufWritePre", {
  group = augroup,
  pattern = {
    "*.lua",
    "*.py",
    "*.go",
    "*.js",
    "*.jsx",
    "*.ts",
    "*.tsx",
    "*.json",
    "*.css",
    "*.scss",
    "*.html",
    "*.sh",
    "*.bash",
    "*.zsh",
    "*.c",
    "*.cpp",
    "*.h",
    "*.hpp",
  },
  callback = function(args)
    -- avoid formatting non-file buffers (helps prevent weird write prompts)
    if vim.bo[args.buf].buftype ~= "" then
      return
    end
    if not vim.bo[args.buf].modifiable then
      return
    end
    if vim.api.nvim_buf_get_name(args.buf) == "" then
      return
    end

    local has_efm = false
    for _, c in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
      if c.name == "efm" then
        has_efm = true
        break
      end
    end
    if not has_efm then
      return
    end

    pcall(vim.lsp.buf.format, {
      bufnr = args.buf,
      timeout_ms = 2000,
      filter = function(c)
        return c.name == "efm"
      end,
    })
  end,
})
