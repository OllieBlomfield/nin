function damage(obj, dmg)
    obj.hp -= dmg
    obj.damaged = true
end

function draw_health(obj)
    for i=0,obj.hp-1 do spr(49,6*i,4) end
end