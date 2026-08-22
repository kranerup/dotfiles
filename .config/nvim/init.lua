-- Prerequisites:
-- sudo apt install npm
-- npm config set prefix ~/.npm-global
-- mkdir -p ~/.npm-global
-- npm install -g tree-sitter-cli
-- echo "prefix=~/.npm-global" >> ~/.npmrc
-- export PATH="$HOME/.npm-global/bin:$PATH"
--
-- sudo apt install -y fzf
-- sudo apt install -y golang
-- sudo apt install -y python3.12-venv
--
-- pip install --user --break-system-packages pynvim
--
--
-- This has to be set before initializing any modules
--
if vim.g.lessmode then
  vim.g.mapleader = ","
else
  vim.g.mapleader = " "
end


vim.opt.termguicolors = true


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

-- ============================================================================
-- OPTIONS
-- ============================================================================

vim.opt.errorbells = false -- no error sounds
vim.opt.autochdir = true -- do autochange directories
vim.opt.clipboard:append("unnamedplus") -- use system clipboard

vim.opt.wrap = false -- do not wrap lines by default
vim.opt.tabstop = 2 -- tabwidth
vim.opt.shiftwidth = 2 -- indent width
vim.opt.softtabstop = 2 -- soft tab stop not tabs on tab/backspace
vim.opt.expandtab = true -- use spaces instead of tabs
vim.opt.smartindent = true -- smart auto-indent
vim.opt.autoindent = true -- copy indent from current line

vim.opt.ignorecase = true -- case insensitive search
vim.opt.smartcase = true -- case sensitive if uppercase in string
vim.opt.hlsearch = true -- highlight search matches
vim.opt.incsearch = true -- show matches as you type
-- ============================================================================
vim.api.nvim_create_autocmd('ColorScheme', {
  group = vim.api.nvim_create_augroup('my_hl_overrides', { clear = true }),
  callback = function()
    vim.api.nvim_set_hl(0, 'Search',       { fg = '#ffffff', bg = '#9c4464' })
    vim.api.nvim_set_hl(0, 'Comment',      { fg = '#FF5D62', italic = true })
    vim.api.nvim_set_hl(0, 'MatchParen',   { fg = '#FF5D62', bg = '#545454', bold = true })
    vim.api.nvim_set_hl(0, 'WinSeparator', { fg = '#808080', bg = '#303030' })
  end,
})

vim.pack.add({"https://github.com/rebelot/kanagawa.nvim"})
require("kanagawa").setup({
    -- Replace this with your scheme-specific settings or remove to use the defaults
    -- transparent = true,
    background = {
        -- light = "lotus",
        dark = "wave", -- "wave, dragon"
    },
    colors = {
        palette = {
            -- Background colors
            sumiInk0 = "#161616", -- modified
            sumiInk1 = "#181818", -- modified
            sumiInk2 = "#1a1a1a", -- modified
            sumiInk3 = "#000000", -- #1F1F1F", -- modified
            sumiInk4 = "#2A2A2A", -- modified
            sumiInk5 = "#363636", -- modified
            sumiInk6 = "#545454", -- modified

            -- Popup and Floats
            waveBlue1 = "#322C47", -- modified
            waveBlue2 = "#4c4464", -- modified

            -- Diff and Git
            winterGreen = "#2B3328",
            winterYellow = "#49443C",
            winterRed = "#43242B",
            winterBlue = "#252535",
            autumnGreen = "#76A56A", -- modified
            autumnRed = "#C34043",
            autumnYellow = "#DCA561",

            -- Diag
            samuraiRed = "#E82424",
            roninYellow = "#FF9E3B",
            waveAqua1 = "#7E9CD8", -- modified
            dragonBlue = "#7FB4CA", -- modified

            -- Foreground and Comments
            oldWhite = "#C8C093",
            --fujiWhite = "#F9E7C0", -- modified
            fujiWhite = "#FFFFFF", -- modified
            fujiGray = "#727169",
            oniViolet = "#BFA3E6", -- modified
            oniViolet2 = "#BCACDB", -- modified
            crystalBlue = "#8CABFF", -- modified
            springViolet1 = "#938AA9",
            springViolet2 = "#9CABCA",
            springBlue = "#7FC4EF", -- modified
            waveAqua2 = "#77BBDD", -- modified

            springGreen = "#98BB6C",
            boatYellow1 = "#938056",
            boatYellow2 = "#C0A36E",
            carpYellow = "#FFEE99", -- modified

            sakuraPink = "#D27E99",
            waveRed = "#E46876",
            peachRed = "#FF5D62",
            surimiOrange = "#FFAA44", -- modified
            katanaGray = "#717C7C",
        },
    },
})

