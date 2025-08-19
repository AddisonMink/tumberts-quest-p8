function add_scamp(entities, col, row)
  local move_delay = 0.2
  local attack_cd = 1
  local attack_dur = 1

  local state = "idle"
  local next_row = nil
  local timer = { t = 0 }
  local cooldown = { t = 0 }

  local me = {
    col = col,
    row = row,
    sprite = sprite:mk(96, "big", 0, -6),
    hitbox = "enemy",
    hp = 1,
    invincible = { t = 0 }
  }

  function me:update(enemy_col, player)
    if state == "idle" and me.row == player.row and tick(cooldown) then
      state = "attack"
      timer.t = attack_dur
      add_bow(entities, me.col, me.row, attack_dur)
    elseif state == "idle" and me.row ~= player.row then
      state = "moving"
      timer.t = move_delay
      next_row = me.row + sgn(player.row - me.row)
    elseif state == "moving" and me.row == player.row then
      state = "idle"
    elseif state == "moving" and tick(timer) then
      state = "idle"
      battle_util:move(me, entities, enemy_col, col, next_row)
    elseif state == "attack" and tick(timer) then
      state = "idle"
      cooldown.t = attack_cd
    end
  end

  function can_attack(player)
    return me.row == player.row
        and tick(cooldown)
  end

  add(entities, me)
end

function add_bow(entities, col, row, dur)
  local timer = { t = dur / 2 }
  local state = "draw"
  local me = {
    col = col,
    row = row,
    sprite = sprite:mk(64, "tall", 4, -4, true)
  }

  function me:update()
    if state == "draw" and tick(timer) then
      state = "shoot"
      me.sprite.id = 65
      timer.t = dur / 2
      add_arrow(entities, col, row)
    elseif state == "shoot" and tick(timer) then
      del(entities, me)
    end
  end

  add(entities, me)
end

function add_arrow(entities, col, row)
  local speed = 0.075
  local timer = { t = speed }

  local me = {
    col = col,
    row = row,
    sprite = sprite:mk(66, "long", 0, 0, true),
    hurtbox = "player"
  }

  function me:update()
    if tick(timer) then
      timer.t = speed
      me.col -= 1
      if me.col < 1 then del(entities, me) end
    end
  end

  add(entities, me)
end