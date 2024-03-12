-- Theme & UI
vim.o.timeout = true
vim.o.timeoutlen = 500
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.updatetime = 300
vim.o.incsearch = false
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

require("mini.starter").setup()

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
require("mini.animate").setup()
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

-- QoL
require("better_escape").setup({ mapping = { "jk" } })

-- Git
require("vgit").setup()

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

    ['C-n'] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item({ behavior = 'insert' })
      else
        cmp.complete()
      end
    end),

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
        ignore_cmds = { "Man", "!" },
      },
    },
  })
})

require("gitsigns").setup({
  signcolumn = true,
  numhl = true,
  linehl = false,
  word_diff = false,
  current_line_blame = true,
})

local builtin = require("statuscol.builtin")
require("statuscol").setup({
  segments = {
    {
      text = {
        -- Don't like implementation, but it will do for now.
        function(args)
          local diagnostics = vim.diagnostic.get(args.bufnr, { lnum = args.lnum - 1 })
          local severity = 0
          for _, d in ipairs(diagnostics) do
            if d.severity == 1 then
              severity = 1
              break
            elseif d.severity == 2 then
              severity = 2
            end
          end
          if severity == 1 then
            return "%#ErrorMsg#"
          elseif severity == 2 then
            return "%#WarningMsg#"
          else
            return " "
          end
        end,
        " %*",
      },
      sign = { name = { "Diagnostic" } },
      click = "v:lua.ScSa"
    },
    {
      text = { builtin.lnumfunc },
      condition = { true, builtin.not_empty },
      click = "v:lua.ScLa"
    },
    {
      sign = { name = { "Git*" } },
      click = "v:lua.ScSa"
    },
    {
      text = { builtin.foldfunc, " " },
      click = "v:lua.ScFa"
    },
  },
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
    f = { "<cmd>Telescope find_files<cr>", "Find file" },
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
  ["<leader>X"] = { "<cmd>%bd|e#<cr>", "Delete other buffers" },
  ["<leader>g"] = {
    d = { "<cmd>VGit project_diff_preview<cr>", "Git diff" },
    D = { "<cmd>VGit buffer_diff_preview<cr>", "Git buffer diff" },
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
  ["C-k"] = { vim.lsp.buf.signature_help, "Show signature" },
  ['<leader>r'] = {
    n = { vim.lsp.buf.rename, "Rename" },
    h = { "<cmd>Gitsigns reset_hunk<cr>", "Reset hunk" },
  },
  ['<leader>p'] = {
    h = { "<cmd>Gitsigns preview_hunk<cr>", "Preview hunk" },
  },
  ['<leader>s'] = {
    h = { "<cmd>VGit buffer_hunk_stage<cr>", "Stage hunk" },
  },
  ['<leader>i'] = { vim.diagnostic.open_float, "Diagnostic float" },
  ['<leader>e'] = { "<cmd>Telescope diagnostics bufnr=0<cr>", "Diagnostics buffer" },
  ['<leader>E'] = { "<cmd>Telescope diagnostics<cr>", "Diagnostics" },
  ['<leader>k'] = {
    m = { "<cmd>Telescope keymaps<cr>", "Show Keymaps" },
  },
  ["]"] = {
    q = { "<cmd>cnext<cr>", "Next quick list item", nowait = true },
    c = { "<cmd>VGit hunk_down<cr>", "Next hunk", nowait = true },
  },
  ["["] = {
    q = { "<cmd>cprevious<cr>", "Previous quick list item", nowait = true },
    c = { "<cmd>VGit hunk_up<cr>", "Previous hunk", nowait = true },
  },
  ["<Tab>"] = { "<cmd>bnext<cr>", "Next buffer", nowait = true },
  ["<S-Tab>"] = { "<cmd>bprevious<cr>", "Previous buffer", nowait = true },
})

vim.keymap.set("n", "-", "<cmd>Oil<cr>", { desc = "Open parent directory", nowait = true })
vim.keymap.set("n", ";", ":", { desc = "Enter command mode", nowait = true })
vim.keymap.set("n", "zR", require("ufo").openAllFolds)
vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
vim.keymap.set('n', 'zm', require('ufo').closeFoldsWith)

require("Comment").setup({
  toggler = {
    line = "<leader>/",
    block = "<leader>?",
  },
  opleader = {
    line = "<leader>?",
    block = "<leader>/",
  },
  extra = {
    above = "<leader>ck",
    below = "<leader>cj",
    eol = "<leader>cl",
  }
})
