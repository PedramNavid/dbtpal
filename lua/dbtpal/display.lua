local M = {}

local function popup(title, data, opts)
  local name = "dbtpalConsole"
  local cur = vim.fn.bufnr(name)

  if cur and cur ~= -1 then vim.api.nvim_buf_delete(cur, { force = true }) end

  local columns = vim.o.columns
  local lines = vim.o.lines
  local width = math.ceil(columns * 0.8)
  local height = math.ceil(lines * 0.8 - 4)
  local left = math.ceil((columns - width) * 0.5)
  local top = math.ceil((lines - height) * 0.5 - 1)

  -- TODO: merge this table with config
  local win_opts = vim.tbl_deep_extend("force", {
    relative = "editor",
    style = "minimal",
    border = "double",
    width = width,
    height = height,
    col = left,
    row = top,
    title = title or "Job Results",
  }, opts or {})

  local buf = vim.api.nvim_create_buf(false, true)
  local win = vim.api.nvim_open_win(buf, true, win_opts)
  vim.api.nvim_buf_set_name(buf, name)
  local chan = vim.api.nvim_open_term(buf, {})

  local push = function(line) vim.api.nvim_chan_send(chan, line) end

  for _, line in ipairs(data) do
    push(string.format("> %s\r\n", line))
  end

  push "\r\n ---- Press q to quit ----- \r\n"
  vim.api.nvim_buf_set_keymap(buf, "n", "q", ":q<CR>", {})

  return win, buf
end

M.popup = popup
return M
