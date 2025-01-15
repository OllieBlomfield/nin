blood = {
    x=0,
    y=0,
    lns={}, --lines
    splat={},
    --shake=true,

    new=function(self, tbl, n, al, v)
        al=al or 0
        v=v or 0
        tbl=tbl or {}
        setmetatable(tbl,{__index=self})
        for i=1,n do
            add(self.splat,{
                x=tbl.x,
                y=tbl.y,
                lines=tbl.lines,
                vx=rnd(1)-0.5,
                vy=rnd(1)+v,
                l=rnd(35) + al,
                --c=flr(rnd(2)+1)*4
                c=8
            })
        end
        return tbl
    end,

    update=function(self)
        for s in all(self.splat) do
            s.vy-=0.03
            s.l-=1
            s.y-=s.vy
            s.x+=s.vx
            if s.l<=0 then
                if s.lines then self:add_blood_lines(s.x,s.y,s.c) end
                del(self.splat,s)
            end
            if s.y>128 or s.x>128 or s.x<0 then
                del(self.splat,s)
            end
        end
    end,

    draw=function(self)
        --print(#self.splat)
        for s in all(self.splat) do
            pset(s.x,s.y,s.c)
        end
        for b in all(self.lns) do
            local ty=b.y
            local tx=b.x
            line(tx,ty,tx,ty+b.ln,b.c)
        end
    end,

    add_blood_lines=function(self,x,y,cl)
        add(self.lns,{
            x=x,
            y=y,
            ln=flr(rnd(7))+1,
            c=cl
        })
    end

}

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
        if not d.fall and t%120==flr(rnd(120)) then d.fall = true end
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

