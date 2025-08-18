function item_module()
  local me = {}

  me.axe = {
    name = "axe",
    desc = "swing axe",
    icon = 33,
    lock = 0.3,
    exec = function(entities, col, row)
      local sprite = sprite:mk(26, "long")
      local params = { dur = 0.3, hurtbox = "enemy", damage = 2 }
      battle_util:melee(entities, col + 1, row, sprite, params)
    end
  }

  return me
end