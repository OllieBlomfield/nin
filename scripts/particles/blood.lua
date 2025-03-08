drip = {}
function add_blood_drip(x,y)
    for i=1,3 do
        add(drip,{
            og_y=y,
            x=x,
            y=y,
            vy=0,
            fall=false
        })
    end
end

function drip_update()
    for d in all(drip) do
        if not d.fall and t%200==flr(rnd(200)) then d.fall = true end
        if d.fall then
            d.vy=max(d.vy+0.01,0.5)
            d.y+=d.vy
            if d.y > 128 then
                d.vy=0
                d.y=d.og_y
                d.fall=false
            end
        end
    end
end

function add_blood(x,y,n,al,v)
    for i=1,n do
        al = al or 0
        v = v or 0
        add(bloods, {
            x=x,
            y=y,
            vx=rnd(1)-0.5,
            vy=rnd(1)+v,
            l=rnd(35) + al
        })
    end
end

function blood_update()
    for b in all(bloods) do
        b.vy-=0.03
        b.l-=1
        b.y-=b.vy
        b.x+=b.vx
        if b.l<=0 then
            add(splat,{
                x=b.x,
                y=b.y,
                ln=rnd(7)+1
            })
            del(bloods,b)
        end
    end
end

function blood_draw()
    for b in all(bloods) do
        pset(b.x,b.y,8)
    end
    for s in all(splat) do
        line(s.x,s.y,s.x,s.y+s.ln,8)
    end
end
