local hero = {	

}

local walk = require 'assets.animations.hero_walk'
local retreat = require 'assets.animations.hero_retreat'
local active = walk

function update(dt)
	if active == walk then
		if walk.done == true then		
			active = retreat
		else
		    walk.animation:update(dt)
		end		
	end
	if active == retreat then
		if retreat.done == true then
			active = walk
		else
			retreat.animation:update(dt)
		end
	end
end

function draw()
	--draw test anim
	love.graphics.setColor(255, 255, 255, 255)
	active.animation:draw(active.spritemap, 40, 40)
end

hero.update = update
hero.draw = draw

return hero
