function start_ui_module()
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
    local l2 = "flickerwick has spread"
    local l3 = "corruption through the"
    local l4 = "forest and your beloved"
    local l5 = "petunia has taken ill!"
    local l6 = "he must be defeated to"
    local l7 = "lift the curse!"
    local s = sprite:mk(108, "big")

    y = ui:draw_npatch(x, y, w, h)
    y = ui:draw_line("tumbert's quest", x, y, w)
    y += 8
    y = ui:draw_line(l1, x, y, w)
    y = ui:draw_line(l2, x, y, w)
    y = ui:draw_line(l3, x, y, w)
    y = ui:draw_line(l4, x, y, w)
    y = ui:draw_line(l5, x, y, w)
    y = ui:draw_line(l6, x, y, w)
    y = ui:draw_line(l7, x, y, w)
    sprite:spr(s, x + (w - 16) / 2, y)
  end

  return me
end