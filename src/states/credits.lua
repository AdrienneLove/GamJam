local credits = {}

local timer = require "lib.hump.timer"

local swishfont = love.graphics.newFont('assets/fonts/ARIAL ROUNDED MT.TTF', 18)
local swishfont_bold = love.graphics.newFont('assets/fonts/arcadeclassic.TTF', 22)
local swishfont_big = love.graphics.newFont('assets/fonts/arcadeclassic.TTF', 60)

local eye_dot = love.graphics.newImage

function credits:enter(state)
	--hero:reset() --reset the player (SO FRESH)
	self.current = 1; 	-- currently selected menu element
	bg = love.graphics.newImage('assets/images/title_bg.png')
	self.actions = {
		{ name="Play",    screen="intro" },
		{ name="Exit",    screen="exit" }
	} 
	self.items = { --credit text sections

		{ title = "On The Lamb by Oopa Chaloopa!", info = {"48hr Game Making Challenge 2014"}},
		{ title = "Artists", info =  {"Rimon Bar", "Camila Duran Espinosa" } },
		{ title = "Programmers", info =  {"Cameron Bland", "Adrian Love", "Racheal Smith", "Michael Whitman" } },
		{ title = "Attribution", info =  { "Music licenced by Creative Commons 3.0 (non-commercial, share-alike, attribution)\n\n"..
			"Heavens Trial by WingoWinston\n (http://www.newgrounds.com/audio/listen/519155 accessed 5th Oct 2014) \n"..
			"did i lose? by jambrother2\n (http://www.newgrounds.com/audio/listen/580941 accessed 5th Oct 2014) \n"..
			"Cephelopod by Kevin MacLeod\n (http://incompetech.com/music/royalty-free/index.html?isrc=USUAN1200081 accessed 5th Oct 2014) \n"
			}
		}
	}

	self.data = {} 

	title_music = love.audio.newSource( "assets/audio/did_i_lose.ogg", "stream" )
	title_music:setLooping( true )
	love.audio.play( title_music )
end

function credits:leave()
	love.audio.stop( title_music )
end

function credits:update(dt)
	timer.update(dt)
	fever:update(timer)
end

function credits:draw()

	-- push graphics stack
	love.graphics.push()

	--set background & font
	love.graphics.setBackgroundColor(255, 255, 255, 255)
	love.graphics.draw(bg, 0, 0, 0, 1.08, 1.08, 0, 0 )

	spacing_index = 1
	for i, v in ipairs(self.items) do
		--print(i)
		--space between menu items

		local spacing = 30
		local positionToDrawCredits = { x = 50, y = 35}
		
		-- default menu item style
		love.graphics.setColor(255, 255, 255, 255)
		
		-- draw menu item name
		love.graphics.setFont(swishfont_bold)
		love.graphics.printf(v.title, positionToDrawCredits.x, positionToDrawCredits.y + (spacing_index*spacing), love.graphics.getWidth()-100, 'left')
		spacing_index = spacing_index + 1
		for ind=1,#v.info do
			love.graphics.setFont(swishfont)
			love.graphics.printf(v.info[ind], positionToDrawCredits.x, positionToDrawCredits.y + (spacing_index*spacing), love.graphics.getWidth()-100, 'left')
			spacing_index = spacing_index + 1
		end
	end

	
	if fever.enabled then
		love.graphics.setColor(fever.current.r,fever.current.g,fever.current.b,fever.opacity)
		love.graphics.circle("fill",905,322,7,10)
		love.graphics.setColor(255,255,255,255);
		love.graphics.setFont(swishfont_big)
		love.graphics.printf("SEIZURE  WARNING",800,150,0,"left")
		love.graphics.setFont(swishfont)
	end

	--stupid flanders
	love.graphics.setColor(255,255,255,255);

	--pop graphics stack
	love.graphics.pop()

end

function credits:keypressed(key, unicode)
	if (key == "return" or key == " ")  then
		Gamestate.switch(require("states.".."title"), self.save)
	end
end

function credits:joystickhat(joystick, hat, direction)
-- Xbox configuration for windows binds the d-pad as a 'hat'.

	-- if love._os == "Windows" then
	-- 	if direction == "u" then
	-- 		self.current = self.current - 1
	-- 		if self.current < 1 then
	-- 			self.current = #self.actions
	-- 		end
	-- 	elseif direction == "d" then
	-- 		self.current = (self.current % #self.actions) + 1
	-- 	end
	-- end
end

function credits:joystickpressed(joystick, button)
	if joystick:isGamepadDown("a") or joystick:isGamepadDown("start") then  -- A button or Start
		Gamestate.switch(require("states.".."title"), self.save)
	end

	if joystick:isGamepadDown("back") then 
		fever.enabled = not fever.enabled
	end
end

function credits:mousepressed(x,y,button)
	if x > 880 and x < 925 and y > 300 and y < 330 then
		fever.enabled = not fever.enabled
	end
	--print(x..","..y)
end

return credits