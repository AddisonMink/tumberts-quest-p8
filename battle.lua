function battle_module()
  local w = 16 * 6
  local h = 14 * 3
  local x = 64 - 4 - w / 2
  local y = 64 - 24 - h / 2
  local enemy_col = 4
  local player = nil
  local entities = {}
  local me = {}

  local player = { col = 2, row = 2, sprite = sprite:mk(38, "big", 0, -6) }
  add(entities, player)

  function me:update() end

  function me:draw()
    draw_grid()
    draw_entities()
  end

  function draw_grid()
    for col = 1, 6, 1 do
      local id = col < enemy_col and 6 or 8
      for row = 1, 3, 1 do
        sprite:spr(sprite:mk(id, "big"), x + (col - 1) * 16, y + (row - 1) * 14)
      end
    end
  end

  function draw_entities()
    for e in all(entities) do
      if e.sprite then
        local ex = x + (e.col - 1) * 16
        local ey = y + (e.row - 1) * 14
        sprite:spr(e.sprite, ex, ey)
      end
    end
  end

  return me
end