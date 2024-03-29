local intro = {}

local Timer = require "lib.hump.timer"

local intro_scroll = {
	image = love.graphics.newImage("assets/images/intro.png"), 
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
local tute_sheep = love.graphics.newImage("assets/images/sheep.png")
local tute_guard = love.graphics.newImage("assets/images/jaguar.png")
local tute_buttons = {
	x = love.graphics.newImage("assets/images/colourBlue.png"),
	y = love.graphics.newImage("assets/images/colourYellow.png"),
	a = love.graphics.newImage("assets/images/colourGreen.png"),
	b = love.graphics.newImage("assets/images/colourRed.png")
}

local tute_font = love.graphics.newFont( "assets/fonts/munro.ttf", 28 )
local tute_button_font = love.graphics.newFont( "assets/fonts/munro.ttf", 34 )

local ready_to_transition = false;

function intro:enter(state)
	--these things need to be reset for when the game is finished completely and started over.
	show_tutorial = false
	intro_scroll.x = 0
	intro_scroll.finished_scrolling = false
	intro_scroll.speed = 180

	intro_music = love.audio.newSource( "assets/audio/heavens_trial.ogg", "stream" )
	intro_music:setLooping( true )
	intro_music:setVolume(0)
	love.audio.play( intro_music )

	--intro_scroll.image = love.graphics.newImage("assets/images/intro.png")
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
	end)

	self.timer:add(2, function()
		input_locked = false
		intro_scroll.scrolling = true
	end)

	-- tutorial assets
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

	--love.graphics.printf(intro_scroll.x, 0, 460, love.graphics.getWidth(), "center")
	if intro_scroll.x < -200 and intro_scroll.x > -1200 then
		love.graphics.setColor(0, 0, 0, 120)
		love.graphics.printf("The sacrificial lamb...", 2, 462, love.graphics.getWidth(), "center")
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.printf("The sacrificial lamb...", 0, 460, love.graphics.getWidth(), "center")
	end

	if intro_scroll.x < -2100 and intro_scroll.x > -3000 then
		love.graphics.setColor(0, 0, 0, 120)
		love.graphics.printf("...a dash for freedom", 2, 462, love.graphics.getWidth(), "center")
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.printf("...a dash for freedom", 0, 460, love.graphics.getWidth(), "center")
	end

	if intro_scroll.x < -3300 and intro_scroll.x > -3850 then
		love.graphics.setColor(0, 0, 0, 120)
		love.graphics.printf("...a convenient disguise.", 2, 462, love.graphics.getWidth(), "center")	
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.printf("...a convenient disguise.", 0, 460, love.graphics.getWidth(), "center")
	end

	--pop graphics stack
	love.graphics.pop()

	if intro_scroll.finished_scrolling and not show_tutorial then
		love.graphics.printf("Press   START   button   to   continue", 0, 460, love.graphics.getWidth(), "center")
	end


	if show_tutorial then 
		love.graphics.setColor(33, 33, 33, 255)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(tute_sheep, love.graphics.getWidth()/2 -300, 150, 0, 6, 6)
		love.graphics.draw(tute_guard, love.graphics.getWidth()/2 +100, 150, 0, 6, 6)

		love.graphics.setFont(tute_button_font)
		love.graphics.draw(tute_buttons.x, love.graphics.getWidth()/2-50-130, 425, 0, 5, 5)
		love.graphics.print("A", love.graphics.getWidth()/2-54-113, 426)
		love.graphics.draw(tute_buttons.y, love.graphics.getWidth()/2-50-80, 385, 0, 5, 5)
		love.graphics.print("W", love.graphics.getWidth()/2-50-68, 385)
		love.graphics.draw(tute_buttons.a, love.graphics.getWidth()/2-50-80, 425, 0, 5, 5)
		love.graphics.print("S", love.graphics.getWidth()/2-50-65, 425)
		love.graphics.draw(tute_buttons.b, love.graphics.getWidth()/2-50-30, 425, 0, 5, 5)
		love.graphics.print("D", love.graphics.getWidth()/2-50-17, 425)

		love.graphics.draw(tute_buttons.b, love.graphics.getWidth()/2+20+120, 405, 0, 5, 5)
		love.graphics.print("B", love.graphics.getWidth()/2+28+124, 405)
		love.graphics.draw(tute_buttons.y, love.graphics.getWidth()/2+20+80, 370, 0, 5, 5)
		love.graphics.print("Y", love.graphics.getWidth()/2+28+84, 370)
		love.graphics.draw(tute_buttons.a, love.graphics.getWidth()/2+20+80, 435, 0, 5, 5)
		love.graphics.print("A", love.graphics.getWidth()/2+28+84, 435)
		love.graphics.draw(tute_buttons.x, love.graphics.getWidth()/2+20+40, 405, 0, 5, 5)
		love.graphics.print("X", love.graphics.getWidth()/2+28+44, 405)

		love.graphics.setFont(tute_font)
		love.graphics.printf("OR", love.graphics.getWidth()/2, 400, 20, "center")
		love.graphics.printf("Fool the guards by waving correctly", love.graphics.getWidth()/2-300, 50, 600, "center")
		love.graphics.printf("Match your wave to the guards colour", love.graphics.getWidth()/2-300, 500, 600, "center")
	end


	love.graphics.setColor(33, 33, 33, self.fade_params.opacity)
	love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

