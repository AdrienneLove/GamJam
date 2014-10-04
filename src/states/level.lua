local level = {}

local Timer = require "lib.hump.timer"

hero = require "assets.chars.hero"

--level vars

local levels = {
	require 'states.levels.level_one',
	require 'states.levels.level_two'
}

local cur_level = 1

print(levels[2]["name"])

--print(levels[cur_level]["foregrounds_left"])

-- player / enemy stuff
local guards = require "assets.chars.guard"
local focusedGuard --this is being used by the wave checking
local spawn = false -- when true, chance for a spawn is triggered.


-- ui stuff
local gameover = false
local indicator = false
local waveCorrect = false
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

	-- set timer to go from intro to play
	-- Timer.add(1, function() status = "play" end)
	Timer.addPeriodic(spawnDelay, function() spawn = true end)

	--build initial background panels
	for key,value in pairs(levels[cur_level]["background_panels"]) do 
		value.x = background_imagedata_1:getWidth() * (key-1)
		value.image = background_panel_images[math.random(table.getn(background_panel_images))]
		if key == 1 then
			value.current = true
		else 
			value.current = false
		end
	end

	--build initial foreground panels
	for key,value in pairs(levels[cur_level]["foreground_panels"]) do 
		value.x = foreground_imagedata_1:getWidth() * (key-1)
		value.image = foreground_panel_images[math.random(table.getn(foreground_panel_images))]

		if key == 1 then
			value.current = true
		else 
			value.current = false
		end
	end

	--build entry doors
	for _,v in pairs(levels) do
		v.entry_door.image = love.graphics.newImage('assets/images/start_door.png')
		v.entry_door.x = 0
		v.entry_door.y = 0

		v.exit_door.image = love.graphics.newImage('assets/images/end_door.png')
		v.exit_door.x = 197
		v.exit_door.y = 0
	end

	-- set timer to go from intro to play
	-- Timer.add(1, function() status = "play" end)
	Timer.addPeriodic(levels[cur_level]["spawnDelay"], function() spawn = true end)

	--static props
	staticprops:populate()
end

function level:leave()

end

function level:update(dt)
	--update all timers
	Timer.update(dt)

	if not intro_completed then
	-- For intro
		if hero.x == 20 and not intro_completed then
			status = "play"
			hero.state = status
			intro_completed = true
		end


	if status == "play" or status == "outro" then

		--move entry door 
		if levels[cur_level]["entry_door"]["alive"] then
			levels[cur_level]["entry_door"]["x"] = levels[cur_level]["entry_door"]["x"] - levels[cur_level]["level_speed"] * dt;
			if levels[cur_level]["entry_door"]["x"] <= -200 then
				levels[cur_level]["entry_door"]["alive"] = false
				levels[cur_level]["entry_door"]["image"] = nil
			end
		end

		--static prop
		staticprops:update(dt, levels[cur_level]["level_speed"])

	end

	--update player/enemys
	if hero.lives == 0 then
		gameover = true
	end
	if gameover then
		level:gameover()
	end
	level:spawner()
	guards:update(dt)
	hero:update(dt)

	if status == "play" or status == "outro" then

		-- move background panels
		for key, value in pairs(levels[cur_level]["background_panels"]) do 
			-- move panels
			value.x = value.x - levels[cur_level]["level_speed"] * dt

			if value.x <  background_imagedata_1:getWidth()*-1 and levels[cur_level]["backgrounds_left"] > 0 then

				-- set item values and assign a new random image 
				-- I swear to god this is random 
				value.image = background_panel_images[math.random(table.getn(background_panel_images))]
				value.x = background_imagedata_1:getWidth()*2
				value.current = false

				-- set current panel
				if key+1 > table.getn(levels[cur_level]["background_panels"]) then
					levels[cur_level]["background_panels"][1].current = true
				else 
					levels[cur_level]["background_panels"][key+1].current = false
				end

				--search furthest and replace it, set this x to new furthest location
				for furthest_key, furthest_value in pairs(levels[cur_level]["background_panels"]) do 
					if furthest_value.furthest then 
						-- don't touch this. wizardy ahead. (can't touch this)
						if key == 1 then
							value.x = furthest_value.x + furthest_value.image:getWidth() - levels[cur_level]["level_speed"] * dt
						else
							value.x = furthest_value.x + furthest_value.image:getWidth()
						end
						furthest_value.furthest = false
						value.furthest = true
						--done searching so break
						break
					end
				end

				levels[cur_level]["backgrounds_left"] = levels[cur_level]["backgrounds_left"] -1
			end
		end

		-- move foreground panels
		for key, value in pairs(levels[cur_level]["foreground_panels"]) do 
			-- move panels
			value.x = value.x - levels[cur_level]["level_speed"] * dt

			if value.x <  foreground_imagedata_1:getWidth()*-1 and levels[cur_level]["foregrounds_left"] > 0 then

				-- set item values and assign a new random image
				value.image = foreground_panel_images[math.random(table.getn(foreground_panel_images))]
				value.x = background_imagedata_1:getWidth()*2
				value.current = false

				-- set current panel
				if key+1 > table.getn(levels[cur_level]["foreground_panels"]) then
					levels[cur_level]["foreground_panels"][1].current = true
				else 
					levels[cur_level]["foreground_panels"][key+1].current = false
				end

				--search furthest and replace it, set this x to new furthest location
				for furthest_key, furthest_value in pairs(levels[cur_level]["foreground_panels"]) do 
					if furthest_value.furthest then 
						-- don't touch this. wizardy ahead. (can't touch this)
						if key == 1 then
							value.x = furthest_value.x + furthest_value.image:getWidth()	 - levels[cur_level]["level_speed"] * dt
						else
							value.x = furthest_value.x + furthest_value.image:getWidth()
						end
						furthest_value.furthest = false
						value.furthest = true
						--done searching so break
						break
					end
				end

				levels[cur_level]["foregrounds_left"] = levels[cur_level]["foregrounds_left"] - 1
				print(levels[cur_level]["foregrounds_left"])
			end
		end

		if status == "play" and levels[cur_level]["foregrounds_left"] == 0 and levels[cur_level]["backgrounds_left"] == 0 then
			
			--search furthest background and put a door there
			for furthest_key, furthest_value in pairs(levels[cur_level]["foreground_panels"]) do 
				if furthest_value.furthest then
					levels[cur_level]["exit_door"]["x"] = furthest_value.x + levels[cur_level]["exit_door"]["x"]
					levels[cur_level]["exit_door"]["alive"] = true
					levels[cur_level]["exit_door"]["distance"] = levels[cur_level]["exit_door"]["x"]
					status = "outro"
					break
				end
			end
		end

		if status == "outro" then
			if levels[cur_level]["exit_door"]["distance"] > 200 then 
				levels[cur_level]["exit_door"]["x"] = levels[cur_level]["exit_door"]["x"] - levels[cur_level]["level_speed"] * dt
				levels[cur_level]["exit_door"]["distance"] = levels[cur_level]["exit_door"]["distance"] - levels[cur_level]["level_speed"] * dt
			else
				status = "exit"
			end 
		end
	end

	if status == "exit" then
		if hero.state ~= "stand" and not hero.leaving then
			hero.state = "stand"
			Timer.add(1, function() hero.state = "exit"; hero.leaving = true end)
		end

		if hero.x > 250 then
			status = "quit"
		end
	end
