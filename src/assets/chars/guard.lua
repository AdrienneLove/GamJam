local guard_manager = {

	guard_types = {
		-- ORDER OF THESE IS IMPORTANT for staggering which colours spawn on early levels.
		{ -- 1 RED FOX
			speed = 90,
			expectedWave = "B",
			guard_body_anim_data = { --default body
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "fox_body.png", 	
				_ANIMATIONSPEED = 0.105	
			},
			guard_body_image = nil,
			guard_body_animation = nil,
			guard_head_anim_data = { --default head
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "fox_head.png", 	
				_ANIMATIONSPEED = 0.105	
			},
			guard_head_image = nil,
			guard_head_animation = nil,
			guard_head_anim_data = { --default head
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "fox_head.png", 	
				_ANIMATIONSPEED = 0.105	
			},
			guard_head_image = nil,
			guard_head_animation = nil,
			guard_happy_anim_data = {
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "fox_head_happy.png", 	
				_ANIMATIONSPEED = 0.105	
			},
			guard_happy_image = nil,
			guard_happy_animation = nil,
			guard_angry_anim_data = {
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "fox_head_angry.png", 	
				_ANIMATIONSPEED = 0.105	
			},
			guard_angry_image = nil,
			guard_angry_animation = nil,
			guard_fail_image = "fox_fail.png"

		},
		{ -- 2 GREEN SNAKE SNAAAAKE SNAAAAAAAKKKE!? 
			speed = 110,
			expectedWave = "A",
			guard_body_anim_data = {
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "snake_body.png", 	
				_ANIMATIONSPEED = 0.12 		
			},
			guard_body_image = nil,
			guard_body_animation = nil,
			guard_head_anim_data = { --default head
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "snake_head.png", 	
				_ANIMATIONSPEED = 0.12	
			},
			guard_head_image = nil,
			guard_head_animation = nil,
			guard_happy_anim_data = {
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "snake_head_happy.png", 	
				_ANIMATIONSPEED = 0.12 	
			},
			guard_happy_image = nil,
			guard_happy_animation = nil,
			guard_angry_anim_data = {
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "snake_head_angry.png", 	
				_ANIMATIONSPEED = 0.12 	
			},
			guard_angry_image = nil,
			guard_angry_animation = nil,
			guard_fail_image = "snake_fail.png"

		},
		{ -- 3 YELLOW JAG
			
			speed = 95,
			expectedWave = "Y",
			guard_body_anim_data = { --default body
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "jaguar_body.png", 	
				_ANIMATIONSPEED = 0.11		
			},
			guard_body_image = nil,
			guard_body_animation = nil,
			guard_head_anim_data = { --default head
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "jaguar_head.png", 	
				_ANIMATIONSPEED = 0.11	
			},
			guard_head_image = nil,
			guard_head_animation = nil,
			guard_happy_anim_data = {
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "jaguar_head_happy.png", 	
				_ANIMATIONSPEED = 0.11	
			},
			guard_happy_image = nil,
			guard_happy_animation = nil,
			guard_angry_anim_data = {
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "jaguar_head_angry.png", 	
				_ANIMATIONSPEED = 0.11	
			},
			guard_angry_image = nil,
			guard_angry_animation = nil,
			guard_fail_image = "jaguar_fail.png"	
		},
		{ -- 4 BLUE EAGLE
			speed = 103,
			expectedWave = "X",
			guard_body_anim_data = { --default body
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "eagle_body.png", 	
				_ANIMATIONSPEED = 0.115		
			},
			guard_body_image = nil,
			guard_body_animation = nil,
			guard_head_anim_data = { --default head
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "eagle_head.png", 	
				_ANIMATIONSPEED = 0.115	
			},
			guard_head_image = nil,
			guard_head_animation = nil,
			guard_happy_anim_data = {
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "eagle_head_happy.png", 	
				_ANIMATIONSPEED = 0.115	
			},
			guard_happy_image = nil,
			guard_happy_animation = nil,
			guard_angry_anim_data = {
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "eagle_head_angry.png", 	
				_ANIMATIONSPEED = 0.115	
			},
			guard_angry_image = nil,
			guard_angry_animation = nil,
			guard_fail_image = "eagle_fail.png"	
		}
	},

	current_guards = {}

}

