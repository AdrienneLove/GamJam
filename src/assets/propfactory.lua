local propfactory = {
	static_prop_types = {
		{
			image = love.graphics.newImage('assets/images/door1.png'),
			y = 34
		},
		{
			image = love.graphics.newImage('assets/images/door2.png'),
			y = 34
		},
		{
			image = love.graphics.newImage('assets/images/mosstop.png'),
			y = 12
		},
		{
			image = love.graphics.newImage('assets/images/mossmiddle.png'),
			y = 36
		},
		{
			image = love.graphics.newImage('assets/images/mossground.png'),
			y = 52
		},
		{
			image = love.graphics.newImage('assets/images/mask1.png'),
			y = 20
		},
		{
			image = love.graphics.newImage('assets/images/palmtree1.png'),
			y = 22
		}
	},
	anim_prop_types = {
		{
			anim_data = {
				_WIDTH = 13,				
				_HEIGHT = 30,			
				_FRAMES = 2,			
				_FILENAME = "assets/animations/torch.png", 	
				_ANIMATIONSPEED = 0.2
			},
			y = 14
		}
	},

	static_props = {},
	anim_props = {}
}


function propfactory:addAnim()

	local selected = math.random(table.getn(self.anim_prop_types))

	local temp = {
		image = love.graphics.newImage(self.anim_prop_types[selected]["anim_data"]._FILENAME),
		x = math.random(1000),
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

function propfactory:addStatic(selected, placement)
	temp = {}
	temp.image = self.static_prop_types[selected].image
	temp.image:setFilter('nearest','nearest')
	temp.x = placement
	temp.y = self.static_prop_types[selected].y
	temp.alive = true

	table.insert(self.static_props, temp)
end

function propfactory:collisionCheck(x1, w1, x2, w2)

	if ((x2 + w2) > x1) and ((x2 + w2) < (x1 + w1)) then
		return false
	elseif (x2 > x1 ) and (x2 < (x1 + w1)) then
		return false
	else
		return true -- no collision
	end
end

function propfactory:findSpace(width, stage_width)

	local stage_width = stage_width or 2000

	local static_size = table.getn(self.static_props)

	if static_size == 0 then
		return math.random(2000)
	end

	for attempt = 1, 10 do

		local placement = math.random(2000)

		local test = false

		for i = 1, static_size do

			if (self.static_props[i].x == nil) then
				print("i ("..i..") is missing")
			end

			local x1 = self.static_props[i].x
			local w1 = self.static_props[i].image:getWidth()

			test = self:collisionCheck(x1, w1, placement, width)

			if test == false then
				break
			end
		end

		if test == true then
			return placement
		end
	end

	return 0 -- failure
end

function propfactory:populate()

	for i = 1,40 do

		local selected = math.random(table.getn(self.static_prop_types))

		local width = self.static_prop_types[selected].image:getWidth()

		local placement = self:findSpace(width, 2000)

		if placement == 0 then
			break
		else
			propfactory:addStatic(selected, placement)
		end

	end

	print("Added "..table.getn(self.static_props))

	for i = 1, 4 do
		self:addAnim()
	end
end

function propfactory:update(dt, level_speed)

	for i, v in ipairs(self.static_props) do
		if v.alive then
			v.x = v.x - level_speed * dt;
			if v.x <= -200 then
				v.alive = false
				v.image = nil
			end
		end
	end

	for i, v in ipairs(self.anim_props) do
		if v.alive then
			v:update(dt, level_speed)
		end
	end

end

function propfactory:draw()

	for i, v in ipairs(self.static_props) do
		if v.alive then
			love.graphics.draw(v.image, v.x, v.y)
		end
	end

	for i, v in ipairs(self.anim_props) do
		if v.alive then
			v:draw()
		end
	end
end

return propfactory