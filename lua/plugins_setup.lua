local vim = vim

-- Theme & UI
vim.o.timeout = true
vim.o.timeoutlen = 500
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.incsearch = true
vim.wo.signcolumn = 'auto:1'
vim.opt.number = true
vim.opt.autoindent = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true
vim.opt.colorcolumn = "81"
vim.opt.laststatus = 3
vim.opt.scrolloff = 5
vim.opt.nuw = 2

-- local M = {}
-- _G.Status = M
--
-- function M.get_signs()
--   local buf = vim.api.nvim_win_get_buf(vim.g.statusline_winid)
--   return vim.tbl_map(function(sign)
--     return vim.fn.sign_getdefined(sign.name)[1]
--   end, vim.fn.sign_getplaced(buf, { group = "*", lnum = vim.v.lnum })[1].signs)
-- end
--
-- function M.column()
--   local sign, git_sign
--   for _, s in ipairs(M.get_signs()) do
--     if s.name:find("GitSign") then
--       git_sign = s
--     else
--       sign = s
--     end
--   end
--   local components = {
--     sign and (" %#" .. sign.texthl .. "#" .. sign.text .. "%*") or "",
--     [[%=]],
--     [[%{&nu?(&rnu&&v:relnum?v:relnum:v:lnum):''}]],
--     git_sign and ("%#" .. git_sign.texthl .. "#" .. git_sign.text .. "%*") or "  ",
--   }
--   return table.concat(components, "")
-- end
--
-- vim.opt.statuscolumn = [[%!v:lua.Status.column()]]

local telescopeActions = require("telescope.actions")
require('telescope').setup({
  defaults = {
    winblend = vim.g.neovide and 100 or 0,
    borderchars = { "", "", "", "", "", "", "", "" },
  },
  pickers = {
    buffers = {
      mappings = {
        n = {
          ["<M-d>"] = telescopeActions.delete_buffer,
        },
        i = {
          ["<M-d>"] = telescopeActions.delete_buffer,
        },
      },
    },
  },
})

require("noice").setup({
  lsp = {
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    }
  }
})
require("notify").setup({
  background_colour = "#000000",
  top_down = false,
})

require('github-theme').setup({
  options = {
    transparent = true,
  },
})
vim.cmd('colorscheme github_dark')

-- require("scrollbar").setup({
--   marks = {
--     Cursor = {
--       text = "•",
--       priority = 0,
--       gui = nil,
--       color = nil,
--       cterm = nil,
--       color_nr = nil, -- cterm
--       highlight = "Normal",
--     },
--     Search = {
--       text = { "•", "•" },
--       priority = 1,
--       gui = nil,
--       color = nil,
--       cterm = nil,
--       color_nr = nil, -- cterm
--       highlight = "Search",
--     },
--     Error = {
--       text = { "•", "•" },
--       priority = 2,
--       gui = nil,
--       color = nil,
--       cterm = nil,
--       color_nr = nil, -- cterm
--       highlight = "DiagnosticVirtualTextError",
--     },
--     Warn = {
--       text = { "•", "•" },
--       priority = 3,
--       gui = nil,
--       color = nil,
--       cterm = nil,
--       color_nr = nil, -- cterm
--       highlight = "DiagnosticVirtualTextWarn",
--     },
--     Info = {
--       text = { "•", "•" },
--       priority = 4,
--       gui = nil,
--       color = nil,
--       cterm = nil,
--       color_nr = nil, -- cterm
--       highlight = "DiagnosticVirtualTextInfo",
--     },
--     Hint = {
--       text = { "•", "•" },
--       priority = 5,
--       gui = nil,
--       color = nil,
--       cterm = nil,
--       color_nr = nil, -- cterm
--       highlight = "DiagnosticVirtualTextHint",
--     },
--     Misc = {
--       text = { "•", "•" },
--       priority = 6,
--       gui = nil,
--       color = nil,
--       cterm = nil,
--       color_nr = nil, -- cterm
--       highlight = "Normal",
--     },
--     GitAdd = {
--       text = "│",
--       priority = 7,
--       gui = nil,
--       color = nil,
--       cterm = nil,
--       color_nr = nil, -- cterm
--       highlight = "GitSignsAdd",
--     },
--     GitChange = {
--       text = "│",
--       priority = 7,
--       gui = nil,
--       color = nil,
--       cterm = nil,
--       color_nr = nil, -- cterm
--       highlight = "GitSignsChange",
--     },
--     GitDelete = {
--       text = "│",
--       priority = 7,
--       gui = nil,
--       color = nil,
--       cterm = nil,
--       color_nr = nil, -- cterm
--       highlight = "GitSignsDelete",
--     },
--   },
-- })
-- require("scrollbar.handlers.gitsigns").setup()

