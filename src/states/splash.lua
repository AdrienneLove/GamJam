require "lib.utils"

local splash = {}

function splash:enter(state)
	self.current = 1 

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
	love.graphics.draw(self.data.sparkle, love.graphics.getWidth()/2-136, love.graphics.getHeight()/2-310)
	love.graphics.draw(self.data.cube, love.graphics.getWidth()/2-44, love.graphics.getHeight()/2-230)
	love.graphics.draw(self.data.mans, love.graphics.getWidth()/2-103, love.graphics.getHeight()/2-145)
	love.graphics.draw(self.data.oopa, love.graphics.getWidth()/2-106, love.graphics.getHeight()/2+90)
	love.graphics.draw(self.data.chaloopa, love.graphics.getWidth()/2-106, love.graphics.getHeight()/2+156)

	--draw text
	love.graphics.setColor(76, 45, 129, 255)
	love.graphics.printf("Splash screen", 10, 10, 200, 'center')

	--pop graphics stack
	love.graphics.pop()

end

function splash:keypressed(key, unicode)
	self.current = 2

	local screen = self.actions[self.current].screen

	--will remove keypress state change once animating splash is done.
	Gamestate.switch(require("states."..screen), self.save)

end

return splash