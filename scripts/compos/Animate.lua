-- 逐帧动画
local Animate = {};
function Animate:New(tbParams) 
    local obj = Compo:DeriveClass("Animate");
    obj.nCol = tbParams.nCol or 1;
    obj.nRow = tbParams.nRow or 1;
    obj.nQuadW = tbParams.nQuadW or 0; -- 单个帧的宽
    obj.nQuadH = tbParams.nQuadH or 0; -- 单个帧的高
    obj.sImgName = tbParams.sImgName or ""; -- 动作帧 sName_act_001.png 
    obj.sActName = tbParams.sActName or ""; -- 动作帧 role_sActName_001.png 
    obj.nTotalFrame = tbParams.nTotalFrame or 0; -- 总帧数
    obj.sPlayCount = tbParams.sPlayCount or "3"; -- 播放次数 (循环播放 "n")
    obj.nTimeAfterPlay = tbParams.nTimeAfterPlay or 0.5; -- 多长时间后播放 (秒)
    obj.nCurFrame = 0; -- 当前播放帧
    obj.bRunning = false; -- 动画是否在运行
    obj.nLastTime = 0; -- 上一次时间
    obj.iCurQuad = nil; -- 正在渲染的当前帧
    obj.iImage = nil; -- 图集
    obj.x = 0;
    obj.y = 0;
    return obj; 
end 

return Animate;