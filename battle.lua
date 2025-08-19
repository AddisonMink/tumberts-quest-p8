function battle_module(hp, all_items)
  local w = 16 * 6
  local h = 14 * 3
  local x = 64 - 4 - w / 2
  local y = 64 - 24 - h / 2
  local ready_dur = 0.5
  local start_dur = 0.2
  local enemy_col = 4
  local invincibility_dur = 0.5
  local player = nil
  local entities = {}
  local state = #all_items > 0 and "select_items" or "ready"
  local timer = { t = ready_dur }
  local perfect = true
  local rewards = {}
  local max_items = 3
  local select_items_ui = select_items_ui_module(all_items, max_items)
  local me = {
    enemy_col = 4
  }

  player = add_player(entities, hp, 2, 2)
  player.items = {}
  add_redcap(entities, 4, 1)
  add_scamp(entities, 6, 1)
  for e in all(entities) do
    if e.reward then add(rewards, e.reward) end
  end

  function me:update()
    if state == "select_items" then
      local result = select_items_ui:update()
      if result then
        state = "ready"
        timer.t = ready_dur
        player.items = result
      end
    elseif state == "ready" and tick(timer) then
      state = "start"
      timer.t = start_dur
    elseif state == "start" and tick(timer) then
      state = "play"
    elseif state == "play" then
      update_system()
      hit_system()
      invincibility_system()
      death_system()
      column_system()
      end_system()
    elseif state == "win" and btnp(5) then
      return { type = "win", hp = player.hp }
    elseif state == "perfect" and btnp(5) then
      local i = flr(rnd(#rewards)) + 1
      local reward = rewards[i]
      return { type = "perfect", reward = reward, hp = player.hp }
    elseif state == "lose" and btnp(5) then
      return { type = "lose", hp = 0 }
    end
    return {}
  end

  function me:draw()
    hud:draw(player.hp, player.items, max_items)
    draw_grid()
    draw_entities()
    if state == "select_items" then
      select_items_ui:draw()
    elseif state == "ready" then
      draw_message("ready!")
    elseif state == "start" then
      draw_message("start!")
    elseif state == "win" then
      draw_message("clear!")
    elseif state == "perfect" then
      draw_message("perfect!")
    elseif state == "lose" then
      draw_message("defeat!")
    end
  end

  function update_system()
    for e in all(entities) do
      if e.update then e:update(enemy_col, player) end
    end
  end

  function hit_system()
    for damager in all(entities) do
      if damager.hurtbox then
        for target in all(entities) do
          local hit = damager.hurtbox == target.hitbox
              and damager.col == target.col
              and damager.row == target.row
              and target.invincible.t <= 0

          if hit then
            local damage = damager.damage or 1
            target.hp -= damage
            target.invincible.t = invincibility_dur
            target.sprite.color = 7
            if target.hitbox == "player" then
              perfect = false
            end
          end
        end
      end
    end
  end

  function invincibility_system()
    for e in all(entities) do
      if e.invincible then
        if tick(e.invincible) then
          e.sprite.color = nil
        end
      end
    end
  end

  function death_system()
    for e in all(entities) do
      if e.hp and e.hp <= 0 then
        del(entities, e)
      end
    end
  end

  function column_system()
    enemy_col = 7
    for e in all(entities) do
      if e.hitbox == "enemy" and e.col < enemy_col then
        enemy_col = e.col
      end
    end
  end

  function end_system()
    if player.hp <= 0 then
      state = "lose"
    else
      for e in all(entities) do
        if e.hitbox == "enemy" then
          return
        end
      end
      state = perfect and "perfect" or "win"
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

  function draw_message(text)
    local tx = x + (w - #text * 4) / 2
    local ty = y + (h - 6) / 2
    print(text, tx + 1, ty + 1, 0)
    print(text, tx, ty, 15)
  end

  function draw_entities()
    for e in all(entities) do
      if e.sprite then
        local ex = x + (e.col - 1) * 16
        local ey = y + (e.row - 1) * 14
        sprite:spr(e.sprite, ex, ey)
        if e.hitbox == "enemy" then
          local hp_x = x + (e.col - 1) * 16 + 6
          local hp_y = y + (e.row - 1) * 14 - 12
          print(e.hp, hp_x, hp_y, 15)
        end
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
    local h = entity.col ~= col
    me:blur(entities, entity.col, entity.row, h)
    entity.col = col
    entity.row = row
  end

  function me:blur(entities, col, row, horizontal)
    local timer = { t = 0.1 }
    local id = horizontal and 12 or 42

    local me = {
      col = col,
      row = row,
      sprite = sprite:mk(id, "big", 0, -6)
    }

    function me:update()
      if tick(timer) then del(entities, me) end
    end

    add(entities, me)
  end

  function me:melee(entities, col, row, sprite, params)
    local timer = { t = params.dur or 0 }

    local me = {
      col = col,
      row = row,
      sprite = sprite,
      hurtbox = params.hurtbox,
      damage = params.damage
    }

    function me:update()
      if tick(timer) then del(entities, me) end
    end

    add(entities, me)
  end

  return me
end