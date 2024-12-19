function add_collect(x,y)
    for i=1,20 do
        add(collects,{
            x=x,
            y=y,
            l=rnd(20)+10,
            dx=rnd(1)-0.5,
            dy=rnd(2)
        })
    end
end

function collect_update()
    for c in all(collects) do
        if c.l<=0 then del(collects,c) end
        c.dy-=0.1
        c.l-=1
        c.x+=c.dx
        c.y-=c.dy
    end
end