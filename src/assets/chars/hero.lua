local hero = {	

	-- IF YOU ARE CHANGING THESE REMEMBER TO CHANGE THEM
	-- IN hero:newLevel() ALSO, THANKS
	lives = 4,
	state = "intro", -- "play", "stand", "exit"
	x = -100,
	leaving = false,
	life = love.graphics.newImage('assets/images/Life_full.png'),
	empty = love.graphics.newImage('assets/images/Life_empty.png'),

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
	hero_body_wave_x_animation = nil,

	hero_body_wave_y = {	
		_WIDTH = 32,
		_HEIGHT = 35,
		_FRAMES = 6,
		_FILENAME = "sheep_wave_y.png",
		_ANIMATIONSPEED = 0.08
	},
	hero_body_wave_y_spritemap = nil,
	hero_body_wave_y_animation = nil,

	hero_body_wave_a = {	
		_WIDTH = 32,
		_HEIGHT = 35,
		_FRAMES = 6,
		_FILENAME = "sheep_wave_a.png",
		_ANIMATIONSPEED = 0.08
	},
	hero_body_wave_a_spritemap = nil,
	hero_body_wave_a_animation = nil,

	hero_body_wave_b = {	
		_WIDTH = 32,
		_HEIGHT = 35,
		_FRAMES = 6,
		_FILENAME = "sheep_wave_b.png",
		_ANIMATIONSPEED = 0.08
	},
	hero_body_wave_b_spritemap = nil,
	hero_body_wave_b_animation = nil,
	hero_fail = "sheep_fail.png"
}

hero.life:setFilter('nearest','nearest')
hero.empty:setFilter('nearest','nearest')

local y = 70

hero.hero_fail = love.graphics.newImage("assets/images/"..hero.hero_fail)
hero.hero_fail:setFilter("nearest", "nearest")

-- default run animation for body and legs
hero.hero_body_spritemap = love.graphics.newImage("assets/images/"..hero.hero_body._FILENAME)
hero.hero_body_spritemap:setFilter('nearest', 'nearest')

hero.hero_legs_spritemap = love.graphics.newImage("assets/images/"..hero.hero_legs._FILENAME)
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

-- salute Y
hero.hero_body_wave_y_spritemap = love.graphics.newImage("assets/images/"..hero.hero_body_wave_y._FILENAME);
hero.hero_body_wave_y_spritemap:setFilter('nearest', 'nearest')
local hero_body_wave_y_grid = anim8.newGrid(hero.hero_body_wave_y._WIDTH, hero.hero_body_wave_y._HEIGHT, hero.hero_body_wave_y_spritemap:getWidth(), hero.hero_body_wave_y_spritemap:getHeight())
hero.hero_body_wave_y_animation = anim8.newAnimation(hero_body_wave_y_grid('1-'..hero.hero_body_wave_y._FRAMES,1), hero.hero_body_wave_y._ANIMATIONSPEED, function()
		--one anim ends go back to default
		hero.hero_body_animation:gotoFrame(active_legs_animation.position)
		active_body_animation = hero.hero_body_animation
		active_body_spritemap = hero.hero_body_spritemap

	end)

-- salute A
hero.hero_body_wave_a_spritemap = love.graphics.newImage("assets/images/"..hero.hero_body_wave_a._FILENAME);
hero.hero_body_wave_a_spritemap:setFilter('nearest', 'nearest')
local hero_body_wave_a_grid = anim8.newGrid(hero.hero_body_wave_a._WIDTH, hero.hero_body_wave_a._HEIGHT, hero.hero_body_wave_a_spritemap:getWidth(), hero.hero_body_wave_a_spritemap:getHeight())
hero.hero_body_wave_a_animation = anim8.newAnimation(hero_body_wave_a_grid('1-'..hero.hero_body_wave_a._FRAMES,1), hero.hero_body_wave_a._ANIMATIONSPEED, function()
		--one anim ends go back to default
		hero.hero_body_animation:gotoFrame(active_legs_animation.position)
		active_body_animation = hero.hero_body_animation
		active_body_spritemap = hero.hero_body_spritemap

	end)

-- salute B
hero.hero_body_wave_b_spritemap = love.graphics.newImage("assets/images/"..hero.hero_body_wave_b._FILENAME);
hero.hero_body_wave_b_spritemap:setFilter('nearest', 'nearest')
local hero_body_wave_b_grid = anim8.newGrid(hero.hero_body_wave_b._WIDTH, hero.hero_body_wave_b._HEIGHT, hero.hero_body_wave_b_spritemap:getWidth(), hero.hero_body_wave_b_spritemap:getHeight())
hero.hero_body_wave_b_animation = anim8.newAnimation(hero_body_wave_b_grid('1-'..hero.hero_body_wave_b._FRAMES,1), hero.hero_body_wave_b._ANIMATIONSPEED, function()
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

	if hero.state == "exit" then
		hero.x = hero.x + 3
	end

end

function hero:init()
	active_body_animation:resume()
	active_legs_animation:resume()
	self.lives = 4
	self.state = "intro" -- "play", "stand", "exit"
	self.x = -100
	self.leaving = false
end

function hero:newLevel()
	-- self.lives = 4
	self.state = "intro" -- "play", "stand", "exit"
	self.x = -100
	self.leaving = false
end

local soundX = love.audio.newSource( "assets/audio/energy-1.wav", "static" )
local soundY = love.audio.newSource( "assets/audio/energy-2.wav", "static" )
local soundA = love.audio.newSource( "assets/audio/energy-3.wav", "static" )
local soundB = love.audio.newSource( "assets/audio/energy-4.wav", "static" )
local soundEatLife = love.audio.newSource( "assets/audio/fail.wav", "static" )
soundX:setVolume(0.6)
soundY:setVolume(0.6)
soundA:setVolume(0.6)
soundB:setVolume(0.6)
soundEatLife:setVolume(0.4)

function hero:saluteX()
	if hero.state ~= "exit" then
		--love.audio.play( soundX )
		active_body_animation = hero.hero_body_wave_x_animation
		active_body_spritemap = hero.hero_body_wave_x_spritemap
		active_body_animation:resume()
	end
end
function hero:saluteY()
	if hero.state ~= "exit" then	
		--love.audio.play( soundY )
		active_body_animation = hero.hero_body_wave_y_animation
		active_body_spritemap = hero.hero_body_wave_y_spritemap
		active_body_animation:resume()
	end
end
function hero:saluteA()
	if hero.state ~= "exit" then
		--love.audio.play( soundA )
		active_body_animation = hero.hero_body_wave_a_animation
		active_body_spritemap = hero.hero_body_wave_a_spritemap
		active_body_animation:resume()
	end
end
function hero:saluteB()
	if hero.state ~= "exit" then
		--love.audio.play( soundB )
		active_body_animation = hero.hero_body_wave_b_animation
		active_body_spritemap = hero.hero_body_wave_b_spritemap
		active_body_animation:resume()
	end
end


function hero:draw()
	--draw test anim
	love.graphics.setColor(255, 255, 255, 255)
	
	if hero.state ~= "stand" then
		active_legs_animation:draw(active_legs_spritemap, hero.x, 70)
		active_body_animation:draw(active_body_spritemap, hero.x, 70)
	else
		love.graphics.draw(hero.hero_fail, hero.x, y+1 )
	end
end

function hero:eatLife()
	if hero.lives > 0 then
		love.audio.play( soundEatLife )
		hero.lives = hero.lives - 1
	end
end

function hero:stopHero()
	hero.state = "stand"
end

return hero
