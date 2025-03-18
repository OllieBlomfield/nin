function save()
    dset(0,mx)
    dset(1,my)
    dset(2,timer)
    dset(3,mins)
    dset(4,deaths)
    dset(5,coins)
    next_spot=7
    --[[for i=1,32 do
        if collected[i] then
            dset(next_spot,i)
            next_spot+=1
        end
    end
    dset(6,next_spot-7) --sets how man]]
end

function clear_save()
    for i=0,63 do dset(i,0) end
    dset(1,48)
end
menuitem(2, "clear save", clear_save)