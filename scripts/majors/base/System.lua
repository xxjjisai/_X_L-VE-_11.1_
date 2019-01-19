_G.System = Class:DeriveClass("System");

function System:DeriveClass(sClassName)
    local obj = {}; 
    obj.sClassName = sClassName;
    obj.tbListenerList = {};                -- 侦听列表 
    obj.tbRegisterCompoList = {};           -- 注册该系统需要的组件列表
    obj.nUniqueID = 0;                      -- 唯一识别
    obj.sTagType = "System";                -- 标签类型
	setmetatable(obj,{__index = self});
	return obj;
end

function System:GetCurScene()
    return SceneMgr:GetCurScene();
end

function System:SetRegisterCompo(tbRegisterCompoList)
    self.tbRegisterCompoList = tbRegisterCompoList;
end 

function System:GetRegisterCompo(iActor)
    if iActor == nil then return false end
    local nCompoCount = #self.tbRegisterCompoList;
    for _,sCompoName in ipairs(self.tbRegisterCompoList) do 
        if iActor:GetiCompo(sCompoName) then 
           nCompoCount = nCompoCount - 1;
        end
    end
    if nCompoCount <= 0 then 
        return true;
    end
    return false;
end 

