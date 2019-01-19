_G.MapGeneratorSystem = System:DeriveClass("MapGeneratorSystem");

MapGeneratorSystem:SetRegisterCompo{
    "Map","AStar"
}

function MapGeneratorSystem:Start()
    local iScene = self:GetCurScene();
    local iMap = iScene:GetActorByTagType("Map");
    if not self:GetRegisterCompo(iMap) then return end
    local iMapCompo = iMap:GetiCompo("Map");
    local iAstarCompo = iMap:GetiCompo("AStar");
    local tbMapInfo = {};
    math.randomseed(os.time());
    self.nCount = 0;
    iAstarCompo.tbNode.nCellSize = iMapCompo.nCellSize;
    iMapCompo.tbDataMapInfo = {iAstarCompo.tbNode};
    iMapCompo.tbRealMapInfo = {iAstarCompo.tbNode};
    while self.nCount < iMapCompo.nCellCount do
        local tbNode = clone( iMapCompo.tbDataMapInfo[#iMapCompo.tbDataMapInfo] );
        local nDir = math.random(1,4);
        if nDir == 1 then 
            tbNode.x = tbNode.x + iMapCompo.nCellSize;
        elseif nDir == 2 then  
            tbNode.x = tbNode.x - iMapCompo.nCellSize;
        elseif nDir == 3 then  
            tbNode.y = tbNode.y + iMapCompo.nCellSize;
        elseif nDir == 4 then  
            tbNode.y = tbNode.y - iMapCompo.nCellSize;
        end
        tbNode.nWalkAble = 1;
        tbNode.nCellSize = iMapCompo.nCellSize;
        if not self:GetSameItem(iMapCompo.tbDataMapInfo,tbNode) then 
            table.insert(iMapCompo.tbRealMapInfo,tbNode);
        end
        table.insert(iMapCompo.tbDataMapInfo,tbNode);
        self.nCount = self.nCount + 1;
    end 

    for i = 1, #iMapCompo.tbRealMapInfo do
        local tbNode = iMapCompo.tbRealMapInfo[i];
        local iTile = ActorMgr:CreateActor("Tile");
        iScene:AddActor(iTile);
        local nSizeW = iTile:GetiCompo("Size").w;
        local nSizeH = iTile:GetiCompo("Size").h;
        iTile:ChangeiCompoParam({
            ["Position"] = { x = tbNode.x, y = tbNode.y };
        });
        
        local iTile2 = ActorMgr:CreateActor("Tile");
        iScene:AddActor(iTile2);
        local nSizeW = iTile2:GetiCompo("Size").w;
        local nSizeH = iTile2:GetiCompo("Size").h;
        iTile2:ChangeiCompoParam({
            ["Position"] = { x = tbNode.x, y = tbNode.y };
            ["Rectangle"] = { sFillType = "line"};
            ["Color"] = { r = 0.92, g = 1, b = 1, a = 0.1 };
        });

        if i == 1 then 
            -- todo... 读取角色数据
            local iPlayer = SceneMgr:GetCurPlayer();
            local pw = iPlayer:GetiCompo("Size").w;
            local ph = iPlayer:GetiCompo("Size").h;
            local ox,oy = 2 * tbNode.x + pw * 0.5, 2 * tbNode.y + ph * 0.5;
            iPlayer:ChangeiCompoParam({
                ["Position"] = { x = ox, y = oy };
            })
        elseif i == #iMapCompo.tbRealMapInfo then 
            if SceneMgr:GetCurSceneID() < Option.nMaxSceneCount then 
                local iLeaveTile = ActorMgr:CreateActor("LeaveTile");
                iScene:AddActor(iLeaveTile);
                iLeaveTile:ChangeiCompoParam({
                    ["Position"] = { x = tbNode.x, y = tbNode.y };
                });
            end
        else
            --todo... 填充其它Actor
        end

        -- 
        tbNode.nWalkAble = 1;
        tbNode.nID = Origin:SetUniqueID();
        tbNode.addNeighbors(tbNode,iMapCompo.tbRealMapInfo);

        -- local nBoxIndex = 3;
        -- if i == math.random(2,4) then 
        --     local iBox = ActorMgr:CreateActor("Box");
        --     iScene:AddActor(iBox);
        --     local nSizeW = iBox:GetiCompo("Size").w;
        --     local nSizeH = iBox:GetiCompo("Size").h;
        --     iBox:ChangeiCompoParam({
        --         ["Position"] = { x = tbNode.x + nSizeW * 0.5, y = tbNode.y + nSizeW * 0.5};
        --     });
        --     tbNode.nWalkAble = 0;
        -- end

        -- local randomx = function (i)
        --     if i%2 == 0 then 
        --         return i;
        --     end 
        -- end

        -- if i == randomx(i) then 
        --     local iWall = ActorMgr:CreateActor("Wall");
        --     iScene:AddActor(iWall);
        --     local nSizeW = iWall:GetiCompo("Size").w;
        --     local nSizeH = iWall:GetiCompo("Size").h;
        --     iWall:GetiCompo("Size").h = math.random(10,100)
        --     iWall:ChangeiCompoParam({
        --         -- ["Position"] = { x = tbNode.x, y = tbNode.y };
        --         ["Position"] = { x = tbNode.x + nSizeW * 0.5, y = tbNode.y - nSizeW * 0.9};
        --         ["Color"] = { r = 0.5, g = math.random(), b = 0.5, a = 1 };
        --     });
        -- end

    end
    iMapCompo.tbMapInfo = tbMapInfo;
end

function MapGeneratorSystem:GetSameItem(tbDataMapInfo,tbNode)
    for i = 1,#tbDataMapInfo do 
        local item = tbDataMapInfo[i];
        if item.x == tbNode.x and item.y == tbNode.y then 
            return true;
        end 
    end
    return false;
end