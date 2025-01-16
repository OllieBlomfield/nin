function snow_init()
    for i=1,80 do
        add(snow,{
            x=rnd(128),
            y=rnd(128),
            s=rnd(10),
            spd=flr(rnd(2))
        })
    end
end

function snow_update()
    for s in all(snow) do
        s.y+=s.s/40
        s.x+=sin(t/1200)/4-s.spd/4
        if s.y>128 then s.y=-2 end
        if s.x>128 then s.x=0 end
        if s.x<0 then s.x=128 end
    end
end

function snow_draw()
    snow_update()
    for s in all(snow) do
        --if s.s>8 then rectfill(s.x,s.y,s.x+1,s.y+1,7)
        --else pset(s.x,s.y,7) end
        pset(s.x,s.y,7)
    end
end