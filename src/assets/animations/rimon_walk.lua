
-- Rimon, only look at this bit up here!

local rimon_walk = {
	_WIDTH = 78,				-- width of a single frame of animation
	_HEIGHT = 114,			-- height of a single frame of animation
	_FRAMES = 8,			-- frames there are in the animation
	_FILENAME = "rimon_walk.png", 	-- file name in the animations folder
	_ANIMATIONSPEED = 0.12 		-- speed the animation cycles at
}

-----------------------------

--include libs and setup vars
local anim8 = require 'lib.anim8'
local rimon_walk_spritemap, animation

--include image, set up width and frames 
rimon_walk_spritemap = love.graphics.newImage("assets/animations/rimon_walk.png");
local g = anim8.newGrid(rimon_walk._WIDTH, rimon_walk._HEIGHT, rimon_walk_spritemap:getWidth(), rimon_walk_spritemap:getHeight())
animation = anim8.newAnimation(g('1-'..rimon_walk._FRAMES,1), rimon_walk._ANIMATIONSPEED)

--pass all the stuff that's needed back to game
rimon_walk.rimon_walk_spritemap = rimon_walk_spritemap;
rimon_walk.animation = animation;

return rimon_walk;