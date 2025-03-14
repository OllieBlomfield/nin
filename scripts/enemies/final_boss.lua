function final_init()
    f_boss = {
        state=-1,
        move=0, --0 first, 1/2 second, 3 third, 4 transition
        move_in=false,
        flash=false,
        dw=8,
        x=90,
        y=60,
        kb_x=0,
        spd=1,
        hp=12,
        prev_hp=0,
        dmged=0,
    }
    boss_t,change_t,balls=0,0,{}
end

function final_update()
    boss_t+=f_boss.spd
    final_draw()
    --ball logic
    for b in all(balls) do
        b.x+=b.vx
        b.y+=b.vy
        if coll(plr,{x=b.x,y=b.y,w=4,h=4}) then damage(plr,1) end
    end
    if plr.x<120 and plr.x>8 and f_boss.state==-1 and not cleared then
        set_boss_walls(10)
        f_boss.state=1
    end
    if f_boss.state==1 then final_fight()
    elseif f_boss.state==2 then final_outro() end
end


function final_draw()
    for b in all(balls) do spr(105+flr((t%15)/7),b.x,b.y) end
    if f_boss.flash and boss_t%15>7 then pal(7,8) end
    if not (f_boss.dmged>0 and boss_t%15>7) then sspr(104,16,8,15,f_boss.x,f_boss.y,f_boss.dw,15,f_boss.x<plr.x) end
    pal(7,7)
    f_boss.prev_hp=max(0,f_boss.prev_hp-0.05)
    draw_hb(86,f_boss.hp,12,f_boss.prev_hp)
end

function final_fight()
    f_boss.dmged=max(0,f_boss.dmged-1)
    --f_boss.kb_vx-=0.05*sgn(f_boss.kb_vx)
    --[[if f_boss.kb_x>0 then
        f_boss.kb_x=max(f_boss.kb_x-0.05)
    else
        f_boss.kb_x=min(f_boss.kb_x+0.05)
    end]]

    if f_boss.hp<=0 then f_boss.state=2 end
    
    if f_boss.move!=4 then
        local box={x=f_boss.x+1,y=f_boss.y,w=5,h=8}
        if coll(plr,box) and not plr.gp then damage(plr,1) end
        if coll(wpn,box) and wpn.attacking and f_boss.dmged==0 then
            f_boss.hp-=5
            f_boss.prev_hp+=min(f_boss.hp,1)
            f_boss.dmged=30
            --f_boss.kb_x=-sgn(wpn.dir-2)*4
            add_blood(f_boss.x,f_boss.y,20)
        end
        if boss_t>600 then
            f_boss.move,f_boss.spd,change_t=4,0,boss_t
        end
    end
    
    --move1
    if f_boss.move==0 then
        f_boss.x,f_boss.y=42*sin(boss_t/250)+64,42*cos(boss_t/250)+64
        --if (t%200>180) then f_boss.spd=max(0.6,f_boss.spd-0.1) else f_boss.spd=1 end
        f_boss.flash=(t%200>150)
        if (t%200==199) then
            for i=0,7 do
                add(balls,{
                    x=f_boss.x+3,
                    y=f_boss.y+3,
                    vx=sin(i/7),
                    vy=cos(i/7)
                })
            end
        end  
    end

    --move2
    if f_boss.move==1 or f_boss.move==2 then
        f_boss.y,f_boss.x,f_boss.flash=42*cos(boss_t/250)+64,5*sin(boss_t/150)+100-72*(f_boss.move-1),(t%170>120)
        if (t%170>150) and (t%5==0) then
            add(balls,{
                x=f_boss.x+3,
                y=f_boss.y+3,
                vx=2*sgn(f_boss.move-2),
                vy=0
            })
        end
    end

    --move3
    if f_boss.move==3 then
        f_boss.x,f_boss.y,f_boss.flash=42*sin(boss_t/250)+64,5*cos(boss_t/150)+100-72,(t%100)>60
        if (t%100==99) then
            add_enemy(f_boss.x,30,0,sgn(rnd(2)-1))
        end
    end

    --f_boss.x+=f_boss.kb_x

    --transition
    if f_boss.move==4 then 
        if boss_t-change_t>100 then
            f_boss.move_in,boss_t,f_boss.move=true,100,flr(rnd(4))
        end
        f_boss.dw,f_boss.spd=max(0,f_boss.dw-0.2),min(1,f_boss.spd+0.05)
    end

    if f_boss.move_in then
        f_boss.dw=min(8,f_boss.dw+0.3)
        if f_boss.dw==8 then
            f_boss.move_in=false
        end
    end
end

function final_outro()

    f_boss.dw=max(0,f_boss.dw-0.1)
    if t%10>8 then add_blood(f_boss.x,f_boss.y,15) end
    if f_boss.dw==0 then
        f_boss.state=4
        set_boss_walls(10,0)
        plr.spl_am=2
        plr.spl_t=900
    end
end