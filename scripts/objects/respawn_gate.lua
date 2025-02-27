respawn_gate={
    update=function(self)
        if coll(plr,self) then rsp={self.x,self.y} end
    end
}