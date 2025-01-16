function menu_init()
    t=0
    start=0
    update=menu_update
    draw=menu_draw
end

fadeTable={ --from https://kometbomb.net/pico8/fadegen.html
    {0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    {1,1,129,129,129,129,129,129,129,129,0,0,0,0,0},
    {2,2,2,130,130,130,130,130,128,128,128,128,128,0,0},
    {3,3,3,131,131,131,131,129,129,129,129,129,0,0,0},
    {4,4,132,132,132,132,132,132,130,128,128,128,128,0,0},
    {5,5,133,133,133,133,130,130,128,128,128,128,128,0,0},
    {6,6,134,13,13,13,141,5,5,5,133,130,128,128,0},
    {7,6,6,6,134,134,134,134,5,5,5,133,130,128,0},
    {8,8,136,136,136,136,132,132,132,130,128,128,128,128,0},
    {9,9,9,4,4,4,4,132,132,132,128,128,128,128,0},
    {10,10,138,138,138,4,4,4,132,132,133,128,128,128,0},
    {11,139,139,139,139,3,3,3,3,129,129,129,0,0,0},
    {12,12,12,140,140,140,140,131,131,131,1,129,129,129,0},
    {13,13,141,141,5,5,5,133,133,130,129,129,128,128,0},
    {14,8,136,136,136,136,132,132,132,130,128,128,128,128,0},
    {8,8,136,136,136,136,132,132,132,130,128,128,128,128,0}
   }

function menu_update()
    t+=1
    if start>0 then start+=1 end
    if btnp(5) then start=1 end
    if start>90 then pal() level_init() end
end

function menu_draw()
    cls()
    palt(0, false)
    palt(12, true)
    map(0,48)
    rectfill(0,0,128,119,0)
    rect(0,0,127,127,7)
    draw_logo(35,40)
    print("demo v1",35,74)
    if t%100<50 and start==0 then print("❎escape",48,80,7) end
    if start>45 then fade(start-45) end
end

function draw_logo(x,y)
    if start<44 then
        pal(8,7)
        pal(14,7)
        pal(15,7)
    else
        pal(8,fadeTable[7][start-44])
        pal(14,fadeTable[7][start-44])
        pal(15,fadeTable[7][start-44])
    end
    sspr(56,32,12,16,x,y,24,32)
    if start<44 then
        if start>0 then pal(8,8) end
        if start>2 then pal(14,8) end
        if start>3 then pal(15,8) end
    end
    sspr(68,32,5,16,x+25,y,10,32)
    sspr(56,32,12,16,x+34,y,24,32)
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

