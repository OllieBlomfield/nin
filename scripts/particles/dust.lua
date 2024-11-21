function add_dust(x,y,l)
    add(plr_dust,{
        x=x,
        y=y,
        sy=rnd(1),
        l=l,
        c=7
    })
end

function dust_update()
	for s in all(plr_dust) do
		s.y-=s.sy/4
		s.l-=0.5
		if s.l<2 then s.c=6 end
		if s.l==0 then del(plr_dust,s) end
	end
end

--[[dust = particle:new({
    x=10,
    y=10,
})--]]