_G.MoveRectangle = System:DeriveClass("MoveRectangle");

function MoveRectangle:Update(dt)
   local iScene = self:GetCurScene();
   for _,iActor in ipairs(iScene:GetActorList()) do
        repeat 
            if iActor == nil then 
                break;
            end
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
            local mx = iActor:GetiCompo("MouseTarget").x;
            local my = iActor:GetiCompo("MouseTarget").y;
            local px = iActor:GetiCompo("Position").x;
            local py = iActor:GetiCompo("Position").y;
            local pw = iActor:GetiCompo("Size").w;
            local ph = iActor:GetiCompo("Size").h;
            local nDistance = Dist(mx,my,px + pw * 0.5,py + ph * 0.5);
            if nDistance <= 5 then 
                iActor:GetiCompo("Velocity").x = 0;
                iActor:GetiCompo("Velocity").y = 0;
                return; 
            end 
            iActor:GetiCompo("Position").x = iActor:GetiCompo("Position").x + iActor:GetiCompo("Velocity").x * dt;
            iActor:GetiCompo("Position").y = iActor:GetiCompo("Position").y + iActor:GetiCompo("Velocity").y * dt;
        until true
   end 
end