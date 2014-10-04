local l = {

	name = "one",

	status = "intro", -- other states are play, dead, outro
	intro_completed = false,

	-- Difficulty/pacing stuff
	level_speed = 100,
	spawnChance = 10, -- out of 100; chance on a spawn tick that enemy will spawn
	spawnDelay = .5, -- spawn tick. on tick enemies will have a chance to spawn

	--background stuff
	backgrounds_left = 4, -- these two values the same
	foregrounds_left = 4,
	panels_left = 6,
	status = "intro", -- other states are play, dead and outro

	-- hot swap between panel 1, 2 and 3
	background_panels = {
		{ x = 0, image = nil, current = false, furthest = false},
		{ x = 0, image = nil, current = false, furthest = false},
		{ x = 0, image = nil, current = false, furthest = true}
	},

	foreground_panels = {
		{ x = 0, image = nil, current = false, furthest = false},
		{ x = 0, image = nil, current = false, furthest = false},
		{ x = 0, image = nil, current = false, furthest = true}
	},

	--doors and stuff
	entry_door = {image = nil, x = nil, y = nil, alive = true},
	exit_door = {image = nil, x = nil, y = nil, alive = false, distance = 0},

}

return l