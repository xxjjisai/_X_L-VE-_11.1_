_G.PlayMechanism2 = GameChainSystem:DeriveClass("PlayMechanism2");

function PlayMechanism2:StartHandler()
 
    self:CreateChain("Chain1",function (pfn) 
        Timer:after(1, function() 
            local iScene = self:GetCurScene();
            local iAnimateSys = iScene:GetSystemByName("AnimationSystem");
            local iPlayer = iScene:GetPlayer(1)
            iPlayer:ChangeiCompoParam({
                ["Animate"] = { sImg = "ball", nQuadW = 32, nQuadH = 32, nTotalFrame= 5, nLoop = 1, nTotalPlayCount = 10,nTimeAfterPlay = 0.07 };
            })
            iAnimateSys:ReSetFrame(iPlayer);
            iAnimateSys:Play(iPlayer);
            if pfn then 
                pfn()
            end 
        end)
    end,function (pfn) 
        Timer:after(1, function() 
            self:Trace(1,"Chain1 complete") 
            if pfn then 
                pfn()
            end
        end)
    end);

    self:CreateChain("Chain2",function (pfn)
        Timer:after(2, function() 
            local iScene = self:GetCurScene();
            local iAnimateSys = iScene:GetSystemByName("AnimationSystem");
            local iPlayer = iScene:GetPlayer(1)
            iPlayer:ChangeiCompoParam({
                ["Animate"] = { sImg = "tc", nQuadW = 30, nQuadH = 55, nTotalFrame= 18, nLoop = 1, nTotalPlayCount = 5,nTimeAfterPlay = 0.07 };
            })
            iAnimateSys:ReSetFrame(iPlayer);
            iAnimateSys:Play(iPlayer);
            if pfn then 
                pfn()
            end
        end)
    end,function (pfn) 
        Timer:after(2, function() 
            self:Trace(1,"Chain2 complete") 
            if pfn then 
                pfn()
            end
        end)
    end);

    self:CreateChain("Chain3",function (pfn)
        Timer:after(3, function() 
            local iScene = self:GetCurScene();
            local iAnimateSys = iScene:GetSystemByName("AnimationSystem");
            local iPlayer = iScene:GetPlayer(1)
            iPlayer:ChangeiCompoParam({
                ["Animate"] = { sImg = "ball", nQuadW = 32, nQuadH = 32, nTotalFrame= 5, nLoop = 1, nTotalPlayCount = 10,nTimeAfterPlay = 0.07 };
            })
            iAnimateSys:ReSetFrame(iPlayer);
            iAnimateSys:Play(iPlayer);
            if pfn then 
                pfn()
            end
        end) 
    end,function (pfn) 
        Timer:after(3, function() 
            self:Trace(1,"Chain3 complete")
            local iScene = self:GetCurScene();
            local iAnimateSys = iScene:GetSystemByName("AnimationSystem");
            local iPlayer = iScene:GetPlayer(1)
            iPlayer:ChangeiCompoParam({
                ["Animate"] = { sImg = "tc", nQuadW = 30, nQuadH = 55, nTotalFrame= 18, nLoop = 1, nTotalPlayCount = 10,nTimeAfterPlay = 0.07 };
            })
            iAnimateSys:ReSetFrame(iPlayer);
            iAnimateSys:Play(iPlayer);
            if pfn then 
                pfn()
            end
        end) 
    end);

    self:ExecuteChain(true,function ()
        self:StartHandler();
        self:Trace(1,"Chain System complete!")
    end);
end