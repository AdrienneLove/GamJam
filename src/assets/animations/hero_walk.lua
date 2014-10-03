
-- Rimon, only look at this bit up here!

local hero_walk = {
	_WIDTH = 78,				-- width of a single frame of animation
	_HEIGHT = 114,			-- height of a single frame of animation
	_FRAMES = 8,			-- frames there are in the animation
	_FILENAME = "hero_walk.png", 	-- file name in the animations folder
	_ANIMATIONSPEED = 0.12, 		-- speed the animation cycles at
	done = false
}

-----------------------------

-- setup vars
local spritemap, animation

--include image, set up width and frames 
spritemap = love.graphics.newImage("assets/animations/"..hero_walk._FILENAME);
local g = anim8.newGrid(hero_walk._WIDTH, hero_walk._HEIGHT, spritemap:getWidth(), spritemap:getHeight())

local looper = function()
	hero_walk.done = true
end

animation = anim8.newAnimation(g('1-'..hero_walk._FRAMES,1), hero_walk._ANIMATIONSPEED, looper)

--pass all the stuff that's needed back to game
hero_walk.spritemap = spritemap;
hero_walk.animation = animation;

return hero_walk;