local hero = {	
	lives = 4
}

local walk = require 'assets.animations.hero_walk'
local retreat = require 'assets.animations.hero_retreat'
local active = walk
--local lives = 4

function hero:update(dt)
	if active == walk then
		if walk.done == true then		
			active = retreat
			walk.done = false
		else
		    walk.animation:update(dt)
		end		
	end
	if active == retreat then
		if retreat.done == true then
			active = walk
			retreat.done = false
		else
			retreat.animation:update(dt)
		end
	end
end

function hero:draw()
	--draw test anim
	love.graphics.setColor(255, 255, 255, 255)
	active.animation:draw(active.spritemap, 40, 40)
end

function hero:eatLife()
	if hero.lives > 0 then
		hero.lives = hero.lives - 1
	end
end

return hero
