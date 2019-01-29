-- 游戏链系统
_G.GameChainSystem = System:DeriveClass("GameChainSystem");

function GameChainSystem:Start()
    self.tbChainList = {};
    self.iChain = nil;
    self.nCurIndex = 0;
    self:StartHandler();
end

function GameChainSystem:StartHandler()
    self:Trace(3,"you must Implementation !!!")
end

function GameChainSystem:ExecuteChain(bExecute,onComplete)
    self.nCurIndex = self.nCurIndex + 1;
    if self.nCurIndex > #self.tbChainList then 
        if onComplete then 
            self.nCurIndex = 0;
            self.tbChainList = {};
            self.iChain = nil;
            self.nCurIndex = 0;
            onComplete();
        end
        return;
    end 
    self.iChain = self.tbChainList[self.nCurIndex];
    self.iChain:Execute(function ()
        self.iChain:Complete(function()
            if bExecute then 
                self:ExecuteChain(bExecute,onComplete)
            end 
        end);
    end);
end

function GameChainSystem:CreateChain(sClassName,nExecuteTime,onExecute,onComplete)
    local iChain = Chain:DeriveClass(sClassName, nExecuteTime, onExecute, onComplete);
    table.insert(self.tbChainList,iChain)
end

