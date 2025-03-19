function update_en_vx(obj, dir)
    if obj.vx != 0 then obj.vx*=0.91 end
    obj.vx = 0.6*dir

    if obj.vx < 0 and collide_map(obj,"left",2)then
        obj.vx=0
    elseif obj.vx > 0 and collide_map(obj,"right",2) then
        obj.vx=0
    end
end

function can_see_plr(obj, dir) --and not collide_map_raycast(plr,obj) (removed for space, add back to end of both if statements if enough space at end)
    if obj.y-16<= plr.y and obj.y+8 >= plr.y and plr.respawn_state==0 then
        if dir > 0 and (obj.x <= plr.x and obj.x + 35 >= plr.x) then
            return true
        elseif dir < 0 and (obj.x >= plr.x and obj.x - 35 <= plr.x) then
            return true
        end
    end
    return false
end

function add_enemy(x,y,st,d)
    if not cleared then
        --st = st or 1
        --d = d or 1
        add(enemies, {
            x=x,
            y=y,
            h=8,
            w=8,
            sp=32,
            vx=0,
            vy=0,
            grounded = false,
            patrol_dir = 1,
            chase_dir = 1,
            max_vx=0.9,
            hp = 1,
            d = d or 1,
            og_state = 1,
            state = st or 1, --0 for idle, 1 for patrolling, 2 for chasing
        })
    end
end

function enemy_update()
    for e in all(enemies) do
        if e.state == 0 then
            if can_see_plr(e, e.d) then e.state = 2 end
        elseif e.state == 1 then
            --state logic
            update_en_vx(e, e.patrol_dir*0.5)
            if e.vx == 0 then e.patrol_dir*=-1 end
            
            --change state logic
            if can_see_plr(e, e.patrol_dir) then e.state = 2 end
            
        elseif e.state == 2 then
            --state logic
            
            update_en_vx(e, sgn(plr.x - e.x))
            add_dust(e.x+2,e.y+8,3)
            
            --change state logic
            if not can_see_plr(e, sgn(plr.x - e.x)) then e.state = 1 end
        end
        --[[if e.vx < 0 then
            if collide_map(e,"left",2) then
                e.vx=0
            end
        elseif e.vx > 0 then
            if collide_map(e,"right",2) then
                e.vx=0
            end
        end]]
        --if (e.vx > 0 and collide_map(e,"right",2)) or (e.vx < 0 and collide_map(e,"left",2)) then e.vx=0 end

        --logic regardless of state
        if e.hp <= 0 then
            add_blood(e.x+4,e.y+4,20)
            sfx(24,2)
            del(enemies,e)
        end
        if coll(e, plr) and plr.inv == 0 and not wpn.attacking then
            damage(plr,1)
        end

        --can't remember what this fixes but it breaks spawn direction so come back and fix later :)
        
        if e.vx > 0 then 
            e.d = 1 
        elseif e.vx < 0 then
            e.d = -1
        end

        

        if e.x>128 or e.x<0 or e.y>128 then del(enemies,e) end
        
        --update_en_vy(self)
        e.vy = max(e.vy-0.25, MAX_Y_DECEL)
        if e.vy < 0 then
            if collide_map(e, "down", 0) then
                e.vy,e.grounded=0,true
                e.y-=((e.y+e.h+1)%8)-1
            end
        end

        e.y-=e.vy
        e.x+=e.vx
    end
end

function enemy_draw()
    for e in all(enemies) do
        pal(15,8)
        pal(13,8)
        pal(9,8)
        pal(7,4)
        spr(e.sp,e.x,e.y,1,1, e.d < 0)
        if e.state==2 then
            spr(48, e.x + 3, e.y-8)
        end
        e.sp = e.state==0 and (t%120>60 and 16 or 17) or (t%18>9 and 18 or 19)
        pal(7,7)
    end
end

