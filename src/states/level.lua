local level = {}

local Timer = require "lib.hump.timer"

--level vars
local level_speed = 200
local backgrounds_left = 4
local foregrounds_left = backgrounds_left
local status = "intro" -- other states are play, dead, outro and exit
-- into_completed value in level:enter()


--background stuff
local level_speed = 100
local panels_left = 6
local status = "intro" -- other states are play, dead and outro

-- hot swap between panel 1, 2 and 3
local background_panels = {
	{ x = 0, image = nil, current = false, furthest = false},
	{ x = 0, image = nil, current = false, furthest = false},
	{ x = 0, image = nil, current = false, furthest = true}
}

local foreground_panels = {
	{ x = 0, image = nil, current = false, furthest = false},
	{ x = 0, image = nil, current = false, furthest = false},
	{ x = 0, image = nil, current = false, furthest = true}
}

--doors and stuff
local entry_door = {image = nil, x = nil, y = nil, alive = true}
local exit_door = {image = nil, x = nil, y = nil, alive = false, distance = 0}

-- player / enemy stuff
hero = require "assets.chars.hero"
local guards = require "assets.chars.guard"
local focusedGuard --this is being used by the wave checking
local spawnChance = 10 -- out of 100; chance on a spawn tick that enemy will spawn
local spawn = false -- when true, chance for a spawn is triggered.
local spawnDelay = 1 -- spawn tick. on tick enemies will have a chance to spawn

-- ui stuff
local gameover = false
local indicator = false
local waveCorrect = false
local cube = love.graphics.newImage('assets/animations/splash_cube.png')
local swishfont = love.graphics.newFont('assets/fonts/LovedbytheKing.ttf', 30)

local staticprops = require "assets.propfactory"

function level:enter(state)

	-- Test for intro, set to true if into has finished not used otherwise.
	intro_completed = false

	love.graphics.setDefaultFilter('nearest')
	--panel iterates at half screen

	--load in panel data for foreground and background
	background_imagedata_start = love.image.newImageData('assets/images/start.gif')
	background_imagedata_1 = love.image.newImageData('assets/images/wall1.png')
	background_imagedata_2 = love.image.newImageData('assets/images/wall2.png')
	foreground_imagedata_1 = love.image.newImageData('assets/images/floor1sketch.png')
	background_imagedata_end = love.image.newImageData('assets/images/end.gif')

	--create as many image items as needed for background then foreground
	background_panel_images = { 
		love.graphics.newImage(background_imagedata_1),
		love.graphics.newImage(background_imagedata_2)
	}

	foreground_panel_images = {
		love.graphics.newImage(foreground_imagedata_1)
	}



	--build initial background panels
	for key,value in pairs(background_panels) do 
		value.x = background_imagedata_1:getWidth() * (key-1)
		value.image = background_panel_images[math.random(table.getn(background_panel_images))]
   		if key == 1 then
   			value.current = true
   		else 
   			value.current = false
   		end
	end

	--build initial foreground panels
	for key,value in pairs(foreground_panels) do 
		value.x = foreground_imagedata_1:getWidth() * (key-1)
		value.image = foreground_panel_images[math.random(table.getn(foreground_panel_images))]
   		
   		if key == 1 then
   			value.current = true
   		else 
   			value.current = false
   		end
	end

	--build entry door
	entry_door.image = love.graphics.newImage('assets/images/start_door.png')
	entry_door.x = 0
	entry_door.y = 0

	exit_door.image = love.graphics.newImage('assets/images/end_door.png')
	exit_door.x = 197
	exit_door.y = 0

	-- set timer to go from intro to play
	-- Timer.add(1, function() status = "play" end)
	Timer.addPeriodic(spawnDelay, function() spawn = true end)

	-- enemy spawn (testers)
	guards:newGuard(2)
	guards:newGuard(1)
	guards:newGuard(3)
	guards:newGuard(4)

	--static props
	staticprops:populate()
end

function level:leave()
	
end

