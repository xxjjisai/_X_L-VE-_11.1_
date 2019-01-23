_G.AnimationSystem = System:DeriveClass("AnimationSystem");

AnimationSystem:SetRegisterCompo{
   "Animate","Position","Color","Size"
}

function AnimationSystem:Start()
   local iScene = self:GetCurScene();
   for _,tbLayer in pairs(iScene:GetRenderList()) do
      for _,iActor in ipairs(tbLayer) do 
         repeat
            if not self:GetRegisterCompo(iActor) then break end
            local sImgName = Actor:GetiCompo("Animate").sImgName;
            local iImage = AssetsMgr:GetTexture(sImgName);
            Actor:GetiCompo("Animate").iImage = iImage;
            local nQuadW = iActor:GetiCompo("Animate").nQuadW;
            local nQuadH = iActor:GetiCompo("Animate").nQuadH;
            local nImgW,nImgH = iImage:getWidth(), iImage:getHeight();
            local nCol = math.floor(nImgW/nQuadW);
            local nRow = math.floor(nImgH/nQuadH);
            Actor:GetiCompo("Animate").tbQuad = {};
            local nFrame = 1;
            for i = 0, nCol-1 do
                for j = 0, nRow-1 do
                  Actor:GetiCompo("Animate").tbQuad[nFrame] = love.graphics.newQuad(i*nQuadW, j*nQuadH, nQuadW, nQuadH, nImgW, nImgH);
                  nFrame = nFrame + 1;
                end
            end
            Actor:GetiCompo("Animate").nTotalFrame = nFrame;
         until true
      end
   end
end

function AnimationSystem:Update(dt)
   local iScene = self:GetCurScene();
   for _,tbLayer in pairs(iScene:GetRenderList()) do
      for _,iActor in ipairs(tbLayer) do 
         repeat
            if not self:GetRegisterCompo(iActor) then break end
            if not iActor:GetiCompo("Animate").bRunning then 
               break;
            end 
            local nTimeAfterPlay = iActor:GetiCompo("Animate").nTimeAfterPlay;
            local nLastTime = iActor:GetiCompo("Animate").nLastTime;
            local nNowTime = GetTime();
            if nNowTime - nLastTime >= nTimeAfterPlay * 1000 then 
               iActor:GetiCompo("Animate").nLastTime = nNowTime;
               iActor:GetiCompo("Animate").nCurFrame = iActor:GetiCompo("Animate").nCurFrame + 1;
               if iActor:GetiCompo("Animate").nCurFrame >= iActor:GetiCompo("Animate").nTotalFrame then 
                  iActor:GetiCompo("Animate").iCurQuad = iActor:GetiCompo("Animate").tbQuad[iActor:GetiCompo("Animate").nTotalFrame];
                  break;
               end
               iActor:GetiCompo("Animate").iCurQuad = iActor:GetiCompo("Animate").tbQuad[iActor:GetiCompo("Animate").nCurFrame];
            end 
         until true
      end
   end 
end

function AnimationSystem:Render()
   local iScene = self:GetCurScene();
   for _,tbLayer in pairs(iScene:GetRenderList()) do
      for _,iActor in ipairs(tbLayer) do 
         repeat
            if not self:GetRegisterCompo(iActor) then break end
            local x = iActor:GetiCompo("Position").x;
            local y = iActor:GetiCompo("Position").y;
            local iImage = iActor:GetiCompo("Animate").iImage;
            local iCurQuad = iActor:GetiCompo("Animate").iCurQuad;
            local nQuadW = iActor:GetiCompo("Animate").nQuadW;
            local nQuadH = iActor:GetiCompo("Animate").nQuadH;
            local w = iActor:GetiCompo("Size").w;
            local h = iActor:GetiCompo("Size").h;
            local nImageX = x - (nQuadW * 0.5 - w * 0.5)
            local nImageY = y - (nQuadH - h);
            local color = iActor:GetiCompo("Color");
            love.graphics.setColor(color.r,color.g,color.b,color.a);
            love.graphics.drawq(iImage, iCurQuad, nImageX, nImageY)
         until true
      end
   end 
end

function AnimationSystem:Play(iActor)
   if not iActor then 
      return;
   end
   iActor:GetiCompo("Animate").bRunning = true;
end

function AnimationSystem:Destory(iActor)
   if not iActor then 
      return;
   end
   if iActor:GetiCompo("Animate").bRunning then 
       iActor:GetiCompo("Animate").bRunning = false;
   end
end

function AnimationSystem:Pause(iActor)
   if not iActor then 
      return;
   end
   if iActor:GetiCompo("Animate").bRunning then 
       iActor:GetiCompo("Animate").bRunning = false;
   end
end

function AnimationSystem:Resume(iActor)
   if not iActor then 
      return;
   end
   if not iActor:GetiCompo("Animate").bRunning then 
       iActor:GetiCompo("Animate").bRunning = true;
   end
end