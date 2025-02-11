function player_init(pos)
    SLIDE_DECEL,SLOW_DECEL,FAST_DECEL,MAX_Y_DECEL = 0.02,0.08,0.25,-1.3
    GROUNDPOUND_Y_VEL=-3
    MAX_X_VELOCTY = 1.1
    run_anim_delay = {30,30,30,20,20,15,15,15}
    WALL_JUMP_MOVE_DELAY = 12
    WALL_JUMP_REDUCED_X_VELOCITY = 0.6
    PLR_INV_TIME = 100
    COYOTE_TIME=5

    
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
        dr_w=8,
        dr_h=8, -- draw height and draw width
        temp_collect=false,
        dropped=false,
        sprung=0
    }

    wpn_init()
    plr_dust = {}
end


function player_update()
    --blood logic
    if plr.spl_t<=0 then 
        plr.spl_am=0
        plr.spl_pal={7,7,7}
    else
        plr.spl_t-=1
        if plr.spl_t < 8 then
            for i=1,plr.spl_am do
                plr.spl_pal[i]=14
            end
        end
    end

    --inv logic
    plr.inv=max(0,plr.inv-1)


    if plr.respawn_state==0 then
        plr_movement_update()
        player_mele_update()
    elseif plr.respawn_state<4 then
        wpn.attacking=false
        plr.respawn_time+=1
        if btnp(5) and plr.respawn_time>20 and fade_in<=0 then fade_in+=2 end
        if fade_in>0 then fade_in+=2 end
        if fade_in>=16 then plr_respawn() end
        plr.sp=25
        if plr.respawn_state==1 then
            plr.vx=-sgn(plr.vx)*0.8
            plr.vy=1
            plr.sp=25
            plr.respawn_state=1.1
        elseif plr.respawn_state<2 and plr.respawn_state>1 then
            if t%10>5 then plr.spl_pal={8,8,8} end
            plr.respawn_state=min(2,plr.respawn_state+0.05)
            if plr.vx>0 then plr.vx=max(plr.vx-0.03,0.1) else plr.vx=min(plr.vx+0.03,-0.1) end
            plr.vy=max(0.1,plr.vy-0.1)
            plr.x+=plr.vx
            plr.y-=plr.vy
        elseif flr(plr.respawn_state)==2 then
            shake=3
            --add_bludsplosion(plr.x,plr.y)
            add(bloods,blood:new({
                x=plr.x+4,
                y=plr.y+4,
                lines=true,
            },40))
            plr.respawn_state=3
        end
    else
        if btnp(4) then
            plr.respawn_state=0
            plr.vy=plr.jumpfrc
        end
    end
end


function plr_respawn()
    if #levels[lvl] > 2 then
        player_init({levels[lvl][3][1],levels[lvl][3][2]})
    else
        player_init({16,112})
    end
    level_load()
end

function add_splat()
    plr.spl_am=min(3,plr.spl_am+1)
    plr.spl_t = 240
end