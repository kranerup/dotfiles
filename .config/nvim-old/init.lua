vim.autochdir = true
vim.g.lisp_rainbow = 1
vim.g.paredit_mode = 0
vim.g.slimv_clhs_root = "file:/usr/share/doc/hyperspec/Body/"
vim.g.slimv_browser_cmd = "tmux new-window w3m"
vim.g.slimv_lisp = 'ros run'
vim.g.slimv_impl = 'sbcl'
vim.opt.clipboard:append("unnamedplus")


-- Bootstrap lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- This has to be set before initializing lazy
if vim.g.lessmode then
  vim.g.mapleader = ","
else
  vim.g.mapleader = " "
end


-- Initialize lazy with dynamic loading of anything in the plugins directory
require("lazy").setup("plugins", {
   change_detection = {
    enabled = true, -- automatically check for config file changes and reload the ui
    notify = false, -- turn off notifications whenever plugin changes are made
  },
})

require("cmp").setup.filetype("lisp", {
  enabled = false,
})

-- These modules are not loaded by lazy
require("core.options")
require("core.keymaps")


require('less-mode').setup()
