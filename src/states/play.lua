local play = {}

--local rimon_walk = require 'assets.animations.rimon_walk';
local swishfont = love.graphics.newFont('assets/fonts/LovedbytheKing.ttf', 30) 
local enemies = {
	guards = require "assets.chars.guard"
}
hero = require "assets.chars.hero"
local cube = love.graphics.newImage('assets/animations/splash_cube.png')
local gameover = false

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
		gameover = true
	end
end

function play:draw()
	-- push graphics stack
	love.graphics.push()

	--set background
	love.graphics.setBackgroundColor(33, 33, 33, 255)

	--draw test anim
	love.graphics.setColor(255, 255, 255, 255)

	-- draw life count
	for i=1,hero.lives do
		love.graphics.draw(cube, 40*i, 50)
	end

	if gameover then
		--draw text
		love.graphics.setColor(255, 156, 255, 255)
		love.graphics.setFont(swishfont)
		love.graphics.printf("LOL NOPE.", love.graphics.getWidth()/2-250, love.graphics.getHeight()/2-25, 500, 'center')
	end
	
	--draw enemies
	enemies.guards:draw()

	--draw hero
	hero:draw(dt)

	--pop graphics stack
	love.graphics.pop()
end

function play:gamepadpressed(joystick, button)
	print("tramp balls")

end

function play:joystickpressed(joystick, button)
	--hero:eatLife()
	--print(hero.lives)

	if (love._os == "Windows") then
		button = button + 10
	end

	print(button)
	if button == 14 then
		-- Y = 14
		hero:saluteY()
	end
	if button == 13 then
		-- X = 13
		hero:saluteX()
	end
	if button == 12 then
		-- B = 12
		hero:saluteB()
	end
	if button == 11 then
		-- A = 11
		hero:saluteA()
	end 

end


return play