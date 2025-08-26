function add_jester(entities, col, row)
  local min_jumps, max_jumps = 2, 4
  local jump_delay = 0.1
  local start_delay = 2
  local attack_dur = 2
  local state = "start"
  local timer = { t = start_delay }
  local jumps = 0

  local me = {
    col = col,
    row = row,
    sprite = sprite:mk(74, "big", 0, -8),
    hitbox = "enemy",
    hp = 5,
    invincible = { t = 0 }
  }

  function me:update(enemy_col, player)
    if state == "start" and tick(timer) then
      state = "jump"
      jumps = flr(rnd(max_jumps - min_jumps + 1)) + min_jumps
      timer.t = jump_delay
    elseif state == "jump" and tick(timer) then
      local min_col = max(player.col + 1, 4)
      local col = flr(rnd(6 - min_col + 1)) + min_col
      local row = flr(rnd(3 - 1 + 1)) + 1
      battle_util:blur(entities, me.col, me.row)
      me.col, me.row = col, row
      jumps -= 1
      if jumps <= 0 then
        state = "attack"
        timer.t = attack_dur
        me.sprite.id = 76
        add_jester_flame(entities, col, row, attack_dur)
      else
        timer.t = jump_delay
      end
    elseif state == "attack" and tick(timer) then
      state = "jump"
      jumps = flr(rnd(max_jumps - min_jumps + 1)) + min_jumps
      timer.t = jump_delay
      me.sprite.id = 74
    end
  end

  add(entities, me)
  add_flame_sprite(entities, col - 1, row)
end

function add_jester_flame(entities, col, row, dur)
  local timer = { t = dur / 2 }
  local state = 1

  local me = {
    col = col,
    row = row,
    sprite = sprite:mk(100, "tall", -2, -10)
  }

  function me:update()
    me.sprite.id = flr(time() / 0.2) % 2 == 0 and 100 or 101

    if state == 1 and tick(timer) then
      state = 2
      timer.t = dur / 2
      for c = 1, col - 1, 1 do
        add_fire_trap(entities, c, row, "player")
      end
    elseif state == 2 and tick(timer) then
      del(entities, me)
    end
  end

  add(entities, me)
end

function add_flame_sprite(entities, col, row)
  local move_delay = 1
  local sample_delay = 1.5
  local sample_timer = { t = 0 }
  local move_timer = { t = 0 }
  local target_col, target_row = nil, nil

  local me = {
    col = col,
    row = row,
    sprite = sprite:mk(100, "tall", 4, -8),
    hurtbox = "player"
  }

  function me:update(enemy_col, player)
    me.sprite.id = flr(time() / 0.2) % 2 == 0 and 100 or 101

    if tick(sample_timer) then
      target_col, target_row = player.col, player.row
      sample_timer.t = sample_delay
    end

    if tick(move_timer) then
      local dx = target_col == me.col and 0 or sgn(target_col - me.col)
      local dy = target_row == me.row and 0 or sgn(target_row - me.row)
      if dx ~= 0 then me.col += dx else me.row += dy end
      move_timer.t = move_delay
    end
  end

  add(entities, me)
end