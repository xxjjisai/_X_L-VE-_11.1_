_G.AssetsMgr = Class:DeriveClass("AssetsMgr");  

AssetsMgr.tbMedia = {images = {}, sounds = {}, fonts = {}};
AssetsMgr.tbRecordMedia = {}; 
AssetsMgr.loadlogo = nil;

function AssetsMgr:Start(sSceneName,callback) 
    self.loadlogo = nil;--love.graphics.newImage( "assets/textures/flash.jpg" )
	Option.bLoaded = false; 
    self:Trace(1,"[started loading]"); 
    local pfn = function ()
        self:Trace(1,"[End loading]");
        Option.bLoaded = true;
        callback();
    end  
    
    if AssetsMgr.tbRecordMedia[sSceneName] ~= nil then 
        pfn();
        return;
    end  
    
    -- 字体资源
    local tbFont = AssetsFontCfg[sSceneName];
    if not next(tbFont) then 
        self:Trace(1,"Not Find Font");
    else
        local iFont = {};
        if tbFont ~= nil then 
            for a = 1, #tbFont do 
                for i = 1, 72 do 
                    if i%2==0 then 
                        iFont.sName = i..tbFont[a].sName;
                        iFont.sPath = tbFont[a].sPath;
                        iFont.nSize = i;
                        AssetsMgr.tbMedia.fonts[tonumber(iFont.sName)] = love.graphics.newFont(iFont.sPath,iFont.nSize);
                    end
                end
            end
        end 
    end
    
    -- 声音资源
    local tbSound = AssetsVoiceCfg[sSceneName];
    if not next(tbSound) then 
        self:Trace(1,"Not Find Sound");
    else
        if tbSound ~= nil then 
            for _,iSound in pairs(AssetsVoiceCfg[sSceneName]) do 
                if iSound ~= nil then 
                    self:Trace(1,"Loading Sound ",iSound.sName);
                    AssetsMgr.tbMedia.sounds[iSound.sName] = love.audio.newSource(iSound.sPath, "stream" );
                end    
            end
        end  
    end 

    -- 贴图资源
    local tbImage = AssetsTextureCfg[sSceneName];
    if not next(tbImage) then 
        self:Trace(1,"Not Find Image");
        pfn();
        return;
    else
        if tbImage ~= nil then 
            for _,iTexture in pairs(AssetsTextureCfg[sSceneName]) do 
                self:Trace(1,"Loading Image ",iTexture.sName);
                loader.newImage(self.tbMedia.images,iTexture.sName,iTexture.sPath);
            end
        end 
    end
    
    AssetsMgr.tbRecordMedia[sSceneName] = true;

    -- 开始加载
    loader.start(pfn, nil);
end 

function AssetsMgr:Update(dt)
    loader.update();
end 

function AssetsMgr:Render()
	if not Option.bLoaded then 
		love.graphics.push();
        love.graphics.scale(offestw,offesth);
        -- love.graphics.setColor(1,1,1,1);
        -- love.graphics.setFont(AssetsMgr:GetFont(522));
        -- love.graphics.print(GameTextCfg.GetTextFunc(10000), (graphicsWidth*0.5) - AssetsMgr:GetFont(522):getWidth(GameTextCfg.GetTextFunc(10000))*0.5,graphicsHeight*0.4);
		self:DrawLoadingBar();
		love.graphics.pop();
		-- state info
		if Option.bDebug == true then
            love.graphics.setColor(0.6, 0.39, 0.6, 1)
            local stats = love.graphics.getStats()
            love.graphics.print("GPU memory: "..(math.floor(stats.texturememory/1.024)/1000).." Kb\nLua Memory: "..(math.floor(collectgarbage("count")/1.024)/1000).." Kb\nFonts: "..stats.fonts.."\nCanvas Switches: "..stats.canvasswitches.."\nCanvases: "..stats.canvases.."\nFPS: "..love.timer.getFPS(), 10, 10)
		end
	end
end 

function AssetsMgr:DrawLoadingBar()
	local separation = 30;
	local w = graphicsWidth - 2 * separation;
	local h = 12;
	local x,y = separation, graphicsHeight - separation - h;

	x, y = x + 3, y + 3;
	w, h = w - 6, h - 7;

	love.graphics.setColor(0.23,0.23,0.23,1);
	love.graphics.rectangle("fill", x, y, w, h);

	if loader.loadedCount > 0 then
		w = w * (loader.loadedCount / loader.resourceCount);
		-- love.graphics.setColor(1,1,1,1)
		-- love.graphics.rectangle("fill",0,0,screenWidth,screenHeight);
        love.graphics.setColor(1,1,1,1);
        if self.loadlogo then 
            local x = graphicsWidth/2 - self.loadlogo:getWidth()/2;
            local y = 100;
            love.graphics.draw(self.loadlogo,x,y);
        end
		love.graphics.rectangle("fill", x, y, w, h);
		love.graphics.setColor(1,1,1,0.19);
		love.graphics.rectangle("fill", x, y, graphicsWidth - 2 * separation - 6, h);
		love.graphics.setColor(1,1,1,1);
	end
end 

function AssetsMgr:GetTexture(sImage)
    return self.tbMedia.images[sImage];
end 

function AssetsMgr:GetFont(nFont)
    return self.tbMedia.fonts[nFont];
end 

function AssetsMgr:GetSound(sSound)
    return self.tbMedia.sounds[sSound];
end 
