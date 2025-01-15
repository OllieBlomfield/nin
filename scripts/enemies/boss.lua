function boss_init()
    health_bar=true
    boss={
        state=0, --0 intro, 1 fight, 2 death
        x=-30,
        y=64,
        eye_off_x=0,
        eye_off_y=0,
        kb_x=0,
        kb_y=0,
        hp=10,
        dmged=0,
        midcol=0,
        draw=true
    }
    pixs={{-2,-6},{3,-6,},{3,2},{2,-1}}
    boss_t=0
end

function boss_update()
    boss_t+=1
    if boss.state==0 then boss_intro_update()
    elseif boss.state==1 then boss_fight_update() 
    else boss_outro_update() end
end

function boss_draw()
    boss_update()

    if boss.dmged>0 or boss.hp<=2 then
        if t%14>7 then boss.midcol=8 else boss.midcol=7 end
    end
    

    if boss.draw then
        circ(boss.x,boss.y,8,0)
        circfill(boss.x,boss.y,7,boss.midcol)
        spr(101,boss.x+boss.eye_off_x-2,boss.y+boss.eye_off_y-2,0.625,0.75,boss.eye_off_x<0)
        for i=8,2,-2 do
            if boss.hp<=i then
                --line(boss.x+boss.eye_off_x,boss.y+boss.eye_off_y,boss.x-6,boss.y-3,8)
                local px=pixs[((10-i)/2)][1]
                local py=pixs[(10-i)/2][2]
                line(boss.x+boss.eye_off_x,boss.y+boss.eye_off_y,boss.x-px,boss.y-py,8)
            end
        end
    end
    --rect(boss.x-6,boss.y-6,boss.x+6,boss.y+6,14)
    --rect(boss.x-8,boss.y-8,boss.x+8,boss.y+8,14)
end

function boss_fight_update()
--particles
    add_dust(boss.x,boss.y-4,10)
    add_dust(boss.x,boss.y+4,10)
    add_dust(boss.x,boss.y-6,8)
    add_dust(boss.x,boss.y+6,8)
    add_dust(boss.x,boss.y-2,7)
    add_dust(boss.x,boss.y+2,7)
    add_dust(boss.x,boss.y,5)

    --movement
    boss.x=42*sin(t/250)+64 + 12*cos(t/200)+boss.kb_x
    boss.y=42*cos(t/250)+64 + 20*sin(t/200)+boss.kb_y

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

    if boss.hp<=0 then boss_t=0 boss.state=2 end

    if coll(plr,{x=boss.x-5,y=boss.y-5,h=10,w=10}) and not plr.gp then damage(plr,1) end
    if (coll(wpn,{x=boss.x-8,y=boss.y-8,h=16,w=16}) and wpn.attacking) or (coll(plr,{x=boss.x-6,y=boss.y-6,h=12,w=12}) and plr.gp) then 
        if boss.dmged<=0 then
            boss.dmged=30 
            boss.hp-=2
            if plr.spl_am<3 then plr.spl_am+=1 end
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

function boss_intro_update()
    if boss_t>80 then
        boss.x=(80-boss_t/50)*sin(t/250)+64 + 30*cos(t/200)
        boss.y=(80-boss_t/50)*cos(t/250)+64 + 30*sin(t/200)
        if boss_t>320 then
            boss.midcol=7
            boss.draw=boss_t%20>10
            boss.x=64
            boss.y=64
            if boss_t>500 then
                boss_t=0
                boss.draw=true
                boss.state=1
            end
        end
    end
end

function boss_outro_update()
    boss.x+=rnd(2)-1
    boss.y+=rnd(2)-1
    if boss_t>180 and boss.draw then 
        boss.draw=false
        add(bloods,blood:new({
            x=boss.x,
            y=boss.y+4,
            lines=true,
        },100,30,1))
        health_bar=false
    end
end