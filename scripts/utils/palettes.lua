function main_pal()
    pal()
    pal(4,-8,1)
    palt(0, false)
    palt(12, true)
end

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