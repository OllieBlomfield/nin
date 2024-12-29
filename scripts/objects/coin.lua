collected={}
coin_anim={6,7,8,9,8,7}
coin = {
    update=function(self)
        if coll(plr,self) then
            plr.temp_collect=true  
        end

        if plr.temp_collect and plr.grounded then
            plr.temp_collect=false
            add_collect(plr.x-(plr.vx*3),plr.y+(plr.vy*3))
            collected[lvl]=true
            del(objects,self)
        end
    end,

    draw=function(self)
        if not plr.temp_collect then
            spr(coin_anim[self.frame],self.x,self.y)
        else
            spr(coin_anim[self.frame],plr.x-(plr.vx*3),plr.y+(plr.vy*3))
        end
        if t%10==9 then
            if self.frame<6 then
                self.frame+=1
            else
                self.frame = 1
            end
        end
    end
}