
_G.ContentMgr = Class:DeriveClass("ContentMgr");

function ContentMgr:ProduceHandler(iScene,fCallback)
    local cfg = _G["Scene_"..iScene.nSceneID];
    for _,tbActor in ipairs(cfg.tbActor) do 
        local iActor = ActorMgr:CreateActor(tbActor.sActorType);
        iScene:AddActor(iActor);
        iActor:ChangeiCompoParam(tbActor.tbProperty);
    end 
    for _,sSystemName in ipairs(cfg.tbSystem) do 
        iScene:RegisterSystem(_G[sSystemName]);
    end
    if fCallback then fCallback(); end 
end

function ContentMgr:UninstallHandler(iScene,fCallback)
    iScene:UninstallActor();
    iScene:UninstallSystem();
    if fCallback then fCallback(); end 
end