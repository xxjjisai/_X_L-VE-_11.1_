_G.CameraMgr = Class:DeriveClass("CameraMgr");  

function CameraMgr:SetFollowStyle(sFollowStyle)
    Camera:setFollowStyle(sFollowStyle);
end

function CameraMgr:Update(dt)
    if Option.bLoadActor then 
        return;
    end 
    -- 移动镜头 鼠标方式
    if Option.bCamera_MouseMove then 
        if Option.bMouse_Move then 
            local mx,my = CameraMgr:GetMousePosition();
            Camera:follow(mx, my); 
        end
    end
    -- 移动镜头 键盘方式
    if Option.bCamera_KeyMove then 
        local keyi = love.keyboard.isDown("lshift");
        if keyi then 
            local mx,my = CameraMgr:GetMousePosition();
            Camera:follow(mx, my); 
        end
    end
    if Option.bCamera_MouseScale then 
        -- 缩小镜头 
        local keyi = love.keyboard.isDown("]");
        if keyi then 
            if Camera.scale <= 0.1 then return end;
            Camera.scale = Camera.scale - 0.01;
        end 
        -- 放大镜头
        local keyu = love.keyboard.isDown("[");
        if keyu then 
            if Camera.scale >= 10 then return end;
            Camera.scale = Camera.scale + 0.01;
        end  
    end
    -- 还原镜头
    local keyu = love.keyboard.isDown("o");
    if keyu then  
        Camera.scale = 1;
    end 
    Camera:update(dt);
end 

function CameraMgr:Follow(iActor)  
    local nActorX = iActor:GetiCompo("Transform").x;
    local nActorY = iActor:GetiCompo("Transform").y;
    local nActorW = iActor:GetiCompo("Transform").w;
    local nActorH = iActor:GetiCompo("Transform").h;
    Camera:follow(nActorX + nActorW * 0.5, nActorY + nActorH * 0.5);
end 

function CameraMgr:Attach()
    Camera:attach()
end 

function CameraMgr:Detach()
    Camera:detach() 
    Camera:draw()
end 

function CameraMgr:RenderAttach(pfn)
    self:Attach();
    if pfn then 
        pfn();
    end 
    self:Detach()  
end 

function CameraMgr:Shake(nDouFU,nDuration, nHz)
    Camera:shake(nDouFU or 8,nDuration or 1, nHz or 60)
end 

function CameraMgr:Fade(nDuration,r,g,b,a,pfn)
    Camera:fade(nDuration, {r,g,b,a},pfn)
end 

function CameraMgr:Flash(nDuration,r,g,b,a)
    Camera:flash(nDuration, {r,g,b,a})
end  

function CameraMgr:GetMousePosition()
    return Camera:getMousePosition();
end 
 
function CameraMgr:WheelMoved(x, y)
    if Option.bCamera_MouseScale then  
        if y > 0 then 
            if Camera.scale >= 10 then return end;
            Camera.scale = Camera.scale + 0.04; 
        elseif y < 0 then
            if Camera.scale <= 0.1 then return end;
            Camera.scale = Camera.scale - 0.04; 
        end
    end
end 

function CameraMgr:MouseDown(x,y,button)   
    if button == 1 then 
        
    end    

    if button == 2 then 
        if Option.bCamera_MouseMove then 
            Option.bMouse_Move = not Option.bMouse_Move;
        end
    end 
end