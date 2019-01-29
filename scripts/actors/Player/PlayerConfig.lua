local PlayerConfig = 
{
    ["Position"] = { x = 0, y = 0 };
    ["Size"] = { w = 64, h = 64 };
    ["Color"] = { r = 1, g = 1, b = 1, a = 1 };
    ["RenderLayer"] = { nLayerIndex = RenderLayerType.nPlayer };
    -- ["Rectangle"] = { sFillType = "fill"};
    -- ["Sprite"] = { sImg = "grass" };
    -- ["Animate"] = { sImg = "ball", nQuadW = 32, nQuadH = 32, nTotalFrame= 5, nLoop = 1, nTotalPlayCount = 10,nTimeAfterPlay = 0.07 };
    ["Animate"] = { sImg = "tc", nQuadW = 30, nQuadH = 55, nTotalFrame= 18, nLoop = 1, nTotalPlayCount = 10,nTimeAfterPlay = 0.07 };
}
return PlayerConfig