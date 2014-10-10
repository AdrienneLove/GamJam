local title = {}
hero = require "assets.chars.hero"
local swishfont = love.graphics.newFont('assets/fonts/arcadeclassic.TTF', 60)
local swishfont_big = love.graphics.newFont('assets/fonts/arcadeclassic.TTF', 60)

local timer = require 'lib.hump.timer'


function title:enter(state)
	--hero:reset() --reset the player (SO FRESH)
	self.current = 1; 	-- currently selected menu element
	bg = love.graphics.newImage('assets/images/title_bg.png')
	self.actions = {
		{ name="Play",    screen="intro", rune = love.graphics.newImage('assets/images/title_top.png'), runeUp = love.graphics.newImage('assets/images/title_top_up.png') },
		{ name="Credits", screen="credits", rune = love.graphics.newImage('assets/images/title_middle.png'), runeUp = love.graphics.newImage('assets/images/title_middle_up.png') },
		{ name="Exit",    screen="exit", rune = love.graphics.newImage('assets/images/title_bottom.png'), runeUp = love.graphics.newImage('assets/images/title_bottom_up.png') }
	} 

	self.data = {} 

	title_music = love.audio.newSource( "assets/audio/did_i_lose.ogg", "stream" )
	title_music:setLooping( true )
	love.audio.play( title_music )
end

function title:leave()
	love.audio.stop( title_music )
end

function title:update(dt)
	timer.update(dt)
	fever:update(timer)
end

function title:draw()

	-- push graphics stack
	love.graphics.push()

	--set background & font
	love.graphics.setBackgroundColor(255, 255, 255, 255)
	love.graphics.draw(bg, 0, 0, 0, 1.08, 1.08, 0, 0 )
	love.graphics.setFont(swishfont)


	-- draw title 
	love.graphics.setFont(swishfont_big)
	love.graphics.printf('On The Lamb!', 0, 75, love.graphics.getWidth(), "center" )



	-- draw menu
	for i,v in ipairs(self.actions) do
		
		--space between menu items
		local spacing = 90
		local positionToDrawMenu = { x = 300, y = 100 }

		love.graphics.setColor(255, 255, 255, 255)
		-- selected menu item style
		if i == self.current then
			-- draw pointer triangle
			love.graphics.draw(v.runeUp, positionToDrawMenu.x, positionToDrawMenu.y + (i*spacing))
		else
			love.graphics.draw(v.rune, positionToDrawMenu.x, positionToDrawMenu.y+ (i*spacing))
			love.graphics.setColor(255, 255, 255, 100) --font opacity
		end
		
		-- draw menu item name
		love.graphics.printf(v.name, positionToDrawMenu.x+100, positionToDrawMenu.y +10+ (i*spacing), 100, 'left')
	end

	if fever.enabled then
		love.graphics.setColor(fever.current.r,fever.current.g,fever.current.b,fever.opacity)
		love.graphics.circle("fill",905,322,7,10)
		love.graphics.setColor(255,255,255,255);
		love.graphics.printf("SEIZURE  WARNING",800,150,0,"left")
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