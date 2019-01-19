-- 精灵
local Sprite = {};

function Sprite:New(tbParams) 
    local obj = Compo:DeriveClass("Sprite");
    obj.sImg = tbParams.sImg;
    obj.r = tbParams.r or 0;
    obj.sx = tbParams.sx or 1;
    obj.sy = tbParams.sy or 1;
    obj.ox = tbParams.ox or 0;
    obj.oy = tbParams.oy or 0;
    obj.kx = tbParams.kx or 0;
    obj.ky = tbParams.ky or 0;
    return obj; 
end 

return Sprite;