function level:update(dt)
	--update all timers
	Timer.update(dt)

	-- For intro
	if hero.x == 20 and not intro_completed then
		status = "play"
		hero.state = status
		intro_completed = true
	end

	if status == "play" or status == "outro" then

		--move entry door 
		if entry_door.alive then
			entry_door.x = entry_door.x - level_speed * dt;
			if entry_door.x <= -200 then
				entry_door.alive = false
				entry_door.image = nil
			end
		end

		--static prop
		staticprops:update(dt, level_speed)

	end

	--update player/enemys
	level:spawner()
	guards:update(dt)
	hero:update(dt)

	if status == "play" or status == "outro" then

		-- move background panels
		for key, value in pairs(background_panels) do 
			-- move panels
			value.x = value.x - level_speed * dt

			if value.x <  background_imagedata_1:getWidth()*-1 and backgrounds_left > 0 then

				-- set item values and assign a new random image 
				-- I swear to god this is random 
				value.image = background_panel_images[math.random(table.getn(background_panel_images))]
				value.x = background_imagedata_1:getWidth()*2
				value.current = false

				-- set current panel
				if key+1 > table.getn(background_panels) then
					background_panels[1].current = true
				else 
					background_panels[key+1].current = false
				end

				--search furthest and replace it, set this x to new furthest location
				for furthest_key, furthest_value in pairs(background_panels) do 
					if furthest_value.furthest then 
						-- don't touch this. wizardy ahead. (can't touch this)
						if key == 1 then
							value.x = furthest_value.x + furthest_value.image:getWidth()	 - level_speed * dt
						else
							value.x = furthest_value.x + furthest_value.image:getWidth()
						end
						furthest_value.furthest = false
						value.furthest = true
						--done searching so break
						break
					end
				end

				backgrounds_left = backgrounds_left -1
			end
		end

		-- move foreground panels
		for key, value in pairs(foreground_panels) do 
			-- move panels
			value.x = value.x - level_speed * dt

			if value.x <  foreground_imagedata_1:getWidth()*-1 and foregrounds_left > 0 then

				-- set item values and assign a new random image
				value.image = foreground_panel_images[math.random(table.getn(foreground_panel_images))]
				value.x = background_imagedata_1:getWidth()*2
				value.current = false

				-- set current panel
				if key+1 > table.getn(foreground_panels) then
					foreground_panels[1].current = true
				else 
					foreground_panels[key+1].current = false
				end

				--search furthest and replace it, set this x to new furthest location
				for furthest_key, furthest_value in pairs(foreground_panels) do 
					if furthest_value.furthest then 
						-- don't touch this. wizardy ahead. (can't touch this)
						if key == 1 then
							value.x = furthest_value.x + furthest_value.image:getWidth()	 - level_speed * dt
						else
							value.x = furthest_value.x + furthest_value.image:getWidth()
						end
						furthest_value.furthest = false
						value.furthest = true
						--done searching so break
						break
					end
				end

				foregrounds_left = foregrounds_left - 1
			end
		end

		if status == "play" and foregrounds_left == 0 and backgrounds_left == 0 then
			
			--search furthest background and put a door there
			for furthest_key, furthest_value in pairs(foreground_panels) do 
				if furthest_value.furthest then
					exit_door.x = furthest_value.x + exit_door.x
					exit_door.alive = true
					exit_door.distance = exit_door.x
					status = "outro"
					break
				end
			end
		end

		if status == "outro" then
			if exit_door.distance > 200 then 
				exit_door.x = exit_door.x - level_speed * dt
				exit_door.distance = exit_door.distance - level_speed * dt
			else 
				status = "exit"
			end 
		end
	end
end

function level:draw()
	love.graphics.push()

	love.graphics.scale( SCALE )

	--draw background panels 1, 2 and 3
	for key, value in pairs(background_panels) do 
		love.graphics.draw(value.image, value.x, 0)
	end

	--draw foreground panels 1, 2 and 3
	for key, value in pairs(foreground_panels) do 
		love.graphics.draw(value.image, value.x, 0)
	end

	if entry_door.alive then
		love.graphics.draw(entry_door.image, entry_door.x, entry_door.y)
	end

	if exit_door.alive then
		love.graphics.draw(exit_door.image, exit_door.x, exit_door.y)
	end

	--static props
	staticprops:draw()

	-- draw life count
	for i=1,hero.lives do
		--love.graphics.draw(cube, 40*i, 50)
		love.graphics.printf(hero.lives, 15*i, 20, 250, 'left')
	end

	if gameover then
		--draw text
		love.graphics.setColor(255, 156, 255, 255)
		love.graphics.setFont(swishfont)
		love.graphics.printf("LOL NOPE.", love.graphics.getWidth()/2-250, love.graphics.getHeight()/2-25, 500, 'center')
	end

	-- wave detect / indicator for the zone that enemies can receive waves in
	if indicator then
		if waveCorrect then
			love.graphics.setColor(0, 220, 50, 255)
		else
			love.graphics.setColor(240, 30, 30, 255)
		end
	else
		love.graphics.setColor(45, 45, 45, 255)
	end
	love.graphics.rectangle("fill", 50, 120, 40, 5)
	
	--draw enemies
	guards:draw()

	--draw hero
	hero:draw(dt)
	
	love.graphics.pop()
end

function level:keypressed(key, unicode)
	-- navigate menu
	if key == "q" then
		love.event.push("quit")
	end

end

function level:checkWave(wave)
	-- NOTE: we still need to account for a guard not being waved at... this is also a failure but should be tracked elsewhere... (in guard maybe?)
	if level:checkArea() then
		if wave == focusedGuard.expectedWave then
			--flip this guards wavedAt to true.
			waveCorrect = true
		else
			waveCorrect = false
			hero:eatLife()
		end
	else
		--no guard in area, NOM LYF
		waveCorrect = false
		hero:eatLife()
	end
	indicator = true
end

-- checks the detection area for a guard, returns true / false
function level:checkArea()
	for i=1,table.getn(guards.current_guards) do
		if guards.current_guards[i]["x"] > 50 and guards.current_guards[i]["x"] < 90 then
			focusedGuard = guards.current_guards[i]
			return true
		end
	end
	return false
end

function level:joystickreleased(joystick, button)
	indicator = false
end


function level:joystickpressed(joystick, button)
	
	if button == 4 then
		-- Y = 14
		wave = "Y"
		hero:saluteY()
	end
	if button == 3 then
		-- X = 13
		wave = "X"
		hero:saluteX()
	end
	if button == 2 then
		-- B = 12
		wave = "B"
		hero:saluteB()
	end
	if button == 1 then
		-- A = 11
		wave = "A"
		hero:saluteA()
	end

	level:checkWave(wave)
end

function level:spawner()
	local roll = math.random(0,100)

	if spawn and roll > 0 and roll < spawnChance then
		guard = math.random(1,4)
		guards:newGuard(guard)
		spawn = false
	elseif spawn then
		-- if the spawn was true and no spawn happened, still flip spawn back to false.
		--spawn = false
	end
	-- timer that has a x% chance to trigger spawn.
end

return level