vim.opt.background = "dark"
vim.cmd.colorscheme("kanagawa")

--
--
-- ============================================================================
-- PLUGINS (vim.pack)
-- ============================================================================
--
--
vim.api.nvim_create_autocmd("VimEnter", {
  once = true,
  callback = function()
    vim.pack.add({"https://github.com/christoomey/vim-tmux-navigator"})


    vim.pack.add({"https://github.com/folke/snacks.nvim"})
    require("snacks").setup({
        picker = { enabled = true },
        explorer = { enabled = true,
          replace_netrw = true, -- Replace netrw with the snacks explorer
        },
    })
    vim.keymap.set("n", "<leader>e", function()
      Snacks.explorer()
    end, { desc = "File Explorer" })
    vim.keymap.set("n", "<leader>f", function()
      Snacks.picker.files()
    end)
    vim.keymap.set("n", "<leader>g", function()
      Snacks.picker.git_files()
    end, { desc = "File Explorer" })
    vim.keymap.set("n", "<leader>b", function() Snacks.picker.buffers() end)
    vim.keymap.set("n", "<leader>/", function() Snacks.picker.grep() end)

    vim.pack.add({"https://github.com/kovisoft/slimv"})
    -- for slimv repl
    vim.g.lisp_rainbow = 1
    vim.g.paredit_mode = 0
    vim.g.slimv_clhs_root = "file:/usr/share/doc/hyperspec/Body/"
    vim.g.slimv_browser_cmd = "tmux new-window w3m"
    vim.g.slimv_lisp = 'ros run'
    vim.g.slimv_impl = 'sbcl'
    vim.g.slimv_repl_split = 4

    -- ********* completion nvim-cmp *******************************
    --vim.pack.add({'https://github.com/hrsh7th/nvim-cmp'})
    --vim.pack.add({'https://github.com/hrsh7th/cmp-buffer'})
    --vim.pack.add({'https://github.com/hrsh7th/cmp-nvim-lsp'})

    --local cmp = require('cmp')
    --cmp.setup({
    --    snippet = {
    --      -- REQUIRED - you must specify a snippet engine
    --      expand = function(args)
    --        vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)
    --      end,
    --    },
    --    window = {
    --      completion = cmp.config.window.bordered(),
    --      documentation = cmp.config.window.bordered(),
    --    },
    --    mapping = cmp.mapping.preset.insert({
    --      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    --      ['<C-f>'] = cmp.mapping.scroll_docs(4),
    --      ['<C-Space>'] = cmp.mapping.complete(),
    --      ['<C-e>'] = cmp.mapping.abort(),
    --      ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    --    }),
    --    sources = cmp.config.sources({
    --      { name = 'nvim_lsp' },
    --      { name = 'buffer' },
    --    })
    --  })

    --cmp.setup.filetype("lisp", {
    --  enabled = false,
    --})

    -- ********* blink completion *******************************
	vim.pack.add({"https://github.com/L3MON4D3/LuaSnip"})
    vim.pack.add({ "https://github.com/saghen/blink.lib" })
    vim.pack.add({ "https://github.com/saghen/blink.cmp" })

    require("blink.cmp").setup({
        keymap = {
            preset = 'default',
            -- ["<C-Space>"] = { "show", "hide" },
            ["<Tab>"]      = { "accept", "fallback" },
            ["<C-y>"] = { 'show', 'show_documentation', 'hide_documentation' },
            ["<C-j>"]     = { "select_next", "fallback" },
            ["<C-k>"]     = { "select_prev", "fallback" },
            -- ["<Tab>"]     = { "snippet_forward", "fallback" },
            -- ["<S-Tab>"]   = { "snippet_backward", "fallback" },
        },
        appearance = { nerd_font_variant = "mono" },
        completion = { menu = { auto_show = true } },
        sources = { default = { "lsp", "path", "buffer", "snippets" } },
        signature = { enabled = true },
        snippets = {
            expand = function(snippet)
                require("luasnip").lsp_expand(snippet)
            end,
        },
        fuzzy = { implementation = "lua" }
    })

    vim.lsp.config["*"] = {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
    }

    --
    -- ********* python lsp jedi *******************************
    -- ~/.config/nvim/lsp/jedi.lua  (or inline in init.lua)
    vim.lsp.config('jedi', {
      cmd = { 'jedi-language-server' },
      filetypes = { 'python' },
      root_markers = { 'pyproject.toml', 'setup.py', '.git' },
      init_options = {
        diagnostics = { enable = false },
        completion  = { disableSnippets = true, resolveEagerly = false },
        hover       = { enable = false },
        jediSettings = { autoImportModules = {} },
      },
      on_attach = function(client, bufnr)
        -- hard-disable anything the server still advertises
        local caps = client.server_capabilities
        caps.hoverProvider              = false
        caps.signatureHelpProvider      = nil
        caps.codeActionProvider         = false
        caps.documentHighlightProvider  = false
        caps.documentFormattingProvider = false
        caps.renameProvider             = false
        caps.inlayHintProvider          = nil

        vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = false })
      end,
    })
    vim.lsp.enable('jedi')

    -- ********* C lsp clangd *********************
    -- see :h lsp-defaults
    -- ~/.config/nvim/lsp/clangd.lua
    vim.lsp.config('clangd', {
      cmd = {
        'clangd',
        '--background-index',
        '--clang-tidy=false',
        '--header-insertion=never',
        '--completion-style=detailed',
        '-j=8',
      },
      filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
      root_dir = function(bufnr, on_dir)
        local root = vim.fs.root(bufnr, { 'compile_commands.json', 'build/compile_commands.json' })
        if root then
          on_dir(root)
        end
        -- no call → clangd never starts for this buffer
      end,
    })
    vim.lsp.enable('clangd')

    -- ********** status line ************
    vim.pack.add({"https://github.com/nvim-tree/nvim-web-devicons"})-- fancy icons
    vim.pack.add({"https://github.com/linrongbin16/lsp-progress.nvim"}) -- LSP loading progress
    vim.pack.add({"https://github.com/nvim-lualine/lualine.nvim"})
    require("lualine").setup({
        options = {
          -- For more themes, see https://github.com/nvim-lualine/lualine.nvim/blob/master/THEMES.md
          theme = "papercolor_light", -- "auto, tokyonight, catppuccin, codedark, nord" 
        },
        sections = {
          lualine_c = {
            {
              -- Customize the filename part of lualine to be parent/filename
              'filename',
              file_status = true,      -- Displays file status (readonly status, modified status)
              newfile_status = false,  -- Display new file status (new file means no write after created)
              path = 4,                -- 0: Just the filename
                                       -- 1: Relative path
                                       -- 2: Absolute path
                                       -- 3: Absolute path, with tilde as the home directory
                                       -- 4: Filename and parent dir, with tilde as the home directory
              symbols = {
                modified = '[+]',      -- Text to show when the file is modified.
                readonly = '[-]',      -- Text to show when the file is non-modifiable or readonly.
              }
            }
          }
        }
      })
    end
})

