switch_solid=-1
switch_delay=0
switch_block={
    update=function(self)
        if switch_solid==1 then fset(85,7) else fset(85,128) end
        if switch_solid==-1 then fset(86,7) else fset(86,128) end
    end,
    draw=function(self)
        if fget(self.h,7) then pal(8,5) end
        spr(self.h,self.x,self.y)
        pal(8,8)
    end
}

switch ={
    update=function(self)
        if wpn.attacking and coll(wpn,self) and switch_delay==0 and mget(mx+(plr.x/16),my+(plr.y/16))!=85 then 
            switch_solid*=-1
            switch_delay=15
        end
    end,
    draw=function(self)
        if switch_solid==1 then spr(99,self.x,self.y) else spr(98,self.x,self.y) end
    end
}