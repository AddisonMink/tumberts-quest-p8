function end_ui_module()
  local me = {}

  function me:update()
    return (btnp(4) or btnp(5)) and "cancel" or nil
  end

  function me:draw()
    local w = 108
    local h = 96
    local x = (128 - w) / 2 - 4
    local y = (128 - h) / 2 - 24

    local l1 = "the foul magician"
    local l2 = "flickerwick has been"
    local l3 = "defeated and the curse"
    local l4 = "has been lifted from "
    local l5 = "your beloved rat!"
    local l6 = "petunia thanks you!"
    local s = sprite:mk(106, "big")

    y = ui:draw_npatch(x, y, w, h)
    y = ui:draw_line("the curse is lifted!", x, y, w)
    y += 8
    y = ui:draw_line(l1, x, y, w)
    y = ui:draw_line(l2, x, y, w)
    y = ui:draw_line(l3, x, y, w)
    y = ui:draw_line(l4, x, y, w)
    y = ui:draw_line(l5, x, y, w)
    y = ui:draw_line(l6, x, y, w)
    sprite:spr(s, x + (w - 16) / 2, y)
    spr(79, x + (w - 16) / 2 - 6, y - 2)
  end

  return me
end