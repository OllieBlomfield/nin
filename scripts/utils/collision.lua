function collide_map(obj,aim,flag)
    local x,y,w,h,
    x1,y1,x2,y2 =
    obj.x,obj.y,obj.w,obj.h,
    0,0,0,0
   
    if aim=="left" then
      x1,y1,x2,y2=x-1,y,x,y+h-1
    elseif aim=="right" then
      x1,y1,x2,y2=x+w-1,y,x+w,y+h-1
    elseif aim=="up" then
      x1,y1,x2,y2=x+2,y-1,x+w-3,y
    elseif aim=="down" then
      x1,y1,x2,y2=x+2,y+h,x+w-3,y+h
    end

    --pixels to tiles
    x1/=8    y1/=8
    x2/=8    y2/=8
   
    if fget(mget(x1+mx,y1+my), flag)
    or fget(mget(x1+mx,y2+my), flag)
    or fget(mget(x2+mx,y1+my), flag)
    or fget(mget(x2+mx,y2+my), flag) then
      return true
    else
      return false
    end
end

function coll(a,b)
  if a.y > b.y+b.h-1 then return false end
  if b.y > a.y+a.h-1 then return false end
  if a.x>b.x+b.w-1 then return false end
  if b.x>a.x+a.w-1 then return false end

  return true
end
