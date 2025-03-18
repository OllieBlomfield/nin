function damage(obj,dmg)
    obj.hp -= dmg
    obj.damaged = true
end

function draw_hb(w,hp,maxhp,prev_diff)
    local l,r=flr(64-w/2),flr(64+w/2)
    rect(l-2,121,r+2,127,0)
    rect(l-1,122,r+1,126,7)
    rectfill(l,123,r,125,0)
    local hp_length = l+w*hp/maxhp
    if hp>0 then
        rectfill(l,123,hp_length,125,8)
    end
    if prev_diff>0 then
        rectfill(hp_length,123,hp_length+w*(prev_diff/maxhp),125,4)
    end
end