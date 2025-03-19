function plr_movement_update()
    if plr.x > 128 then
        if mx<112 then
            check_level_clear()
            mx+=16
            plr.x=0
            level_load()
        else
            plr.respawn_state=1
        end
    end
    if plr.x<0 then
        check_level_clear()
        mx-=16
        plr.x=128
        level_load()
    end
    if plr.y<0 and my>0 then
        check_level_clear()
        my-=16
        plr.y=128
        level_load()
    end
    if plr.y>128 then
        if my==48 then
            plr.respawn_state=1
        else
            check_level_clear()
            my+=16
            plr.y=0
            level_load()
        end
    end

    if plr.hp <= 0 then plr.respawn_state = 1 end

    --map collisions for player
    mcol_l,mcol_r,mcol_u,mcol_d = collide_map(plr,"left",2),collide_map(plr,"right",2),collide_map(plr, "up", 1),collide_map(plr, "down", 0)

    if plr.vx != 0 then plr.vx*=plr.fr end
    if btn(1) and not plr.gp then
        update_player_x_velocity(1)
    elseif btn(0) and not plr.gp then
        update_player_x_velocity(-1)
    end

    plr.sprung=max(plr.sprung-1)

    if plr.jumped then
        if btn(4) or plr.sprung>0 then
            plr.decel=SLOW_DECEL
        else
            plr.jumped = false
        end
    else
        plr.decel=FAST_DECEL
    end

    if btnp(4) then plr.jp_buffer = 6 else plr.jp_buffer-=1 end

    if plr.jmp_held and not btn(4) then plr.jmp_held=false end

    if (plr.jp_buffer>0) and not plr.jumped and plr.coy_time>0 then
        plr.coy_time=0
        plr_jump()
        plr.grounded = false
        for i=1,6 do
            if i < 4 then
                add_dust(plr.x+rnd(3)-1,plr.y+8,8)
            else
                add_dust(plr.x+6+rnd(2),plr.y+8,8)
            end
        end
    end
    --collision

    --Wall Jump and slide Logic
    if plr.vy < 0 then
        if mcol_l or mcol_r then
            if plr.jp_buffer>0 and not plr.jmp_held then
                plr_jump()
                plr.vx = mcol_l and 1 or -1
                plr.wgt = WALL_JUMP_MOVE_DELAY
            end
            plr.decel = SLIDE_DECEL
            add_dust(plr.x + (mcol_r and (plr.w-1) or 0), plr.y+3,5)
        end
    end

    --allows for time when cant go back
    if plr.wgt > 0 then
        plr.wgt-=1
        if plr.wgt <= 0 or plr.grounded then
            plr.max_vx = MAX_X_VELOCTY
            plr.wgt = 0
        end
    end

    if not plr.grounded and btnp(3) and plr.sprung==0 then 
        plr.gp=true
        plr.vx*= 0.01
    end
    
    if not plr.gp then
        plr.vy = max(plr.vy-plr.decel, MAX_Y_DECEL)
    else
        plr.vy=-2.5
    end
    
    if plr.vy < 0 then
        --logic for fall partices (not sure to add or not)
        if plr.gp then
            add_dust(plr.x, plr.y+2, 2)
            add_dust(plr.x+7, plr.y+2, 2)
        end
        --
        plr.grounded = false
        if (mcol_d) and not (btn(3) and collide_map(plr,"down",5) and not plr.gp) then
            if plr.vy<=0 then
                plr.vy,plr.grounded = 0,true
                plr.y-=((plr.y+plr.h+1)%8)-1
            end
            if plr.gp then shake=9 plr.inv=50 sfx(9,3) end
            plr.gp,plr.jumped,plr.sprung=false,false,0
        end
    end

    if plr.vy > 0 then
        if mcol_u then
            plr.vy = 0
        end
    end

    if plr.vx<0 then
        if collide_map(plr,"left",2) then
          plr.vx=0
        end
        if plr.grounded and plr.vx < -0.05 then
            add_dust(plr.x+6,plr.y+8,4)
        end
    elseif plr.vx>0 then
        if collide_map(plr,"right",2) then
          plr.vx=0
        end
        if plr.grounded and plr.vx > 0.05 then
            add_dust(plr.x+1,plr.y+8,4)
        end
    end

    if plr.grounded then
        plr.coy_time=COYOTE_TIME
    else
        plr.coy_time-=1
    end

    plr.x+=plr.vx
    plr.y-=plr.vy

    update_plr_animation()
end

function update_player_x_velocity(dir)
    if plr.vx*dir < 0 and plr.wgt > 0 then
        plr.max_vx = WALL_JUMP_REDUCED_X_VELOCITY
    else
        plr.max_vx = MAX_X_VELOCTY
    end
    if abs(plr.vx) - plr.max_vx < 0 then
        if plr.vx * dir < 0 then
            plr.vx += 0.025 * dir
        else
            plr.vx += 0.1 * dir
        end
    else
        plr.vx -= 0.1 * dir
    end
end

function plr_jump(vx)
    plr.jmp_held,plr.vy,plr.jumped,plr.jp_buffer=true,plr.jumpfrc,true,0
    sfx(14,2)
end

