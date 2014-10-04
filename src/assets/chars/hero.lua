local hero = {	
	lives = 4,
	state = "intro",
	x = -50, 
	hero_body = {			--default run body
		_WIDTH = 32,
		_HEIGHT = 35,
		_FRAMES = 12,
		_FILENAME = "sheep_body.png",
		_ANIMATIONSPEED = 0.1
	},
	hero_body_spritemap = nil,
	hero_body_animation = nil,
	hero_legs = {			--default run legs
		_WIDTH = 32,	
		_HEIGHT = 35,
		_FRAMES = 12,
		_FILENAME = "sheep_legs.png", 
		_ANIMATIONSPEED = 0.1,
	},
	hero_legs_spritemap = nil,
	hero_legs_animation = nil,

	--extra bodies (waves) and legs (run, walk etc) go here
	hero_body_wave_x = {	
		_WIDTH = 32,
		_HEIGHT = 35,
		_FRAMES = 6,
		_FILENAME = "sheep_wave_x.png",
		_ANIMATIONSPEED = 0.08
	},
	hero_body_wave_x_spritemap = nil,
	hero_body_wave_x_animation = nil
}

-- local walk = require 'assets.animations.hero_walk'
-- local retreat = require 'assets.animations.hero_retreat'

-- local saluteX = require 'assets.animations.hero_saluteX'
-- local saluteY = require 'assets.animations.hero_salutey'
-- local saluteA = require 'assets.animations.hero_saluteA'
-- local saluteB = require 'assets.animations.hero_saluteB'

local y = 70

-- default run animation for body and legs
hero.hero_body_spritemap = love.graphics.newImage("assets/images/"..hero.hero_body._FILENAME);
hero.hero_body_spritemap:setFilter('nearest', 'nearest')

hero.hero_legs_spritemap = love.graphics.newImage("assets/images/"..hero.hero_legs._FILENAME);
hero.hero_legs_spritemap:setFilter('nearest', 'nearest')

local hero_body_grid = anim8.newGrid(hero.hero_body._WIDTH, hero.hero_body._HEIGHT, hero.hero_body_spritemap:getWidth(), hero.hero_body_spritemap:getHeight())
local hero_legs_grid = anim8.newGrid(hero.hero_legs._WIDTH, hero.hero_legs._HEIGHT, hero.hero_legs_spritemap:getWidth(), hero.hero_legs_spritemap:getHeight())

hero.hero_body_animation = anim8.newAnimation(hero_body_grid('1-'..hero.hero_body._FRAMES,1), hero.hero_body._ANIMATIONSPEED)
hero.hero_legs_animation = anim8.newAnimation(hero_legs_grid('1-'..hero.hero_legs._FRAMES,1), hero.hero_legs._ANIMATIONSPEED)

local active_body_animation = hero.hero_body_animation
local active_body_spritemap = hero.hero_body_spritemap

local active_legs_animation = hero.hero_legs_animation
local active_legs_spritemap = hero.hero_legs_spritemap

-- salute X
hero.hero_body_wave_x_spritemap = love.graphics.newImage("assets/images/"..hero.hero_body_wave_x._FILENAME);
hero.hero_body_wave_x_spritemap:setFilter('nearest', 'nearest')
local hero_body_wave_x_grid = anim8.newGrid(hero.hero_body_wave_x._WIDTH, hero.hero_body_wave_x._HEIGHT, hero.hero_body_wave_x_spritemap:getWidth(), hero.hero_body_wave_x_spritemap:getHeight())
hero.hero_body_wave_x_animation = anim8.newAnimation(hero_body_wave_x_grid('1-'..hero.hero_body_wave_x._FRAMES,1), hero.hero_body_wave_x._ANIMATIONSPEED, function()
		--one anim ends go back to default
		hero.hero_body_animation:gotoFrame(active_legs_animation.position)
		active_body_animation = hero.hero_body_animation
		active_body_spritemap = hero.hero_body_spritemap

	end)


function hero:update(dt)
	if hero.state == "intro" then
		hero.x = hero.x + 1
	end

	active_body_animation:update(dt)
	active_legs_animation:update(dt)

end

function hero:saluteX()
	active_body_animation = hero.hero_body_wave_x_animation
	active_body_spritemap = hero.hero_body_wave_x_spritemap
	active_body_animation:resume()
end
function hero:saluteY()
	--active = saluteY
end
function hero:saluteA()
	--active = saluteA
end
function hero:saluteB()
	--active = saluteB
end


function hero:draw()
	--draw test anim
	love.graphics.setColor(255, 255, 255, 255)
	
	active_legs_animation:draw(active_legs_spritemap, hero.x, 70)
	active_body_animation:draw(active_body_spritemap, hero.x, 70)
end

function hero:eatLife()
	if hero.lives > 0 then
		hero.lives = hero.lives - 1
	end
end

return hero
