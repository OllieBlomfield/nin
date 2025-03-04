spring={
    update=function(self) 
        if coll(plr,self) and plr.respawn_state==0 then
            self.frame=0
            if plr.gp then
                plr.vy,plr.gp=3.8,false
            else
                plr.vy=2.4
            end
            plr.sprung,plr.grounded,plr.jumped=20,false,true
            --plr.grounded=false
            --plr.jumped=true
        end
    end,
    draw = function(self)
        --[[if flr(self.frame)==0 then 
            self.frame+=0.1
        else 
            self.frame=1
        end--]]
        self.frame = flr(self.frame)==0 and self.frame+0.1 or 1
        sspr(72,34+(self.frame*2),8,6-(self.frame*2),self.x,self.y+2+(self.frame*2))
        spr(73,self.x,self.y+(self.frame*4),1,0.25)
        line(self.x+1,self.y+7,self.x+6,self.y+7,7)
    end
}