function collide_map(obj,aim,flag)
    --obj = table needs x,y,w,h
    --aim = left,right,up,down
   
    local x=obj.x  local y=obj.y
    local w=obj.w  local h=obj.h
   
    local x1=0	 local y1=0
    local x2=0  local y2=0
   
    if aim=="left" then
      x1=x-1  y1=y
      x2=x    y2=y+h-1
   
    elseif aim=="right" then
      x1=x+w-1    y1=y
      x2=x+w  y2=y+h-1
   
    elseif aim=="up" then
      x1=x+2    y1=y-1
      x2=x+w-3  y2=y
   
    elseif aim=="down" then
      x1=x+2      y1=y+h
      x2=x+w-3    y2=y+h
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
  local a_left=a.x
  local a_top=a.y
  local a_right=a.x+a.w-1
  local a_bottom=a.y+a.h-1

  local b_left=b.x
  local b_top=b.y
  local b_right=b.x+b.w-1
  local b_bottom=b.y+b.h-1

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
    local col_sp=mget((d+a.x)/8,(((d+a.x)*gr)+inc)/8)
    if fget(col_sp, 0) or fget(col_sp,1) or fget(col_sp/8,2) then return true end
  end
  return false
end

