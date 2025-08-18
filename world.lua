function world_module(items, max_items, treasures)
  local state = "enter"
  local nodes = {}
  local from_key = nil
  local to_key = nil
  local move_speed = 0.33 / 2
  local timer = 0
  local timer_max = 0
  local fog = {}
  local node_key = 7 .. "," .. 5
  local inventory_ui = nil
  local add_item_ui = nil
  local battle = nil
  local hp = 10
  local me = {}

  function me:update()
    local node = nodes[node_key]

    if state == "battle" then
      local result = battle:update()
      if result.type == "win" then
        state = "idle"
        hp = result.hp
        mset(node.x, node.y, 49)
      elseif result.type == "perfect" then
        state = "add_item"
        add_item_ui = add_item_ui_module(items, max_items, result.reward)
      elseif result.type == "lose" then
      end
    elseif state == "idle" then
      if btnp(0) and node.left then
        state = "moving"
        from_key = node_key
        to_key = node.left
        node_key = node.left
        timer_max = move_speed * 3
        timer = timer_max
      elseif btnp(1) and node.right then
        state = "moving"
        from_key = node_key
        to_key = node.right
        node_key = node.right
        timer_max = move_speed * 3
        timer = timer_max
      elseif btnp(2) and node.up then
        state = "moving"
        from_key = node_key
        to_key = node.up
        node_key = node.up
        timer_max = move_speed * 2
        timer = timer_max
      elseif btnp(3) and node.down then
        state = "moving"
        from_key = node_key
        to_key = node.down
        node_key = node.down
        timer_max = move_speed * 2
        timer = timer_max
      elseif btnp(4) or btnp(5) then
        state = "inventory"
        inventory_ui = inventory_ui_module(items)
      end
    elseif state == "moving" then
      timer -= 1 / 30
      if timer <= 0 then state = "enter" end
    elseif state == "enter" then
      clear_fog(node)
      local id = mget(node.x, node.y)
      if id == 49 then
        -- empty node
        state = "idle"
      elseif id == 36 then
        -- battle node
        state = "battle"
        battle = battle_module(hp, items)
      elseif id == 5 then
        -- treasure node
        if treasures[node_key] then
          state = "add_item"
          local new_item = treasures[node_key]
          add_item_ui = add_item_ui_module(items, max_items, new_item)
        else
          state = "idle"
          mset(node.x, node.y, 49)
        end
      elseif id == 37 then
        -- home node
        state = "idle"
      end
    elseif state == "inventory" then
      if inventory_ui:update() == "cancel" then
        state = "idle"
        inventory_ui = nil
      end
    elseif state == "add_item" then
      local result = add_item_ui:update()
      if result then
        state = "idle"
        mset(node.x, node.y, 49)
      end
    end
  end

  function me:draw()
    map()
    hud:draw(hp, items)
    draw_fog()

    if state == "battle" then
      battle:draw()
    elseif state == "inventory" then
      inventory_ui:draw()
    elseif state == "add_item" then
      add_item_ui:draw()
    elseif state == "moving" then
      local t = (timer_max - timer) / timer_max
      draw_player_between(nodes[from_key], nodes[to_key], t)
    else
      draw_player_at(nodes[node_key])
    end
  end

  function clear_fog(node)
    for x = max(0, node.x - 3), min(node.x + 3, 14), 1 do
      for y = max(0, node.y - 2), min(node.y + 2, 12), 1 do
        local dist = abs(node.x - x) + abs(node.y - y)
        if dist <= 3 then fog[x][y] = false end
      end
    end
  end

  function draw_fog()
    for x = 0, 14, 1 do
      for y = 0, 12, 1 do
        if fog[x][y] then
          spr(52, x * 8, y * 8)
        end
      end
    end
  end

  function draw_player_between(node1, node2, t)
    local x = node1.x + (node2.x - node1.x) * t
    local y = node1.y + (node2.y - node1.y) * t
    draw_player(x * 8, y * 8)
  end

  function draw_player_at(node)
    local x = node.x * 8
    local y = node.y * 8
    draw_player(x, y)
  end

  function draw_player(x, y)
    local frame = flr(time() * 4) % 4
    local id = frame == 0 and 4
        or frame == 1 and 20
        or frame == 2 and 4
        or frame == 3 and 20
    local flip_x = frame == 3
    spr(id, x, y, 1, 1, flip_x)
  end

  function is_path(x, y)
    local s = mget(x, y)
    return s == 34 or s == 50
  end

  -- initialization
  camera(-4, -24)

  -- for each node
  for x = 1, 13, 3 do
    for y = 1, 11, 2 do
      local key = x .. "," .. y
      nodes[key] = { x = x, y = y }
      local node = nodes[key]
      -- check right path
      if is_path(x + 1, y) and is_path(x + 2, y) then
        node.right = (x + 3) .. "," .. y
      end
      -- check left path
      if is_path(x - 1, y) and is_path(x - 2, y) then
        node.left = (x - 3) .. "," .. y
      end
      -- check up path
      if is_path(x, y - 1) then
        node.up = x .. "," .. (y - 2)
      end
      -- check down path
      if is_path(x, y + 1) then
        node.down = x .. "," .. (y + 2)
      end
    end

    -- fill area with fog.
    for x = 0, 14, 1 do
      fog[x] = {}
      for y = 0, 12, 1 do
        fog[x][y] = true
      end
    end
  end

  -- initialization end

  return me
end