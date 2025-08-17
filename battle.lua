function battle_module()
  local w = 16 * 6
  local h = 14 * 3
  local x = 64 - 4 - w / 2
  local y = 64 - 24 - h / 2
  local enemy_col = 4
  local player = nil
  local entities = {}
  local me = {
    enemy_col = 4
  }

  player = add_player(entities, 2, 2)

  function me:update()
    update_system()
  end

  function me:draw()
    draw_grid()
    draw_entities()
  end

  function update_system()
    for e in all(entities) do
      if e.update then e:update(enemy_col) end
    end
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

function battle_util_module()
  local me = {}

  function me:move(entity, entities, enemy_col, col, row)
    if col < 1 or col > 6 or row < 1 or row > 3 then return end
    if entity.player and col >= enemy_col then return end
    entity.col = col
    entity.row = row
  end

  function me:melee(entities, row, col, sprite, params)
    local timer = { t = params.dur or 0 }

    local me = {
      col = col,
      row = row,
      sprite = sprite
    }

    function me:update()
      if tick(timer) then del(entities, me) end
    end

    add(entities, me)
  end

  return me
end