vim.pack.add({
	--"https://www.github.com/lewis6991/gitsigns.nvim",
	--"https://www.github.com/echasnovski/mini.nvim",
	--"https://www.github.com/ibhagwan/fzf-lua",
	--"https://www.github.com/nvim-tree/nvim-tree.lua",
	--{
	--	src = "https://github.com/nvim-treesitter/nvim-treesitter",
	--	branch = "main",
	--	build = ":TSUpdate",
	--},
	---- Language Server Protocols
	--"https://www.github.com/neovim/nvim-lspconfig",
	--"https://github.com/mason-org/mason.nvim",
	--"https://github.com/creativenull/efmls-configs-nvim",
	--{
	--	src = "https://github.com/saghen/blink.cmp",
	--	version = vim.version.range("1.*"),
	--},
	--"https://github.com/L3MON4D3/LuaSnip",
  "https://github.com/folke/which-key.nvim",
})

--packadd("nvim-treesitter")
--packadd("gitsigns.nvim")
--packadd("mini.nvim")
--packadd("fzf-lua")
--packadd("nvim-tree.lua")
-- LSP
--packadd("nvim-lspconfig")
--packadd("mason.nvim")
--packadd("efmls-configs-nvim")
--packadd("blink.cmp")
--packadd("LuaSnip")


-- ============================================================================
require('less-mode').setup()


vim.keymap.set('n', '*', function()
  vim.fn.setreg('/', '\\<' .. vim.fn.expand('<cword>') .. '\\>')
  vim.opt.hlsearch = true
end, { silent = true })

