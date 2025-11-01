return {
    "linrongbin16/gentags.nvim",
    config = function()
      require('gentags').setup({
      --debug = {
      --  enable = true,
      --  file_log = true
      --}
    })
    end,
}

