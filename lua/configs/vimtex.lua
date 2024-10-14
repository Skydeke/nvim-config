vim.g.vimtex_mappings_enabled = 0
vim.g.vimtex_view_general_viewer = "zathura_simple"
vim.g.vimtex_view_method = "zathura_simple"
vim.g.vimtex_compiler_method = "latexmk"
vim.g.vimtex_compiler_latexmk = {
  callback = 1,
  continuous = 1,
  executable = vim.fn.expand "~" .. "/.config/nvim/latex/latexmk",
  options = {
    "-shell-escape",
    "-verbose",
    "-file-line-error",
    "-synctex=1",
    "-interaction=nonstopmode",
  },
}
vim.g.vimtex_quickfix_mode = 0
vim.g.vimtex_fold_enabled = 1
vim.g.vimtex_fold_types = {
  cmd_addplot = {
    cmds = { "addplot[+3]?" },
  },
  cmd_multi = {
    cmds = {
      "%(re)?new%(command|environment)",
      "providecommand",
      "presetkeys",
      "Declare%(Multi|Auto)?CiteCommand",
      "Declare%(Index)?%(Field|List|Name)%(Format|Alias)",
    },
  },
  cmd_single = {
    cmds = { "hypersetup", "tikzset", "pgfplotstableread", "lstset" },
  },
  cmd_single_opt = {
    cmds = { "usepackage", "includepdf" },
  },
  comments = {
    enabled = 0,
  },
  env_options = vim.empty_dict(),
  envs = {
    blacklist = {},
    whitelist = {
      "figure",
      "frame",
      "table",
      "example",
      "answer",
      "titlepage",
      "cvskills",
      "cventries",
      "cvhonors",
    },
  },
  items = {
    enabled = 0,
  },
  markers = vim.empty_dict(),
  preamble = {
    enabled = 0,
  },
  sections = {
    parse_levels = 0,
    parts = { "appendix", "frontmatter", "mainmatter", "backmatter" },
    sections = {
      "%(add)?part",
      "%(chapter|addchap)",
      "%(section|section\\*)",
      "%(subsection|subsection\\*)",
      "%(subsubsection|subsubsection\\*)",
      "paragraph",
    },
  },
}
