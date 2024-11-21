function main_pal()
    pal(4,-8,1)
    palt(0, false)
    palt(12, true)

    if plr.splat_t > 0 then
        pal(15,plr.spl_pal)
        if plr.spl_am>0 then
            pal(13,plr.spl_pal)
            if plr.spl_am==2 then
                pal(9,plr.spl_pal)
            else
                pal(9,7)
            end
        else
            pal(13,7)
        end
    else
        pal(15,7)
        pal(13,7)
        pal(9,7)
    end
end