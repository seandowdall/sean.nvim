return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    -- Only run eslint_d when an ESLint config exists in the project
    local eslint_config_files = {
      ".eslintrc",
      ".eslintrc.json",
      ".eslintrc.js",
      ".eslintrc.cjs",
      ".eslintrc.yaml",
      ".eslintrc.yml",
      "eslint.config.js",
      "eslint.config.cjs",
      "eslint.config.mjs",
      "eslint.config.ts",
      "eslint.config.mts",
      "eslint.config.cts",
    }

    local function find_eslint_root(start_dir)
      -- Find any eslint config file and return its directory
      local found = vim.fs.find(eslint_config_files, { upward = true, path = start_dir })[1]
      if found then
        return vim.fn.fnamemodify(found, ":h")
      end

      -- Also check for package.json with an eslintConfig field
      local pkg = vim.fs.find("package.json", { upward = true, path = start_dir })[1]
      if pkg then
        local ok, content = pcall(vim.fn.readfile, pkg)
        if ok then
          local ok_json, data = pcall(vim.fn.json_decode, table.concat(content, "\n"))
          if ok_json and type(data) == "table" and data.eslintConfig ~= nil then
            return vim.fn.fnamemodify(pkg, ":h")
          end
        end
      end

      return nil
    end

    -- Attach a condition so eslint_d is skipped if no config is found
    if lint.linters.eslint_d then
      local original = lint.linters.eslint_d
      lint.linters.eslint_d = vim.tbl_deep_extend("force", original, {
        condition = function(ctx)
          local start_dir = ctx.dirname
            or (ctx.filename and vim.fn.fnamemodify(ctx.filename, ":h"))
            or vim.fn.getcwd()
          return find_eslint_root(start_dir) ~= nil
        end,
        cwd = function(ctx)
          local start_dir = ctx.dirname
            or (ctx.filename and vim.fn.fnamemodify(ctx.filename, ":h"))
            or vim.fn.getcwd()
          return find_eslint_root(start_dir) or start_dir
        end,
      })
    end

    lint.linters_by_ft = {
      javascript = { "eslint_d" },
      typescript = { "eslint_d" },
      javascriptreact = { "eslint_d" },
      typescriptreact = { "eslint_d" },
      svelte = { "eslint_d" },
      python = { "pylint" },
    }

    local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

    -- Toggleable auto-linting
    vim.g.lint_auto_enabled = true

    vim.api.nvim_create_user_command("LintToggle", function()
      vim.g.lint_auto_enabled = not vim.g.lint_auto_enabled
      vim.notify("nvim-lint auto: " .. (vim.g.lint_auto_enabled and "ON" or "OFF"), vim.log.levels.INFO)
    end, { desc = "Toggle automatic linting autocommands" })

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        if vim.g.lint_auto_enabled then
          lint.try_lint()
        end
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })

    vim.keymap.set("n", "<leader>L", function()
      vim.cmd("LintToggle")
    end, { desc = "Toggle automatic linting" })
  end,
}
