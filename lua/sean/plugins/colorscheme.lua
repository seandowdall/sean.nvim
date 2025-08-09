return {
  "folke/tokyonight.nvim",
  priority = 1000,
  config = function()
    local transparent = false -- set to true if you would like to enable transparency

    local function is_light_background()
      return vim.o.background == "light"
    end

    local function notify_wezterm_of_theme()
      local theme = is_light_background() and "light" or "dark"
      if vim.fn.executable("wezterm") == 1 then
        local cmd = { "wezterm", "cli", "set-user-var", "NVIM_THEME", theme }
        if vim.system then
          vim.system(cmd)
        else
          vim.fn.jobstart(cmd, { detach = true })
        end
      end
    end

    local bg = "#011628"
    local bg_dark = "#011423"
    local bg_highlight = "#143652"
    local bg_search = "#0A64AC"
    local bg_visual = "#275378"
    local fg = "#CBE0F0"
    local fg_dark = "#B4D0E9"
    local fg_gutter = "#627E97"
    local border = "#547998"

    require("tokyonight").setup({
      transparent = transparent,
      styles = {
        sidebars = transparent and "transparent" or (is_light_background() and "normal" or "dark"),
        floats = transparent and "transparent" or (is_light_background() and "normal" or "dark"),
      },
      on_colors = function(colors)
        -- Only apply custom dark palette when using a dark background
        if is_light_background() then
          return
        end
        colors.bg = bg
        colors.bg_dark = transparent and colors.none or bg_dark
        colors.bg_float = transparent and colors.none or bg_dark
        colors.bg_highlight = bg_highlight
        colors.bg_popup = bg_dark
        colors.bg_search = bg_search
        colors.bg_sidebar = transparent and colors.none or bg_dark
        colors.bg_statusline = transparent and colors.none or bg_dark
        colors.bg_visual = bg_visual
        colors.border = border
        colors.fg = fg
        colors.fg_dark = fg_dark
        colors.fg_float = fg
        colors.fg_gutter = fg_gutter
        colors.fg_sidebar = fg_dark
      end,
    })

    if is_light_background() then
      vim.cmd("colorscheme tokyonight-day")
    else
      vim.cmd("colorscheme tokyonight")
    end

    notify_wezterm_of_theme()
  end,
}
