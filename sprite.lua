function sprite_module()
  local me = {}

  function me:spr(id, shape, x, y, flip_x, color)
    if color then
      for i = 0, 15, 1 do
        pal(i, color)
      end
    end

    local sx = id % 16 * 8
    local sy = flr(id / 16) * 8
    local sw = shape == "tall" and 8 or 16
    local sh = shape == "long" and 8 or 16
    sspr(sx, sy, sw, sh, x, y, sw, sh, flip_x)

    pal()
  end

  return me
end