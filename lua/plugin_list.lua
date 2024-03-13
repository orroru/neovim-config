return {
  {
    "nvim-lua/plenary.nvim",
  },
  {
    'projekt0n/github-nvim-theme',
    lazy = false,
    priority = 1000,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
  },
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build =
    'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
  },
  {
    "rcarriga/nvim-notify",
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
  },
  {
    "stevearc/oil.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
  },
  {
    "tanvirtin/vgit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  {
    "williamboman/mason.nvim",
  },
  {
    "williamboman/mason-lspconfig.nvim",
  },
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = 'v3.x',
    lazy = true,
    config = false,
    dependencies = {
      {
        "neovim/nvim-lspconfig",
        dependencies = {
          "hrsh7th/cmp-nvim-lsp",
        },
      },
      {
        "hrsh7th/nvim-cmp",
        dependencies = {
          "L3MON4D3/LuaSnip",
          "hrsh7th/cmp-buffer",
          "hrsh7th/cmp-cmdline",
          "onsails/lspkind.nvim",
        },
      },
    },
  },
  {
    "echasnovski/mini.animate",
    version = "*",
  },
  {
    'Bekaboo/deadcolumn.nvim',
  },
  {
    "sontungexpt/sttusline",
    branch = "table_version",
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    event = { "BufEnter" },
  },
  {
  },
  {
    "numToStr/Comment.nvim",
    lazy = false,
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = {
      "kevinhwang91/promise-async",
      {
        "luukvbaal/statuscol.nvim",
        dependencies = {
          {
            "lewis6991/gitsigns.nvim",
          },
        },
      },
    },
    event = "BufReadPost",
  },
}
