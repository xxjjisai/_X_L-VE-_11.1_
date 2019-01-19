_G.GameTextCfg = 
{
    GetTextFunc = function (nIndex)
        return _G[LanguageType.Chinese.."Language"][nIndex];
    end
}

_G.EnglishLanguage = 
{
    [10000] = "_X_";
    [10001] = "  TAP TO START GAME ";
    [10002] = "World Generating...";
    [10003] = "TAP TO RESTART GAME";
    [10004] = "Pause, press P to continue";
    [10005] = " RGS ";
    [10006] = "This is Max Scene !!! ";
    [10007] = " %s  ";
    [10008] = "This is Min Scene !!! ";
    [10009] = "Can't Find TargetScene !!! ";
    [10010] = " 11.1-[0.0.1] ";
    [10011] = " The End. ";
}

_G.ChineseLanguage = 
{
    [10000] = "_X_";
    [10001] = "点击屏幕开始";
    [10002] = "世界生成中...";
    [10003] = "点击屏幕重新开始游戏";
    [10004] = "暂停, 按下 P 键继续";
    [10005] = " 生成世界中 ";
    [10006] = "已经是最后一个场景 ";
    [10007] = " %s  ";
    [10008] = "已经是第一个场景 ";
    [10009] = "没有找到目标场景 ";
    [10010] = " 11.1-[0.0.1] ";
    [10011] = " The End. ";
}