-- Files
local oil = require("oil")
oil.setup()


-- Neovide specific
if vim.g.neovide then
  vim.api.nvim_set_current_dir(vim.fn.expand("~"))
  oil.open("~")

  vim.o.guifont = "JetBrainsMono Nerd Font:h12"
  vim.opt.winblend = 100
  vim.g.neovide_hide_mouse_when_typing = true
  vim.g.neovide_transparency = 0.90
  vim.g.neovide_input_macos_alt_is_meta = true

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

  vim.cmd("hi! NormalFloat blend=100")
  vim.cmd("hi! FloatBorder blend=100")
  vim.cmd("hi! CursorLine blend=0")
  vim.cmd("hi! PmenuSel blend=0")
  vim.cmd("hi! TelescopeMatching blend=0")
  vim.cmd("hi! TelescopePreviewMatch guibg=#555555 blend=0")
  vim.cmd("hi! Visual blend=0")
  vim.cmd("hi! Pmenu blend=100")
else
  require("mini.animate").setup()
end

require("deadcolumn").setup({
  scope = "buffer",
})
require("sttusline").setup({
  statusline_color = "Normal",
  laststatus = 3,
})

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
    changedelete = { text = '┃' },
    untracked    = { text = '┆' },
  },
  signcolumn = true,
  numhl = false,
  current_line_blame = true,
  _extmark_signs = false,
})
require("diffview").setup()
local function toggleDiffview()
  if next(require('diffview.lib').views) == nil then
    vim.cmd('DiffviewOpen')
  else
    vim.cmd('DiffviewClose')
  end