function guard_manager:newGuard(num, speedModifier)

	if num < 0 or num > 4 then
		print("newGuard: Invalid guard index.")
		return
	end

	local g = {
		guard_body_image = love.graphics.newImage("assets/images/"..self.guard_types[num]["guard_body_anim_data"]._FILENAME),
		guard_head_image = love.graphics.newImage("assets/images/"..self.guard_types[num]["guard_head_anim_data"]._FILENAME),
		--guard_stop_image = love.graphics.newImage("assets/images/"..self.guard_types[num]["guard_stop_anim_data"]._FILENAME),
		guard_happy_image = love.graphics.newImage("assets/images/"..self.guard_types[num]["guard_happy_anim_data"]._FILENAME),
		guard_angry_image = love.graphics.newImage("assets/images/"..self.guard_types[num]["guard_angry_anim_data"]._FILENAME),
		guard_fail_image = love.graphics.newImage("assets/images/"..self.guard_types[num]["guard_fail_image"]),
		speed = self.guard_types[num]["speed"] * speedModifier,
		x = 240,
		expectedWave = self.guard_types[num]["expectedWave"],
		isWavedAt = false,
		isTooSlow = false,
		guard_body_anim_data = self.guard_types[num]["guard_body_anim_data"],
		guard_head_anim_data = self.guard_types[num]["guard_head_anim_data"], 
		--guard_stop_anim_data = self.guard_types[num]["guard_stop_anim_data"],
		guard_happy_anim_data = self.guard_types[num]["guard_happy_anim_data"],
		guard_angry_anim_data = self.guard_types[num]["guard_angry_anim_data"],
		state = "play" -- "play", "stop", "failed", "success"
	}
	g.guard_body_image:setFilter('nearest', 'nearest')
	g.guard_head_image:setFilter('nearest', 'nearest')
	--g.guard_stop_image:setFilter('nearest', 'nearest')
	g.guard_happy_image:setFilter('nearest', 'nearest')
	g.guard_angry_image:setFilter('nearest', 'nearest')
	local guard_body_grid = anim8.newGrid(g.guard_body_anim_data._WIDTH, g.guard_body_anim_data._HEIGHT, g.guard_body_image:getWidth(), g.guard_body_image:getHeight())
	local guard_head_grid = anim8.newGrid(g.guard_head_anim_data._WIDTH, g.guard_head_anim_data._HEIGHT, g.guard_head_image:getWidth(), g.guard_head_image:getHeight())
	local guard_happy_grid = anim8.newGrid(g.guard_happy_anim_data._WIDTH, g.guard_happy_anim_data._HEIGHT, g.guard_happy_image:getWidth(), g.guard_happy_image:getHeight())
	local guard_angry_grid = anim8.newGrid(g.guard_angry_anim_data._WIDTH, g.guard_angry_anim_data._HEIGHT, g.guard_angry_image:getWidth(), g.guard_angry_image:getHeight())

	g.animation = anim8.newAnimation(guard_body_grid('1-'..g.guard_body_anim_data._FRAMES,1), g.guard_body_anim_data._ANIMATIONSPEED*speedModifier)
	g.head_animation = anim8.newAnimation(guard_head_grid('1-'..g.guard_head_anim_data._FRAMES,1), g.guard_head_anim_data._ANIMATIONSPEED*speedModifier)
	g.happy_animation = anim8.newAnimation(guard_happy_grid('1-8',1), g.guard_happy_anim_data._ANIMATIONSPEED*speedModifier)
	g.angry_animation = anim8.newAnimation(guard_angry_grid('1-8',1), g.guard_angry_anim_data._ANIMATIONSPEED*speedModifier)
	
	g.active_body_animation  = g.animation
	g.active_body_spritemap = g.guard_body_image

	g.active_head_animation = g.head_animation
	g.active_head_spritemap = g.guard_head_image

	--[[ halt anim state
	g.stop_animation = anim8.newAnimation(guard_stop_grid('1-'..g.guard_stop_anim_data._FRAMES,1), g.guard_stop_anim_data._ANIMATIONSPEED, function()
			--one anim ends go back to default
			g.animation:gotoFrame(active_body_animation.position)
			active_body_animation = g.animation
			active_body_spritemap = g.guard_body_image

		end) ]]--

	function g:update(dt)

		self.x = self.x - self.speed * dt
		-- self.animation:update(dt)
		-- self.head_animation:update(dt)
		self.active_head_animation:update(dt)
		self.active_body_animation:update(dt)
	end

	function g:draw()
		--draw test anim
		love.graphics.setColor(255, 255, 255, 255)
		if self.state ~= "stop" then
			self.active_body_animation:draw(self.guard_body_image, self.x, 65)
			self.active_head_animation:draw(self.active_head_spritemap, self.x, 65)
		else
			love.graphics.draw(self.guard_fail_image, self.x, 64 )
		end
	end

	local soundPass = love.audio.newSource( "assets/audio/pass.wav", "static" )
	
	function g:failWave()
		self.angry_animation:gotoFrame(self.active_head_animation.position)
		--self.active_head_animation = self.angry_animation
		self.active_head_spritemap = self.guard_angry_image
		--for triggering the particle effect for failing on a guard
		self.state = "failed"
		self.isWavedAt = true
	end

	function g:successWave()
		self.happy_animation:gotoFrame(self.active_head_animation.position)
		--self.active_head_animation = self.happy_animation
		self.active_head_spritemap = self.guard_happy_image
		love.audio.play( soundPass )
		--for triggering the particle effect for success on a guard
		self.state = "success"
		self.isWavedAt = true
	end

	function g:stopGuard()
		--used by gameover to stop the guard in place and halt animation
		--self.active_head_animation:pause()
		self.state = "stop"
	end


	table.insert(self.current_guards, g)
end

function guard_manager:despawn()
	local _current_guards = self.current_guards
	local c = 0
	for i=1,table.getn(self.current_guards) do
		if self.current_guards[i-c]["x"] < -20 then
			purge(_current_guards[i-c])
			table.remove(_current_guards, i - c)
			c = c + 1
		end
	end
end

function guard_manager:update(dt)

	for _,guard in ipairs(self.current_guards) do
		guard:update(dt)
	end
	self:despawn()
end

function guard_manager:draw()

	for _,guard in ipairs(self.current_guards) do
		guard:draw()
	end
end

function guard_manager:leavecheck()
	for _,guard in ipairs(self.current_guards) do
		if (guard.x) < 42 and guard.isWavedAt == false and guard.isTooSlow == false then
			guard.isTooSlow = true
			return true
		end
	end

	return false
end

return guard_manager