_G.RectangleRenderSystem = System:DeriveClass("RectangleRenderSystem");

RectangleRenderSystem:SetRegisterCompo{
   "RenderLayer","Rectangle","Size","Position","Color"
}

function RectangleRenderSystem:Render()
   local iScene = self:GetCurScene();
   for _,tbLayer in pairs(iScene:GetRenderList()) do
      for _,iActor in ipairs(tbLayer) do 
         repeat
            if not self:GetRegisterCompo(iActor) then break end
            local x = iActor:GetiCompo("Position").x;
            local y = iActor:GetiCompo("Position").y;
            local w = iActor:GetiCompo("Size").w;
            local h = iActor:GetiCompo("Size").h;
            local sFillType = iActor:GetiCompo("Rectangle").sFillType;
            local color = iActor:GetiCompo("Color");
            love.graphics.setColor(color.r,color.g,color.b,color.a);
            love.graphics.rectangle(sFillType,x,y,w,h);
         until true
      end
   end 
end