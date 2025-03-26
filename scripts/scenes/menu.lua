function menu_init()
    t,start,menu_state,sp_diff,update,draw,fade_in,selection,show_inventory,inv_delay=0,0,0,0,menu_update,menu_draw,15,0,false,0
    choices={{dget(58)==1 and "continue" or "escape",trigger_start},{"new run",function() clear_save(true) trigger_start() end}}
    pal_pos = dget(58)==1 and 3 or 2
    has_a_timer=-1
    choices[pal_pos+2]={"extra",function() show_inventory=true end}
    achievements=split"1.beat the game,2.escape in less \nthan 10 minutes,3.escape with less \nthan 30 deaths,4.collect all coins"
end

function trigger_start()
    sfx(9)
    start=1
end

fadeTable={--from https://kometbomb.net/pico8/fadegen.html
    {unpack_split"0,0,0,0,0,0,0,0,0,0,0,0,0,0,0"},
    {unpack_split"1,1,129,129,129,129,129,129,129,129,0,0,0,0,0"},
    {unpack_split"2,2,2,130,130,130,130,130,128,128,128,128,128,0,0"},
    {unpack_split"3,3,3,131,131,131,131,129,129,129,129,129,0,0,0"},
    {unpack_split"4,4,132,132,132,132,132,132,130,128,128,128,128,0,0"},
    {unpack_split"5,5,133,133,133,133,130,130,128,128,128,128,128,0,0"},
    {unpack_split"6,6,134,13,13,13,141,5,5,5,133,130,128,128,0"},
    {unpack_split"7,6,6,6,134,134,134,134,5,5,5,133,130,128,0"},
    {unpack_split"8,8,136,136,136,136,132,132,132,130,128,128,128,128,0"},
    {unpack_split"9,9,9,4,4,4,4,132,132,132,128,128,128,128,0"},
    {unpack_split"10,10,138,138,138,4,4,4,132,132,133,128,128,128,0"},
    {unpack_split"11,139,139,139,139,3,3,3,3,129,129,129,0,0,0"},
    {unpack_split"12,12,12,140,140,140,140,131,131,131,1,129,129,129,0"},
    {unpack_split"13,13,141,141,5,5,5,133,133,130,129,129,128,128,0"},
    {unpack_split"14,14,14,134,134,141,141,2,2,133,130,130,128,128,0"},
    {unpack_split"15,143,143,134,134,134,134,5,5,5,133,133,128,128,0"}
}

function menu_update()
    t+=1
    if menu_state==1 then
        if btnp(3) and selection<#choices-1 and not show_inventory then sfx(27) selection+=1 end
        if btnp(2) and not show_inventory then sfx(27) selection=max(selection-1) end
        if start>0 then start+=1
        elseif btnp(5) and not show_inventory then sfx(28) choices[selection+1][2]() end
        if start>90 then music(-1) pal() level_init() end
        choices[pal_pos]={"palette:"..pal_got[pal_c][2],
        function()
            pal_c = pal_c==#pal_got and 1 or min(pal_c+1,#pal_got)
        end}
        choices[pal_pos+1]={"timer:"..(has_a_timer==1 and "on" or "off"),function() has_a_timer*=-1 end}
    end
end

function menu_draw()
    fade(fade_in)
    if menu_state==0 then credit_draw()
    else start_draw() end

    if show_inventory then
        if btnp(4) then show_inventory=false end
        rectfill(unpack_split"20,60,110,100,0")
        rect(unpack_split"20,60,110,100,7")
        print(unpack_split"🅾️->,92,62,7")
        for i=1,4 do
            local outstr = achievements[i]..(dget(58+i)==1 and "★" or "")
            pal(7,pals[i+1][1][1])
            if i==1 then pal(7,5) print(outstr,22,62,7) else print(outstr) end
        end
    end
    

end

function fade(i)
    for c=0,15 do
        if flr(i+1)>=16 then
            pal(c,0)
        else
            pal(c,fadeTable[c+1][flr(i+1)])
        end
    end
end

function credit_draw()
    cls()
    if t<54 then fade_in=max(26-t/2) end
    if t>190 then fade_in=t/3-53 end
    if t>230 then music(10) menu_state=1 end
    if t==130 then sfx(20) end
    if t>130 then sp_diff=min(6,2*(t\2-65)) end
    spr(120+sp_diff,55,60)
    spr(121+sp_diff,67,60)
end

function start_draw()
    cls()
    fade_in=max(16-(t-230))
    change_pal()
    palt(0, false)
    palt(12, true)
    map(0,48)
    rectfill(unpack_split"0,0,128,119,0")
    for i=1,#choices do
        if not (start>0 and t%30>15) then print(choices[i][1],48,72+i*8,7) end
    end
    print("❎",40,80+selection*8)
    local next_id=2
    for i=0,3 do
        if dget(59+i)==1 then
            print("★",i*6,114)
            pal_got[next_id]=pals[i+2]
            next_id+=1
        end
    end
    --draws logo
    if start<44 then
        pal(8,7)
        pal(14,7)
        pal(15,7)
    else
        pal(8,fadeTable[7][start-44])
        pal(14,fadeTable[7][start-44])
        pal(15,fadeTable[7][start-44])
    end
    sspr(unpack_split"56,32,12,16,35,40,24,32")
    if start<44 then
        if start>0 then pal(8,8) end
        if start>2 then pal(14,8) end
        if start>3 then pal(15,8) end
    end
    spr(unpack_split"77,100,112")
    sspr(unpack_split"68,32,4,16,60,40,8,32")
    sspr(unpack_split"56,32,12,16,69,40,24,32")

    if start>45 then fade_in=start-45 end
end

