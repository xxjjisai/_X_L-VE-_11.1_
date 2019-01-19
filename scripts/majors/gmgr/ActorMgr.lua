_G.ActorMgr = Class:DeriveClass("ActorMgr"); 

function ActorMgr:CreateActor(sActorType)
    local sActorPath = string.format("scripts/actors/%s/%s",sActorType,sActorType);
    local sActorCfgPath = string.format("scripts/actors/%s/%sConfig",sActorType,sActorType);
    local iActor = require(sActorPath):Create(sActorType..Origin:SetUniqueID());
    iActor.sTagType = sActorType;
    local CfgActor =  require(sActorCfgPath);
    iActor:BindCompo(CfgActor);
    return iActor
end

function ActorMgr:RemoveActor(iActor)
    SceneMgr:GetCurScene():RemoveActor(iActor);
end