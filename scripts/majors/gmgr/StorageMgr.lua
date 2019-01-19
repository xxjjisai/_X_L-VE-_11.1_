_G.StorageMgr = Class:DeriveClass("StorageMgr"); 

StorageMgr.tbRoleInfo = {};
StorageMgr.bStartPush = false;

function StorageMgr:Init()
    StorageMgr:Read()
end

function StorageMgr:Read()
    local file = io.open('data.ext','rb');
    if file == nil then 
        self:InitInfo();
        return self.tbRoleInfo;
    end
    local blob = Blob(file:read('*all'))
    local tbl = blob:readTable(); 
    file.close();
    self:Trace(1,"-----------------Storage Read Start-------------------");
    self:Trace(1,tbl);
    self:Trace(1,"----------------Storage Read Complete-----------------");
    self.tbRoleInfo = tbl;
    return tbl
end

function StorageMgr:GetInfo()
    return self.tbRoleInfo;
end

function StorageMgr:InitInfo()
    local tbInfo = 
    {
        nStyleType          = 1,    -- 玩家装扮风格类型
        nCurSceneID         = 1,    -- 玩家当前所处场景
        tbData = { a = 1, b = 2, c = 3 },
    }
    self.tbRoleInfo = tbInfo;
    self:Push(); 
end

function StorageMgr:Push()

    if not Option.bStore then
        return 
    end

    self:Trace(1,"-----------------Storage Push Start-------------------");
    local blob = Blob();
    blob:writeTable(self.tbRoleInfo);
    local file = io.open('data.ext', 'wb')
    file:write(blob:string());
    file:close();
    self:Trace(1,self.tbRoleInfo);
    self:Read();
    self:Trace(1,"----------------Storage Push Complete-----------------");
end

function StorageMgr:ChangeValue(sType,nValue)
    self.tbRoleInfo[sType] = nValue;
    if not self.bStartPush then 
        self.bStartPush = true;
        Timer:after(1, function()
            self:Push();
            self.bStartPush = false;
        end) 
    end
end

-- function StorageMgr:StorePlayerPosition()
--     local iScene = SceneMgr:GetScene();
--     if iScene == nil then return end 
--     local iPlayer = iScene:GetPlayer();
--     if iPlayer == nil then return end
--     self.tbRoleInfo["nPlayerX"] = iPlayer:GetiCompo("Transform").x;
--     self.tbRoleInfo["nPlayerY"] = iPlayer:GetiCompo("Transform").y;
--     self:Push();
-- end