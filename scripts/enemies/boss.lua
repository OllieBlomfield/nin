function boss_init()
    boss={
        state=0, --0 intro, 1 fight, 2 death
        x=-30,
        y=64,
        eye_off_x=0,
        eye_off_y=0,
        kb_x=0,
        kb_y=0,
        hp=7,
        prev_hp=0,
        hb_w=-1,
        dmged=0,
        midcol=0,
        draw=true,
        spd=1
    }
    pixs={{-2,-6},{3,-6,},{3,5},{2,-4}}
    boss_t=0
end

function boss_update()
    boss_t+=1*boss.spd
    if boss.state==0 then intro_update()
    elseif boss.state==1 then fight_update() 
    else outro_update() end
end

function boss_draw()
    boss_update()
    if boss.dmged>0 or boss.hp<=3 then
        if t%14>7 then boss.midcol=8 else boss.midcol=7 end
    end
    
    if boss.draw then
        if boss.state==0 then
            if boss_t>320 then
                circ(64,39,min(8,(boss_t-320)/5),0)
                circfill(64,39,min(7,(boss_t-320)/5),fadeTable[8][max(1,15-flr((boss_t-360)))]) 
                clip(55,30,74,48)
                spr(101,62,min(39,24+(boss_t/2)-180),0.625,0.75)
                clip()
            end
        end

        add_dust(boss.x,boss.y,5)
        for i=1,3 do
            add_dust(boss.x,boss.y+i*2,6+flr(i+(0.4*i)))
            add_dust(boss.x,boss.y-i*2,6+flr(i+(0.4*i)))
        end

        circ(boss.x,boss.y,8,0)
        circfill(boss.x,boss.y,7,boss.midcol)
        spr(101,boss.x+boss.eye_off_x-2,boss.y+boss.eye_off_y-2,0.625,0.75,boss.eye_off_x<0)
        for i=2,5 do
            if boss.hp<=i then
                local px=pixs[i-1][1]
                local py=pixs[i-1][2]
                line(boss.x+boss.eye_off_x,boss.y+boss.eye_off_y,boss.x-px,boss.y-py,8)
            end
        end
    end

    boss.prev_hp=max(0,boss.prev_hp-0.05)
    if boss.hb_w>0 then draw_hb(boss.hb_w,boss.hp,7,boss.prev_hp) end
end
--108
--132
--368

function fight_update()
--particles

    --movement
    boss.x=42*sin(boss_t/250)+64 + 12*cos(boss_t/200)+boss.kb_x
    boss.y=42*cos(boss_t/250)+64 + 20*sin(boss_t/200)+boss.kb_y

    if boss.kb_x>0 then boss.kb_x-=0.2 end
    if boss.kb_y>0 then boss.kb_y-=0.2 end

    boss.eye_off_x=-(boss.x-plr.x)/25
    boss.eye_off_y=-(boss.y-plr.y)/25

    --damage
    if boss.dmged>=0 then
        boss.dmged-=1 
    else
        boss.midcol=7
    end

    if boss.hp<=0 then boss_t=0 boss.spd=1 boss.state=2 end
    if boss.hp<=4 then boss.spd=1.3 end
    if boss.hp<=2 then boss.spd=1.6 end

    if coll(plr,{x=boss.x-5,y=boss.y-5,h=10,w=10}) and not plr.gp then damage(plr,1) end
    if (coll(wpn,{x=boss.x-8,y=boss.y-8,h=16,w=16}) and wpn.attacking) or (coll(plr,{x=boss.x-6,y=boss.y-6,h=12,w=12}) and plr.gp) then 
        if boss.dmged<=0 then
            boss.dmged=30
            boss.prev_hp+=min(boss.hp,1)
            boss.hp-=1
            --if plr.spl_am<3 then plr.spl_am+=1 end NEEDS A FIX
            plr.splat_t=300
            if wpn.dir<3 then
                boss.kb_x=-sgn(wpn.dir-2)*4
            else
                boss.kb_y=-sgn(wpn.dir-4)*4
            end
            add(bloods,blood:new({
                x=boss.x,
                y=boss.y+4,
                lines=true,
            },20))
        end
    end
end

function intro_update()
    if boss_t>80 then
        boss.x=(80-boss_t/50)*sin(t/250)+64 + 30*cos(t/200)
        boss.y=(80-boss_t/50)*cos(t/250)+64 + 30*sin(t/200)
        if boss_t>320 then
            boss.x=-10
            boss.y=-10
            boss.hb_w=min(86,boss.hb_w+1)
            if boss_t>390 then
                boss.midcol=7
                boss_t=132
                boss.state=1
            end
        end
    end
end

function outro_update()
    boss.x+=rnd(2)-1
    boss.y+=rnd(2)-1
    if boss_t>180 then
        if boss.draw then
            boss.draw=false
            add(bloods,blood:new({
                x=boss.x,
                y=boss.y,
                lines=true,
            },100,30,0.3))
        else boss.hb_w-=1 end
    end
end