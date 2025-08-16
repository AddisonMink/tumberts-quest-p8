-- returns nil if ongoing
-- returns an array of items if complete
function add_item_ui_module(items, max_items, new_item)
  local state = "new-item"
  local index = 1
  local me = {}

  function me:update()
    if state == "new-item" then
      index, result = ui:update_yes_no_menu(index)
      if result == "confirm" then
        if #items < max_items then
          add(items, new_item)
          return items
        else
          state = "inventory-full"
          index = 1
        end
      elseif result == "cancel" then
        return items
      end
    elseif state == "inventory-full" then
      index, result = ui:update_yes_no_menu(index)
      if result == "confirm" then
        state = "replace-item"
        index = 1
      elseif result == "cancel" then
        state = "new-item"
        index = 1
      end
    elseif state == "replace-item" then
      if btnp(2) then
        index = ui:prev(index, #items)
      elseif btnp(3) then
        index = ui:next(index, #items)
      elseif btnp(4) then
        state = "inventory-full"
        index = 1
      elseif btnp(5) then
        items[index] = new_item
        return items
      end
    end
  end

  function me:draw()
    if state == "new-item" then
      draw_new_item(index)
    elseif state == "inventory-full" then
      draw_new_item(-1)
      draw_inventory_full(index)
    elseif state == "replace-item" then
      draw_new_item(-1)
      draw_inventory_full(-1)
      draw_replace_item(index)
    end
  end

  function draw_new_item(index)
    local w = 64
    local info_h = 12
    local item_h = 32
    local confirm_h = 30
    local h = info_h + item_h + confirm_h + ui.radius * 4
    local x = (128 - w) / 2
    local y = (128 - h) / 2

    y = ui:draw_npatch(x, y, w, info_h)
    y = ui:draw_line("found an item!", x, y, w)
    y += ui.radius
    y = ui:draw_npatch(x, y, w, item_h)
    y = ui:draw_line(new_item.name, x, y, w)
    y = ui:draw_line(new_item.desc, x, y, w)
    y += ui.radius * 4
    y = ui:draw_npatch(x, y, w, confirm_h)
    y = ui:draw_line("take it?", x, y, w)
    ui:draw_yes_no_menu(x, y, index, w)
  end

  function draw_inventory_full(index)
    local w = 76
    local h = 38
    local x = (128 - w) / 2
    local y = (128 - h) / 2
    y = ui:draw_npatch(x, y, w, h)
    y = ui:draw_line("inventory full!", x, y, w)
    y = ui:draw_line("replace an item?", x, y, w)
    ui:draw_yes_no_menu(x, y, index, w)
  end

  function draw_replace_item(index)
    local w = 76
    local h = 64
    local x = (128 - w) / 2
    local y = (128 - h) / 2

    y = ui:draw_npatch(x, y, w, h)
    y = ui:draw_line("drop which item?", x, y, w)
    y = ui:draw_menu(x, y, items, index)
  end

  return me
end