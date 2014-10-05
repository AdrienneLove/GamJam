local l = {

	status = "intro", -- other states are play, dead, outro
	pre_intro = false,
	intro_completed = false,

	-- Difficulty/pacing stuff
	level_speed = 70,
	spawnChance = 40, -- out of 100; chance on a spawn tick that enemy will spawn
	spawnDelay = 1, -- spawn tick. on tick enemies will have a chance to spawn
	enemySpeed = 1, -- modifier for enemy speeds

	--background stuff
	backgrounds_left = 6, -- these two values the same
	foregrounds_left = 6,
	panels_left = 8,
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