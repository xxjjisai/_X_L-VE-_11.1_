-- 游戏玩法链，用来递进游戏流程

_G.Chain = Entity:DeriveClass("Chain");

function Chain:DeriveClass(sClassName,nExecuteTime,onExecute,onComplete)
    local obj = {}; 
    obj.sClassName = sClassName;
    obj.sState = "execute";
    obj.tbDataList = {};                -- 数据列表
    obj.nUniqueID = 0;                  -- 唯一识别
    obj.onComplete = onComplete;        -- 完成回调
    obj.onExecute = onExecute;          -- 执行回调
    obj.nExecuteTime = nExecuteTime or 0
	setmetatable(obj,{__index = self});
	return obj;
end

function Chain:Complete(pfn)
    if self.onComplete then 
        Timer:after(self.nExecuteTime, function() 
            self.onComplete(function ()
                if pfn then
                    pfn();
                end
            end);
        end);
    end 
end

function Chain:Execute(pfn)
    if self.onExecute then 
        Timer:after(self.nExecuteTime, function() 
            self.onExecute(function ()
                if pfn then
                    pfn();
                end 
            end); 
        end);
    end 
end
