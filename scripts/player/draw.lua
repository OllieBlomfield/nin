function update_plr_animation()
    --Logic to chose which state
    if plr.gp then
        plr.state=8
    elseif plr.inv > PLR_INV_TIME/2 then
        plr.state = 6
    elseif plr.vy > 0 then
        plr.state = 3
    elseif plr.vy < 0 then
        if mcol_l or mcol_r then
            plr.state = 5
        else
            plr.state = 4
        end
    elseif abs(plr.vx) > 0.05 then
        if (plr.vx > 0 and btn(0) and not btn(1)) or (plr.vx < 0 and btn(1) and not btn(0)) then
            plr.state = 2
        else
            plr.state = 1
        end
    else
        if btn(3) then
            plr.state = 7
        else
            plr.state = 0
        end
    end

    --animating each state
    if plr.state == 0 then
        if t % 120 > 60 then
            plr.sp = 17
        else
            plr.sp = 16
        end
    elseif plr.state == 1 then
        spd = min(flr(abs(plr.vx)/0.13)+1,8)
        if t%run_anim_delay[spd] > run_anim_delay[spd]/2 then
            plr.sp = 18
        else
            plr.sp = 19
        end
    elseif plr.state == 2 then
        plr.sp = 20
    elseif plr.state == 3 then
        plr.sp = 21
    elseif plr.state == 4 then
        plr.sp = 22
    elseif plr.state == 5 then
        plr.sp = 23
    elseif plr.state == 6 then
        plr.sp = 25
    elseif plr.state == 7 then
        plr.sp=24
    elseif plr.state==8 then
        plr.sp=27
    end
end

function player_draw()
    plr_pal()
    if abs(plr.vy)>0.8 then plr.dr_h = 9 else plr.dr_h=8 end
    sx, sy = (plr.sp % 16) * 8, (plr.sp \ 16) * 8 --from wiki
    if (plr.inv>0 and t%14>7) or (plr.inv<=0) then
        sspr(sx,sy,8,8,plr.x,plr.y,plr.dr_w,plr.dr_h, plr.vx < 0 or collide_map(plr, "left", 0))
        weapon_draw()
    end
    
    main_pal()
end