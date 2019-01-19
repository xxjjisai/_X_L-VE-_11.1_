
-- 速率
local Velocity = {};

function Velocity:New(tbParams) 
    local obj = Compo:DeriveClass("Velocity");
    obj.x = tbParams.x or 0; -- x 轴速率
    obj.y = tbParams.y or 0; -- y 轴速率
    obj.nSpeed = tbParams.nSpeed or 0;
    return obj; 
end 

return Velocity;