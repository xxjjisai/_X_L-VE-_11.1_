_G.GuoDuMgr = Class:DeriveClass("GuoDuMgr"); 

GuoDuMgr.nCurCount = 0;
GuoDuMgr.nMaxCount = 100;
GuoDuMgr.nCountSpeed = math.random(10,15);
GuoDuMgr.bStart = false;
GuoDuMgr.pfn = nil;

function GuoDuMgr:Start(pfn) 
    local separation = 100;
	local w = graphicsWidth - 2 * separation; 
    self.nCountSpeed = math.random(7,15);
    self.nCurCount = 0;
    self.nMaxCount = w;
    self.bStart = true;
    self.pfn = pfn;
end

function GuoDuMgr:Update(dt)
    if not self.bStart then 
        return 
    end 
    if self.nCurCount < self.nMaxCount then 
        self.nCurCount = self.nCurCount + self.nCountSpeed;
    else 
        if self.pfn then 
            self.pfn();
        end 
        self.bStart = false;
        self.nCurCount = 0;
        self.nMaxCount = 100;
    end 
end

function GuoDuMgr:Render()
    local separation = 100;
	local w = graphicsWidth - 2 * separation;
	local h = 14;
	local x,y = separation, graphicsHeight - separation - h;

	x, y = x + 3, y + 3;
	w, h = w - 6, h - 7;

    if self.bStart then 
        love.graphics.push();
        love.graphics.setColor(0.23,0.23,0.23,1);
        love.graphics.rectangle("fill", x, y, w, h);
        w = w * (self.nCurCount / self.nMaxCount);
        love.graphics.setColor(1,1,1,1);
        love.graphics.rectangle("fill", x, y, w, h);
        love.graphics.setColor(1,1,1,1);
        love.graphics.pop();
    end
end 

