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
            local nx = sx*8
            local ny = sy*8
            if s==28 then add_object(spike,nx,ny+4,4,6)
            elseif s==29 then add_object(spike,nx+5,ny+2,5,2)
            elseif s==30 then add_object(spike,nx,ny+2,5,2)
            elseif s==44 then add_object(spike,nx,ny,4,8)
            elseif s==6 and not collected[lvl] then add_object(coin,nx,ny,8,8,1)
            elseif s==31 then add_object(enemy_gate,nx,ny)
            elseif s==112 and #enemies>0 then add_object(enemy_gate,nx,ny) mset(sx+mx,sy+my,31)
            elseif s==98 then add_object(switch,nx,ny,8,8)
            elseif s==85 then add_object(switch_block,nx,ny,s)
            elseif s==86 then add_object(switch_block,nx,ny,s)
            elseif s==73 then add_object(spring,nx,ny,8,8,1)
            elseif s==16 then add_object(respawn_gate,nx,ny,8,8)
            end
            --sx=sx*8
            --sy=sy*8
            --[[if s==28 then add_object(spike,sx+1,sy+4,4,6)
            elseif s==29 then add_object(spike,sx+5,sy+2,5,2)
            elseif s==30 then add_object(spike,sx,sy+2,5,2)
            elseif s==44 then add_object(spike,sx,sy,4,8)
            elseif s==6 and not collected[lvl] then add_object(coin,sx,sy,8,8,1)
            elseif s==31 then add_object(enemy_gate,sx,sy)
            elseif s==112 and #enemies>0 then add_object(enemy_gate,sx,sy) mset(sx/8+mx,sy/8+my,31)
            elseif s==98 then add_object(switch,sx,sy,8,8)
            elseif s==85 then add_object(switch_block,sx,sy,s)
            elseif s==86 then add_object(switch_block,sx,sy,s)
            elseif s==73 then add_object(spring,sx,sy,8,8,1)
            elseif s==16 then add_object(respawn_gate,sx,sy,8,8)
            end]]
        end
    end
end