local intro = {}

local Timer = require "lib.hump.timer"

local intro_scroll = {
	image = nil, 
	x = 0,
	speed = 180, 
	scrolling = false
}
local width_scale = nil
local height_scale = nil
local intro_music = nil
local input_locked = true

function intro:enter(state)
	intro_music = love.audio.newSource( "assets/audio/heavens_trial.mp3", "stream" )
	intro_music:setLooping( true )
	love.audio.play( intro_music )

	intro_scroll.image = love.graphics.newImage("assets/images/intro.png")
	width_scale = intro_scroll.image:getHeight() / love.graphics.getHeight()
	height_scale = 1 - ((intro_scroll.image:getHeight() - love.graphics.getHeight() ) / love.graphics.getHeight() )

	self.fading = true
	self.timer = Timer.new()
	self.fade_params = { opacity = 255 }
	self.bgm_params = { volume = 0.5 }
	self.timer:add(1/60, function()
		self.timer:tween(0.25, self.fade_params, { opacity = 0 }, 'in-out-sine')
		self.timer:add(0.25, function()
			self.fading = false
		end)
	end)

	self.timer:add(2, function()
		input_locked = false
		intro_scroll.scrolling = true
	end)

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
		end
	end

	if self.fading then
		intro_music:setVolume(self.bgm_params.volume)
	end

	self.timer:update(dt)
end

function intro:draw()

	-- push graphics stack
	love.graphics.push()
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.draw(intro_scroll.image, intro_scroll.x, 0, 0, width_scale, height_scale, 0, 0 )

	--pop graphics stack
	love.graphics.pop()

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
					self.timer:tween(0.25, self.fade_params, { opacity = 255 }, 'in-out-sine')
					self.timer:add(2, function()
						Gamestate.switch(require("states.level"))
					end)
				end)
			end
		end
	end
end

function intro:joystickhat(joystick, hat, direction)

end

function intro:joystickpressed(joystick, button)

end

return intro