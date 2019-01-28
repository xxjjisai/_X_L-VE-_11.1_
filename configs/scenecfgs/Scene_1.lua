
_G.Scene_1 = 
{
    tbActor = 
    {
        { sActorType = "Player"; },
        { sActorType = "Player"; tbProperty = {
            ["Position"] = { x = 100, y = 0 };
            ["Animate"] = { sImg = "tc", nQuadW = 30, nQuadH = 55, nTotalFrame= 18, nLoop = 1, nTotalPlayCount = 10,nTimeAfterPlay = 0.07 };
        }},
        { sActorType = "Player"; tbProperty = {
            ["Position"] = { x = 200, y = 0 };
            ["Animate"] = { sImg = "tc", nQuadW = 30, nQuadH = 55, nTotalFrame= 18, nLoop = 1, nTotalPlayCount = 10,nTimeAfterPlay = 0.07 };
        }},
        { sActorType = "Player"; tbProperty = {
            ["Position"] = { x = 200, y = 100 };
            ["Animate"] = { sImg = "ball", nQuadW = 32, nQuadH = 32, nTotalFrame= 5, nLoop = 1, nTotalPlayCount = 10,nTimeAfterPlay = 0.07 };
        }},
    };

    tbSystem = 
    {
        "RectangleRenderSystem",
        "LayerSortSystem",
        "SpriteRenderSystem",
        "AnimationSystem",
        -- "UISystem",
    };
}