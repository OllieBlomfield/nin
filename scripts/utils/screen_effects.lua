function screen_shake()
    local fade = 0.95
    offset=0.15
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

--scales some text, used for title. From bbs morningtoast
function scale_text(str,x,y,c,scale)
	memcpy(0x4300,0x0,0x0200)
	memset(0x0,0,0x0200)
	poke(0x5f55,0x00)
	print(str,0,0,7)
	poke(0x5f55,0x60)

	local w,h = #str*4,5
	pal(7,c)
	palt(0,true)
	sspr(0,0,w,h,x,y,w*scale,h*scale)
	pal()

	memcpy(0x0,0x4300,0x0200)
end