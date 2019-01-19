_G.ClickMoveRectangle = System:DeriveClass("ClickMoveRectangle");

function ClickMoveRectangle:Update(dt)
    local iScene = self:GetCurScene();
    local tbActorList = iScene:GetActorList();
    for _,iActor in ipairs(tbActorList) do
        repeat
            if not iActor:GetiCompo("Position") then 
                break;
            end 
            if not iActor:GetiCompo("Velocity") then 
                break;
            end 
            if not iActor:GetiCompo("Direction") then 
                break;
            end 
            if not iActor:GetiCompo("MouseTarget") then 
                break;
            end 
            if not iActor:GetiCompo("Size") then 
                break;
            end 
            local isDown = love.mouse.isDown(1);
            if isDown then 
                local nSpeed = iActor:GetiCompo("Velocity").nSpeed;
                local mx,my = CameraMgr:GetMousePosition();
                local pw = iActor:GetiCompo("Size").w;
                local ph = iActor:GetiCompo("Size").h;
                iActor:GetiCompo("MouseTarget").x = mx;
                iActor:GetiCompo("MouseTarget").y = my;
                local px = iActor:GetiCompo("Position").x + pw * 0.5;
                local py = iActor:GetiCompo("Position").y + ph * 0.5;
                local vx = mx - px;
                local vy = my - py;
                local magnitude = math.sqrt(vx*vx+vy*vy);
                iActor:GetiCompo("Direction").x = vx * (1 / magnitude);
                iActor:GetiCompo("Direction").y = vy * (1 / magnitude);
                iActor:GetiCompo("Velocity").x = iActor:GetiCompo("Direction").x * nSpeed;
                iActor:GetiCompo("Velocity").y = iActor:GetiCompo("Direction").y * nSpeed;
            end
        until true
    end
end