end

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
    completeopt = 'menu,menuone',
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
    completeopt = 'menu,menuone,noselect',
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
    completeopt = 'menu,menuone,noselect',
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
        ignore_cmds = { "Man", "!" },
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
require("which-key").add({
  { "<C-k>",            vim.lsp.buf.signature_help,                      desc = "Show signature" },
  { "<C-w>c",           "<cmd>tabclose<cr>",                             desc = "Close tab" },
  { "<C-w>t",           "<cmd>tabnew<cr>",                               desc = "New tab" },
  { "<M-S-e>",          "<C-w>=",                                        desc = "Un-Expand" },
  { "<M-S-h>",          "<C-w><",                                        desc = "Decrease width" },
  { "<M-S-j>",          "<C-w>-",                                        desc = "Decrese height" },
  { "<M-S-k>",          "<C-w>+",                                        desc = "Increase height" },
  { "<M-S-l>",          "<C-w>>",                                        desc = "Increase width" },
  { "<M-e>",            "<C-w>_<C-w>|",                                  desc = "Expand" },
  { "<M-h>",            "<C-w>h",                                        desc = "Go to the left window" },
  { "<M-j>",            "<C-w>j",                                        desc = "Go to the down window" },
  { "<M-k>",            "<C-w>k",                                        desc = "Go to the up window" },
  { "<M-l>",            "<C-w>l",                                        desc = "Go to the right window" },
  { "<S-Tab>",          "<cmd>bprevious<cr>",                            desc = "Previous buffer",                nowait = true },
  { "<Tab>",            "<cmd>bnext<cr>",                                desc = "Next buffer",                    nowait = true },
  { "<leader><leader>", "<cmd>Telescope buffers<cr>",                    desc = "Show buffers" },
  { "<leader>E",        "<cmd>Telescope diagnostics<cr>",                desc = "Diagnostics" },
  { "<leader>Q",        "<cmd>Telescope diagnostics<cr>",                desc = "Show diagnostics" },
  { "<leader>X",        closeOtherBuffers,                               desc = "Delete other buffers" },
  { "<leader>ca",       "<cmd>lua vim.lsp.buf.code_action()<cr>",        desc = "Code actions" },
  { "<leader>e",        "<cmd>Telescope diagnostics bufnr=0<cr>",        desc = "Diagnostics buffer" },
  { "<leader>fS",       "<cmd>Telescope lsp_workspace_symbols<cr>",      desc = "Show workspace symbols" },
  { "<leader>fb",       "<cmd>Telescope buffers sort_lastused=true<cr>", desc = "Show buffers" },
  { "<leader>ff",       "<cmd>Telescope find_files<cr>",                 desc = "Find file" },
  { "<leader>fm",       "<cmd>LspZeroFormat<cr>",                        desc = "Format buffer" },
  { "<leader>fn",       "<cmd>Telescope notify<cr>",                     desc = "Show notification" },
  { "<leader>fr",       "<cmd>Telescope oldfiles<cr>",                   desc = "Recent files",                   remap = true },
  { "<leader>fs",       "<cmd>Telescope lsp_document_symbols<cr>",       desc = "Show document symbols" },
  { "<leader>fw",       "<cmd>Telescope live_grep<cr>",                  desc = "Find word" },
  { "<leader>gB",       "<cmd>Gitsigns blame_line<cr>",                  desc = "Git branches" },
  { "<leader>gH",       "<cmd>Telescope git_commits<cr>",                desc = "Git history" },
  { "<leader>gb",       "<cmd>Telescope git_branches<cr>",               desc = "Git branches" },
  { "<leader>gd",       toggleDiffview,                                  desc = "Git diff" },
  { "<leader>gh",       "<cmd>Telescope git_bcommits<cr>",               desc = "Git file history" },
  { "<leader>gi",       "<cmd>Gitsigns blame_line<cr>",                  desc = "Git blame" },
  { "<leader>gs",       "<cmd>Telescope git_status<cr>",                 desc = "Git status" },
  { "<leader>i",        vim.diagnostic.open_float,                       desc = "Diagnostic float" },
  { "<leader>km",       "<cmd>Telescope keymaps<cr>",                    desc = "Show Keymaps" },
  { "<leader>n",        "<cmd>enew<cr>",                                 desc = "New buffer" },
  { "<leader>ph",       "<cmd>Gitsigns preview_hunk<cr>",                desc = "Preview hunk" },
  { "<leader>q",        "<cmd>Telescope diagnostics bufnr=0<cr>",        desc = "Show current buffer diagnostics" },
  { "<leader>rh",       "<cmd>Gitsigns reset_hunk<cr>",                  desc = "Reset hunk" },
  { "<leader>rn",       vim.lsp.buf.rename,                              desc = "Rename" },
  { "<leader>sh",       "<cmd>Gitsigns stage_hunk<cr>",                  desc = "Stage hunk" },
  { "<leader>t",        "<cmd>:terminal<cr>",                            desc = "Terminal" },
  { "<leader>x",        "<cmd>bd<cr>",                                   desc = "Delete buffer" },
  { "[c",               "<cmd>Gitsigns prev_hunk<cr>",                   desc = "Previous hunk",                  nowait = true },
  { "[d",               vim.diagnostic.goto_next,                        desc = "Next diagnositc",                nowait = true },
  { "[q",               '<cmd>cprevious<cr>g`"',                         desc = "Previous quick list item",       nowait = true },
  { "]c",               "<cmd>Gitsigns next_hunk<cr>",                   desc = "Next hunk",                      nowait = true },
  { "]d",               vim.diagnostic.goto_prev,                        desc = "Next diagnositc",                nowait = true },
  { "]q",               '<cmd>cnext<cr>g`"',                             desc = "Next quick list item",           nowait = true },
  { "gD",               "<cmd>Telescope lsp_type_definitions<cr>",       desc = "Find type defenitions" },
  { "gI",               "<cmd>Telescope lsp_incoming_calls<cr>",         desc = "Find incoming calls" },
  { "gO",               "<cmd>Telescope lsp_outgoing_calls<cr>",         desc = "Find outgoing calls" },
  { "gd",               "<cmd>Telescope lsp_definitions<cr>",            desc = "Find defenitions" },
  { "gi",               "<cmd>Telescope lsp_implementations<cr>",        desc = "Find implementation" },
  { "gr",               "<cmd>Telescope lsp_references<cr>",             desc = "Find references" },
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
vim.keymap.set("t", '<C-Space>', '<C-\\><C-n>', { desc = "Escape terminal mode" })

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


local builtin = require("statuscol.builtin")
require("statuscol").setup({
  foldfunc = "builtin",
  setopt = true,
  reculright = true,
  segments = {
    -- {
    --   sign = { name = { "GitSign*", } },
    --   text = { "%s" },
    --   click = "v:lua.ScSa"
    -- },
    {
      text = { builtin.lnumfunc },
      condition = { true, builtin.not_empty },
      click = "v:lua.ScLa",
    },
    {
      text = { "%s" },
      sign = { colwidth = 1, maxwidth = 1, auto = true, foldclosed = true },
      click = "v:lua.ScSa"
    },
    {
      text = { builtin.foldfunc, " " },
      condition = { true, builtin.not_empty },
      click = "v:lua.ScFa"
    },
  }
})
