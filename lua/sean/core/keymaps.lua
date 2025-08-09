vim.g.mapleader = " "

local keymap = vim.keymap -- for conciseness

keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode with jk" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- colorscheme: quick toggle between dark and light TokyoNight
keymap.set("n", "<leader>ul", function()
  local function set_bg_and_colorscheme(mode)
    if mode == "light" then
      vim.o.background = "light"
      vim.cmd("colorscheme tokyonight-day")
    else
      vim.o.background = "dark"
      vim.cmd("colorscheme tokyonight")
    end
  end

  if vim.o.background == "light" then
    set_bg_and_colorscheme("dark")
  else
    set_bg_and_colorscheme("light")
  end

  -- Inform WezTerm (if available) of the new theme
  local mode = vim.o.background == "light" and "light" or "dark"
  if vim.fn.executable("wezterm") == 1 then
    local cmd = { "wezterm", "cli", "set-user-var", "NVIM_THEME", mode }
    if vim.system then
      vim.system(cmd)
    else
      vim.fn.jobstart(cmd, { detach = true })
    end
  end
end, { desc = "Toggle TokyoNight light/dark" })
