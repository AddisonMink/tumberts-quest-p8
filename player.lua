function add_player(entities, col, row)
  local attack_dur = 0.2
  local attack_cd_max = 0.2
  local lock = { t = 0 }
  local cooldown = { t = 0 }
  local sword_sprite = sprite:mk(10, "long", -1, 1)
  local sword_params = { dur = attack_dur }

  local me = {
    col = col,
    row = row,
    sprite = sprite:mk(38, "big", 0, -6),
    player = true
  }

  function me:update(enemy_col)
    if not tick(lock) then return end
    tick(cooldown)
    me.sprite.id = 38

    if btnp(0) and lock.t <= 0 then
      move(-1, 0, enemy_col)
    elseif btnp(1) and lock.t <= 0 then
      move(1, 0, enemy_col)
    elseif btnp(2) and lock.t <= 0 then
      move(0, -1, enemy_col)
    elseif btnp(3) and lock.t <= 0 then
      move(0, 1, enemy_col)
    elseif btnp(4) then
    elseif btnp(5) and lock.t <= 0 and cooldown.t <= 0 then
      lock.t = attack_dur
      cooldown.t = attack_cd_max
      me.sprite.id = 40
      battle_util:melee(entities, me.col + 1, me.row, sword_sprite, sword_params)
    end
  end

  function move(dx, dy, enemy_col)
    battle_util:move(me, entities, enemy_col, me.col + dx, me.row + dy)
  end

  add(entities, me)
  return me
end