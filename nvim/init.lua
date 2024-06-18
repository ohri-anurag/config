local Plug = vim.fn["plug#"]

vim.call("plug#begin")

-- Edge colorscheme plugin
Plug("sainnhe/edge")

-- ICONS for telescope
Plug("nvim-tree/nvim-web-devicons")

-- TELESCOPE SETUP
Plug("nvim-lua/plenary.nvim")
Plug("nvim-telescope/telescope.nvim", { tag = "0.1.6" })
Plug("nvim-telescope/telescope-fzf-native.nvim", { ["do"] = "make" })

-- FZF LUA SETUP
Plug("ibhagwan/fzf-lua", { branch = "main" })

-- TREE SITTER SETUP
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })

-- Autocomplete setup
Plug("vim-scripts/AutoComplPop")

-- Bracket Pairs
Plug("jiangmiao/auto-pairs")

-- Indent Guides
Plug("lukas-reineke/indent-blankline.nvim")

vim.call("plug#end")

-- TREE SITTER SETUP
require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
})

-- nvim-web-devicons
require("nvim-web-devicons").setup({
  color_icons = true,
  default = true,
  strict = true,
})

-- Setup the colorscheme
vim.cmd("colorscheme edge")

-- Setup indent guides
require("ibl").setup()

-- Enable line numbers
vim.o.number = true

-- Enable the display of whitespace characters
vim.o.list = true

-- Customize the symbols for spaces, tabs, etc.
vim.o.listchars = "space:·,tab:→ ,eol:↲"

-- Set the leader key
vim.g.mapleader = " " -- Here, the spacebar is set as the leader key

-- The width of an actual tab character.
vim.o.tabstop = 2

-- Use value of 'tabstop' for all indenting operations.
vim.o.shiftwidth = vim.o.tabstop

-- Disable combining tabs and spaces to achieve an indent.
vim.o.softtabstop = 0

-- Indenting, unindenting, and pressing tab in insert-mode all use spaces
-- instead of tabs.
vim.o.expandtab = true

-- Beginning-of-line tab (backspace) behaves like indent (unindent).
vim.o.smarttab = true

-- Round indent to nearest shiftwidth multiple.
vim.o.shiftround = true

-- Case-insensitive search.
vim.o.ignorecase = true

-- ...unless the search phrase contains a capital.
vim.o.smartcase = true

-- Highlight text when yanked.
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- TELESCOPE SETUP
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<leader>fg", builtin.grep_string, {})
vim.keymap.set("n", "<leader>lg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fb", builtin.buffers, {})

-- FZF-LUA Setup
local fzf = require("fzf-lua")
fzf.setup({ "telescope" })
vim.keymap.set("n", "<leader>ft", fzf.tags_grep_cword, {})
vim.keymap.set("n", "<leader>lt", fzf.tags, {})

local function reload_current_file()
  -- Save the current cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  -- Save the current viewport (scroll position)
  local view = vim.fn.winsaveview()

  -- Reload the current file from disk
  vim.cmd("edit!")

  -- Restore the cursor position
  vim.api.nvim_win_set_cursor(0, cursor_pos)

  -- Restore the viewport (scroll position)
  vim.fn.winrestview(view)
end

local function create_format_on_save(file_regex, gen_command)
  vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = file_regex,
    callback = function(args)
      vim.system(gen_command(args.file), function(event)
        vim.schedule(function()
          reload_current_file()
        end)
      end)
    end,
  })
end

create_format_on_save("*.cabal", function(file)
  return { "cabal-fmt", "--inplace", file }
end)

create_format_on_save("*.hs", function(file)
  return { "ormolu", "-i", file }
end)

create_format_on_save("*.dhall", function(file)
  return { "dhall", "--unicode", "format", file }
end)

create_format_on_save("*.lua", function(file)
  return { "stylua", "--indent-type", "Spaces", "--indent-width", "2", file }
end)

-- Comment settings for Dhall
vim.api.nvim_exec(
  [[
    autocmd FileType dhall setlocal commentstring=--\ %s
]],
  false
)
