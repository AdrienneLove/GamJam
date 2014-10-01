local splash = {}

function splash:enter(state)
	self.current = 1 

	self.actions = {
		{ name="splash",    screen="splash" },
		{ name="title",    screen="title" }
	} 

	self.data = {
		cube = love.graphics.newImage('assets/animations/splash_cube.png')
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
	love.graphics.draw(self.data.cube, 100, 100)

	--draw text
	love.graphics.setColor(76, 45, 129, 255)
	love.graphics.setNewFont(30)
	love.graphics.printf("Splash screen", love.graphics.getWidth()/2-250, love.graphics.getHeight()/2-25, 500, 'center')

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