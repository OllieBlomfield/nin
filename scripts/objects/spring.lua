spring={
    update=function(self) 
        if coll(plr,self) then
            self.frame=0
            if plr.gp then
                plr.vy=6
                plr.gp=false
            else
                plr.vy=4.1
            end
        end
    end,
    draw = function(self)
        if flr(self.frame)==0 then 
            --spr(73,self.x,self.y)
            self.frame+=0.1
        else 
            --sspr(72,32,8,2,self.x,self.y+(self.frame*5))
            self.frame=1
            --pset(self.x+3,self.y+6,7)
        end
        sspr(72,34+(self.frame*2),8,6-(self.frame*2),self.x,self.y+2+(self.frame*2))
        spr(73,self.x,self.y+(self.frame*4),1,0.25)
        line(self.x+1,self.y+7,self.x+6,self.y+7,7)
        
        
    end
}