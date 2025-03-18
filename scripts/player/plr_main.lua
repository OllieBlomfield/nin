function player_init(pos)
    SLIDE_DECEL,SLOW_DECEL,FAST_DECEL,MAX_Y_DECEL,GROUNDPOUND_Y_VEL,MAX_X_VELOCTY,run_anim_delay,WALL_JUMP_MOVE_DELAY,
    WALL_JUMP_REDUCED_X_VELOCITY,PLR_INV_TIME,COYOTE_TIME = 
    0.015,0.08,0.25,-1.3,-3,1.1,{30,30,30,20,20,15,15,15},12,0.6,100,5
        
    plr = {
        sp = 16,
        x = pos[1],
        y = pos[2],
        h = 8,
        w = 8,
        vx = 0,
        vy = 0,
        ax = 0.1,
        max_vx = MAX_X_VELOCTY,
        coy_time = 0,
        inv = 0,
        damaged = false,
        fr = 0.91,
        jumpfrc = 2.2,
        jumped = false,
        grounded = true,
        gp = false, --ground pounding check
        decel = 0.1,
        jp_buffer=0,
        wgt = 0, --checks if just wall jumped {time since jump, jump direction}
        state = 0, --used for animation. 0 for idle, 1 for running, 2 for pivot, 3 for jumping, 4 for falling, 5 for sliding
        hp = 1,
        spl_t=0,
        spl_am=0,
        spl_pal = {7,7,7},
        respawn_state = 0,
        respawn_time=0,
        dr_h=8,
        temp_collect=false,
        dropped=false,
        sprung=0,
        jmp_held=false
    }

    if plr.x>64 then plr.vx=-0.001 end

    wpn_init()
    plr_dust = {}
end


function player_update()
    --blood logic
    if plr.spl_t<=0 then 
        plr.spl_am,plr.spl_pal=0,{7,7,7}
        --plr.spl_pal={7,7,7}
    else
        plr.spl_t-=1
        if plr.spl_t < 8 then
            for i=1,plr.spl_am do
                plr.spl_pal[i]=14
            end
        end
    end

    --inv logic
    plr.inv=max(plr.inv-1)


    if plr.respawn_state==0 then
        plr_movement_update()
        player_mele_update()
    elseif plr.respawn_state<3 then
        wpn.attacking,plr.state=false,6
        plr.respawn_time+=1
        if btnp(5) and plr.respawn_time>20 and fade_in<=0 then fade_in+=2 end
        if fade_in>0 then fade_in+=2 end
        if fade_in>=20 then plr_respawn() end

        if plr.respawn_time==1 then
            plr.vx,plr.vy=-sgn(plr.vx)*0.8,1
            sfx(20,2)
        elseif plr.respawn_time>1 and plr.respawn_time<25 then
            if t%10>5 then plr.spl_pal={8,8,8} end
            plr.vx,plr.vy= plr.vx>0 and max(plr.vx-0.03,0.1) or min(plr.vx+0.03,-0.1),max(0.1,plr.vy-0.1)
            plr.x+=plr.vx
            plr.y-=plr.vy
        elseif plr.respawn_time==26 then
            shake,plr.respawn_state=3,2
            add_blood(plr.x+4,plr.y+4,40)
            sfx(19,2)
        end
    elseif plr.respawn_state==4 then
        if btnp(4) then
            plr.respawn_state,plr.vy=0,plr.jumpfrc
            sfx(14,2)
            music(8,0,0)
        end
    end
end


function plr_respawn()
    deaths+=1
    player_init(rsp)
    level_load()
end

function add_splat()
    plr.spl_am,plr.spl_t=min(3,plr.spl_am+1),240
    --plr.spl_t = 240
end