function collide_map(obj,aim,flag)
    --obj = table needs x,y,w,h
    --aim = left,right,up,down
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

--From lazydevs
function coll(a,b)
  local a_left, a_top, a_right, a_bottom,
  b_left, b_top, b_right, b_bottom = 
  a.x, a.y, a.x+a.w-1, a.y+a.h-1,
  b.x, b.y, b.x+b.w-1, b.y+b.h-1

  if a_top > b_bottom then return false end
  if b_top > a_bottom then return false end
  if a_left>b_right then return false end
  if b_left>a_right then return false end

  return true
end

function collide_map_raycast(a,b)
  local gr=(b.y-a.y)/(b.x-a.x)
  local inc=b.y-(gr*b.x)
  local dst = sqrt((a.x-b.x)^2+(a.y-b.y)^2)
  for d=1,dst do
    local col_sp=mget((d+a.x)/8 + mx,(((d+a.x)*gr)+inc)/8 + my)
    if fget(col_sp, 0) or fget(col_sp,1) or fget(col_sp,2) then return true end
  end
  return false
end

