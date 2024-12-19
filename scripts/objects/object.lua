function add_object(type,x,y,h,w,frame)
    add(objects,{
        x=x or 0,
        y=y or 0,
        h=h or 8,
        w=w or 8,
        anim=anim or nil,
        frame=frame or nil,
        update=type.update or 0,
        draw=type.draw or 0,
    })
end

function scan_screen()
    for sx=0,15 do
        for sy=0,15 do
            local s = mget(sx+mx,sy+my)
            if s==28 then add_object(spike,(sx*8)+1,(sy*8)+4,4,6)
            elseif s==29 then add_object(spike,(sx*8)+5,sy*8,8,2)
            elseif s==30 then add_object(spike,sx*8,sy*8,8,2)
            elseif s==6 and not collected[lvl] then add_object(coin,sx*8,sy*8,8,8,1)
            elseif s==98 then add_object(switch,sx*8,sy*8,8,8)
            elseif s==85 then add_object(switch_block,sx*8,sy*8)
            end
        end
    end
end