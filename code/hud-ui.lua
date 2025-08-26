function hud_ui_module()
  local me = {}

  function me:draw(hp, items, max_items)
    local y = ui:draw_npatch(0, -16, 120, 15)
    local item_x = 32
    y += 1
    ui:draw_line("hp:" .. hp, 0, y)
    item_x = ui:draw_line("items:", item_x, y)

    for i = 1, max_items, 1 do
      local id = i <= #items and items[i].icon or 32
      spr(id, item_x + 64 + (i - 1) * 10, y - 2)
    end
  end

  return me
end