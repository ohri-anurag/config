local Plug = vim.fn["plug#"]

vim.call("plug#begin")

-- Lualine
Plug("nvim-lualine/lualine.nvim")

-- Edge colorscheme plugin
Plug("sainnhe/edge")

-- Moonfly colorscheme plugin
Plug("bluz71/vim-moonfly-colors", { as = "moonfly" })

-- Tokyonight colorscheme plugin
Plug("folke/tokyonight.nvim")

-- PaperColor colorscheme plugin
Plug("NLKNguyen/papercolor-theme")
Plug("EdenEast/nightfox.nvim")
-- Oxocarbon colorscheme plugin
Plug("nyoom-engineering/oxocarbon.nvim")

-- ICONS for telescope
Plug("nvim-tree/nvim-web-devicons")

-- TELESCOPE SETUP
Plug("nvim-lua/plenary.nvim")
Plug("nvim-telescope/telescope.nvim", { tag = "0.1.8" })
Plug("nvim-telescope/telescope-fzf-native.nvim", { ["do"] = "make" })

-- FZF LUA SETUP
Plug("ibhagwan/fzf-lua")

-- TREE SITTER SETUP
Plug("nvim-treesitter/nvim-treesitter", { ["do"] = ":TSUpdate" })

-- Autocomplete setup
Plug("vim-scripts/L9")
Plug("othree/vim-autocomplpop")

-- Bracket Pairs
Plug("jiangmiao/auto-pairs")

-- Indent Guides
Plug("lukas-reineke/indent-blankline.nvim")

-- Yanky
Plug("gbprod/yanky.nvim")

-- Co-pilot
Plug("github/copilot.vim")

-- Code Companion
Plug("olimorris/codecompanion.nvim")

-- Vim Yazi plugin
Plug("mikavilpas/yazi.nvim")

-- TODO Comments
Plug("folke/todo-comments.nvim")

-- ALE
Plug("dense-analysis/ale")

-- gh.nvim
Plug("ldelossa/litee.nvim")
Plug("ldelossa/gh.nvim")

vim.call("plug#end")

-- gh.nvim setup
require("litee.lib").setup()
require("litee.gh").setup()

-- ALE Setup
vim.g.ale_linters = { elm = { "elm_ls" } }
vim.g.ale_linters_explicit = 1

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

-- Lualine setup
require("lualine").setup({
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { { "searchcount", maxcount = 999999 }, "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { { "filename", path = 1 } },
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
})

-- nvim-web-devicons
require("nvim-web-devicons").setup({
  color_icons = true,
  default = true,
  strict = true,
})

-- Setup the colorscheme
-- vim.cmd("colorscheme moonfly")
vim.cmd("colorscheme carbonfox")

-- Setup indent guides
require("ibl").setup()

-- TODO Comments setup
require("todo-comments").setup()

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
vim.o.ignorecase = false

-- ...unless the search phrase contains a capital.
vim.o.smartcase = false

-- To enable syntax based closing/folding of code
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevelstart = 99

-- To see the cursor more clearly
vim.o.cursorline = true
vim.o.cursorcolumn = true

-- Yanky keybindings
require("yanky").setup({ highlight = { timer = 200 } })
vim.keymap.set({ "n", "x" }, "p", "<Plug>(YankyPutAfter)")

vim.keymap.set("n", "<c-p>", "<Plug>(YankyPreviousEntry)")
vim.keymap.set("n", "<c-n>", "<Plug>(YankyNextEntry)")

-- TELESCOPE SETUP
require("telescope").setup({
  defaults = {
    mappings = {
      i = {
        ["<Esc>"] = require("telescope.actions").close,
      },
    },
  },
})
local builtin = require("telescope.builtin")
require("telescope").load_extension("yank_history")

vim.keymap.set("n", "<leader>fp", require("telescope").extensions.yank_history.yank_history, {})

-- FZF-LUA Setup
local fzf = require("fzf-lua")
local actions = require("fzf-lua").actions
fzf.setup({
  "telescope",
  fzf_opts = { ["--cycle"] = "" },
  grep = { RIPGREP_CONFIG_PATH = vim.env.RIPGREP_CONFIG_PATH },
  buffers = {
    actions = {
      ["ctrl-d"] = false,
    },
    keymap = {
      builtin = {
        ["<C-d>"] = "preview-page-down",
        ["<C-u>"] = "preview-page-up",
      },
    },
  },
})
vim.keymap.set("n", "<leader>fg", fzf.grep_cword, {})
vim.keymap.set("n", "<leader>lg", fzf.live_grep, {})
vim.keymap.set("n", "<leader>ft", fzf.tags_grep_cword, {})
vim.keymap.set("n", "<leader>lt", fzf.tags, {})
vim.keymap.set("n", "<leader>ff", fzf.files, {})
vim.keymap.set("n", "<leader>fb", fzf.buffers, {})
vim.keymap.set("n", "<leader>c", fzf.git_commits, {})

-- Yazi keybinging
vim.keymap.set("n", "<leader>cw", "<cmd>Yazi cwd<cr>", {})

-- Setup keybindings for copying current filepath relative to VIM's cwd
vim.api.nvim_set_keymap("n", "<F2>", ':let @" = expand("%")<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<F3>", ':let @+ = expand("%")<CR>', { noremap = true, silent = true })

-- Code Companion setup
require("codecompanion").setup({
  strategies = {
    chat = {
      adapter = "openai",
    },
    inline = {
      adapter = "openai",
    },
  },
})
vim.keymap.set({ "n", "v" }, "<leader>a", "<cmd>CodeCompanionChat Toggle<cr>", { noremap = true, silent = true })
vim.keymap.set("v", "ga", "<cmd>CodeCompanionChat Add<cr>", { noremap = true, silent = true })

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])

local function reload_current_file()
  -- Save the current cursor position
  local cursor_pos = vim.api.nvim_win_get_cursor(0)

  -- Save the current viewport (scroll position)
  local view = vim.fn.winsaveview()

  -- Reload the current file from disk
  vim.cmd("edit!")

  -- Get the total number of lines
  local num_lines = vim.fn.line("$")

  if cursor_pos[1] > num_lines then
    cursor_pos[1] = num_lines
  end

  -- Restore the cursor position
  vim.api.nvim_win_set_cursor(0, cursor_pos)

  -- Restore the viewport (scroll position)
  vim.fn.winrestview(view)
end

function create_format_on_save(file_regex, gen_command)
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

-- Source a local .nvimrc.lua file if it is present
if vim.fn.filereadable(".nvimrc.lua") == 1 then
  vim.cmd("source .nvimrc.lua")
end

-- Vim Window navigation keybindings
vim.keymap.set("n", "<C-h>", "<Cmd>wincmd h<CR>")
vim.keymap.set("n", "<C-j>", "<Cmd>wincmd j<CR>")
vim.keymap.set("n", "<C-k>", "<Cmd>wincmd k<CR>")
vim.keymap.set("n", "<C-l>", "<Cmd>wincmd l<CR>")

-- Keybinding for clearing the search highlight
vim.keymap.set("n", "<leader>;", "<Cmd>nohlsearch<CR>")

-- Keybinding to select till the end of line
vim.keymap.set("n", "<S-v>", "v$h")

-- Keybinding to select entire line
vim.keymap.set("n", "vv", "<S-v>")

-- Keybinding for ALE to go to definition
vim.keymap.set("n", "<F12>", "<Cmd>ALEGoToDefinition<CR>")
