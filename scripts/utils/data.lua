function save()
    dset(0,mx)
    dset(1,my)
    dset(2,timer)
    dset(3,mins)
    dset(4,deaths)
    dset(5,coins)
    local next_coin_spot=6
    local next_clear_spot=20
    for i=1,32 do 
        if collected[i] then dset(next_coin_spot,i) next_coin_spot+=1 end
        if levels[i][4] then dset(next_clear_spot,i) next_clear_spot+=1 end
    end
    dset(55,next_clear_spot-20)
end

function clear_save(not_full_clear)
    for i=0,not_full_clear and 58 or 63 do dset(i,0) end
    dset(1,48)
    if not not_full_clear then menu_init() end
end
menuitem(2, "clear save", function() clear_save(false) end)

function unpack_split(a) --from drakeblues forum post
    return unpack(split(a))
end