-- 方向
local Direction = {};

function Direction:New(tbParams) 
    local obj = Compo:DeriveClass("Direction");
    obj.x = tbParams.x; -- X 方向 ( 左:1, 右:-1 )
    obj.y = tbParams.y; -- Y 方向 ( 下:1, 上:-1 )
    return obj; 
end 

return Direction;