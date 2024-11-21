wpn = {
    x=0,
    y=0,
    sp=50,
    attacking = false,
    attack_anim=false,
    w=17,
    h=10,
    off_x=10,
    off_y=0,
    drx = 0,
    dry = 0,
    dir = 0,
    dir_boxes_off = {{0,0,10,0},{-9,0,-10,0},{-5,8,-5,8},{-5,-10,-5,-8}}, --amount of offset to apply in x and y direction
    vert_anim={56,57,58,58,57,56},
    vert_off_x=0,
    hor_anim={50,51,52,53,54,55},
    frame=1,
}

ATK_BUFFER = 10
atk = {
    x=0,
    y=0,
    w=50,
    h=40,
    in_range={},
    buffer=0
}

ray_point={x=0,y=0}

function player_mele_update()
    ray_point = {x=plr.x+8,y=plr.y}
    atk.x = plr.x
    atk.y = plr.y-20
    if plr.damaged and plr.inv == 0 then
        plr.inv = PLR_INV_TIME
    end

    if plr.inv > 0 then 
        plr.inv-=1 
        if plr.inv==0 then plr.damaged = false end
    end


    --set attacking direction
    if not wpn.attacking then
        wpn.sp=50
        if btn(0) then
            wpn.dir=2
        elseif btn(1) then
            wpn.dir=1
        end

        wpn.flp_y = 0

        if btn(2) then
            wpn.dir = 4
            wpn.sp=56
        end

        if btn(3) then
            wpn.dir = 3
            wpn.sp=56
        end--]]

        if btnp(5) then
            if wpn.dir==0 or (wpn.dir==3 and plr.vy==0) then
                if plr.vx < 0 then
                    wpn.dir=2
                else
                    wpn.dir=1
                end
            end
            wpn.attacking = true
            wpn.attack_anim = true
        end--]]
    end
    if wpn.attacking then
        plr_attack_anim()
        wpn.x = plr.x + wpn.dir_boxes_off[wpn.dir][1]
        wpn.y = plr.y + wpn.dir_boxes_off[wpn.dir][2]
        wpn.drx = plr.x + wpn.dir_boxes_off[wpn.dir][3]
        wpn.dry = plr.y - 2 + wpn.dir_boxes_off[wpn.dir][4]
        for e in all(enemies) do
            if coll(wpn,e) then
                damage(e,1)
            end
        end
    end
end

function weapon_draw()
    if wpn.attacking then
        spr(flr(wpn.sp),wpn.drx+wpn.vert_off_x,wpn.dry, 1, 1, wpn.dir==2 or wpn.frame>=4, wpn.dir==3)
        --rect(wpn.x,wpn.y,wpn.x+wpn.w,wpn.y+wpn.h,14)
    end
end

function plr_attack_anim()
    if wpn.dir==4 or wpn.dir==3 then
        if wpn.frame >= 4 then
            wpn.vert_off_x=8
        end
        if wpn.frame >= 7 then
            wpn.attacking = false
            wpn.frame = 1
            wpn.vert_off_x=0
        end
        wpn.sp=wpn.vert_anim[flr(wpn.frame)]
        if t%2==1 then
            wpn.frame+=1
        end
    else
        wpn.sp+=0.7
        if wpn.sp>55.5 then 
            wpn.sp = 50
            wpn.attacking = false
        end
    end
end

function closest_to_plr(lst)
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
end

--TO DO:
--set the location of collide_map_raycast to front of player instead of back. Could use atk object to do this.
--combine atk and wpn