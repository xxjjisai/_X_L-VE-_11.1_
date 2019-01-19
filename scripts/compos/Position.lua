-- 位置
local Position = {};

function Position:New(tbParams) 
    local obj = Compo:DeriveClass("Position");
    obj.x = tbParams.x;
    obj.y = tbParams.y;
    return obj; 
end 

return Position;