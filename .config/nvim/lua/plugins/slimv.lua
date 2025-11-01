return {
  'kovisoft/slimv',
  event = 'VeryLazy',
  ft = { 'lisp' },
  config = function()
    vim.g.lisp_rainbow = 1
    vim.g.paredit_mode = 0
    vim.g.slimv_repl_split = 4
  end
}
