local guard_manager = {

	guard_types = {
		{ -- 1
			walk = require 'assets.animations.guard_fox_walk',
			speed = 1,
			expectedWave = "B"
		},
		{ -- 2
			walk = require 'assets.animations.guard_jaguar_walk',
			speed = 2,
			expectedWave = "Y"
		},
		{ -- 3
			walk = require 'assets.animations.guard_eagle_walk',
			speed = 3,
			expectedWave = "X"
		},
		{ -- 4
			walk = require 'assets.animations.guard_snake_walk',
			speed = 4,
			expectedWave = "A"

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

		walk = self.guard_types[num]["walk"],
		speed = self.guard_types[num]["speed"],
		x = 240, --they're all going to start at the same point offscreen
		expectedWave = self.guard_types[num]["expectedWave"],
		isWavedAt = false
	}

	function g:update(dt)
		self.x = self.x - self.speed * 0.3
		self.walk.animation:update(dt)
	end

	function g:draw()
		--draw test anim
		love.graphics.setColor(255, 255, 255, 255)
		self.walk.animation:draw(self.walk.rimon_walk_spritemap, self.x, 70)
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