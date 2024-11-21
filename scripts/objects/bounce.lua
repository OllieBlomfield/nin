bounce={
    x=0,
    y=0,
    h=8,
    w=8,

    new=function(self,tbl)
        tbl=tbl or {}
        setmetatable(tbl,{__index=self})
        return tbl
    end,

    draw=function(self)
        for b in all(bounces) do
            spr(70,b.x,b.y)
        end
    end
}

BOUNCE_AMOUNT=1.2

function obj_bounce(obj,d)
    if d==1 then
        obj.vx=-BOUNCE_AMOUNT
    elseif d==2 then
        obj.vx=BOUNCE_AMOUNT
    elseif d==3 then
        obj.vy=BOUNCE_AMOUNT
    elseif d==4 then
        obj.vy=-BOUNCE_AMOUNT
    end
end

function add_bounce(x,y)
    add(bounces,bounce:new({
        x=x,
        y=y
    }))
end