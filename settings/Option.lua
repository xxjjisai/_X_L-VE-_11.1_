_G.Option = 
{
    bDebug = false;
    bGameInfo = false;
    bDoFileComplete = false;
    bMenuPlayed = true;
    bLog = false; -- 日志
    bLoaded = false; -- 是否加载资源完成
    sTitle = ""; -- 标题
    sGameState = "LOAD"; -- 游戏全局状态机 LOAD MENU PLAY OVER
    bExit = false; -- 是否退出
    bCamera_MouseMove = true; -- 是否适用鼠标右键移动摄像机
    bCamera_KeyMove = false; -- 是否适用键盘 Left Shift 移动摄像机
    bCamera_MouseScale = false; -- 是否鼠标滚轮缩放摄像机
    bPaused = false; -- 是否暂停
    nMaxSceneCount = 0; -- 如果是设计的场景，场景总数，在 include 中进行赋值
    bStore = false; -- 是否开启外部存储
    sPlayState = "SCENE";
}