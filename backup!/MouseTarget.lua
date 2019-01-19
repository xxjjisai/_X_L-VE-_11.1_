-- 方向
local MouseTarget = {};

function MouseTarget:New(tbParams) 
    local obj = Compo:DeriveClass("MouseTarget");
    obj.x = tbParams.x;
    obj.y = tbParams.y;
    return obj; 
end 

return MouseTarget;