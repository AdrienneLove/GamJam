local level = {}

function level:enter(state)
	
end

function level:leave()
	
end

function level:update(dt)

end

function level:draw()

end

function level:keypressed(key, unicode)
	-- navigate menu
	if key == "q" then
		love.event.push("quit")
	end

end

return level