local PlayerConfig = 
{
    ["Position"] = { x = 0, y = 0 };
    ["Size"] = { w = 32, h = 32 };
    ["Rectangle"] = { sFillType = "fill"};
    ["Color"] = { r = 1, g = 1, b = 1, a = 1 };
    ["RenderLayer"] = { nLayerIndex = RenderLayerType.nPlayer };
    ["Sprite"] = { sImg = "grass" };
    ["Animate"] = { sImg = "ball", nQuadW = 32, nQuadH = 32, nTotalFrame= 5, nLoop = 1, nTimeAfterPlay = 0.07 };
}
return PlayerConfig