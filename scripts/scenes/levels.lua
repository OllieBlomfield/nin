levels={} --extra level data for screens that need it.
for i=1,32 do levels[i]={0,0} end
levels[1] = {function() if plr.x==15 then plr.respawn_state=4 end end,function() if plr.respawn_state==4 then print("🅾️",16,105 + 3*sin(t/170),7) plr.state=9 end end,{15,112}}
levels[2]={function() add_blood_drip(55,7) end, function() line(54,-1,55,6,8) print("🅾️ to jump",13,100,5) end}
levels[4]={function() add_enemy(16,88,0) add_enemy(104,96,0,-1) end,0,{102,8}}
levels[5]={function() add_enemy(8,8,0) add_enemy(112,80,0,-1) end,0}
levels[6]={function() add_enemy(88,32,0) end,0}
levels[7][3]={8,56}
levels[8][3]={8,56}
levels[9][3]={86,112}
levels[10][3]={2,8}
levels[11]={function() add_enemy(56,112,0,-1) add_enemy(56,64,0,1) add_enemy(96,32,0,-1) end,function() print("❎ to kill",17,97+2*sin(t/170),8) end,{20,8}}
levels[12]={function() add_enemy(60,64,0,-1) add_enemy(16,112,0) end,function() print("⬇️",20,30+2*sin(t/200),7) end,{2,20}}
levels[13][3]={106,8}
levels[14]={boss_init,boss_draw,{60,112}}
levels[15][3]={106,8}
levels[16][3]={112,112}
levels[17][3]={112,112}
levels[18][3]={112,112}
levels[19]={function() add_enemy(16,48,0,-1) end,0,{112,112}}
levels[20]={function() add_enemy(8,80,0,1) end,0,{96,8}}
levels[21]={function() for i=1,11 do add_enemy(i*10,8) end end,0}
levels[22]={function() add_enemy(16,24,0,-1) add_enemy(76,24,0,-1) add_enemy(44,112,0,1) end,0}
levels[23]={function() snow_init(40,33,20) end, function() snow_draw() print("⬇️",16,20+2*sin(t/200),7) end}
levels[24][3]={96,112}
levels[25]={0,function() plr.respawn_state,plr.spl_am,plr.spl_t,plr.state=3,2,1,plr.x<82 and 9 or (t%60>30 and 17 or 18) plr.x-=plr.x<80 and 0 or 0.13 plr.y=plr.x<82 and 105 or 104 
    if plr.x<82 then
        rectfill(15,15,73,46,0)
        rect(14,14,74,47,7)
        print("escaped...",16,16,8)
        print("time:"..mins.."."..(timer\60<10 and "0" or "")..(timer\60).."."..(timer%60).."s",16,22,8) 
        spr(118,16,28) print("x"..deaths,26,29)
        pal(7,8) spr(coin_anim[(t\10%6)+1],16,37) print(coins.."/12",26,38) pal(7,7) end end,{112,104}}
levels[26]={function() final_init() end,function() final_update() fire_add(18,6) fire_add(2,22) fire_add(106,6) fire_add(122,22) end,{112,104}}
levels[27][3]={28,112}
levels[28]={function() add_enemy(96,112,0,-1) end,function() fire_add(82,108) fire_add(114,108) end,{120,16}}
levels[29][3]={120,8}
levels[30][3]={120,20}
levels[31]={0,function() fire_add(26,68) fire_add(58,34) end}
levels[32][3]={20,48}
for i=1,32 do levels[i][4]=false end
function level_load()
    lvl = 1+(mx/16)+(((48-my)/16)*8)
    save()
    cleared=levels[lvl][4]
    t = 0
    shake=0
    enemies, bloods, drip, objects, collects, snow, fire, plr_dust,splat={},{},{},{},{},{},{},{},{}
    d_msg = ({"❎ do better","❎ again","❎ more","❎ be faster"})[flr(rnd(4))+1]

    if levels[lvl][1]!=0 then levels[lvl][1]() end
    en_at_start=#enemies>0 --stores if there were any enemies at the start of the screen
    rsp = levels[lvl][3] or {16,112}
    switch_solid=-1
    if my==0 then snow_init() end

    scan_screen()
end

function level_init()
    update=level_update
    draw=level_draw
    mx=dget(0)
    my=dget(1)
    timer=dget(2)
    mins=dget(3)
    deaths=dget(4)
    coins=dget(5)
    fade_in=16
    lvl = 1+(mx/16)+(((48-my)/16)*8)
    rsp = levels[lvl][3] or {16,112}
    player_init(rsp)
    level_load()

    dset(63,0)
end

function level_update()

    if mx!=0 or my!=0 then timer+=1 end
    if timer>3600 then timer-=3600 mins+=1 end
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

    fire_update()
    blood_update()
    drip_update()

    for o in all(objects) do if o.update!=0 then o:update() end end

    switch_delay=max(switch_delay-1)
    if shake>0 then shake-=1 screen_shake() else camera(0,0) end
    
end

function level_draw()
    cls()
    main_pal()
    if fade_in>=0 then fade(fade_in) elseif fade_in==-1 then main_pal() fade_in=-1 end
    
    map(mx,my,0,0,16,16,0x80)
    
    
    blood_draw()
    if my==0 then snow_draw() end

    map(mx,my,0,0,16,16,0x40)

    for c in all(collects) do pset(c.x,c.y,7) end
    for f in all(fire) do circfill(f.x,f.y,f.r,f.c) end
    
    for d in all(drip) do 
        pset(d.x,d.y,8)
        pset(d.x,d.og_y,8)
    end

    for s in all(plr_dust) do pset(s.x,s.y,s.c) end

    if levels[lvl][2]!=0 then levels[lvl][2]() end
    
    for o in all(objects) do if o.draw!=0 then o:draw() end end

    if plr.respawn_state!=2 then 
        player_draw()
    else
        local center_offset = (#d_msg*2)
        rect(62-center_offset,59,center_offset+68,69,7)
        rectfill(63-center_offset,60,center_offset+67,68,0)
        print(d_msg,64-center_offset,62,7)
    end

    for e in all(enemies) do e:draw() end
    main_pal()
end

