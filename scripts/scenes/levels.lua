--[[levels={{
    function()
        add_object(spike,8,8,4)
    end,
    function() end
},{
    function()
        add_blood_drip(55,7)
    end,
    function() line(54,-1,55,6,8) print("🅾️ to jump",13,100,5) end
},{0,function() line(85,85,100,70,5) line(110,70,110,74) line(110,70,105,70) line(110,50,95,35) end},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0,{86,112}},{function() add_enemy(56,112,0,-1) add_enemy(56,64,0,1) add_enemy(96,24,0,-1) end,function() print("❎ to kill",10,82,8) end,{20,8}},{0,0,{2,20}},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{function() add_enemy(112,112) add_enemy(100,112) add_enemy(80,80) end,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0},{0,0}}
--]]
levels={}
for i=1,32 do levels[i]={0,0} end
levels[1] = {function() end,function() end}
levels[2]={function() add_blood_drip(55,7) end, function() line(54,-1,55,6,8) print("🅾️ to jump",13,100,5) end}
levels[9]={0,0,{86,112}}
levels[10]={0,0,{2,8}}
levels[11]={function() add_enemy(56,112,0,-1) add_enemy(56,64,0,1) add_enemy(96,24,0,-1) end,function() print("❎ to kill",10,82,8) end,{20,8}}
levels[12]={0,0,{2,20}}
function level_load()
    lvl = 1+(mx/16)+(((48-my)/16)*8)
    t = 0
    shake=false
    offset=0

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
    mx=48
    my=32
    level_load()
    player_init({16,112})
end

function level_update()
    t+=1
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

    drip_update()
end

function level_draw()
    cls()
    main_pal()
    map(mx,my,0,0,16,16,0x80)
    for e in all(enemies) do e:draw() end
    
    for b in all(bloods) do b:draw() end

    map(mx,my,0,0,16,16,0x40)

    for c in all(collects) do pset(c.x,c.y,7) end

    if levels[lvl][2] != 0 then levels[lvl][2]() end
    for d in all(drip) do 
        pset(d.x,d.y,8) 
        pset(d.x,d.og_y,8)
    end

    for s in all(plr_dust) do pset(s.x,s.y,s.c) end

    for o in all(objects) do if o.draw!=0 then o:draw() end end
    player_draw()
end

