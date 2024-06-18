local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local previewers = require("telescope.previewers")
local putils = require("telescope.previewers.utils")

local write_lines = function(bufnr, begin, lines)
  vim.api.nvim_buf_set_lines(bufnr, begin, -1, true, lines)
  return begin + #lines
end

local write_docs = function(bufnr, begin, docs)
  local ctr = begin
  ctr = write_lines(bufnr, ctr, { "{- Documentation:" })
  ctr = write_lines(bufnr, ctr, docs)
  ctr = write_lines(bufnr, ctr, { "-}" })
  return ctr
end

local function open_browser(url)
  local browser_cmd
  if vim.fn.has("unix") == 1 then
    if vim.fn.executable("sensible-browser") == 1 then
      browser_cmd = "sensible-browser"
    else
      browser_cmd = "xdg-open"
    end
  end
  if vim.fn.has("mac") == 1 then
    browser_cmd = "open"
  end
  vim.cmd(":silent !" .. browser_cmd .. " " .. vim.fn.fnameescape(url))
end

local show_preview = function(self, entry, status)
  local lines
  local item = entry.value
  local docs = vim.split(item.docs, "\n")
  local counter
  local bufnr = self.state.bufnr
  if item.type == "package" then
    counter = write_lines(bufnr, 0, { item.item, "" })
    counter = write_docs(bufnr, counter, docs)
  elseif item.type == "module" then
    counter = write_lines(bufnr, 0, { "-- PACKAGE: " .. item.package.name, "", item.item .. " where", "" })
    counter = write_docs(bufnr, counter, docs)
  else
    counter =
      write_lines(bufnr, 0, { "-- PACKAGE: " .. item.package.name, "", "module " .. item.module.name .. " where", "" })
    counter = write_docs(bufnr, counter, docs)
    counter = write_lines(bufnr, counter, { "", item.item })
  end
  vim.api.nvim_set_option_value("wrap", true, { win = self.state.winid })
  vim.api.nvim_set_option_value("number", true, { win = self.state.winid })
  putils.highlighter(bufnr, "haskell")
end

local hoogle = function(opts)
  opts = opts or {}
  local function_name = opts.function_name or ""
  if function_name == "" then
    function_name = vim.fn.input("Hoogle search: ")
  end
  local on_exit = function(obj)
    local output = obj.stdout
    local items = vim.json.decode(output)
    vim.schedule(function()
      pickers
        .new(opts, {
          prompt_title = "Hoogle Search: " .. function_name,
          previewer = previewers.new_buffer_previewer({
            define_preview = show_preview,
          }),
          finder = finders.new_table({
            results = items,
            entry_maker = function(entry)
              return {
                value = entry,
                display = entry.module.name or entry.item,
                ordinal = entry.module.name or entry.item,
              }
            end,
          }),
          sorter = conf.generic_sorter(opts),
          attach_mappings = function(prompt_bufnr, map)
            actions.select_default:replace(function()
              actions.close(prompt_bufnr)
            end)
            map({ "i", "n" }, "<C-b>", function()
              local entry = action_state.get_selected_entry()
              open_browser(entry.value.url)
              actions.close(prompt_bufnr)
            end)
            return true
          end,
        })
        :find()
    end)
  end
  vim.system({ "hoogle", "search", "--json", function_name }, on_exit)
end

local function word_hoogle()
  local word = vim.fn.expand("<cword>")
  hoogle({ function_name = word })
end
vim.keymap.set("n", "<leader>fh", word_hoogle, {})
vim.keymap.set("n", "<leader>lh", hoogle, {})
