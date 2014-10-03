local guard = {	

}

local walk = require 'assets.animations.rimon_walk';

function update(dt)
	print("boop")
	walk.animation:update(dt)
end

function draw()
	--draw test anim
	love.graphics.setColor(255, 255, 255, 255)
	walk.animation:draw(walk.rimon_walk_spritemap, 10, 10)
end

guard.update = update
guard.draw = draw

return guard