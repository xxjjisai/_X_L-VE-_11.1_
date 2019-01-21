_G.Model = Entity:DeriveClass("Model");

function Model:DeriveClass(sClassName)
    local obj = {}; 
    obj.sClassName = sClassName;
    obj.tbDataList = {};        -- 数据列表
    obj.nUniqueID = 0;          -- 唯一识别
	setmetatable(obj,{__index = self});
	return obj;
end

function Model:SetDataValue(key,value)
    self.tbDataList[key] = value;
end

function Model:GetDataByKey(key)
    return self.tbDataList[key];
end

function Model:GetDataHandler()
    return self.tbDataList;
end

function Model:Init()
    self:Trace(1," Model:Init must be Implementation ")
end