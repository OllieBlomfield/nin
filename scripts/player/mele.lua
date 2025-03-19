function wpn_init() 
    wpn = {
    x=0,
    y=0,
    sp=50,
    attacking = false,
    attack_anim=false,
    w=17,
    h=10,
    drx = 0,
    dry = 0,
    dir = 0, --0/1 right, 2 left, 3 down, 4 up
    dir_boxes_off = {{0,0,10,0},{-9,0,-10,0},{-5,8,-5,8},{-5,-10,-5,-8}}, --amount of offset to apply in x and y direction
    vert_anim={56,57,58,58,57,56},
    vert_off_x=0,
    hor_anim={50,51,52,53,54,55},
    frame=1,
}
end

function player_mele_update()
    if plr.damaged and plr.inv == 0 then
        plr.inv = PLR_INV_TIME
    end

    if plr.inv > 0 then 
        plr.inv-=1 
        if plr.inv==0 then plr.damaged = false end
    end


    --set attacking direction
    if not wpn.attacking then
        wpn.sp,wpn.flp_y=50,0
        if btn(0) then
            wpn.dir=2
        elseif btn(1) then
            wpn.dir=1
        end

        --wpn.flp_y = 0

        if btn(2) then
            wpn.dir,wpn.sp=4,56
            --wpn.sp=56
        end

        if plr.gp then
            wpn.dir=3
        end

        if btnp(5) or plr.gp then
            if not plr.gp then sfx(21,2) end
            if wpn.dir==0 or (wpn.dir==3 and plr.vy==0) then
                --[[if plr.vx < 0 then
                    wpn.dir=2
                else
                    wpn.dir=1
                end]]
                wpn.dir = plr.vx<0 and 2 or 1
            end
            wpn.attacking, wpn.attack_anim = true, true
        end
    end
    if wpn.attacking then
        plr_attack_anim()
        wpn.x, wpn.y, wpn.drx, wpn.dry = plr.x + wpn.dir_boxes_off[wpn.dir][1], plr.y + wpn.dir_boxes_off[wpn.dir][2], plr.x + wpn.dir_boxes_off[wpn.dir][3], plr.y - 2 + wpn.dir_boxes_off[wpn.dir][4]
        for e in all(enemies) do
            if coll(wpn,e) then
                e.hp=0
                add_splat()
            end
        end
    end
end

function weapon_draw()
    if wpn.attacking then
        spr(flr(wpn.sp),wpn.drx+wpn.vert_off_x,wpn.dry, 1, 1, wpn.dir==2 or wpn.frame>=4, wpn.dir==3)
        --rect(wpn.x,wpn.y,wpn.x+wpn.w,wpn.y+wpn.h,14)
        --sfx(10)
    end
end

function plr_attack_anim()
    if wpn.dir==4 or wpn.dir==3 then
        if wpn.frame >= 4 then
            wpn.vert_off_x=8
        end
        if wpn.frame >= 7 then
            wpn.attacking,wpn.frame,wpn.vert_off_x = false,1,0
            --wpn.frame = 1
            --wpn.vert_off_x=0
        end
        wpn.sp=wpn.vert_anim[flr(wpn.frame)]
        if t%2==1 then
            wpn.frame+=1
            
        end
    else
        wpn.sp+=0.7
        if wpn.sp>55.5 then 
            wpn.sp,wpn.attacking=50,false
            --wpn.attacking = false
        end
    end
end

--unused
--[[function closest_to_plr(lst)
    local min_dist = 0
    min_obj = lst[1]
    for l in all(lst) do
        local new_dist = sqrt((plr.x-l.x)^2+(plr.y-l.y)^2)
        if new_dist < min_dist then 
            min_dist=new_dist
            min_obj=l
        end
    end
    return min_obj
end--]]

--TO DO:
--set the location of collide_map_raycast to front of player instead of back. Could use atk object to do this.
--combine atk and wpn