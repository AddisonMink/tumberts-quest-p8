function add_redcap(entities, col, row)
  local move_delay = 0.4
  local attack_cd = 0.4
  local windup_dur = 0.4
  local attack_dur = 0.4
  local axe_sprite = sprite:mk(26, "long", 0, 1, true)
  local axe_params = { dur = attack_dur }

  local state = "idle"
  local next_row = nil
  local timer = { t = 0 }
  local cooldown = { t = 0 }

  local me = {
    col = col,
    row = row,
    sprite = sprite:mk(14, "big", 0, -6),
    hitbox = "enemy",
    hp = 3,
    invincible = { t = 0 }
  }

  function me:update(enemy_col, player)
    if state == "idle" and can_attack(player) then
      state = "windup"
      timer.t = windup_dur
      me.sprite.id = 44
    elseif state == "idle" and me.row ~= player.row then
      state = "moving"
      timer.t = move_delay
      next_row = me.row + sgn(player.row - me.row)
    elseif state == "moving" and me.row == player.row then
      state = "idle"
    elseif state == "moving" and tick(timer) then
      state = "idle"
      battle_util:move(me, entities, enemy_col, col, next_row)
    elseif state == "windup" and tick(timer) then
      state = "attack"
      timer.t = windup_dur
      me.sprite.id = 46
      battle_util:melee(entities, me.col - 1, me.row, axe_sprite, axe_params)
    elseif state == "attack" and tick(timer) then
      state = "idle"
      cooldown.t = attack_cd
      me.sprite.id = 14
    end
  end

  function can_attack(player)
    return me.row == player.row
        and me.col - 1 == player.col
        and tick(cooldown)
  end

  add(entities, me)
end