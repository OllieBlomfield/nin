function menu_init()
    t,start,menu_state,sp_diff,update,draw,fade_in=0,0,0,0,menu_update,menu_draw,15
end

fadeTable={--from https://kometbomb.net/pico8/fadegen.html
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
    {14,14,14,134,134,141,141,2,2,133,130,130,128,128,0},
    {15,143,143,134,134,134,134,5,5,5,133,133,128,128,0}
}

function menu_update()
    t+=1
    if menu_state==1 then
        if start>0 then start+=1
        elseif btnp(5) then start=1 end
        if start>90 then pal() level_init() end
    end
end

function menu_draw()
    fade(fade_in)
    if menu_state==0 then credit_draw()
    else start_draw() end
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
    sspr(68,32,4,16,x+25,y,8,32)
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

function credit_draw()
    cls()
    if t<54 then fade_in=max(16-((t-20)/2)) end
    if t>190 then fade_in=(t-160)/3 end
    if t>230 then menu_state=1 end
    if t>130 then sp_diff=min(6,2*(t\2-65)) end
    spr(120+sp_diff,55,60)
    spr(121+sp_diff,67,60)
end

function start_draw()
    cls()
    fade_in=max(16-(t-230))
    palt(0, false)
    palt(12, true)
    map(0,48)
    rectfill(0,0,128,119,0)
    draw_logo(35,40)
    if t%100<50 and start==0 then print("❎escape",48,80,7) end
    if start>45 then fade_in=start-45 end
end

