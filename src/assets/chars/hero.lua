local hero = {
--animation list
	animTable = {
	0 = require 'assets.animations.hero_stand',
	1 = require 'assets.animations.hero_walk',
	2 = require 'assets.animations.hero_salute'
	},

	active = 0,
	x = 0,
	y = 0
}

function hero:salute()
	animTable[2].Animation.gotoFrame(1)
	active = 2
end

function hero:update(dt)

	animTable[active].Animation:update(dt)

	--check if current animation is over
	--else, advance one frame
end

function hero:draw()
	animTable[active].:draw()

	--drawing here.
end

guard.update = update
guard.draw = draw

return guard