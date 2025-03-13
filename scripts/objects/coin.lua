collected={}
coin_anim={6,7,8,9,8,7}
coin = {
    update=function(self)
        if coll(plr,self) then
            plr.temp_collect=true  
        end

        if plr.temp_collect and plr.grounded then
            new_level, plr.temp_collect, collected[lvl] = false, false, true
            add_collect(plr.x-(plr.vx*3),plr.y+(plr.vy*3))
            coins+=1
            sfx(12,3)
            del(objects,self)
        end
    end,

    draw=function(self)
        spr(coin_anim[(t\10%6)+1],plr.temp_collect and plr.x-(plr.vx*3) or self.x, plr.temp_collect and plr.y+(plr.vy*3) or self.y)
    end
}