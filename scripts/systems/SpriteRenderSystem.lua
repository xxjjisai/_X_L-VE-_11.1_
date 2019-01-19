_G.SpriteRenderSystem = System:DeriveClass("SpriteRenderSystem");

SpriteRenderSystem:SetRegisterCompo{
    "Sprite","Position"
}

function SpriteRenderSystem:Render()
    local iScene = self:GetCurScene();
    for _,tbLayer in pairs(iScene:GetRenderList()) do
       for _,iActor in ipairs(tbLayer) do 
          repeat
             if not self:GetRegisterCompo(iActor) then break end
             local x = iActor:GetiCompo("Position").x;
             local y = iActor:GetiCompo("Position").y;
             local w = iActor:GetiCompo("Size").w;
             local h = iActor:GetiCompo("Size").h;
             local sImg = iActor:GetiCompo("Sprite").sImg;
             local r = iActor:GetiCompo("Sprite").r;
             local sx = iActor:GetiCompo("Sprite").sx;
             local sy = iActor:GetiCompo("Sprite").sy;
             local ox = iActor:GetiCompo("Sprite").ox;
             local oy = iActor:GetiCompo("Sprite").oy;
             local kx = iActor:GetiCompo("Sprite").kx;
             local ky = iActor:GetiCompo("Sprite").ky; 
             local image = AssetsMgr:GetTexture(sImg);
             local nImageW = image:getWidth();
             local nImageH = image:getHeight();
             local nImageX = x - (nImageW * 0.5 - w * 0.5)
             local nImageY = y - (nImageH - h);
             local color = iActor:GetiCompo("Color");
             love.graphics.setColor(color.r,color.g,color.b,color.a);
             love.graphics.draw( image,nImageX, nImageY, r, sx, sy, ox, oy, kx, ky )
            if Option.bDebug then 
                -- 贴图轮廓
                love.graphics.setColor(100,100,250,100);
                love.graphics.rectangle("line", nImageX, nImageY, nImageW, nImageH);
                -- 底部点
                love.graphics.setColor(250,0,0,250); 
                love.graphics.circle( "fill",nImageX + nImageW / 2, nImageY + nImageH, 7 ) 
            end
          until true
       end
    end 
 end