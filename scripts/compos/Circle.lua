-- 圆形
local Circle = {};

function Circle:New(tbParams) 
    local obj = Compo:DeriveClass("Circle");
    obj.sFillType = tbParams.sFillType; -- 是否填充
    obj.r = tbParams.r; -- 半径
    return obj; 
end 

return Circle;