function snow_init(w,h,n)
    snow_w = w or 128
    snow_h = h or 128
    n = n or 80
    for i=1,n do
        add(snow,{
            x=rnd(snow_w),
            y=rnd(snow_h),
            s=rnd(10),
            spd=flr(rnd(2))
        })
    end
end

function snow_update()
    for s in all(snow) do
        s.y+=s.s/40
        s.x+=(sin(t/1200)-s.spd)/4
        if s.y>snow_h then s.y=-2 end
        if s.x>snow_w then s.x=rnd(snow_w) s.y=-2 end
        if s.x<0 then s.x=snow_w end
    end
end

function snow_draw()
    snow_update()
    for s in all(snow) do
        pset(s.x,s.y,7)
    end
end