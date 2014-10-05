local propFactory = {
	static_prop_types = {
		{
			image = love.graphics.newImage('assets/images/door1.png'),
			y = 34,
			door = true
		},
		{
			image = love.graphics.newImage('assets/images/door2.png'),
			y = 34,
			door = true
		},
		{
			image = love.graphics.newImage('assets/images/mosstop.png'),
			y = 12,
			door = false
		},
		{
			image = love.graphics.newImage('assets/images/mossmiddle.png'),
			y = 32,
			door = false
		},
		{
			image = love.graphics.newImage('assets/images/mossground.png'),
			y = 80,
			door = false
		},
		{
			image = love.graphics.newImage('assets/images/mask1.png'),
			y = 20,
			door = false
		},
		{
			image = love.graphics.newImage('assets/images/palmtree1.png'),
			y = 22,
			door = false
		},
		{
			image = love.graphics.newImage('assets/images/vine.png'),
			y = 6,
			door = false
		},
		{
			image = love.graphics.newImage('assets/images/altar.png'),
			y = 48,
			door = true
		},
		{
			image = love.graphics.newImage('assets/images/painting.png'),
			y = 26,
			door = false
		}
	},
	anim_prop_types = {
		{
			anim_data = {
				_WIDTH = 13,				
				_HEIGHT = 30,			
				_FRAMES = 4,			
				_FILENAME = "assets/animations/torch.png", 	
				_ANIMATIONSPEED = 0.08
			},
			y = 14
		}
	},

	torchpoints = {},

	static_props = {},
	anim_props = {},
	offset = 64,
	level_width = 1444
}


function propFactory:addAnim(position)

	local selected = math.random(table.getn(self.anim_prop_types))

	local temp = {
		image = love.graphics.newImage(self.anim_prop_types[selected]["anim_data"]._FILENAME),
		x = position,
		y = self.anim_prop_types[selected].y,
		anim_data = self.anim_prop_types[selected]["anim_data"]
	}
	temp.image:setFilter('nearest', 'nearest')
	local grid = anim8.newGrid(temp.anim_data._WIDTH, temp.anim_data._HEIGHT, temp.image:getWidth(), temp.image:getHeight())
	temp.animation = anim8.newAnimation(grid('1-'..temp.anim_data._FRAMES,1), temp.anim_data._ANIMATIONSPEED)
	temp.alive = true
	
	function temp:update(dt, level_speed)
		if self.alive == true then
			self.x = self.x - level_speed * dt
			self.animation:update(dt)
		end
	end

	function temp:draw()
		--draw test anim
		--love.graphics.setColor(255, 255, 255, 255)
		self.animation:draw(self.image, self.x, self.y)
	end

	table.insert(self.anim_props, temp)
end

function propFactory:addStatic(selected, placement)
	temp = {}
	temp.image = self.static_prop_types[selected].image
	temp.image:setFilter('nearest','nearest')
	temp.x = placement
	temp.y = self.static_prop_types[selected].y
	temp.alive = true

	table.insert(self.static_props, temp)

	self.offset = placement + temp.image:getWidth()

	if (self.static_prop_types[selected].door == true) then
		local templeft = placement - 14
		local tempright = self.offset + 1
		table.insert(self.torchpoints, templeft)
		table.insert(self.torchpoints, tempright)
	end
end

function propFactory:populate()

	local temp = self.level_width

	self:purge()

	for i = 1,40 do

		local selected = math.random(table.getn(self.static_prop_types))
		local placement = self.offset + math.random(24) + 12

		propFactory:addStatic(selected, placement)

		if (self.offset) > self.level_width then
			break
		end
	end

	for i, v in ipairs(self.torchpoints) do
		local flip = math.random()
		if flip < 0.33 then
			self:addAnim(v)
		end
	end

	self.level_width = self.level_width + 120
end

function propFactory:update(dt, level_speed)

	for i, v in ipairs(self.static_props) do
		if v.alive then
			v.x = v.x - level_speed * dt;
			if v.x <= -200 then
				--v.alive = false
				--v.image = nil
				table.remove(self.static_props, i)
			end
		end
	end

	for i, v in ipairs(self.anim_props) do
		if v.alive then
			v:update(dt, level_speed)
			if v.x <= -200 then
				--v.alive = false
				--v.image = nil
				table.remove(self.anim_props, i)
			end
		end
	end

end

function propFactory:draw()

	for i, v in ipairs(self.static_props) do
		if v.alive then
			love.graphics.draw(v.image, v.x, v.y)
			--decomment to show indexes onscreen
			--love.graphics.printf(i, v.x, v.y, 128, "left")
			
		end
	end

	for i, v in ipairs(self.anim_props) do
		if v.alive then
			v:draw()
		end
	end
end

function propFactory:purge()

	for i, v in ipairs(self.static_props) do
		table.remove(self.static_props, i)
	end
	self.static_props = {}

	for i, v in ipairs(self.anim_props) do
		table.remove(self.anim_props, i)
	end
	self.anim_props = {}

	for i, v in ipairs(self.torchpoints) do
		table.remove(self.torchpoints, i)
	end
	self.torchpoints = {}

	self.offset = 64
	
end

return propFactory