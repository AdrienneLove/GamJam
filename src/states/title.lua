local title = {}
hero = require "assets.chars.hero"

function title:enter(state)
	--hero:reset() --reset the player (SO FRESH)
	self.current = 1; 	-- currently selected menu element

	self.actions = {
		{ name="Play",    screen="intro" },
		{ name="Credits", screen="credits" },
		{ name="Exit",    screen="exit" }
	} 

	self.data = {} 

	title_music = love.audio.newSource( "assets/audio/did_i_lose.mp3", "stream" )
	title_music:setLooping( true )
	love.audio.play( title_music )
end

function title:leave()
	love.audio.stop( title_music )
end

function title:update(dt)

end

function title:draw()

	-- push graphics stack
	love.graphics.push()

	--set background & font
	love.graphics.setBackgroundColor(33, 33, 33, 255)

	-- draw menu
	for i,v in ipairs(self.actions) do
		
		--space between menu items
		local spacing = 40
		local positionToDrawMenu = { x = 50, y = 50 }
		
		-- default menu item style
		love.graphics.setColor(255, 0, 255, 200)

		-- selected menu item style
		if i == self.current then
			love.graphics.setColor(255, 156, 255, 255)
			-- draw pointer triangle
			love.graphics.polygon("fill",
				positionToDrawMenu.x -20, positionToDrawMenu.y + 3 + (i*spacing),
				positionToDrawMenu.x -15, positionToDrawMenu.y + 8 + (i*spacing),
				positionToDrawMenu.x -20, positionToDrawMenu.y + 13 + (i*spacing)
			)
		end
		
		-- draw menu item name
		love.graphics.printf(v.name, positionToDrawMenu.x, positionToDrawMenu.y + (i*spacing), 100, 'left')
	end

	--stupid flanders
	love.graphics.setColor(255,255,255,255);

	--pop graphics stack
	love.graphics.pop()

end

function title:keypressed(key, unicode)

	-- navigate menu
	if key == "up" then
		self.current = self.current - 1
		if self.current < 1 then
			self.current = #self.actions
		end
	elseif key == "down" then
		self.current = (self.current % #self.actions) + 1
	end

	--option selected
	if (key == "return" or key == " ")  then

		local action = self.actions[self.current]

		if action.screen == "exit" then 
			love.event.push("quit")
		else
			Gamestate.switch(require("states."..action.screen), self.save)
		end
	end
end

function title:joystickhat(joystick, hat, direction)
-- Xbox configuration for windows binds the d-pad as a 'hat'.

	if love._os == "Windows" then
		if direction == "u" then
			self.current = self.current - 1
			if self.current < 1 then
				self.current = #self.actions
			end
		elseif direction == "d" then
			self.current = (self.current % #self.actions) + 1
		end
	end
end

function title:joystickpressed(joystick, button)

	if joystick:isGamepadDown("a") or joystick:isGamepadDown("start") then  -- A button or Start
		local action = self.actions[self.current]

		if action.screen == "exit" then 
			love.event.push("quit")
		else
			Gamestate.switch(require("states."..action.screen), self.save)
		end
	end


	if joystick:isGamepadDown("dpdown") then
		self.current = self.current + 1
		if self.current > 3 then
			self.current = 1
		end
	elseif joystick:isGamepadDown("dpup") then
		--self.current = (self.current % #self.actions) - 1
		self.current = self.current - 1
		if self.current < 1 then
			self.current = #self.actions
		end
	end

end

return title