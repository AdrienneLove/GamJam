local guard_manager = {

	guard_types = {
		{ -- 1
			speed = 50,
			expectedWave = "B",
			guard_anim_data = {
				_WIDTH = 32,				
				_HEIGHT = 35,			
				_FRAMES = 12,			
				_FILENAME = "sheepRun_RED.png", 	
				_ANIMATIONSPEED = 0.12 		
			},
			guard_image = nil,
			guard_animation = nil

		},
		{ -- 2
			
			speed = 100,
			expectedWave = "Y",
			guard_anim_data = {
				_WIDTH = 32,				
				_HEIGHT = 35,			
				_FRAMES = 12,			
				_FILENAME = "sheepRun_YELLOW.png", 	
				_ANIMATIONSPEED = 0.12 		
			},
			guard_image = nil,
			guard_animation = nil
		},
		{ -- 3
			speed = 150,
			expectedWave = "X",
			guard_anim_data = {
				_WIDTH = 32,				
				_HEIGHT = 35,			
				_FRAMES = 12,			
				_FILENAME = "sheepRun_BLUE.png", 	
				_ANIMATIONSPEED = 0.12 		
			},
			guard_image = nil,
			guard_animation = nil
		},
		{ -- 4
			speed = 200,
			expectedWave = "A",
			guard_anim_data = {
				_WIDTH = 32,				
				_HEIGHT = 35,			
				_FRAMES = 12,			
				_FILENAME = "sheepRun_GREEN.png", 	
				_ANIMATIONSPEED = 0.12 		
			},
			guard_image = nil,
			guard_animation = nil

		}
	},

	current_guards = {}

}

function guard_manager:newGuard(num)

	if num < 0 or num > 4 then
		print("newGuard: Invalid guard index.")
		return
	end

	local g = {
		guard_image = love.graphics.newImage("assets/images/"..self.guard_types[num]["guard_anim_data"]._FILENAME),
		speed = self.guard_types[num]["speed"],
		x = 240,
		expectedWave = self.guard_types[num]["expectedWave"],
		isWavedAt = false,
		guard_anim_data = self.guard_types[num]["guard_anim_data"]
	}
	g.guard_image:setFilter('nearest', 'nearest')
	local guard_grid = anim8.newGrid(g.guard_anim_data._WIDTH, g.guard_anim_data._HEIGHT, g.guard_image:getWidth(), g.guard_image:getHeight())
	g.animation = anim8.newAnimation(guard_grid('1-'..g.guard_anim_data._FRAMES,1), g.guard_anim_data._ANIMATIONSPEED)
	
	function g:update(dt)

		self.x = self.x - self.speed * dt
		self.animation:update(dt)
	end

	function g:draw()
		--draw test anim
		love.graphics.setColor(255, 255, 255, 255)
		self.animation:draw(self.guard_image, self.x, 70)
	end
	

	table.insert(self.current_guards, g)
end


function guard_manager:update(dt)
	for _,guard in ipairs(self.current_guards) do
		guard:update(dt)
	end
end

function guard_manager:draw()

	for _,guard in ipairs(self.current_guards) do
		guard:draw()
	end
end

return guard_manager