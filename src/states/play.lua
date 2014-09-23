local play = {}

function play:enter(state)

end

function play:leave()
	
end

function play:update(dt)

end

function play:draw()

	-- push graphics stack
	love.graphics.push()

	--set background
	love.graphics.setBackgroundColor(33, 33, 33, 255)
	love.graphics.setColor(255, 156, 255, 255)

	love.graphics.setNewFont(30)
	love.graphics.printf("What could paws-ibly go wrong?", love.graphics.getWidth()/2-250, love.graphics.getHeight()/2-25, 500, 'center')
	
	--pop graphics stack
	love.graphics.pop()

end

function play:keypressed(key, unicode)

end

return play