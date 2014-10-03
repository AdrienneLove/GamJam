
-- Rimon, only look at this bit up here!

local guard_walk = {
	_WIDTH = 78,				-- width of a single frame of animation
	_HEIGHT = 114,			-- height of a single frame of animation
	_FRAMES = 8,			-- frames there are in the animation
	_FILENAME = "rimon_walk.png", 	-- file name in the animations folder
	_ANIMATIONSPEED = 0.12 		-- speed the animation cycles at
}

-----------------------------

-- setup vars
local guard_walk_spritemap, animation

--include image, set up width and frames 
guard_walk_spritemap = love.graphics.newImage("assets/animations/"..guard_walk._FILENAME);
local g = anim8.newGrid(guard_walk._WIDTH, guard_walk._HEIGHT, guard_walk_spritemap:getWidth(), guard_walk_spritemap:getHeight())
animation = anim8.newAnimation(g('1-'..guard_walk._FRAMES,1), guard_walk._ANIMATIONSPEED)

--pass all the stuff that's needed back to game
guard_walk.guard_walk_spritemap = guard_walk_spritemap;
guard_walk.animation = animation;

return guard_walk;