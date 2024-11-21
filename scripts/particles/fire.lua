fire_cols={8,8,8,8,8,7,7,7}

fire = {
    x=0,
    y=0,
    parts={},


    new=function(self, tbl)
        tbl=tbl or {}
        setmetatable(tbl,{__index=self})
        for i=8,0,-1 do
            add(self.parts,{
                x=tbl.x,
                y=tbl.y+i*2,
                s=3,
                sp=rnd(3)/10,
                l=i
            })
        end
        return tbl
    end,

    update=function(self)
        for f in all(self.parts) do
            f.l-=0.05+rnd(2)/100
            f.y-=0.2
            --f.s-=f.sp
            --f.s=flr(f.l)
            if f.l<=0 then
                f.x=self.x
                f.y=self.y
                f.s=3
                f.l=6
            end
        end
    end,

    draw=function(self)
        
        for f in all(self.parts) do
            --spr(32,f.x,10)
            circfill(f.x,f.y,f.s,8)
        end
    end
}

