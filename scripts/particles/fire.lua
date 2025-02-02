fire_cols={8,8,8,8,8,7,7,7}
fire={}

function fire_add(x,y)
    if t%2==0 then
        for i=1,5 do
            add(fire,{
                x=x+rnd(4),
                y=y+rnd(6),
                c=7,
                r=rnd(2.5),
                l=18,
                spd=1+rnd(2)
            })
        end
    end
end

function fire_update()

    if t%2==0 then 
        --[[for i=1,5 do
            add(fire,{
                x=x+rnd(4),
                y=y+rnd(6),
                c=7,
                r=rnd(2.5),
                l=18,
                spd=1+rnd(2)
            })
        end--]]
    --end
        for f in all(fire) do
            f.y-=f.spd/2.8
            f.l-=1
            f.r-=0.1
            --f.x+=1
            if f.l<16 then 
                f.c=8
            end 
            if f.l<9 then 
                f.c=4
            end
            --[[if f.l<3 then
                f.c=6
            end--]]
            if f.l<0 then del(fire,f) end
        end
    end
end

