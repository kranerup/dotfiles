-- less-mode.lua: Emulate 'less' keybindings in Neovim
local M = {}

-- Store original keymaps to restore later
local saved_keymaps = {}
local is_active = false

-- Less keybindings
local less_maps = {
  -- Navigation
  { 'n', 'j', '<C-e>', 'Scroll down one line' },
  { 'n', 'k', '<C-y>', 'Scroll up one line' },
  { 'n', 'f', '<C-f>', 'Page down' },
  { 'n', 'b', '<C-b>', 'Page up' },
  { 'n', 'd', '<C-d>', 'Half page down' },
  { 'n', 'u', '<C-u>', 'Half page up' },
  { 'n', 'g', 'gg', 'Go to top' },
  { 'n', 'G', 'G', 'Go to bottom' },
  { 'n', '<Space>', '<C-f>', 'Page down' },
  
  -- Search
  { 'n', '/', '/', 'Search forward' },
  { 'n', '?', '?', 'Search backward' },
  { 'n', 'n', 'n', 'Next match' },
  { 'n', 'N', 'N', 'Previous match' },
  
  -- Quit
  { 'n', 'q', ':q<CR>', 'Quit nvim' },
  { 'n', 'Q', ':q!<CR>', 'Quit nvim (force)' },
}

function M.enable()
  if is_active then
    print("Less mode already active")
    return
  end
  
  -- Make buffer read-only
  vim.bo.modifiable = false
  vim.bo.readonly = true
  
  -- Apply less keybindings
  for _, map in ipairs(less_maps) do
    local mode, lhs, rhs, desc = map[1], map[2], map[3], map[4]
    vim.keymap.set(mode, lhs, rhs, { buffer = true, silent = true, desc = desc })
  end
  
  is_active = true
  print("Less mode enabled (press 'q' to exit)")
end

function M.disable()
  if not is_active then
    print("Less mode not active")
    return
  end
  
  -- Restore buffer settings
  vim.bo.modifiable = true
  vim.bo.readonly = false
  
  -- Remove keymaps
  for _, map in ipairs(less_maps) do
    pcall(vim.keymap.del, map[1], map[2], { buffer = true })
  end
  
  is_active = false
  print("Less mode disabled")
end

function M.toggle()
  if is_active then
    M.disable()
  else
    M.enable()
  end
end

-- Setup function to create commands
function M.setup()
  vim.api.nvim_create_user_command('LessMode', M.enable, {})
  vim.api.nvim_create_user_command('LessModeOn', M.enable, {})
  vim.api.nvim_create_user_command('LessModeOff', M.disable, {})
  vim.api.nvim_create_user_command('LessModeToggle', M.toggle, {})
  
  -- Auto-enable if started with +LessMode
  vim.api.nvim_create_autocmd('VimEnter', {
    callback = function()
      -- Check if +LessMode was passed
      for _, arg in ipairs(vim.fn.argv()) do
        if arg == '+LessMode' then
          vim.schedule(function()
            M.enable()
          end)
          break
        end
      end
    end
  })
end

return M
