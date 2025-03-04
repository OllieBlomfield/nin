function update_plr_animation()
    --Logic to chose which state
    if plr.gp then
        plr.state=8
    elseif plr.inv > PLR_INV_TIME/2 then
        plr.state = 6
    elseif plr.vy > 0 then
        plr.state = 3
    elseif plr.vy < 0 then
        plr.state = (mcol_l or mcol_r) and 5 or 4
    elseif abs(plr.vx) > 0.05 then
        if (plr.vx > 0 and btn(0) and not btn(1)) or (plr.vx < 0 and btn(1) and not btn(0)) then
            plr.state = 2
        else
            plr.state = 1
        end
    else
        plr.state = btn(3) and 7 or 0
    end

    --animating each state
    if plr.state == 0 then
        plr.sp = t%120>60 and 17 or 16
    elseif plr.state == 1 then
        spd = min(abs(plr.vx)\0.13+1,8)
        plr.sp = t%run_anim_delay[spd] > run_anim_delay[spd]/2 and 18 or 19
    elseif plr.state>1 then
        plr.sp=18+plr.state
    end
end

function player_draw()
    plr_pal()
    plr.dr_h = abs(plr.vy)>0.8 and 9 or 8
    sx, sy = (plr.sp % 16) * 8, (plr.sp \ 16) * 8 --from wiki
    sspr(sx,sy,8,8,plr.x,plr.y,8,plr.dr_h, plr.vx < 0 or collide_map(plr, "left", 0))

    weapon_draw()
    main_pal()
end