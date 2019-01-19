_G.RenderCircle = System:DeriveClass("RenderCircle");

function RenderCircle:Render()
local iScene = self:GetCurScene();
   for _,tbLayer in pairs(iScene:GetRenderList()) do
      for _,iActor in ipairs(tbLayer) do
         repeat 
            if iActor == nil then 
               break;
           end 
            if not iActor:GetiCompo("Circle") then 
               break;
            end
            if not iActor:GetiCompo("Position") then 
               break;
            end
            if not iActor:GetiCompo("Color") then 
               break;
            end
            local x = iActor:GetiCompo("Position").x;
            local y = iActor:GetiCompo("Position").y;
            local r = iActor:GetiCompo("Circle").r;
            local sFillType = iActor:GetiCompo("Circle").sFillType;
            local color = iActor:GetiCompo("Color");
            love.graphics.setColor(color.r,color.g,color.b,color.a);
            love.graphics.circle( sFillType,x,y,r )
         until true
      end
   end 
end