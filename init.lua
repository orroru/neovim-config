vim.cmd([[let g:python3_host_prog = '/usr/bin/python3']])
vim.cmd([[set clipboard^=unnamed,unnamedplus]])

require("lazy_init")
require("lazy").setup(require("plugin_list"))
require("plugins_setup")

