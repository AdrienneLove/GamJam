local intro = {}

local Timer = require "lib.hump.timer"

local intro_scroll = {
	image = nil, 
	x = 0,
	speed = 180, 
	scrolling = false,
	scrolling_finished = false
}
local width_scale = nil
local height_scale = nil
local intro_music = nil
local input_locked = true

local show_tutorial = false
local tute_sheep = "sheep.png" 
local tute_guard =  "jaguar.png"
local tute_buttons = {
	x = "colourBlue.png",
	y = "colourYellow.png",
	a = "colourGreen.png",
	b = "colourRed.png"
}

local tute_font = love.graphics.newFont( "assets/fonts/ARCADECLASSIC.ttf", 32 )

function intro:enter(state)
	intro_music = love.audio.newSource( "assets/audio/heavens_trial.mp3", "stream" )
	intro_music:setLooping( true )
	intro_music:setVolume(0)
	love.audio.play( intro_music )

	intro_scroll.image = love.graphics.newImage("assets/images/intro.png")
	width_scale = 0.84
	--height_scale = 1 - ((intro_scroll.image:getHeight() - love.graphics.getHeight() ) / love.graphics.getHeight() )
	height_scale = 0.84

	self.fading = true
	self.timer = Timer.new()
	self.fade_params = { opacity = 255 }
	self.bgm_params = { volume = 0 }
	self.timer:add(1/60, function()
		self.timer:tween(0.5, self.bgm_params, { volume = 0.8 }, 'in-out-sine')
		self.timer:tween(0.25, self.fade_params, { opacity = 0 }, 'in-out-sine')
		self.timer:add(0.25, function()
			self.fading = false
		end)
	end)

	self.timer:add(2, function()
		input_locked = false
		intro_scroll.scrolling = true
	end)


	-- tutorial assets
	tute_sheep = love.graphics.newImage("assets/images/"..tute_sheep)
	tute_guard = love.graphics.newImage("assets/images/"..tute_guard)
	tute_buttons.x = love.graphics.newImage("assets/images/"..tute_buttons.x)
	tute_buttons.y = love.graphics.newImage("assets/images/"..tute_buttons.y)
	tute_buttons.a = love.graphics.newImage("assets/images/"..tute_buttons.a)
	tute_buttons.b = love.graphics.newImage("assets/images/"..tute_buttons.b)
	tute_sheep:setFilter('nearest', 'nearest')
	tute_guard:setFilter('nearest', 'nearest')
	tute_buttons.x:setFilter('nearest', 'nearest')
	tute_buttons.y:setFilter('nearest', 'nearest')
	tute_buttons.a:setFilter('nearest', 'nearest')
	tute_buttons.b:setFilter('nearest', 'nearest')
end

function intro:leave()
	love.audio.stop( intro_music )
end

function intro:update(dt)
	if intro_scroll.scrolling then
		if intro_scroll.x - intro_scroll.speed * dt > (-1*intro_scroll.image:getWidth() * width_scale)+love.graphics.getWidth() then
			intro_scroll.x = intro_scroll.x - intro_scroll.speed * dt 
		else 
			intro_scroll.scrolling = false
			intro_scroll.finished_scrolling = true
		end
	end

	intro_music:setVolume(self.bgm_params.volume)

	self.timer:update(dt)
end

function intro:draw()

	love.graphics.setFont(tute_font)

	-- push graphics stack
	love.graphics.push()

	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(intro_scroll.image, intro_scroll.x, 0, 0, width_scale, height_scale, 0, 0 )

	--pop graphics stack
	love.graphics.pop()

	if intro_scroll.finished_scrolling and not show_tutorial then
		love.graphics.printf("PRESS   ANY   BUTTON   TO   CONTINUE", 0, 460, love.graphics.getWidth(), "center")
	end


	if show_tutorial then 
		love.graphics.setColor(33, 33, 33, 255)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(tute_sheep, love.graphics.getWidth()/2 -300, 150, 0, 6, 6)
		love.graphics.draw(tute_guard, love.graphics.getWidth()/2 +100, 150, 0, 6, 6)

		--80 px width dif
		love.graphics.draw(tute_buttons.x, love.graphics.getWidth()/2-160, 400, 0, 6, 6)
		love.graphics.draw(tute_buttons.y, love.graphics.getWidth()/2-80, 400, 0, 6, 6)
		love.graphics.draw(tute_buttons.a, love.graphics.getWidth()/2, 400, 0, 6, 6)
		love.graphics.draw(tute_buttons.b, love.graphics.getWidth()/2+80, 400, 0, 6, 6)

		love.graphics.printf("Fool the guards by waving correctly", love.graphics.getWidth()/2-300, 50, 600, "center")
		love.graphics.printf("Match your wave to the guards colour", love.graphics.getWidth()/2-300, 500, 600, "center")
	end

	if self.fading then
		love.graphics.setColor(33, 33, 33, self.fade_params.opacity)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	end
end

function intro:keypressed(key, unicode)
	if input_locked == false then
		if key == " " then
			intro_scroll.speed = 400
		end
	end
end


function intro:keyreleased(key, unicode)
	if input_locked == false then
		if key == " " then
			intro_scroll.speed = 180
		end

		if key == "return" then
			if intro_scroll.scrolling  then 
				intro_scroll.x = -1*intro_scroll.image:getWidth()*width_scale + love.graphics.getWidth()
			else 	
				input_locked = true
				self.fading = true

				self.timer:add(1/60, function()
					--fade music
					self.timer:tween(0.5, self.bgm_params, { volume = 0.0 }, 'in-out-sine')

					self.timer:tween(0.25, self.fade_params, { opacity = 255 }, 'in-out-sine', function ()
						show_tutorial = true
						self.timer:tween(0.25, self.fade_params, { opacity = 0 }, 'in-out-sine', function ()
							self.timer:add(3, function()
								self.timer:tween(0.25, self.fade_params, { opacity = 255 }, 'in-out-sine', function ()
									self.timer:add(1, function()
										Gamestate.switch(require("states.level"))
									end)
								end)
							end)
						end)
					end)
					
				end)
			end
		end
	end
end

function intro:joystickhat(joystick, hat, direction)

end

function intro:joystickpressed(joystick, button)

	if input_locked == false then
		if joystick:isGamepadDown("a") then
			intro_scroll.speed = 400
		end
	end
end

function intro:joystickreleased(joystick, button)

	if input_locked == false then

		if button == 1 then
			intro_scroll.speed = 180
		end

		if button == 9 then
			if intro_scroll.scrolling  then 
				intro_scroll.x = -1*intro_scroll.image:getWidth()*width_scale + love.graphics.getWidth()
			else 	
				input_locked = true
				self.fading = true

				self.timer:add(1/60, function()
					--fade music
					self.timer:tween(0.5, self.bgm_params, { volume = 0.0 }, 'in-out-sine')

					self.timer:tween(0.25, self.fade_params, { opacity = 255 }, 'in-out-sine', function ()
						show_tutorial = true
						self.timer:tween(0.25, self.fade_params, { opacity = 0 }, 'in-out-sine', function ()
							self.timer:add(3, function()
								self.timer:tween(0.25, self.fade_params, { opacity = 255 }, 'in-out-sine', function ()
									self.timer:add(1, function()
										Gamestate.switch(require("states.level"))
									end)
								end)
							end)
						end)
					end)
					
				end)
			end
		end

	end
end

return intro