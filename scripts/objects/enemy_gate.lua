enemy_gate = {
    update=function(self) 
        if #enemies==0 then
            mset((self.x/8)+mx,(self.y/8)+my,112)
            add_collect(self.x,self.y)
            del(objects,self) 
        end 
    end
}