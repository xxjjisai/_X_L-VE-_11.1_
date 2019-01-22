
local Animate = {};

function Animate:New(tbParams) 
    local obj = Compo:DeriveClass("Animate");
    obj.sPlayCount = "3"; -- 播放次数 (循环播放 "n")
    obj.nTimeAfterPlay = 0.5; -- 多长时间后播放 (秒)
    obj.nCurFrame = 0; -- 当前播放帧
    obj.nTotalFrame = 8; -- 总帧数
    obj.sAct = ""; -- 动作帧 role_sAct_001.png 
    obj.sName = ""; -- 动作帧 sName_act_001.png 
    obj.nPlaySpeed = 0.4; -- 播放速度
    obj.bRunning = false; -- 动画是否在运行

    function obj:Play(sName,sAct,nPlaySpeed,nTimeAfterPlay,nPlayCount)
        self.sName = sName;
        self.sAct = sAct;
        self.nPlaySpeed = nPlaySpeed;
        self.nPlayCount = nPlayCount;
        self.nTimeAfterPlay = nTimeAfterPlay;
        self.bRunning = true;
        
    end

    function obj:Destory()
        if self.bRunning then 
            self.bRunning = false;
        end
    end

    function obj:Pause()
        if self.bRunning then 
            self.bRunning = false;
        end
    end

    function obj:Resume()
        if self.bRunning then 
            self.bRunning = false;
        end
    end

    function obj:Update(dt)
        if not self.bRunning then 
            return 
        end 

    end

    function obj:Render()
        if not self.bRunning then 
            -- 停留在当前帧
            return
        end 
    end

    return obj; 
end 

return Animate;