_G.Compo = Class:DeriveClass("Compo");

function Compo:DeriveClass(sClassName)
    local obj = {}; 
    obj.sClassName = sClassName;
    obj.nUniqueID = 0;              -- 唯一识别
    obj.sTagType = "Compo";         -- 标签类型
	setmetatable(obj,{__index = self});
	return obj;
end