

function plr_movement_update()
    --blood logic (needs to be moved later)
    if plr.splat_t > 0 then
        plr.splat_t-=1
        if plr.splat_t < 8 then
            plr.spl_pal=14
        end
    else
        plr.spl_pal=8
        plr.spl_am=0
    end

    if plr.x > 128 then
        mx+=16
        plr.x=0
        level_load()
    end
    if plr.x<0 then
        mx-=16
        plr.x=128
        level_load()
    end
    if plr.y<0 then
        my-=16
        plr.y=128
        level_load()
    end
    if plr.y>128 then
        if my==48 then
            plr.respawn_state = 1
        else
            my+=16
            plr.y=0
            level_load()
        end
    end

    if plr.hp <= 0 then plr.respawn_state = 1 end

    --map collisions for player
    mcol_l = collide_map(plr,"left",2)
    mcol_r = collide_map(plr,"right",2)
    mcol_u = collide_map(plr, "up", 1)
    mcol_d = collide_map(plr, "down", 0)


    dust_off = 0
    if plr.vx != 0 then plr.vx*=plr.fr end
    if btn(1) then
        update_player_x_velocity(1)
    elseif btn(0) then
        update_player_x_velocity(-1)
    end

    if plr.jumped then
        if btn(4) then 
            plr.decel=SLOW_DECEL
        else
            plr.jumped = false
        end
    else
        plr.decel=FAST_DECEL
    end

    if btnp(4) then plr.jp_buffer = 6 else plr.jp_buffer-=1 end

    if (plr.jp_buffer>0) and not plr.jumped and plr.coy_time>0 then
        plr.coy_time=0
        plr.jp_buffer = 0
        plr.jump_buffer = false
        plr.vy = plr.jumpfrc
        plr.grounded = false
        plr.jumped = true
        for i=1,6 do
            if i < 4 then
                add_dust(plr.x+rnd(3)-1,plr.y+8,8)
            else
                add_dust(plr.x+6+rnd(2),plr.y+8,8)
            end
        end
    end

    if plr.inv==PLR_INV_TIME-1 then
        plr.vx=-sgn(plr.vx)*1
        plr.vy=2
    end

    --collision

    --Wall Jump and slide Logic
    if plr.vy < 0 then
        if mcol_l then
            if plr.jp_buffer>0 then
                plr.jp_buffer=0
                plr.vy = plr.jumpfrc
                plr.vx = 1
                plr.jumped = true
                plr.wgt = WALL_JUMP_MOVE_DELAY
            end
            plr.decel = SLIDE_DECEL
            add_dust(plr.x, plr.y+3,5)
        elseif mcol_r then
            if plr.jp_buffer>0 then
                plr.jp_buffer=0
                plr.vy = plr.jumpfrc
                plr.vx = -1
                plr.jumped = true
                plr.wgt = WALL_JUMP_MOVE_DELAY
            end
            plr.decel = SLIDE_DECEL
            add_dust(plr.x+plr.w-1, plr.y+3, 5)
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
    
    
    plr.vy = max(plr.vy-plr.decel, MAX_Y_DECEL)
    
    if plr.vy < 0 then
        --logic for fall partices (not sure to add or not)
        --if plr.vy == MAX_Y_DECEL and plr.state != 5 then
        --    add_dust(plr.x, plr.y+3, 2)
        --    add_dust(plr.x+7, plr.y+3, 2)
        --end
        --
        plr.grounded = false
        if (mcol_d) and not (btn(3) and collide_map(plr,"down",5)) then
            plr.vy = 0
            plr.y-=((plr.y+plr.h+1)%8)-1
            plr.grounded = true
            plr.jumped=false
        end
    end

    if plr.vy > 0 then
        if mcol_u then
            plr.vy = 0
        end
    end

    if plr.vx<0 then
        if mcol_l then
          plr.vx=0
        end
        if plr.grounded and plr.vx < -0.05 then
            add_dust(plr.x+6,plr.y+8,4)
        end
    elseif plr.vx>0 then
        if mcol_r then
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

    --[[if plr.vx < 0.01 and plr.vx > 0 and mcol_r then 
        plr.x+=((plr.x-1)%8)-1
    elseif plr.vx < 0 and plr.vx > -0.01 and mcol_l then
        plr.x-=((plr.x+plr.w+1)%8)-1
    end--]]

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
