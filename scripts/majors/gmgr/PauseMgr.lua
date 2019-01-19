_G.PauseMgr = Class:DeriveClass("PauseMgr"); 

function PauseMgr:Render()
    love.graphics.setFont(AssetsMgr:GetFont(522));
    -- love.graphics.push();
    -- love.graphics.scale(offestw,offesth);
    love.graphics.setColor(1,1,1,1);
    love.graphics.setFont(AssetsMgr:GetFont(482));
    love.graphics.print(GameTextCfg.GetTextFunc(10004), (graphicsWidth*0.5) - AssetsMgr:GetFont(482):getWidth(GameTextCfg.GetTextFunc(10004))*0.5,graphicsHeight*0.4);
    love.graphics.setColor(1,1,1,1);
    -- love.graphics.pop();
    love.graphics.setFont(AssetsMgr:GetFont(242));
    love.graphics.setFont(AssetsMgr:GetFont(522));
    love.graphics.setFont(AssetsMgr:GetFont(142));
end 

