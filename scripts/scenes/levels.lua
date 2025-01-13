levels={}
for i=1,32 do levels[i]={0,0} end
levels[1] = {function() if plr.x==16 then plr.respawn_state=3 plr.sp=26 end end,function() if plr.respawn_state==3 then print("🅾️",16,105 + 3*sin(t/170),7) end end,{15,112}}
levels[2]={function() add_blood_drip(55,7) end, function() line(54,-1,55,6,8) print("🅾️ to jump",13,100,5) end}
levels[4]={function() add_enemy(16,88,0) add_enemy(104,96,0,-1) end,0,{102,8}}
levels[5]={function() add_enemy(8,8,0) add_enemy(112,80,0,-1) end,0}
levels[6]={function() add_enemy(88,32,0) end,0}
levels[7]={0,0,{8,56}}
levels[8]={function() switch_solid=1 end,0,{8,56}}
levels[9]={0,0,{86,112}}
levels[10]={0,0,{2,8}}
levels[11]={function() add_enemy(56,112,0,-1) add_enemy(56,64,0,1) add_enemy(96,32,0,-1) end,function() print("❎ to kill",17,96,8) end,{20,8}}
levels[12]={function() add_enemy(60,64,0,-1) add_enemy(16,112,0) end,0,{2,20}}
levels[16]={function() switch_solid=-1 end,0,{112,112}}
levels[23]={0,function() print("end of demo :)",42,58,7) end}
levels[24]={function() switch_solid=1 end,0,{96,112}}
levels[25]={function() add_enemy(112,112,0,-1) end,0}
function level_load()
    lvl = 1+(mx/16)+(((48-my)/16)*8)
    t = 0
    shake=0

    enemies={}
    blood.lns = {}
    bloods={}
    drip={}
    objects={}
    collects={}
    plr_dust = {}


    if levels[lvl][1]!=0 then levels[lvl][1]() end
    
    scan_screen()
end

function level_init(lvl)
    --reload(0x1000, 0x1000, 0x2000,'data/map00.p8')
    update=level_update
    draw=level_draw
    mx=0
    my=48
    fade_in=16
    player_init({16,112})
    level_load()
    
end

function level_update()
    t+=1
    --if fade_in>=0 then fade_in-=1 end
    player_update()
    dust_update()
    collect_update()
    
    for e in all(enemies) do
        e:update()
    end

    for b in all(bloods) do
        b:update()
    end

    for o in all(objects) do
        if o.update!=0 then o:update() end
    end
    if switch_delay>0 then switch_delay-=1 end
    if shake>0 then shake-=1 screen_shake() else camera(0,0) end

    drip_update()
end

function level_draw()
    cls()
    --if fade_in>=0 then fade(fade_in) elseif fade_in==-1 then pal() fade_in=-1 end
    main_pal()
    map(mx,my,0,0,16,16,0x80)
    
    
    for b in all(bloods) do b:draw() end

    map(mx,my,0,0,16,16,0x40)
    --[[rectfill(0,0,7,6,0)
    print(lvl,0,0,7)--]]

    for c in all(collects) do pset(c.x,c.y,7) end

    if levels[lvl][2] != 0 then levels[lvl][2]() end
    for d in all(drip) do 
        pset(d.x,d.y,8) 
        pset(d.x,d.og_y,8)
    end

    for s in all(plr_dust) do pset(s.x,s.y,s.c) end

    for o in all(objects) do if o.draw!=0 then o:draw() end end
    for e in all(enemies) do e:draw() end
    player_draw()
end

