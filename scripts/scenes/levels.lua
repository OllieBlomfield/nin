levels={} --extra level data for screens that need it.
for i=1,32 do levels[i]={0,0} end
levels[1] = {function() if plr.x==15 then plr.respawn_state=4 plr.sp=26 end end,function() if plr.respawn_state==4 then print("🅾️",16,105 + 3*sin(t/170),7) end end,{15,112}}
levels[2]={function() add_blood_drip(55,7) end, function() line(54,-1,55,6,8) print("🅾️ to jump",13,100,5) end}
levels[4]={function() add_enemy(16,88,0) add_enemy(104,96,0,-1) end,0,{102,8}}
levels[5]={function() add_enemy(8,8,0) add_enemy(112,80,0,-1) end,0}
levels[6]={function() add_enemy(88,32,0) end,0}
levels[7]={0,0,{8,56}}
levels[8]={0,0,{8,56}}
levels[9]={0,0,{86,112}}
levels[10]={0,0,{2,8}}
levels[11]={function() add_enemy(56,112,0,-1) add_enemy(56,64,0,1) add_enemy(96,32,0,-1) end,function() print("❎ to kill",17,97+2*sin(t/170),8) end,{20,8}}
levels[12]={function() add_enemy(60,64,0,-1) add_enemy(16,112,0) end,function() print("⬇️",20,30+2*sin(t/200),7) end,{2,20}}
levels[13]={0,0,{106,8}}
levels[14]={boss_init,boss_draw,{60,112}}
levels[15]={0,0,{106,8}}
levels[16]={0,0,{112,112}}
levels[17]={0,0,{112,112}}
levels[18]={0,0,{112,112}}
levels[19]={function() add_enemy(16,48,0,-1) end,0,{112,112}}
levels[20]={function() add_enemy(8,80,0,1) end,0,{96,8}}
levels[21]={function() for i=1,11 do add_enemy(i*10,8) end end,0}
levels[22]={function() add_enemy(16,24,0,-1) add_enemy(76,24,0,-1) add_enemy(44,112,0,1) end,0}
levels[23]={function() snow_init(40,33,20) end, function() snow_draw() print("⬇️",16,20+2*sin(t/200),7) end}
levels[24]={0,0,{96,112}}
levels[25]={function() add_enemy(112,112,0,-1) end,0}
levels[26]={function() snow_init() final_init() end,function() final_update() snow_draw() fire_add(18,6) fire_add(2,22) fire_add(106,6) fire_add(122,22) draw_hb(86,10,10,0) end,{60,104}}
levels[27]={snow_init,snow_draw,{28,112}}
levels[28]={function() snow_init() add_enemy(96,112,0,-1) end,function() snow_draw() fire_add(82,108) fire_add(114,108) end,{120,16}}
levels[29]={snow_init,snow_draw,{120,8}}
levels[30]={snow_init,snow_draw,{120,20}}
levels[31]={snow_init ,function() snow_draw() fire_add(26,68) fire_add(58,34) end}
levels[32]={snow_init,snow_draw,{20,48}}
for i=1,32 do levels[i][4]=false end
function level_load()
    lvl = 1+(mx/16)+(((48-my)/16)*8)
    cleared=levels[lvl][4]
    t = 0
    shake=0
    enemies={}
    blood.lns = {}
    blood.splat = {}
    bloods={}
    --bs={}
    drip={}
    objects={}
    collects={}
    snow={}
    fire={}
    plr_dust = {}
    health_bar=false

    if levels[lvl][1]!=0 then levels[lvl][1]() end
    en_at_start=#enemies>0 --stores if there were any enemies at the start of the screen
    rsp = levels[lvl][3] or {16,112}
    switch_solid=-1

    scan_screen()
end

function level_init()
    --reload(0x1000, 0x1000, 0x2000,'data/map00.p8')
    update=level_update
    draw=level_draw
    mx=32
    my=32
    fade_in=16
    lvl = 1+(mx/16)+(((48-my)/16)*8)
    rsp = levels[lvl][3] or {16,112}
    player_init(rsp)
    level_load()
    
    --if levels[lvl][3] then plr.x,plr.y=levels[lvl][3][1],levels[lvl][3][2] end

end

function level_update()
    t+=1 --used to count number of frames since start
    fade_in=max(-1,fade_in-1)
    player_update()
    dust_update()
    collect_update()
    
    for e in all(enemies) do
        e:update()
    end
    if en_at_start and #enemies==0 then
        levels[lvl][4]=true
    end

    --bludsplosion_update()

    fire_update()
    
    for b in all(bloods) do b:update() end

    for o in all(objects) do if o.update!=0 then o:update() end end

    if switch_delay>0 then switch_delay-=1 end --for switch objects to prevent switching blocks too quickly
    if shake>0 then shake-=1 screen_shake() else camera(0,0) end
    drip_update()
end

function level_draw()
    cls()
    main_pal()
    if fade_in>=0 then fade(fade_in) elseif fade_in==-1 then main_pal() fade_in=-1 end
    --main_pal()
    
    map(mx,my,0,0,16,16,0x80)
    
    
    for b in all(bloods) do b:draw() end

    map(mx,my,0,0,16,16,0x40)

    for c in all(collects) do pset(c.x,c.y,7) end
    for f in all(fire) do circfill(f.x,f.y,f.r,f.c) end
    
    for d in all(drip) do 
        pset(d.x,d.y,8) 
        pset(d.x,d.og_y,8)
    end

    for s in all(plr_dust) do pset(s.x,s.y,s.c) end

    if levels[lvl][2] != 0 then levels[lvl][2]() end
    for o in all(objects) do if o.draw!=0 then o:draw() end end
    --for e in all(enemies) do e:draw() end
    --for b in all(bs) do 
    --    if b.s>1 then rectfill(b.x,b.y,b.x+1,b.y+1,8) else pset(b.x,b.y,8) end
    --end
    if plr.respawn_state<2 or plr.respawn_state==4 then 
        player_draw() 
    else
        rect(41,59,85,69,7)
        rectfill(42,60,84,68,0)
        print("x to retry",44,62,7)
    end

    for e in all(enemies) do e:draw() end
    --[[print(cleared,10,10,14)
    print(rsp[1])
    print(rsp[2])--]]
    main_pal()
end

