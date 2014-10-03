local hero = {	

}

local walk = require 'assets.animations.hero_walk';

function update(dt)
	walk.animation:update(dt)
end

function draw()
	--draw test anim
	love.graphics.setColor(255, 255, 255, 255)
	walk.animation:draw(walk.hero_walk_spritemap, 40, 40)
end

hero.update = update
hero.draw = draw

return hero