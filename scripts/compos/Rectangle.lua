-- 矩形
local Rectangle = {};

function Rectangle:New(tbParams) 
    local obj = Compo:DeriveClass("Rectangle");
    obj.sFillType = tbParams.sFillType; -- 是否填充
    return obj; 
end 

return Rectangle;