spike = { 
    update=function(self)
        if coll(self,plr) and plr.respawn_state==0 then plr.respawn_state=1 end
        for e in all(enemies) do
            if coll(self,e) then
                e.hp=0
            end
        end
    end,
    --[[draw=function(self)
        rect(self.x,self.y,self.x+self.w,self.y+self.h,14)
    end--]]
}