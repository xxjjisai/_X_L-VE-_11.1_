-- 尺寸
local Size = {};

function Size:New(tbParams) 
    local obj = Compo:DeriveClass("Size");
    obj.w = tbParams.w; -- 宽
    obj.h = tbParams.h; -- 高
    return obj; 
end 

return Size;