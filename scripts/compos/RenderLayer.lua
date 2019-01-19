-- 矩形
local RenderLayer = {};

function RenderLayer:New(tbParams) 
    local obj = Compo:DeriveClass("RenderLayer");
    obj.nLayerIndex = tbParams.nLayerIndex; -- 渲染层级 ( 值：RenderLayerType )
    return obj; 
end 

return RenderLayer;