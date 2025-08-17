function sprite_module()
  local me = {}

  function me:mk(id, shape, offset_x, offset_y, flip_x, color)
    return {
      id = id,
      shape = shape,
      offset_x = offset_x or 0,
      offset_y = offset_y or 0,
      flip_x = flip_x or false,
      color = color
    }
  end

  function me:spr(sprite, x, y)
    x += sprite.offset_x
    y += sprite.offset_y
    if sprite.color then
      for i = 0, 15, 1 do
        pal(i, color)
      end
    end

    local sx = sprite.id % 16 * 8
    local sy = flr(sprite.id / 16) * 8
    local sw = sprite.shape == "tall" and 8 or 16
    local sh = sprite.shape == "long" and 8 or 16
    sspr(sx, sy, sw, sh, x, y, sw, sh, sprite.flip_x)

    pal()
  end

  return me
end