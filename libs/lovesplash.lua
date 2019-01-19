--[[
 See the example file "main.lua" for help using this module

 * Copyright (C) 2016 Ricky K. Thomson
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * u should have received a copy of the GNU General Public License
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 --]]

local VERSION = 0.2
local lovesplash = {}

lovesplash.screens = {}
lovesplash.callback = function() return end

function lovesplash.active()
	if #lovesplash.screens < 1 then
		return false
	end
	
	return true
end

function lovesplash.populate(table)
	lovesplash.screens = table
	for _,splash in ipairs(lovesplash.screens) do
		splash.fade = 0
	end
end

function lovesplash.update(dt)
	if #lovesplash.screens > 0 then
		
		local splash = lovesplash.screens[1]
		if splash.duration <= 0 then
			if splash.fade > 0 then
				splash.fade = math.max(splash.fade - splash.speed *dt,0)
			else
				table.remove(lovesplash.screens,1)
				if #lovesplash.screens < 1 then
					lovesplash.callback()
				end
			end
		else
			if splash.fade < 1 then 
				splash.fade = math.min(splash.fade + splash.speed *dt,1)
			else
				splash.duration = math.max(0, splash.duration - dt)
			end
		end
		
	end	
end


function lovesplash.draw()
	if #lovesplash.screens > 0 then
	
		local splash = lovesplash.screens[1]
	
		--fill the screen
		love.graphics.setColor(0,0,0,1)
		love.graphics.rectangle("fill", 0,0,love.graphics.getWidth(),love.graphics.getHeight())
		
		--the splash screen image
		love.graphics.setColor(1,1,1,splash.fade)
		love.graphics.draw(
			splash.image, 
			love.graphics.getWidth()/2-splash.image:getWidth()/2,
			love.graphics.getHeight()/2-splash.image:getHeight()/2
		)
		--and the footer text
		love.graphics.printf(splash.footer, 0,love.graphics.getHeight()-40,love.graphics.getWidth(),"center")
	end
	
end

return lovesplash
