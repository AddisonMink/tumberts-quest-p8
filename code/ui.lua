function ui_module()
  local radius = 4
  local sw = 16
  local id = 1

  local me = { radius = 4 }

  function me:next(i, n) return (i % n) + 1 end
  function me:prev(i, n) return i == 1 and n or i - 1 end

  function me:draw_line(text, x, y, w)
    local offset = w and (w - #text * 4) / 2 or radius
    print(text, x + offset, y, 15)
    return y + 8
  end

  function me:update_yes_no_menu(index)
    if btnp(2) then
      return ui:prev(index, 2), nil
    elseif btnp(3) then
      return ui:next(index, 2), nil
    elseif btnp(4) then
      return index, "cancel"
    elseif btnp(5) then
      return index, index == 1 and "confirm" or "cancel"
    end
    return index, nil
  end

  function me:draw_yes_no_menu(x, y, index, w)
    local items = { { name = "yes" }, { name = "no" } }
    me:draw_menu(x, y, items, index, w)
  end

  function me:draw_menu(x, y, items, index, w, width_f, line_f)
    width_f = width_f or function(item) return #item.name * 4 end

    line_f = line_f or function(x, y, item, color)
      print(item.name, x, y, color)
    end

    local offset = radius
    if w then
      local my_w = 0
      for i in all(items) do
        my_w = max(my_w, radius + 8 + width_f(i))
      end
      offset = (w - my_w) / 2
    end

    for i, item in ipairs(items) do
      local color = index == i and 7 or 15
      local id = index == i and 16 or 0
      spr(id, x + offset, y - 1)
      line_f(x + offset + 8, y, item, color)
      y += 9
    end
    return y
  end

  function me:draw_npatch_with_title(x, y, w, h, title)
    local title_w = #title * 4 + radius * 2
    me:draw_npatch(x, y, w, h)
    me:draw_npatch(x + radius, y - radius * 1.5, title_w, radius * 3)
    print(title, x + radius * 2, y - radius / 2, 15)
  end

  function me:draw_npatch(x, y, w, h)
    local w = max(w, radius * 2)
    local h = max(h, radius * 2)
    local right_x = x + w - radius
    local bot_y = y + h - radius
    local middle_w = w - radius * 2
    local middle_h = h - radius * 2
    local sx, sy = sprite_coords(id)
    local middle_sx = sx + radius
    local middle_sy = sy + radius
    local right_sx = sx + sw - radius
    local bot_sy = sy + sw - radius
    local middle_sw = sw - radius * 2
    local middle_sh = sw - radius * 2
    sspr(sx, sy, radius, radius, x, y)
    sspr(middle_sx, sy, middle_sw, radius, x + radius, y, middle_w, radius)
    sspr(right_sx, sy, radius, radius, right_x, y)
    sspr(sx, middle_sy, radius, middle_sh, x, y + radius, radius, middle_h)
    sspr(middle_sx, middle_sy, middle_sw, middle_sh, x + radius, y + radius, middle_w, middle_h)
    sspr(right_sx, middle_sy, radius, middle_sh, right_x, y + radius, radius, middle_h)
    sspr(sx, bot_sy, radius, radius, x, bot_y)
    sspr(middle_sx, bot_sy, middle_sw, radius, x + radius, bot_y, middle_w, radius)
    sspr(right_sx, bot_sy, radius, radius, right_x, bot_y)
    return y + radius
  end

  function sprite_coords(id)
    local x = (id % 16) * 8
    local y = (id / 16) * 8
    return x, y
  end

  return me
end