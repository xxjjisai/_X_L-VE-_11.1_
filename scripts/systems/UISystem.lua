_G.UISystem = System:DeriveClass("UISystem");

function UISystem:Start()
    self.ui = nuklear.newUI()
    self.combo = {value = 1, items = {'A', 'B', 'C'}}
end

function UISystem:Update(dt)
    self.ui:frameBegin()
    ---------------------
    if self.ui:windowBegin('Simple Example', 100, 100, 200, 160,
    'border', 'title', 'movable') then
		self.ui:layoutRow('dynamic', 30, 1)
		self.ui:label('Hello, world!')
		self.ui:layoutRow('dynamic', 30, 2)
		self.ui:label('Combo box:')
		if self.ui:combobox(self.combo, self.combo.items) then
			self:Trace(1,'Combo!', self.combo.items[self.combo.value])
		end
		self.ui:layoutRow('dynamic', 30, 3)
		self.ui:label('Buttons:')
		if self.ui:button('Sample') then
            self:Trace(1,'Sample!')
            local iActor = SceneMgr:GetCurPlayer()
            ActorMgr:RemoveActor(iActor)
		end
		if self.ui:button('Button') then
			self:Trace(1,'Button!')
		end
	end
    ---------------------
	self.ui:windowEnd()
	self.ui:frameEnd()
end

function UISystem:SetMyUI()

end

function UISystem:Render() 
    self.ui:draw()
end

function UISystem:MouseDown(x, y, button, istouch, presses)   
    self.ui:mousepressed(x, y, button, istouch, presses)
end

function UISystem:MouseUp(x, y, button, istouch, presses)  
    self.ui:mousereleased(x, y, button, istouch, presses)
end

function UISystem:MouseMoved(x, y, dx, dy, istouch)
    self.ui:mousemoved(x, y, dx, dy, istouch)
end

function UISystem:KeyBoardDown(key, scancode, isrepeat) 
    self.ui:keypressed(key, scancode, isrepeat)
end

function UISystem:KeyBoardUp(key, scancode)
    self.ui:keyreleased(key, scancode)
end

function UISystem:WheelMoved(x, y)
    self.ui:wheelmoved(x, y)
end

function UISystem:TextInput(text)
    self.ui:textinput(text)
end