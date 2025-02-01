fire_cols={8,8,8,8,8,7,7,7}
fire={}

function add_fire(x,y)
    for i=1,20 do
        add(fire,{
            x=x*(i/2),
            y=y+rnd(2),
            og_x=x+(i/2),
            og_y=y,
            c=8,
            l=60,
            ep=5+x
        })
    end
end

function fire_update()
    for f in all(fire) do
        f.y-=0.2
        f.x+=rnd(2)-1
        f.l-=1
        if f.l==0 then
            f.x=f.og_x
            f.y=f.og_y+rnd(2)
            f.c=8
            f.l=60
            f.ep=5+f.og_x
        end
    end
end

