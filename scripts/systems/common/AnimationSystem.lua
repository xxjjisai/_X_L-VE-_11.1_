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
            self:ReSetFrame(iActor);
            self:Play(iActor);
         until true
      end
   end
end

function AnimationSystem:ReSetFrame(iActor)
   local sImg = iActor:GetiCompo("Animate").sImg;
   local iImage = AssetsMgr:GetTexture(sImg);
   iActor:GetiCompo("Animate").iImage = iImage;
   local nQuadW = iActor:GetiCompo("Animate").nQuadW;
   local nQuadH = iActor:GetiCompo("Animate").nQuadH;
   local nOffset = iActor:GetiCompo("Animate").nOffset;
   local nStartFrame = iActor:GetiCompo("Animate").nStartFrame;
   local nImgW,nImgH = iImage:getWidth(), iImage:getHeight();
   local nCol = math.floor(nImgW/nQuadW);
   local nRow = math.floor(nImgH/nQuadH);
   iActor:GetiCompo("Animate").tbQuad = {};
   local nFrame = 1;
   iActor:GetiCompo("Animate").nCurFrame = nFrame;
   for i = 0, nRow-1 do
      for j = 0, nCol-1 do
         iActor:GetiCompo("Animate").tbQuad[nFrame] = love.graphics.newQuad(j*nQuadW, i*nQuadH, nQuadW, nQuadH, nImgW, nImgH);
         nFrame = nFrame + 1;
      end
   end
   -- 根据偏移量裁剪序列帧,有点问题暂不可用
   -- for i = 1, nOffset do 
   --    table.remove(iActor:GetiCompo("Animate").tbQuad,i);
   -- end

   iActor:GetiCompo("Animate").nLastTime = 0;
   iActor:GetiCompo("Animate").nCurPlayCount = 0;
   iActor:GetiCompo("Animate").nTotalPlayCount = iActor:GetiCompo("Animate").nTotalPlayCount - nOffset;
   iActor:GetiCompo("Animate").iCurQuad = iActor:GetiCompo("Animate").tbQuad[nStartFrame or iActor:GetiCompo("Animate").nCurFrame];
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
            local nTotalFrame = iActor:GetiCompo("Animate").nTotalFrame;
            local nCurPlayCount = iActor:GetiCompo("Animate").nCurPlayCount;
            local nTotalPlayCount = iActor:GetiCompo("Animate").nTotalPlayCount;
            local nLoop = iActor:GetiCompo("Animate").nLoop;
            local nNowTime = GetTime();
            if nNowTime - nLastTime > nTimeAfterPlay then 
               iActor:GetiCompo("Animate").nLastTime = nNowTime;
               iActor:GetiCompo("Animate").nCurFrame = iActor:GetiCompo("Animate").nCurFrame + 1;
               if iActor:GetiCompo("Animate").nCurFrame > nTotalFrame then 
                  if nLoop == 0 then 
                     iActor:GetiCompo("Animate").nCurPlayCount = iActor:GetiCompo("Animate").nCurPlayCount + 1;
                     if iActor:GetiCompo("Animate").nCurPlayCount >= nTotalPlayCount then 
                        iActor:GetiCompo("Animate").iCurQuad = nil;
                        iActor:GetiCompo("Animate").bRunning = false;
                        if self.fComplete then 
                           self.fComplete();
                        end 
                        break;
                     else 
                        iActor:GetiCompo("Animate").nCurFrame = 1;
                        iActor:GetiCompo("Animate").iCurQuad = iActor:GetiCompo("Animate").tbQuad[iActor:GetiCompo("Animate").nCurFrame];
                        break;
                     end
                  elseif nLoop == 1 then  
                     iActor:GetiCompo("Animate").nCurFrame = 1;
                     iActor:GetiCompo("Animate").iCurQuad = iActor:GetiCompo("Animate").tbQuad[iActor:GetiCompo("Animate").nCurFrame];
                  end
               else 
                  iActor:GetiCompo("Animate").iCurQuad = iActor:GetiCompo("Animate").tbQuad[iActor:GetiCompo("Animate").nCurFrame];
               end
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
            if not iActor:GetiCompo("Animate").bRunning then 
               break;
            end 
            local x = iActor:GetiCompo("Position").x;
            local y = iActor:GetiCompo("Position").y;
            local iImage = iActor:GetiCompo("Animate").iImage;
            if iImage == nil then 
               self:Trace(1,"there is no image")
               break;
            end 
            local iCurQuad = iActor:GetiCompo("Animate").iCurQuad;
            if iCurQuad == nil then 
               self:Trace(1,"there is no quad")
               break;
            end 
            local nQuadW = iActor:GetiCompo("Animate").nQuadW;
            local nQuadH = iActor:GetiCompo("Animate").nQuadH;
            local w = iActor:GetiCompo("Size").w;
            local h = iActor:GetiCompo("Size").h;
            local nImageX = x - (nQuadW * 0.5 - w * 0.5)
            local nImageY = y - (nQuadH - h);
            local color = iActor:GetiCompo("Color"); 
            love.graphics.setColor(color.r,color.g,color.b,color.a);
            love.graphics.draw(iImage, iCurQuad, nImageX, nImageY)
            if Option.bDebug then 
               -- 贴图轮廓
               love.graphics.setColor(100,100,250,100);
               love.graphics.rectangle("line", nImageX, nImageY, nQuadW, nQuadH);
               -- 底部点
               love.graphics.setColor(250,0,0,250); 
               love.graphics.circle( "fill",nImageX + nQuadW / 2, nImageY + nQuadH, 7 ) 
               -- 帧序号
               love.graphics.setColor(255,0,0,250); 
               local nCurFrame = iActor:GetiCompo("Animate").nCurFrame;
               love.graphics.print(string.format("Frame:%d",nCurFrame or 0),nImageX + nQuadW / 2, nImageY + nQuadH + 10);
           end
         until true
      end
   end 
end

function AnimationSystem:Play(iActor,pfn)
   if not iActor then 
      return;
   end
   self.fComplete = pfn;
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