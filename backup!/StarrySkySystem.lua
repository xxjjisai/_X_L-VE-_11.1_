_G.StarrySkySystem = System:DeriveClass("StarrySkySystem");

StarrySkySystem.nShineSpeed = 0.02;
StarrySkySystem.tbStarrySky = {};

StarrySkySystem.nCount = 2000;
StarrySkySystem.nMin = -10000;
StarrySkySystem.nMax = 10000;
StarrySkySystem.nAlpha = 1;

function StarrySkySystem:Start(nCount,nMin,nMax,nAlpha,nShineSpeed)

    self.nCount,self.nMin,self.nMax,self.nAlpha,self.nShineSpeed = nCount or 2000,nMin or -10000,nMax or 10000,nAlpha or 1,nShineSpeed or 0.02;

    for i = 1,self.nCount do 
        local star = {};
        star.color = {1,1,1,math.random( 0,self.nAlpha )};
        star.x = math.random(self.nMin,self.nMax );
        star.y = math.random(self.nMin,self.nMax );
        star.bUp = false;
        star.r = math.random( 3,7 );
        star.c = math.random( 3,6 );
        table.insert(self.tbStarrySky,star);
    end 
end 

function StarrySkySystem:Update(dt)
    if self.tbStarrySky == nil or not next(self.tbStarrySky) then return end;
    for i,star in ipairs(self.tbStarrySky) do 
        if star.bUp then 
            star.color[4] = star.color[4] + self.nShineSpeed;
            if star.color[4] >= self.nAlpha then 
                star.color[4] = self.nAlpha;
                star.bUp = false;
            end  
        else 
            star.color[4] = star.color[4] - self.nShineSpeed;
            if star.color[4] <= 0 then 
                star.color[4] = 0;
                star.x = math.random( self.nMin,self.nMax );
                star.y = math.random( self.nMin,self.nMax );
                star.r = math.random( 3,7 );
                star.c = math.random( 3,6 );
                star.bUp = true;
            end   
        end  
    end
end 

function StarrySkySystem:Render()
    if self.tbStarrySky == nil or not next(self.tbStarrySky) then return end;
    for i,star in ipairs(self.tbStarrySky) do 
        love.graphics.setColor(star.color)
        love.graphics.circle("fill", star.x, star.y, star.r, star.c)--math.random(3,8));
    end
end