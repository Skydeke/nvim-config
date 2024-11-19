require("lint").linters_by_ft = {
  tex = { "chktex" },
}

require("lint").linters.chktex = {
  cmd = "chktex",
  stdin = true, -- or false if it doesn't support content input via stdin. In that case the filename is automatically added to the arguments.
  append_fname = true, -- Automatically append the file name to `args` if `stdin = false` (default: true)
  args = { "-v3", "-I0", "-e", "15", "-n", "1", "-n", "24", "-s", ":", "-f", "%l%b%c%b%d%b%k%b%n%b%m%b%b%b" }, -- list of arguments. Can contain functions with zero arguments that will be evaluated once the linter is used.
  stream = "stdout", -- ('stdout' | 'stderr' | 'both') configure the stream to which the linter outputs the linting result.
  ignore_exitcode = true, -- set this to true if the linter exits with a code != 0 and that's considered normal.
  env = nil, -- custom environment table to use with the external process. Note that this replaces the *entire* environment, it is not additive.
  parser = function(output, _)
    local result = vim.fn.split(output, ":::")
    -- vim.notify(output, vim.log.levels.ERROR)
    local pattern = "(%d+):(%d+):(%d+):(.+):(%d+):(.*)"
    local severities = {
      Error = vim.diagnostic.severity.ERROR,
      Warning = vim.diagnostic.severity.WARN,
      Message = vim.diagnostic.severity.INFO,
    }
    local diagnostics = {}

    for _, line in ipairs(result) do
      local lineno, off, d, sev, code, desc = string.match(line, pattern)

      lineno = tonumber(lineno or 1) - 1
      off = tonumber(off or 1) - 1
      d = tonumber(d or 1)
      table.insert(diagnostics, {
        source = "chktex",
        lnum = lineno,
        col = off,
        end_lnum = lineno,
        end_col = off + d,
        message = desc,
        severity = assert(severities[sev], "missing mapping for severity " .. sev),
        code = code,
        user_data = {
          lsp = {
            code = code,
          },
        },
      })
    end
    return diagnostics
  end,
}
