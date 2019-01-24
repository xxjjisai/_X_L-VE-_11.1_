-- 逐帧动画
local Animate = {};
function Animate:New(tbParams) 
    local obj = Compo:DeriveClass("Animate");
    obj.nCol = tbParams.nCol or 1;
    obj.nRow = tbParams.nRow or 1;
    obj.nStartFrame = tbParams.nStartFrame or nil; -- 起始帧，用来生成随机摆动的草等动画
    obj.nQuadW = tbParams.nQuadW or 0; -- 单个帧的宽
    obj.nQuadH = tbParams.nQuadH or 0; -- 单个帧的高
    obj.sImg = tbParams.sImg or ""; -- 动作帧 sName_act_001.png 
    obj.sActName = tbParams.sActName or ""; -- 动作帧 role_sActName_001.png 
    obj.nTotalFrame = tbParams.nTotalFrame or 0; -- 总帧数
    obj.nCurPlayCount = tbParams.nCurPlayCount or 0; -- 当前播放次数
    obj.nTotalPlayCount = tbParams.nTotalPlayCount or 0; -- 总播放次数
    obj.nTimeAfterPlay = tbParams.nTimeAfterPlay or 1; -- 多长时间后播放 (秒)
    obj.nLoop = tbParams.nLoop or 1; -- 是否循环播放
    obj.nCurFrame = 0; -- 当前播放帧
    obj.bRunning = false; -- 动画是否在运行
    obj.nLastTime = 0; -- 上一次时间
    obj.iCurQuad = nil; -- 正在渲染的当前帧
    obj.iImage = nil; -- 图集缓存
    obj.bRewin = false; -- 是否倒退播放
    obj.x = 0;
    obj.y = 0;
    obj.nOffset = tbParams.nOffset or 0;
    return obj; 
end 

return Animate;