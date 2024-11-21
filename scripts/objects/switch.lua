switch_solid=-1
switch_delay=0
switch_block={
    update=function(self)
        if switch_solid==1 then fset(85,7) else fset(85,128) end
    end,
    draw=function(self)
        if switch_solid==1 then pal(5,8) end
        spr(85,self.x,self.y)
        pal(5,5)
    end
}

switch ={
    update=function(self)
        if wpn.attacking and coll(wpn,self) and switch_delay==0 then 
            switch_solid*=-1
            switch_delay=10
        end
    end,
    draw=function(self)
        if switch_solid==1 then spr(99,self.x,self.y) else spr(98,self.x,self.y) end
    end
}