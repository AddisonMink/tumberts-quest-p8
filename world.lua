function world_module(items, max_items)
  local state = "enter"
  local nodes = {}
  local fog = {}
  local node_key = 7 .. "," .. 5
  local me = {}

  function me:update()
    if state == "enter" then
      clear_fog(nodes[node_key])
      state = "idle"
    end
  end

  function me:draw()
    map()
    hud:draw(10, items)
    draw_map()
    draw_player(nodes[node_key])
  end

  function clear_fog(node)
    for x = node.x - 3, node.x + 3, 1 do
      for y = node.y - 2, node.y + 2, 1 do
        local dist = abs(node.x - x) + abs(node.y - y)
        if dist <= 3 then fog[x][y] = false end
      end
    end
  end

  function draw_map()
    for x = 0, 14, 1 do
      for y = 0, 12, 1 do
        if fog[x][y] then
          spr(52, x * 8, y * 8)
        end
      end
    end
  end

  function draw_player(node)
    local frame = flr(time() * 4) % 4
    local id = frame == 0 and 4
        or frame == 1 and 20
        or frame == 2 and 4
        or frame == 3 and 20
    local flip_x = frame == 3
    spr(id, node.x * 8, node.y * 8, 1, 1, flip_x)
  end

  function is_path(x, y)
    local s = mget(x, y)
    return s == 34 or s == 50
  end

  -- initialization
  camera(-4, -24)

  -- for each node
  for x = 1, 14, 3 do
    for y = 5, 14, 2 do
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