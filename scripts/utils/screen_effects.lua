function screen_shake()
    local fade = 0.95
    offset_x=8-rnd(16)
    offset_y=8-rnd(16)
    offset_x*=offset
    offset_y*=offset
    
    camera(offset_x,offset_y)
    offset*=fade
    if offset<0.05 then
      offset=0
      return true
    end
    return false
end