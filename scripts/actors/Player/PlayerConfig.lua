local PlayerConfig = 
{
    ["Position"] = { x = 0, y = 0 };
    ["Size"] = { w = 64, h = 64 };
    -- ["Rectangle"] = { sFillType = "fill"};
    ["Color"] = { r = 1, g = 1, b = 1, a = 1 };
    ["RenderLayer"] = { nLayerIndex = RenderLayerType.nPlayer };
    -- ["Sprite"] = { sImg = "grass" };
    ["Animate"] = { sImg = "ball", nQuadW = 32, nQuadH = 32, nTotalFrame= 5, nLoop = 1, nTotalPlayCount = 10,nTimeAfterPlay = 0.07 };
}
return PlayerConfig