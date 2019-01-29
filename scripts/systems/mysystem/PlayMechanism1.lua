_G.PlayMechanism1 = GameChainSystem:DeriveClass("PlayMechanism1");

function PlayMechanism1:StartHandler() 

    self:CreateChain("Chain1",4,function (pfn) 
        local iScene = self:GetCurScene();
        local iAnimateSys = iScene:GetSystemByName("AnimationSystem");
        local iPlayer = iScene:GetPlayer(1);
        iPlayer:ChangeiCompoParam({
            ["Animate"] = { sImg = "ball", nQuadW = 32, nQuadH = 32, 
            nTotalFrame= 5, nLoop = 1, nTotalPlayCount = 10,nTimeAfterPlay = 0.07 };
        })
        iAnimateSys:ReSetFrame(iPlayer);
        iAnimateSys:Play(iPlayer);
        if pfn then pfn() end
    end,function (pfn)
        local iScene = self:GetCurScene();
        local iAnimateSys = iScene:GetSystemByName("AnimationSystem");
        local iPlayer = iScene:GetPlayer(1);
        iPlayer:ChangeiCompoParam({
            ["Animate"] = { sImg = "tc", nQuadW = 30, nQuadH = 55, 
            nTotalFrame= 18, nLoop = 0, nTotalPlayCount = 2,nTimeAfterPlay = 0.07 };
        })
        iAnimateSys:ReSetFrame(iPlayer);
        iAnimateSys:Play(iPlayer);
        if pfn then pfn() end
    end);
   
    self:ExecuteChain(true,function ()
        self:Trace(1,"Chain System complete!")
        self:StartHandler();
    end);
end