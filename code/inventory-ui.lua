-- returns nil if ongoing
-- returns cancel is complete
function inventory_ui_module(items)
  local menu_items = {}
  local me = {}

  function me:update()
    return (btnp(4) or btnp(5)) and "cancel" or nil
  end

  function me:draw()
    local w = 92
    local h = 64
    local x = (128 - w) / 2
    local y = (128 - h) / 2 - 24

    y = ui:draw_npatch(x, y, w, h)
    y = ui:draw_line("inventory", x, y, w)
    y += 4
    for i in all(items) do
      local icon_x = x + #i.name * 4 + 2 + ui.radius
      ui:draw_line(i.name, x, y)
      spr(i.icon, icon_x, y - 1)
      y = ui:draw_line("- " .. i.desc, icon_x + 8, y)
      y += 2
    end
  end

  return me
end