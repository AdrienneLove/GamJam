local propfactory = {
	prop_types = {
		image = love.graphics.newImage('assets/images/door1.png'),
		y = 34
	},

	current_props = {}
}

function propfactory:populate()

	for i = 1,10 do
			self.current_props[i] = {}
			self.current_props[i].image = love.graphics.newImage('assets/images/door1.png')
			self.current_props[i].x = math.random(2000)
			self.current_props[i].y = 34
			self.current_props[i].alive = true
	end
end

function propfactory:update(dt, level_speed)

	for i, v in ipairs(self.current_props) do
		if v.alive then
			v.x = v.x - level_speed * dt;
			if v.x <= -200 then
				v.alive = false
				v.image = nil
			end
		end
	end

end

function propfactory:draw()

	for i, v in ipairs(self.current_props) do
		if v.alive then
			love.graphics.draw(v.image, v.x, v.y)
		end
	end

end

return propfactory