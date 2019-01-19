_G.MenuMgr = Class:DeriveClass("MenuMgr");
MenuMgr.speed = 100;
MenuMgr.nCricleR = 1;
function MenuMgr:Start(speed,pfn)

	self.speed = speed or 100;
	splash.populate(
		{
			{		
				image = love.graphics.newImage("assets/textures/images/trees.png"),
				-- footer = "Look, some trees!",
				footer = "",
				speed = self.speed,
				duration = 2,
			},
			{		
				image = love.graphics.newImage("assets/textures/images/rabbit.png"),
				-- footer = "There is a rabbit nearby...",
				footer = "",
				speed = self.speed,
				duration = 2,
			},
			{		
				image = love.graphics.newImage("assets/textures/images/mushroom.png"),
				-- footer = "Who likes eating mushrooms!",
				footer = "",
				speed = self.speed,
				duration = 2,
			},
			{		
				image = love.graphics.newImage("assets/textures/images/love-app-icon.png"),
				-- footer = "Who likes eating mushrooms!",
				footer = "",
				speed = self.speed,
				duration = 2,
			},
		}
	)
		
	splash.callback = pfn;
end 

MenuMgr.bScalBig = true;
function MenuMgr:Update(dt)
	splash.update(dt)
	if self.bScalBig then 
		if self.nCricleR <= 0.1 then 
			self.bScalBig = false;
			return 
		end 
		self.nCricleR = self.nCricleR - 0.01;
	else 
		if self.nCricleR >= 1 then 
			self.bScalBig = true;
			return 
		end 
		self.nCricleR = self.nCricleR + 0.01;
	end


	if splash.active() then 
		return 
	end
end  

function MenuMgr:Render()
	if Option.bMenuPlayed then 
		if Option.sGameState == "MENU" then -- 开始界面
			love.graphics.push();
			love.graphics.scale(offestw,offesth);
			love.graphics.setColor(1,1,1,1);
			love.graphics.setFont(AssetsMgr:GetFont(722));
			love.graphics.print(GameTextCfg.GetTextFunc(10000), (graphicsWidth*0.5) - AssetsMgr:GetFont(722):getWidth(GameTextCfg.GetTextFunc(10000))*0.5,graphicsHeight*0.35);
			love.graphics.setColor(1,1,1,self.nCricleR);
			love.graphics.setFont(AssetsMgr:GetFont(242));
			love.graphics.print(GameTextCfg.GetTextFunc(10001), (graphicsWidth*0.5) - AssetsMgr:GetFont(242):getWidth(GameTextCfg.GetTextFunc(10001))*0.5,graphicsHeight*0.6);
			if Option.bDebug then
				love.graphics.setColor(1, 0, 0, 1);
				local nVersionWidth = graphicsWidth - AssetsMgr:GetFont(242):getWidth(" 11.1-[0.0.1] ");
				local nVersionHeight = graphicsHeight - AssetsMgr:GetFont(242):getHeight(" 11.1-[0.0.1] ") * 1.5 
				love.graphics.print(GameTextCfg.GetTextFunc(10010), nVersionWidth,nVersionHeight);
			end
			love.graphics.setColor(1,1,1,1);
			love.graphics.setFont(AssetsMgr:GetFont(142));
			love.graphics.pop();
		end 
	else
		splash.draw()
		if splash.active() then 
			return 
		end
	end
end 