local title = {}

function title:enter(state)
	self.current = 1; 	-- currently selected menu element

	self.actions = {
		{ name="play",    screen="play" },
		{ name="level",    screen="level" },
		{ name="exit",    screen="exit" }
	} 

	self.data = {} 
end

function title:leave()
	
end

function title:update(dt)

end

function title:draw()

	-- push graphics stack
	love.graphics.push()

	--set background & font
	love.graphics.setBackgroundColor(33, 33, 33, 255)

	-- draw menu
	for i, v in ipairs(self.actions) do
		
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

		if action.name == "exit" then 
			love.event.push("quit")
		else
			Gamestate.switch(require("states."..action.screen), self.save)
		end
	end

end

return title