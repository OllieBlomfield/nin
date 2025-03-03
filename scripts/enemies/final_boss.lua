function final_init()
    f_boss = {
        state=-1,
        x=90,
        y=60,
        vx=0,
        vy=0,
        hp=12,
        prev_hp=0
    }    
end

function final_update()
    final_draw()
    if plr.x<110 and f_boss.state==-1 and not cleared then
        set_boss_walls(10)
        f_boss.state=1
    end
    if f_boss.state==1 then final_fight() end
end


function final_draw()
    spr(45,f_boss.x,f_boss.y,1,1,f_boss.x<plr.x)
    spr(61,f_boss.x,f_boss.y+8,1,1,f_boss.x<plr.x)
end

function final_fight()
    f_boss.vx=sin(t/200)
    f_boss.vy=cos(t/200)
    f_boss.x+=f_boss.vx
    f_boss.y+=f_boss.vy

    --move1

    --move2

    --move3
end