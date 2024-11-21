coin_anim={6,7,8,9,8,7}
coin = {
    update=function(self)
        if coll(plr,self) then
            del(objects,self)
        end
    end,

    draw=function(self)
        spr(coin_anim[self.frame],self.x,self.y)
        if t%10==9 then
            if self.frame<6 then
                self.frame+=1
            else
                self.frame = 1
            end
        end
    end
}