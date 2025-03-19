function final_init()
    f_boss,boss_t,change_t,balls = {
        state=-1,
        move=0, --0 first, 1/2 second, 3 third, 4 transition
        move_in=false,
        flash=false,
        dw=0,
        x=60,
        y=22,
        kb_x=0,
        spd=0.8,
        hp=7,
        prev_hp=0,
        dmged=0,
    },
    0,0,{}
end

function final_update()
    boss_t+=f_boss.spd
    final_draw()
    --ball logic
    for b in all(balls) do
        b.x+=b.vx
        b.y+=b.vy
        if coll(plr,{x=b.x+1,y=b.y+1,w=2,h=2}) then damage(plr,1) end
    end
    if plr.x<120 and plr.x>8 and f_boss.state==-1 and not cleared then
        music(-1)
        set_boss_walls(10)
        f_boss.state=0
    end
    if f_boss.state==0 then final_intro()
    elseif f_boss.state==1 then final_fight()
    elseif f_boss.state==2 then final_outro() end
end


function final_draw()
    for b in all(balls) do spr(105+flr((t%15)/7),b.x,b.y) end
    if f_boss.flash and boss_t%15>7 then pal(7,8) end
    if not (f_boss.dmged>0 and boss_t%15>7) then sspr(104,16,8,15,f_boss.x,f_boss.y,f_boss.dw,15,f_boss.x<plr.x) end
    pal(7,7)
    f_boss.prev_hp=max(f_boss.prev_hp-0.05)
    draw_hb(86,f_boss.hp,7,f_boss.prev_hp)
end

function final_intro()
    f_boss.dw=min(8,f_boss.dw+0.1)
    if boss_t>=100 then music(11) f_boss.state,boss_t=1,0 end
end

function final_fight()
    f_boss.dmged=max(f_boss.dmged-1)

    if f_boss.hp<=0 then f_boss.state=2 end
    
    if f_boss.move!=4 then
        local box={x=f_boss.x+1,y=f_boss.y,w=5,h=8}
        if coll(plr,box) and not plr.gp and f_boss.dmged==0 then damage(plr,1) end
        if coll(wpn,box) and wpn.attacking and f_boss.dmged==0 then
            f_boss.hp-=1
            f_boss.prev_hp+=min(f_boss.hp,1)
            f_boss.dmged=30
            add_blood(f_boss.x,f_boss.y,20)
        end
        if boss_t>600 then
            f_boss.move,f_boss.spd,change_t=4,0,boss_t
        end
    end
    
    --move1
    if f_boss.move==0 then
        f_boss.x,f_boss.y,f_boss.flash=42*sin(boss_t/250)+64,-42*cos(boss_t/250)+64,(t%200>150)
        --f_boss.flash=(t%200>150)
        if (t%200==199) then
            for i=0,7 do
                add(balls,{
                    x=f_boss.x+3,
                    y=f_boss.y+3,
                    vx=0.8*sin(i/7),
                    vy=0.8*cos(i/7)
                })
            end
        end  
    end

    --move2
    if f_boss.move==1 or f_boss.move==2 then
        f_boss.y,f_boss.x,f_boss.flash=42*cos(boss_t/250)+64,5*sin(boss_t/150)+102-80*(f_boss.move-1),(t%170>120)
        if (t%170>150) and (t%4==0) then
            add(balls,{
                x=f_boss.x+3,
                y=f_boss.y+3,
                vx=sgn(f_boss.move-2),
                vy=0
            })
        end
    end

    --move3
    if f_boss.move==3 then
        f_boss.x,f_boss.y,f_boss.flash=42*sin(boss_t/250)+64,5*cos(boss_t/150)+26,(t%180)>150
        if (t%180==179) then
            add_enemy(f_boss.x,30,0)
        end
    end
    
    --transition
    if f_boss.move==4 then 
        if boss_t-change_t>100 then
            f_boss.move_in,boss_t,f_boss.move=true,100,flr(rnd(4))
        end
        f_boss.dw,f_boss.spd=max(f_boss.dw-0.2),min(0.8,f_boss.spd+0.05)
    end

    if f_boss.move_in then
        f_boss.dw=min(8,f_boss.dw+0.3)
        --if f_boss.dw==8 then
        --    f_boss.move_in=false
        --end
        f_boss.move_in = f_boss.dw!=8
    end
end

function final_outro()
    music(-1)
    f_boss.dw=max(0,f_boss.dw-0.1)
    if t%10>8 then add_blood(f_boss.x,f_boss.y,15) end
    if f_boss.dw==0 then
        f_boss.state,plr.spl_am,plr.spl_t=4,2,900
        set_boss_walls(10,0)
    end
end