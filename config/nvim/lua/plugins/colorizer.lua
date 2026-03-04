local status_ok, colorizer = pcall(require, "colorizer")
if not status_ok then
  return
end

colorizer.setup({
  filetypes = { "*" },
  user_default_options = {
    RGB = true,          -- #RGB hex codes
    RRGGBB = true,       -- #RRGGBB hex codes
    names = false,       -- "Extreme" цветные имена не трогаем
    RRGGBBAA = false,    -- Прозрачность в терминале не работает
    mode = 'background', -- Закрашивать фон
  },
})
