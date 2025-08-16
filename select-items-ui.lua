function select_items_ui_module(items, max_items)
  local state = "select"
  local index = 1
  local selected = {}
  local me = {}

  function me:update()
    if state == "select" then
      if btn(0) or btn(1) then
        state = "hide"
      elseif btnp(2) then
        index = ui:prev(index, #items)
      elseif btnp(3) then
        index = ui:next(index, #items)
      elseif btnp(4) and #selected > 0 then
        local item = selected[#selected]
        del(selected, item)
        add(items, item)
      elseif btnp(5) and #selected < max_items and #items > 0 then
        local item = items[index]
        del(items, item)
        add(selected, item)
        index = 1
      elseif btnp(5) and #selected == max_items or #items == 0 then
        return selected
      end
    elseif state == "hide" then
      state = (btn(0) or btn(1)) and "hide" or "select"
    end
  end

  function me:draw()
    if state == "hide" then return end

    local w = 92
    local h = 64
    local x = (128 - w) / 2
    local y = (128 - h) / 2

    y = ui:draw_npatch(x, y, w, h)
    y = ui:draw_line("select items", x, y, w)
    y += 4

    local new_y = ui:draw_line("items: ", x, y)
    local items_x = x + #"items: " * 4 + 2
    for i = 1, max_items, 1 do
      local x = items_x + (i - 1) * 9
      local id = i <= #selected and selected[i].icon or 32
      spr(id, x, y - 2)
    end
    y = new_y + 4

    y = ui:draw_menu(x, y, items, index, nil, item_line_w, item_line)
  end

  function item_line_w(item)
    local s = item.name .. " - " .. item.desc
    return #s * 4 + 8
  end

  function item_line(x, y, item, color)
    local x = print(item.name, x, y, color)
    spr(item.icon, x + 2, y - 2)
    print(" - " .. item.desc, x + 10, y, color)
  end

  return me
end