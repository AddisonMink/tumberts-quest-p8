function item_module()
  local me = {}

  me.axe = {
    name = "axe",
    desc = "x2 damage",
    icon = 33,
    lock = 0.3,
    exec = function(entities, col, row)
      local sprite = sprite:mk(26, "long")
      local params = { dur = 0.3, hurtbox = "enemy", damage = 2 }
      battle_util:melee(entities, col + 1, row, sprite, params)
    end
  }

  me.bow = {
    name = "bow",
    desc = "projectile",
    icon = 48,
    lock = 1,
    exec = function(entities, col, row)
      add_bow(entities, col, row, 1, "enemy")
    end
  }

  me.staff = {
    name = "staff",
    desc = "fire col 2 ahead",
    icon = 53,
    lock = 1,
    exec = function(entities, col, row)
      if col + 3 > 6 then return end
      for r = 1, 3, 1 do
        add_fire_trap(entities, col + 3, r, "enemy")
      end
    end
  }

  return me
end