end

function level:draw()
	love.graphics.push()

	love.graphics.scale( SCALE )

	--draw background panels 1, 2 and 3
	for key, value in pairs(levels[cur_level]["background_panels"]) do 
		love.graphics.draw(value.image, value.x, 0)
	end

	--draw foreground panels 1, 2 and 3
	for key, value in pairs(levels[cur_level]["foreground_panels"]) do 
		love.graphics.draw(value.image, value.x, 0)
	end

	if levels[cur_level]["entry_door"]["alive"] then
		love.graphics.draw(levels[cur_level]["entry_door"]["image"], levels[cur_level]["entry_door"]["x"], levels[cur_level]["entry_door"]["y"])
	end

	if levels[cur_level]["exit_door"]["alive"] then
		love.graphics.draw(levels[cur_level]["exit_door"]["image"], levels[cur_level]["exit_door"]["x"], levels[cur_level]["exit_door"]["y"])
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
	if key == "w" then
		-- Y = 14
		wave = "Y"
		hero:saluteY()
	end
	if key == "a" then
		-- X = 13
		wave = "X"
		hero:saluteX()
	end
	if key == "d" then
		-- B = 12
		wave = "B"
		hero:saluteB()
	end
	if key == "s" then
		-- A = 11
		wave = "A"
		hero:saluteA()
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

	local wave

	if joystick:isGamepadDown("y") then
		wave = "Y"
		hero:saluteY()
	end
	if joystick:isGamepadDown("x") then
		wave = "X"
		hero:saluteX()
	end
	if joystick:isGamepadDown("b") then
		wave = "B"
		hero:saluteB()
	end
	if joystick:isGamepadDown("a") then
		wave = "A"
		hero:saluteA()
	end

	if wave then level:checkWave(wave) end
end

function level:spawner()
	local roll = math.random(0,100)
	if gameover then
		spawn = false
	end

	if spawn and roll > 0 and roll < levels[cur_level]["spawnChance"] then
		guard = math.random(1,4)
		guards:newGuard(guard)
		spawn = false
	elseif spawn then
		-- if the spawn was true and no spawn happened, still flip spawn back to false.
		--spawn = false
	end
	-- timer that has a x% chance to trigger spawn.
end

function level:gameover()
	spawnChance = 0
	spawner = false
	level:stopNearestGuard()
end

function level:stopNearestGuard()
	if #guards.current_guards > 0 then
		local lowest = guards.current_guards[1].x
		local nearest = guards.current_guards[1]
		for i,v in ipairs(guards.current_guards) do
			if v.x > 90 and v.x < lowest then
				nearest = guards.current_guards[i]
			end
		end
		nearest.speed = 0
	end
	--printTable(nearest)
end

return level