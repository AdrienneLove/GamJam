local credits = {}
local swishfont = love.graphics.newFont('assets/fonts/ARIAL ROUNDED MT.ttf', 20)
local swishfont_bold = love.graphics.newFont('assets/fonts/ARLRDBD.TTF', 26)


function credits:enter(state)
	--hero:reset() --reset the player (SO FRESH)
	self.current = 1; 	-- currently selected menu element

	self.actions = {
		{ name="Play",    screen="intro" },
		{ name="Exit",    screen="exit" }
	} 
	self.items = { --credit text sections
		{ title = "On The Lamb by Oopa Chaloopa! (48hr Game Making Challenge 2014)", info = {""}},
		{ title = "Artists", info =  {"Rimon Bar", "Camila Duran Espinosa" } },
		{ title = "Programmers", info =  {"Cameron Bland", "Adrian Love", "Racheal Smith", "Michael Whitman" } },
		{ title = "Attributions", info =  { "Music licenced by Creative Commons 3.0 (non-commercial, share-alike, attribuation)\n\n"..
			"Heavens Trial by WingoWinston (http://www.newgrounds.com/audio/listen/519155 accessed 5th Oct 2014) \n"..
			"did i lose? by jambrother2 (http://www.newgrounds.com/audio/listen/580941 accessed 5th Oct 2014) \n"..
			"Cephelopod by Kevin MacLeod (http://incompetech.com accessed 5th Oct 2014) \n"
			}
		}
	}

	self.data = {} 

	title_music = love.audio.newSource( "assets/audio/did_i_lose.mp3", "stream" )
	title_music:setLooping( true )
	love.audio.play( title_music )
end

function credits:leave()
	love.audio.stop( title_music )
end

function credits:update(dt)

end

function credits:draw()

	-- push graphics stack
	love.graphics.push()

	--set background & font
	love.graphics.setBackgroundColor(33, 33, 33, 255)

	spacing_index = 1
	for i, v in ipairs(self.items) do
		--print(i)
		--space between menu items
		local spacing = 40
		local positionToDrawCredits = { x = 50, y = 0}
		
		-- default menu item style
		love.graphics.setColor(255, 0, 255, 200)
		
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

end

return credits