-- Save this as: ~/.config/nvim/lua/plugins/less-mode.lua

return {
  name = "less-mode",
  dir = vim.fn.stdpath("config") .. "/lua/less-mode",
  config = function()
    require('less-mode').setup()
  end,
  -- Load on command
  cmd = { "LessMode", "LessModeOn", "LessModeOff", "LessModeToggle" },
  -- Or load immediately if you want +LessMode flag to work
  lazy = false,
}
