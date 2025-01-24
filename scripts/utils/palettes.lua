pals={{7,0,5,8},{0,7,6,8},{11,0,3,7},{14,10,13,2}}
pal_c=1
--custom pallette reset function
function main_pal()
    pal()
    pal(7,pals[pal_c][1],1) --fg
    pal(0,pals[pal_c][2],1) --bg2
    pal(5,pals[pal_c][3],1) --bg1
    pal(8,pals[pal_c][4],1) --blud
    --[[pal(7,10,1)
    pal(0,14,1)
    pal(8,12,1)--]]
    pal(4,-8,1)
    palt(0, false)
    palt(12, true)
end

--controls player pallette and how much blood is on the player
function plr_pal()
    if plr.spl_am>0 then
        for i=1,plr.spl_am do
            plr.spl_pal[i]=8
        end
    end
    pal(15,plr.spl_pal[1])  
    pal(13,plr.spl_pal[2])
    pal(9,plr.spl_pal[3])
end