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