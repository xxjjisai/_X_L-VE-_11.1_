
require("scripts/majors/core/Class");
require("scripts/majors/core/Event");
require("scripts/majors/core/Origin");

require("scripts/majors/base/Entity");
require("scripts/majors/base/Actor");
require("scripts/majors/base/Compo");
require("scripts/majors/base/Scene");
require("scripts/majors/base/System");
require("scripts/majors/base/Model");
require("scripts/majors/base/Chain");

require("settings/Option");
require("settings/include");

-- 系统列表
function love.load()
    _G.graphicsWidth  = love.graphics.getWidth();
    _G.graphicsHeight = love.graphics.getHeight();
    _G.screenWidth, _G.screenHeight = love.window.getDesktopDimensions();
    love.graphics.setBackgroundColor(0.2156862745098,0.27843137254902,0.30980392156863);

    Include:Import(function(nCode)
        if nCode ~= 0 then 
            return error("do file failed");
        end  
        Option.bDoFileComplete = true;
        GameMgr:StartUp();
    end)

    if Option.bLog then 
        local str = string.format(" \n ******************************* [ %s ] ******************************* \n ",os.date("%c"));
        local file = io.open('gc.log', 'w')
        file:write(str.."\n");
        file:close();
    end
end

function love.update(dt)
    if Option.bDoFileComplete then 
        Timer:update(dt); 
        Tween.update(dt);
        GameMgr:Update(dt); 
    end 
end

function love.draw()
    if Option.bDoFileComplete then 
        GameMgr:Render(); 
    end
    if Option.bDebug then 
        -- 状态
        love.graphics.setFont(AssetsMgr:GetFont(241));
        love.graphics.setColor(1, 0, 0, 1);
        love.graphics.print(Option.sGameState, graphicsWidth - AssetsMgr:GetFont(241):getWidth(Option.sGameState) - 10,10);
        -- 帧率等信息
        love.graphics.setColor(1,0.19,0.19,1);
        local stats = love.graphics.getStats();
        local str_stats = "GPU Memory: "..(math.floor(stats.texturememory/1.024)/1000).." Kb\nLUA Memory: "..
        (math.floor(collectgarbage("count")/1.024)/1000).." Kb\nFonts: "..stats.fonts.."\nCanvas Switches: "..
        stats.canvasswitches.."\nCanvases: "..stats.canvases.."\nFPS: "..love.timer.getFPS()
        love.graphics.print(str_stats,10,10);
        love.graphics.setColor(1,1,1,1);   
        love.graphics.setFont(AssetsMgr:GetFont(241));
    end
end

--------------------------------------

function love.mousepressed(x, y, button, istouch, presses)
    if Option.bDoFileComplete == true then 
        GameMgr:MouseDown(x, y, button, istouch, presses);
    end 
end 

function love.mousereleased(x, y, button, istouch, presses)
    if Option.bDoFileComplete == true then
        GameMgr:MouseUp(x, y, button, istouch, presses);
    end 
end

function love.mousemoved(x, y, dx, dy, istouch)
    if Option.bDoFileComplete == true then
        GameMgr:MouseMoved(x, y, dx, dy, istouch);
    end 
end

function love.keypressed(key, scancode, isrepeat)
    if key == "r" then 
        love.event.quit("restart");
    end 
    if key == "escape" then 
        love.event.quit();
    end 
    if Option.bDoFileComplete == true then
        GameMgr:KeyBoardDown(key, scancode, isrepeat);
    end 
end  

function love.keyreleased(key, scancode)
    if Option.bDoFileComplete == true then
        GameMgr:KeyBoardUp(key, scancode);
    end 
end

function love.wheelmoved(x, y)
    if Option.bDoFileComplete == true then
        GameMgr:WheelMoved(x, y); 
    end
end

function love.textinput(text)
    if Option.bDoFileComplete == true then
        GameMgr:TextInput(text); 
    end
end

-- 关闭游戏
function love.quit()
	if Option.bExit then
		print("we are not ready to quit yet!")
		Option.bExit = not Option.bExit;
    else
        if Option.bDoFileComplete == true then 
            GameMgr:QuitGame();
        end 
		print("Thanks for playing.Please play again soon!")
		return Option.bExit;
	end
	return true
end