local play = {}

-- an animation extends anim8, see https://github.com/kikito/anim8
anim8 = require 'lib.anim8'

--local rimon_walk = require 'assets.animations.rimon_walk';
local swishfont = love.graphics.newFont('assets/fonts/LovedbytheKing.ttf', 30) 
local enemies = {
	guards = require "assets.chars.guard"
}
local hero = require "assets.chars.hero"
local cube = love.graphics.newImage('assets/animations/splash_cube.png')

function play:enter(state)

	enemies.guards:newGuard(2)
	enemies.guards:newGuard(1)
	enemies.guards:newGuard(3)
	enemies.guards:newGuard(4)

	enemies.guards:newGuard(2)
	enemies.guards:newGuard(1)
	enemies.guards:newGuard(3)
	enemies.guards:newGuard(4)

end

function play:leave()
	
end

function play:update(dt)
	--rimon_walk.animation:update(dt)
	--update enemies
	enemies.guards:update(dt)
	hero:update(dt)
	if hero.lives == 0 then
		
	end
end

function play:draw()
	-- push graphics stack
	love.graphics.push()

	--set background
	love.graphics.setBackgroundColor(33, 33, 33, 255)

	--draw test anim
	love.graphics.setColor(255, 255, 255, 255)
	--rimon_walk.animation:draw(rimon_walk.rimon_walk_spritemap, love.graphics.getWidth()/2-39, love.graphics.getHeight()/2-300)

	--draw text
	love.graphics.setColor(255, 156, 255, 255)
	love.graphics.setFont(swishfont)
	love.graphics.printf("I know they make you fur-ious but my cat puns are su-purr-ior.", love.graphics.getWidth()/2-250, love.graphics.getHeight()/2-25, 500, 'center')

	-- draw life count
	for i=1,hero.lives do
		love.graphics.draw(cube, 40*i, 50)
	end
	
	--draw enemies
	enemies.guards:draw()

	--draw hero
	hero:draw(dt)

	--pop graphics stack
	love.graphics.pop()
end

function play:keypressed(key, unicode)

end

function play:joystickpressed(joystick, button)
	hero:eatLife()
	print(hero.lives)


	-- Y = 14
	-- X = 13
	-- B = 12
	-- A = 11

end

return play