_G.Entity = Class:DeriveClass("Entity");

function Entity:DeriveClass(sClassName)
    local obj = {}; 
    obj.sClassName = sClassName;
    obj.tbListenerList = {};        -- 侦听列表 
    obj.tbiCompoList = {};          -- 组件列表
    obj.nUniqueID = 0;              -- 唯一识别
    obj.sTagType = "Entity";        -- 标签类型
	setmetatable(obj,{__index = self});
	return obj;
end