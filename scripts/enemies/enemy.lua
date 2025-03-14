enemy = {
    x=0,
    y=0,
    h=8,
    w=8,
    sp=32,
    vx=0,
    vy=0,
    grounded = false,
    patrol_dir = 1,
    sight_range = 35,
    chase_dir = 1,
    max_vx=0.9,
    alert=false,
    hp = 1,
    d = 1,
    og_state = 1,
    state = 1, --0 for idle, 1 for patrolling, 2 for chasing


    new=function(self,tbl)
        tbl=tbl or {}
        setmetatable(tbl,{__index=self})
        return tbl
    end,

    update=function(self,tbl)
        if self.state == 0 then
            if can_see_plr(self, self.d) then self.state = 2 end
        elseif self.state == 1 then
            --state logic
            update_en_vx(self, self.patrol_dir*0.5)
            if self.vx == 0 then self.patrol_dir*=-1 end
            
            --change state logic
            if can_see_plr(self, self.patrol_dir) then self.state = 2 end
            
        elseif self.state == 2 then
            --state logic
            
            update_en_vx(self, sgn(plr.x - self.x))
            add_dust(self.x+2,self.y+8,3)
            
            --change state logic
            if not can_see_plr(self, sgn(plr.x - self.x)) then self.state = 1 end
        end
        if self.vx < 0 then
            if collide_map(self,"left",2) then
                self.vx=0
            end
        elseif self.vx > 0 then
            if collide_map(self,"right",2) then
                self.vx=0
            end
        end

        --logic regardless of state
        if self.hp <= 0 then
            add_blood(self.x+4,self.y+4,20)
            sfx(10,2)
            del(enemies,self)
        end
        if coll(self, plr) and plr.inv == 0 and not wpn.attacking then
            damage(plr,1)
        end

        --can't remember what this fixes but it breaks spawn direction so come back and fix later :)
        
        if self.vx > 0 then 
            self.d = 1 
        elseif self.vx < 0 then 
            self.d = -1
        end
        

        if self.x>128 or self.x<0 or self.y>128 then del(enemies,self) end
        
        --update_en_vy(self)
        self.vy = max(self.vy-0.25, MAX_Y_DECEL)
        if self.vy < 0 then
            if collide_map(self, "down", 0) then
                self.vy,self.grounded=0,true
                self.y-=((self.y+self.h+1)%8)-1
            end
        end
        self.y-=self.vy

        self.x+=self.vx
    end,

    draw=function(self)
        pal(15,8)
        pal(13,8)
        pal(9,8)
        pal(7,4)
        spr(self.sp,self.x,self.y,1,1, self.d < 0)
        if self.state==2 then
            spr(48, self.x + 3, self.y-8)
        end
        self.sp = self.state==0 and (t%120>60 and 16 or 17) or (t%18>9 and 18 or 19)
        pal(7,7)
    end
}

--[[function animate_enemy(obj)
    --state logic

    --[[if obj.state==0 then
        obj.sp=t%120>60 and 16 or 17
    else
        obj.sp=t%18>9 and 18 or 19
    end

    obj.sp = obj.state==0 and (t%120>60 and 16 or 17) or (t%18>9 and 18 or 19)
end]]

function update_en_vx(obj, dir)
    if obj.vx != 0 then obj.vx*=0.91 end
    obj.vx = 0.6*dir

    if obj.vx < 0 then
        if collide_map(obj,"left",2) then
            obj.vx=0
        end
    elseif obj.vx > 0 then
        if collide_map(obj,"right",2) then
            obj.vx=0
        end
    end
end

function can_see_plr(obj, dir)
    if obj.y-16<= plr.y and obj.y+8 >= plr.y and plr.respawn_state==0 then
        if dir > 0 and (obj.x <= plr.x and obj.x + obj.sight_range >= plr.x) and not collide_map_raycast(plr,obj) then
            return true
        elseif dir < 0 and (obj.x >= plr.x and obj.x - obj.sight_range <= plr.x) and not collide_map_raycast(plr,obj) then
            return true
        end
    end
    return false
end

function add_enemy(x,y,st,d)
    if not cleared then
        st = st or 1
        d = d or 1
        add(enemies, enemy:new({
            x=x,
            y=y,
            og_state=st,
            state=st,
            d=d
        }))
    end
end