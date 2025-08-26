function add_witch(entities, col, row)
  local attack_dur = 1.0
  local move_delay = 0.0
  local attack_cd = 2.0

  local move_table = {
    [1] = { 2, 3 },
    [2] = { 1, 3 },
    [3] = { 1, 2 }
  }

  local timer = { t = 0 }
  local cooldown = { t = attack_cd }
  local next_row = nil
  local state = "idle"

  local me = {
    col = col,
    row = row,
    sprite = sprite:mk(98, "big", 0, -6),
    hitbox = "enemy",
    hp = 3,
    invincible = { t = 0 },
    reward = items.staff
  }

  function me:update(enemy_col, player)
    me.sprite.offset_y = flr(time()) % 2 == 0 and -6 or -8
    tick(cooldown)

    if state == "idle" and me.row == player.row then
      local moves = move_table[player.row]
      state = "move"
      timer.t = move_delay
      next_row = moves[flr(rnd(2)) + 1]
    elseif state == "idle" and cooldown.t <= 0 then
      state = "attack"
      timer.t = attack_dur
      add_witch_flame(entities, me.col, me.row, attack_dur, player.col)
    elseif state == "move" and tick(timer) then
      state = "idle"
      battle_util:move(me, entities, enemy_col, me.col, next_row)
    elseif state == "attack" and tick(timer) then
      state = "idle"
      cooldown.t = attack_cd
    end
  end

  add(entities, me)
end

function add_witch_flame(entities, col, row, dur, trap_col)
  local timer = { t = dur / 2 }
  local state = 1

  local me = {
    col = col,
    row = row,
    sprite = sprite:mk(100, "tall", 0, -6)
  }

  function me:update()
    me.sprite.id = flr(time() / 0.2) % 2 == 0 and 100 or 101

    if state == 1 and tick(timer) then
      state = 2
      timer.t = dur / 2
      for r = 1, 3, 1 do
        add_fire_trap(entities, trap_col, r, "player")
      end
    elseif state == 2 and tick(timer) then
      del(entities, me)
    end
  end

  add(entities, me)
end

function add_fire_trap(entities, col, row, hurtbox)
  local start_dur = 0.5
  local burn_dur = 1.0
  local timer = { t = start_dur }
  local state = "start"

  local me = {
    col = col,
    row = row,
    sprite = sprite:mk(82, "long", 0, 0)
  }

  function me:update()
    if state == "start" and tick(timer) then
      state = "burn"
      timer.t = burn_dur
      me.hurtbox = hurtbox
    elseif state == "burn" then
      me.sprite.id = flr(time() / 0.2) % 2 == 0 and 68 or 84
      if tick(timer) then del(entities, me) end
    end
  end

  add(entities, me)
end