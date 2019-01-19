-- 颜色
local Color = {};

function Color:New(tbParams) 
    local obj = Compo:DeriveClass("Color");
    obj.r = tbParams.r;
    obj.g = tbParams.g;
    obj.b = tbParams.b;
    obj.a = tbParams.a;
    return obj; 
end 

return Color;