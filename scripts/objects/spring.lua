spring={
    update=function(self) 
        if coll(plr,self) and plr.respawn_state==0 then
            self.frame=0
            if plr.gp then
                plr.vy,plr.gp=3.8,false
                sfx(23,3)
            else
                plr.vy=2.4
                sfx(22,3)
            end
            plr.sprung,plr.grounded,plr.jumped=20,false,true
        end
    end,
    draw = function(self)
        self.frame = flr(self.frame)==0 and self.frame+0.1 or 1
        local x,y = self.x,self.y
        sspr(72,34+(self.frame*2),8,6-(self.frame*2),x,y+2+(self.frame*2))
        spr(73,x,y+(self.frame*4),1,0.25)
        line(x+1,y+7,x+6,y+7,7)
    end
}