require "lib.utils"

local splash = {}

function splash:enter(state)
	self.current = 1 
	self.frame = 0

	self.actions = {
		{ name="splash",    screen="splash" },
		{ name="title",    screen="title" }
	} 

	self.data = {
		cube = love.graphics.newImage('assets/animations/splash_cube.png'),
		mans = love.graphics.newImage('assets/animations/splash_mans.png'),
		sparkle = love.graphics.newImage('assets/animations/splash_sparkle.png'),
		oopa = love.graphics.newImage('assets/animations/splash_oopa.png'),
		chaloopa = love.graphics.newImage('assets/animations/splash_chaloopa.png')
	} 
end

function splash:leave()
	
end

function splash:update(dt)

end

function splash:draw()

	-- push graphics stack
	love.graphics.push()

	--set background
	love.graphics.setColor(255, 255, 255, 255)
	love.graphics.setBackgroundColor(252, 183, 114, 255)
	-- Correct final positions:
	-- love.graphics.draw(self.data.sparkle, love.graphics.getWidth()/2-136, love.graphics.getHeight()/2-310)
	-- love.graphics.draw(self.data.cube, love.graphics.getWidth()/2-44, love.graphics.getHeight()/2-230)
	-- love.graphics.draw(self.data.mans, love.graphics.getWidth()/2-103, love.graphics.getHeight()/2-145)
	-- love.graphics.draw(self.data.oopa, love.graphics.getWidth()/2-106, love.graphics.getHeight()/2+90)
	-- love.graphics.draw(self.data.chaloopa, love.graphics.getWidth()/2-106, love.graphics.getHeight()/2+156)

	-- SPARKLE - frame 5+: enter sparkle, and remain rotating.
	-- needs to be drawn first as it sits behind everything else.
	if self.frame/60 >= 5 and self.frame/60 <= 7 then
		local opacity = ((self.frame/60) - 5) * 85
		local degrees = (self.frame%60) * 0.3

		love.graphics.setColor(255, 255, 255, opacity)
		love.graphics.draw(self.data.sparkle, love.graphics.getWidth()/2, 
			love.graphics.getHeight()/2-174, math.rad(degrees), 1, 1, 
			self.data.sparkle:getWidth()/2, self.data.sparkle:getHeight()/2)
	elseif self.frame/60 > 6 then
		-- sparkle entry complete, keep it there
		local degrees = (self.frame%60) * 0.3
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(self.data.sparkle, love.graphics.getWidth()/2, 
			love.graphics.getHeight()/2-174, math.rad(degrees), 1, 1, 
			self.data.sparkle:getWidth()/2, self.data.sparkle:getHeight()/2)
	end

	-- LOGO MAN - frame 2 - 5: enter mans
	if self.frame/60 <= 5 and self.frame/60 >= 2 then
		local opacity = ((self.frame/60) - 2) * 85
		love.graphics.setColor(255, 255, 255, opacity)
		love.graphics.draw(self.data.mans, love.graphics.getWidth()/2-103, love.graphics.getHeight()/2-145)
	elseif self.frame/60 > 5 then
		-- entry complete, keep the mans there.
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(self.data.mans, love.graphics.getWidth()/2-103, love.graphics.getHeight()/2-145)
	end

	-- CUBE - frame 3 - 6: enter cube
	if self.frame/60 >= 3 and self.frame/60 <= 6 then
		local opacity = ((self.frame/60) - 3) * 85
		local ypos = 260 - (((self.frame/60) - 3) * 10)
		love.graphics.setColor(255, 255, 255, opacity)
		love.graphics.draw(self.data.cube, love.graphics.getWidth()/2-44, love.graphics.getHeight()/2-ypos)
	elseif self.frame/60 > 6 then
		-- cube entry complete, keep it there, pulse up and down (still todo)
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(self.data.cube, love.graphics.getWidth()/2-44, love.graphics.getHeight()/2-230)
	end

	-- TODO: frame 7: enter "oopa"
	if self.frame/60 <= 6 and self.frame/60 >= 4 then
		local opacity = ((self.frame/60) - 4) * 127.5
		love.graphics.setColor(255, 255, 255, opacity)
		love.graphics.draw(self.data.oopa, love.graphics.getWidth()/2-106, love.graphics.getHeight()/2+90)
	elseif self.frame/60 > 6 then
		-- entry complete, keep the mans there.
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(self.data.oopa, love.graphics.getWidth()/2-106, love.graphics.getHeight()/2+90)
	end

	-- TODO: frame 7: enter "oopa"
	if self.frame/60 <= 7 and self.frame/60 >= 5 then
		local opacity = ((self.frame/60) - 5) * 127.5
		love.graphics.setColor(255, 255, 255, opacity)
		love.graphics.draw(self.data.chaloopa, love.graphics.getWidth()/2-106, love.graphics.getHeight()/2+156)
	elseif self.frame/60 > 7 then
		-- entry complete, keep the mans there.
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.draw(self.data.chaloopa, love.graphics.getWidth()/2-106, love.graphics.getHeight()/2+156)
	end

	if self.frame/60 > 12 then
		Gamestate.switch(require("states.title"), self.save)
	end

	self.frame = self.frame + 1

	--pop graphics stack
	love.graphics.pop()
end

function splash:keypressed(key, unicode)
	self.current = 2

	local screen = self.actions[self.current].screen

	if self.frame/60 < 10 then
		self.frame = 60*10
	elseif self.frame/60 >= 10 then
		--will remove keypress state change once animating splash is done.
		Gamestate.switch(require("states."..screen), self.save)
	end

end

function splash:joystickpressed(joystick, button)
	self.current = 2

	local screen = self.actions[self.current].screen

	if self.frame/60 < 10 then
		self.frame = 60*10
	elseif self.frame/60 >= 10 then
		--will remove keypress state change once animating splash is done.
		Gamestate.switch(require("states."..screen), self.save)
	end

end

return splash