function intro:keypressed(key, unicode)
	if input_locked == false then
		if key == " " and not ready_to_transition then
			intro_scroll.speed = 400
		end

		if key == "return" then
			if intro_scroll.scrolling  then 
				intro_scroll.x = -1*intro_scroll.image:getWidth()*width_scale + love.graphics.getWidth()
			else 	
				if not ready_to_transition then
					input_locked = true

					self.timer:add(1/60, function()
						--fade music
						self.timer:tween(0.5, self.bgm_params, { volume = 0.0 }, 'in-out-sine')
						self.timer:tween(0.25, self.fade_params, { opacity = 255 }, 'in-out-sine', function ()
							show_tutorial = true
							self.timer:tween(0.25, self.fade_params, { opacity = 0 }, 'in-out-sine', function ()
								ready_to_transition = true
								input_locked = false
							end)
						end)
						
					end)
				else 
					if ready_to_transition then
						input_locked = true
						self.timer:tween(0.25, self.fade_params, { opacity = 255 }, 'in-out-sine', function ()
							self.timer:add(1, function()
								Gamestate.switch(require("states.level"))
							end)
						end)
					end
				end
			end
		end
	end
end


function intro:keyreleased(key, unicode)
	if input_locked == false then
		if key == " " then
			intro_scroll.speed = 180
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

		if button == 9 or joystick:isGamepadDown("start") then
			if intro_scroll.scrolling  then 
				intro_scroll.x = -1*intro_scroll.image:getWidth()*width_scale + love.graphics.getWidth()
			else 	
				if not ready_to_transition then
					input_locked = true

					self.timer:add(1/60, function()
						--fade music
						self.timer:tween(0.5, self.bgm_params, { volume = 0.0 }, 'in-out-sine')
						self.timer:tween(0.25, self.fade_params, { opacity = 255 }, 'in-out-sine', function ()
							show_tutorial = true
							self.timer:tween(0.25, self.fade_params, { opacity = 0 }, 'in-out-sine', function ()
								ready_to_transition = true
								input_locked = false
							end)
						end)
						
					end)
				else 
					if ready_to_transition then
						input_locked = false
						self.timer:tween(0.25, self.fade_params, { opacity = 255 }, 'in-out-sine', function ()
							self.timer:add(1, function()
								Gamestate.switch(require("states.level"))
							end)
						end)
					end
				end
			end
		end
	end
end

function intro:joystickreleased(joystick, button)

	if input_locked == false then
		if not joystick:isGamepadDown("a") then
			intro_scroll.speed = 180
		end
	end
end

return intro