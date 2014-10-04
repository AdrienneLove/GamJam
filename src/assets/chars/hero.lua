local hero = {	
	lives = 4,
	state = "intro", -- "play", "stand", "exit"
	x = -50,
	leaving = false
}

local walk = require 'assets.animations.hero_walk'
local retreat = require 'assets.animations.hero_retreat'

local saluteX = require 'assets.animations.hero_saluteX'
local saluteY = require 'assets.animations.hero_salutey'
local saluteA = require 'assets.animations.hero_saluteA'
local saluteB = require 'assets.animations.hero_saluteB'

local active = walk
--local lives = 4

local y = 70

function hero:update(dt)
	if hero.state == "intro" then
		hero.x = hero.x + 1
	end

	if hero.state == "exit" then
		hero.x = hero.x + 3
	end

	walk.animation:update(dt)
	-- if active == walk then
	-- 	if walk.done == true then		
	-- 		active = retreat
	-- 		walk.done = false
	-- 	else
	-- 	    walk.animation:update(dt)
	-- 	end		
	-- elseif active == retreat then
	-- 	if retreat.done == true then
	-- 		active = walk
	-- 		retreat.done = false
	-- 	else
	-- 		retreat.animation:update(dt)
	-- 	end
	-- else
	-- 	if active.done == true then
	-- 		active.done = false
	-- 		active = walk
	-- 	else
	-- 		active.animation:update(dt)
	-- 	end
	-- end
end

function hero:saluteX()
	active = saluteX
end
function hero:saluteY()
	active = saluteY
end
function hero:saluteA()
	active = saluteA
end
function hero:saluteB()
	active = saluteB
end


function hero:draw()
	--draw test anim
	love.graphics.setColor(255, 255, 255, 255)
	active.animation:draw(active.spritemap, hero.x, 70)
end

function hero:eatLife()
	if hero.lives > 0 then
		hero.lives = hero.lives - 1
	end
end

return hero
