local guard_manager = {

	guard_types = {
		{ -- 1
			speed = 80,
			expectedWave = "B",
			guard_body_anim_data = { --default body
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "fox_body.png", 	
				_ANIMATIONSPEED = 0.12 		
			},
			guard_body_image = nil,
			guard_body_animation = nil,
			guard_head_anim_data = { --default head
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "fox_head.png", 	
				_ANIMATIONSPEED = 0.12	
			},
			guard_head_image = nil,
			guard_head_animation = nil,
			guard_stop_anim_data = { -- halt body (gameover)
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "fox_head_expressions.png", 	
				_ANIMATIONSPEED = 0.12	
			},
			guard_stop_image = nil,
			guard_stop_animation = nil

		},
		{ -- 2
			
			speed = 90,
			expectedWave = "Y",
			guard_body_anim_data = { --default body
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "jaguar_body.png", 	
				_ANIMATIONSPEED = 0.12 		
			},
			guard_body_image = nil,
			guard_body_animation = nil,
			guard_head_anim_data = { --default head
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "jaguar_head.png", 	
				_ANIMATIONSPEED = 0.12	
			},
			guard_head_image = nil,
			guard_head_animation = nil,
			guard_stop_anim_data = { -- halt body (gameover)
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "jaguar_head_expressions.png", 	
				_ANIMATIONSPEED = 0.12	
			},
			guard_stop_image = nil,
			guard_stop_animation = nil
		},
		{ -- 3
			speed = 100,
			expectedWave = "X",
			guard_body_anim_data = { --default body
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "eagle_body.png", 	
				_ANIMATIONSPEED = 0.12 		
			},
			guard_body_image = nil,
			guard_body_animation = nil,
			guard_head_anim_data = { --default head
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "eagle_head.png", 	
				_ANIMATIONSPEED = 0.12	
			},
			guard_head_image = nil,
			guard_head_animation = nil,
			guard_stop_anim_data = { -- halt body (gameover)
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "eagle_head_expressions.png", 	
				_ANIMATIONSPEED = 0.12	
			},
			guard_stop_image = nil,
			guard_stop_animation = nil
		},
		{ -- 4
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
			guard_stop_anim_data = { -- halt body (gameover)
				_WIDTH = 32,				
				_HEIGHT = 39,			
				_FRAMES = 8,			
				_FILENAME = "snake_body.png", 	
				_ANIMATIONSPEED = 0.12	
			},
			guard_stop_image = nil,
			guard_stop_animation = nil

		}
	},

	current_guards = {}

}


local tween = require 'lib.tween'

local particles = {}
local particle_types = {
	pass = {image = love.graphics.newImage('assets/images/pass.png')},
	fail = {image = love.graphics.newImage('assets/images/fail.png')}
}

guard_manager.particles = particles
guard_manager.particle_types = particle_types

function guard_manager:newGuard(num)

	if num < 0 or num > 4 then
		print("newGuard: Invalid guard index.")
		return
	end

	local g = {
		guard_body_image = love.graphics.newImage("assets/images/"..self.guard_types[num]["guard_body_anim_data"]._FILENAME),
		guard_head_image = love.graphics.newImage("assets/images/"..self.guard_types[num]["guard_head_anim_data"]._FILENAME),
		guard_stop_image = love.graphics.newImage("assets/images/"..self.guard_types[num]["guard_stop_anim_data"]._FILENAME),
		speed = self.guard_types[num]["speed"],
		x = 240,
		expectedWave = self.guard_types[num]["expectedWave"],
		isWavedAt = false,
		guard_body_anim_data = self.guard_types[num]["guard_body_anim_data"],
		guard_head_anim_data = self.guard_types[num]["guard_head_anim_data"], 
		guard_stop_anim_data = self.guard_types[num]["guard_stop_anim_data"],
		state = "play" -- "play", "stop", "failed", "success"
	}
	g.guard_body_image:setFilter('nearest', 'nearest')
	g.guard_head_image:setFilter('nearest', 'nearest')
	g.guard_stop_image:setFilter('nearest', 'nearest')
	local guard_body_grid = anim8.newGrid(g.guard_body_anim_data._WIDTH, g.guard_body_anim_data._HEIGHT, g.guard_body_image:getWidth(), g.guard_body_image:getHeight())
	local guard_head_grid = anim8.newGrid(g.guard_head_anim_data._WIDTH, g.guard_head_anim_data._HEIGHT, g.guard_head_image:getWidth(), g.guard_head_image:getHeight())
	local guard_stop_grid = anim8.newGrid(g.guard_stop_anim_data._WIDTH, g.guard_stop_anim_data._HEIGHT, g.guard_stop_image:getWidth(), g.guard_stop_image:getHeight())
	g.animation = anim8.newAnimation(guard_body_grid('1-'..g.guard_body_anim_data._FRAMES,1), g.guard_body_anim_data._ANIMATIONSPEED)
	g.head_animation = anim8.newAnimation(guard_head_grid('1-'..g.guard_head_anim_data._FRAMES,1), g.guard_head_anim_data._ANIMATIONSPEED)
	
	g.active_body_animation  = g.animation
	g.active_body_spritemap = g.guard_body_image

	g.active_head_animation = g.head_animation
	g.active_head_spritemap = g.guard_head_image

	-- halt anim state
	g.stop_animation = anim8.newAnimation(guard_stop_grid('1-'..g.guard_stop_anim_data._FRAMES,1), g.guard_stop_anim_data._ANIMATIONSPEED, function()
			--one anim ends go back to default
			g.animation:gotoFrame(active_body_animation.position)
			active_body_animation = g.animation
			active_body_spritemap = g.guard_body_image

		end)

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
		self.active_body_animation:draw(self.guard_body_image, self.x, 65)
		self.active_head_animation:draw(self.guard_head_image, self.x, 65)
	end
	
	function g:failWave()
		--for triggering the particle effect for failing on a guard
		self.state = "failed"
		--print("set to failed")
	end

	function g:successWave()
		--for triggering the particle effect for success on a guard
		self.state = "success"
		--print("set to success")
	end

	function g:stopGuard()
		--used by gameover to stop the guard in place and halt animation
		--self.active_head_animation:pause()
		self.active_body_animation:pause()
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
	self.current_guards = _current_guards
end

function guard_manager:update(dt)

	self:particleUpdate(dt)

	for _,guard in ipairs(self.current_guards) do
		guard:update(dt)
	end
	self:despawn()
end

function guard_manager:draw()

	self:particleDraw()

	for _,guard in ipairs(self.current_guards) do
		guard:draw()
	end
end

function guard_manager:spawnParticle(type, _x)
	
	temp = {}
	temp.image = self.particle_types["pass"].image
	temp.image:setFilter('nearest','nearest')
	temp.x = _x
	temp.y = 126

	if type == "pass" then
		temp.image = self.particle_types["pass"].image
	elseif type == "fail" then
		temp.image = self.particle_types["fail"].image
	else
		print("Unrecognized particle type")
		return
	end

	temp.tween = tween.new(2, temp, {y = 0}, "outInElastic")

	table.insert(self.particles, temp)
end

function guard_manager:particleUpdate(dt)
	for i, v in ipairs(self.particles) do
		complete = v.tween:update(dt)

		if (complete == true) then
			table.remove(self.particles, i)
		end
	end
end

function guard_manager:particleDraw()
	for i, v in ipairs(self.particles) do
		love.graphics.draw(v.image, v.x, v.y)
	end
end

return guard_manager