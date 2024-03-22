-- Theme & UI
vim.o.timeout = true
vim.o.timeoutlen = 500
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.incsearch = true
vim.wo.signcolumn = 'yes'
vim.opt.number = true
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.colorcolumn = "81"
vim.opt.laststatus = 3
vim.opt.scrolloff = 5
vim.opt.nuw = 1
vim.opt.statuscolumn = " %s%=%l "

-- Neovide specific
if vim.g.neovide then
  require('telescope').setup({
    defaults = {
      winblend = 100,
    },
  })
  vim.opt.winblend = 100
  vim.opt.pumblend = 100
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_transparency = 0.90
  vim.g.neovide_window_floating_opacity = 100

  vim.g.neovide_floating_blur_amount_x = 5.0
  vim.g.neovide_floating_blur_amount_y = 5.0

  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<C-=>", function()
    change_scale_factor(1.25)
  end)
  vim.keymap.set("n", "<C-->", function()
    change_scale_factor(1 / 1.25)
  end)
else
  require("mini.animate").setup()
end

require('github-theme').setup({
  options = {
    transparent = true,
  },
})
vim.cmd('colorscheme github_dark')
require("deadcolumn").setup({
  scope = "buffer",
})
require("sttusline").setup({
  statusline_color = "Normal",
  laststatus = 3,
})
require("noice").setup({
  presets = {
    lsp_doc_border = true,
  },
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    }
  }
})
require("notify").setup({ background_colour = "#000000" })
vim.cmd("highlight! link NormalFloat Normal")

local diagnostic_icons = {
  error = '⚠',
  warn = '⚠',
  hint = '󰋼',
  info = '',
}

vim.diagnostic.config({
  severity_sort = true,
})

-- QoL
require("better_escape").setup({ mapping = { "jk" } })

local function closeOtherBuffers()
  local curbufnr = vim.api.nvim_get_current_buf()
  local buflist = vim.api.nvim_list_bufs()
  for _, bufnr in ipairs(buflist) do
    if vim.bo[bufnr].buflisted and bufnr ~= curbufnr then
      vim.cmd('bd ' .. tostring(bufnr))
    end
  end
end

