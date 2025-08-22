function add_cutthroat(entities, col, row)
  local attack_cd = 0
  local windup_dur = 0.5
  local attack_dur = 0.5
  local knife_sprite = sprite:mk(104, "long")
  local knife_params = { dur = attack_dur, hurtbox = "player" }

  local state = "idle"
  local old_col = nil
  local timer = { t = 0 }
  local cooldown = { t = 0 }
  local post = nil

  local me = {
    col = col,
    row = row,
    sprite = sprite:mk(70, "big", 0, -6),
    hitbox = "enemy",
    hp = 3,
    invincible = { t = 0 },
    reward = items.axe
  }

  local function can_attack(player)
    return tick(cooldown)
        and me.row == player.row
        and player.col > 1
  end

  function me:update(enemy_col, player)
    if state == "idle" and can_attack(player) then
      state = "windup"
      battle_util:blur(entities, me.col, me.row)
      old_col = me.col
      post = add_post(entities, me.col, me.row)
      me.col = player.col - 1
      me.sprite.id = 102
      me.no_claim = true
      timer.t = windup_dur
    elseif state == "windup" and tick(timer) then
      state = "attack"
      me.sprite.id = 72
      timer.t = attack_dur
      battle_util:melee(entities, me.col + 1, me.row, knife_sprite, knife_params)
    elseif state == "attack" and tick(timer) then
      state = "idle"
      me.sprite.id = 70
      cooldown.t = attack_cd
      battle_util:blur(entities, me.col, me.row)
      me.col = old_col
      me.no_claim = nil
      del(entities, post)
    end
  end

  function me:die()
    if post then del(entities, post) end
  end

  add(entities, me)
end

function add_post(entities, col, row)
  local me = {
    col = col,
    row = row,
    sprite = sprite:mk(120, "long", 0, 2),
    hitbox = "enemy"
  }

  add(entities, me)
  return me
end