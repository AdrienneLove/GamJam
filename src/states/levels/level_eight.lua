local l = {

	status = "intro", -- other states are play, dead, outro
	pre_intro = false,
	intro_completed = false,

	-- Difficulty/pacing stuff
	guard_types = {1,2,3,4},

	level_speed = 70,
	spawnChance = 100, -- out of 100; chance on a spawn tick that enemy will spawn
	spawnDelay = 0.5, -- spawn tick. on tick enemies will have a chance to spawn
	enemySpeed = 1.2, -- modifier for enemy speeds

	--background stuff
	backgrounds_left = 8, -- these two values the same
	foregrounds_left = 8,
	panels_left = 10, -- used in prop factory, actual panel amount.
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
	exit_door = {image = nil, x = nil, y = nil, alive = false, distance = 0}

}

return l