-- Git
require("gitsigns").setup({
  signs = {
    add          = { text = '│' },
    change       = { text = '│' },
    delete       = { text = '│' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signcolumn = true,
  numhl = true,
  current_line_blame = true,
  _extmark_signs = true,
})
require("diffview").setup()
local function toggleDiffview()
  if next(require('diffview.lib').views) == nil then
    vim.cmd('DiffviewOpen')
  else
    vim.cmd('DiffviewClose')
  end
end

-- Files
require("oil").setup()

-- Syntax
require("nvim-treesitter.configs").setup({
  ensure_installed = {
    "c",
    "cpp",
    "lua",
    "vim",
    "vimdoc",
    "query",
    "csv",
    "html",
    "css",
    "javascript",
    "typescript",
    "json",
    "cmake",
    "make",
    "go",
    "gomod",
    "gosum",
    "gitignore",
    "gitcommit",
    "python",
    "dockerfile",
    "yaml",
    "markdown",
    "markdown_inline",
    "regex",
    "bash",
  },
  sync_install = false,
  highlight = { enable = true },
  indent = { enable = true },
})

-- LSP, Autocompletion, Formatting and etc.
local lsp_zero = require("lsp-zero")
lsp_zero.set_sign_icons(diagnostic_icons)

lsp_zero.on_attach(function(_, bufnr)
  lsp_zero.default_keymaps({ buffer = bufnr })
end)

require("mason").setup({})
require("mason-lspconfig").setup({
  handlers = {
    lsp_zero.default_setup,
  }
})

local cmp = require("cmp")
local cmp_action = lsp_zero.cmp_action()
local lspkind = require("lspkind")

cmp.setup({
  preselect = cmp.PreselectMode.None,
  completion = {
    completeopt = 'menu,menuone,noinsert',
  },
  mapping = cmp.mapping.preset.insert({
    ['<CR>'] = cmp.mapping.confirm({ select = false }),

    -- Ctrl+Space to trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),

    -- Scroll up and down in the completion documentation
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
  }),
  window = {
    completion = cmp.config.window.bordered({}),
    documentation = cmp.config.window.bordered({ winhighlight = "Normal:NormalFloat" })
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
  },
  formatting = {
    format = lspkind.cmp_format({}),
  },
  sorting = {
    comparators = {
      cmp.config.compare.offset,
      cmp.config.compare.exact,
      cmp.config.compare.score,
      cmp.config.compare.recently_used,
      cmp.config.compare.kind,
    },
  },
})

cmp.setup.cmdline("/", {
  preselect = cmp.PreselectMode.None,
  completion = {
    completeopt = 'menu,menuone,noselect,noinsert',
  },
  mapping = cmp.mapping.preset.cmdline({
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }),
  sources = {
    { name = "buffer" }
  },
})

cmp.setup.cmdline(":", {
  preselect = cmp.PreselectMode.None,
  completion = {
    completeopt = 'menu,menuone,noselect,noinsert',
  },
  mapping = cmp.mapping.preset.cmdline({
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    {
      name = "cmdline",
      option = {
        ignore_cmds = { "Man" },
      },
    },
  })
})


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.foldingRange = {
  dynamicRegistration = false,
  lineFoldingOnly = true,
}

local lspconfig = require("lspconfig")
local language_servers = lspconfig.util.available_servers()
for _, ls in ipairs(language_servers) do
  lspconfig[ls].capabilites = capabilities
end
local ufo = require("ufo")
ufo.setup()

-- Which Key (NOTE: Some key mappings are set elswhere)
require("which-key").register({
  ["<leader>f"] = {
    w = { "<cmd>Telescope live_grep<cr>", "Find word" },
    f = { "<cmd>Telescope find_files path_display={'truncate'}<cr>", "Find file" },
    r = { "<cmd>Telescope oldfiles<cr>", "Recent files", noremap = false },
    n = { "<cmd>Telescope notify<cr>", "Show notification" },
    b = { "<cmd>Telescope buffers<cr>", "Show buffers" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Show document symbols" },
    S = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Show workspace symbols" },
    m = { "<cmd>LspZeroFormat<cr>", "Format buffer" },
  },
  ["<leader>q"] = { "<cmd>Telescope diagnostics bufnr=0<cr>", "Show current buffer diagnostics" },
  ["<leader>Q"] = { "<cmd>Telescope diagnostics<cr>", "Show diagnostics" },
  ["<leader>n"] = { "<cmd>enew<cr>", "New buffer" },
  ["<leader>x"] = { "<cmd>bd<cr>", "Delete buffer" },
  ["<leader>X"] = { closeOtherBuffers, "Delete other buffers" },
  ["<leader>g"] = {
    d = { toggleDiffview, "Git diff" },
    b = { "<cmd>Gitsigns blame_line<cr>", "Git blame" },
  },
  ["g"] = {
    r = { "<cmd>Telescope lsp_references<cr>", "Find references" },
    d = { "<cmd>Telescope lsp_definitions<cr>", "Find defenitions" },
    D = { "<cmd>Telescope lsp_type_definitions<cr>", "Find type defenitions" },
    i = { "<cmd>Telescope lsp_implementations<cr>", "Find implementation" },
    I = { "<cmd>Telescope lsp_incoming_calls<cr>", "Find incoming calls" },
    O = { "<cmd>Telescope lsp_outgoing_calls<cr>", "Find outgoing calls" },
  },
  ["<C-k>"] = { vim.lsp.buf.signature_help, "Show signature" },
  ['<leader>r'] = {
    n = { vim.lsp.buf.rename, "Rename" },
    h = { "<cmd>Gitsigns reset_hunk<cr>", "Reset hunk" },
  },
  ['<leader>p'] = {
    h = { "<cmd>Gitsigns preview_hunk<cr>", "Preview hunk" },
  },
  ['<leader>s'] = {
    h = { "<cmd>Gitsigns stage_hunk<cr>", "Stage hunk" },
  },
  ['<leader>i'] = { vim.diagnostic.open_float, "Diagnostic float" },
  ['<leader>e'] = { "<cmd>Telescope diagnostics bufnr=0<cr>", "Diagnostics buffer" },
  ['<leader>E'] = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
  ['<leader>k'] = {
    m = { "<cmd>Telescope keymaps<cr>", "Show Keymaps" },
  },
  ["]"] = {
    q = { '<cmd>cnext<cr>g`"', "Next quick list item", nowait = true },
    c = { "<cmd>Gitsigns next_hunk<cr>", "Next hunk", nowait = true },
  },
  ["["] = {
    q = { '<cmd>cprevious<cr>g`"', "Previous quick list item", nowait = true },
    c = { "<cmd>Gitsigns prev_hunk<cr>", "Previous hunk", nowait = true },
  },
  ["<Tab>"] = { "<cmd>bnext<cr>", "Next buffer", nowait = true },
  ["<S-Tab>"] = { "<cmd>bprevious<cr>", "Previous buffer", nowait = true },
  ["<leader>c"] = {
    a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code actions" },
  },
})

vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory", nowait = true })
vim.keymap.set("n", ";", ":", { desc = "Enter command mode", nowait = true })
vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith)
vim.keymap.set({ 'n', 'x', 'o' }, 'f', '<Plug>(leap-forward)', { desc = "Leap forward" })                         
vim.keymap.set({ 'n', 'x', 'o' }, 'F', '<Plug>(leap-backward)', { desc = "Leap backward" })
vim.keymap.set({ 'n', 'x', 'o' }, 'gs', '<Plug>(leap-from-window)', { desc = "Leap from window" })

require("Comment").setup({
  toggler = {
    line = "<leader>/",
    block = "<leader>?",
  },
  opleader = {
    line = "<leader>/",
    block = "<leader>?",
  },
  extra = {
    above = "<leader>ck",
    below = "<leader>cj",
    eol = "<leader>cl",
  }
})
