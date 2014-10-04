local level = {}

local Timer = require "lib.hump.timer"

hero = require "assets.chars.hero"

--level vars

local levels = {
	require 'states.levels.level_one',
	require 'states.levels.level_two',
	require 'states.levels.level_three',
	require 'states.levels.level_four',
	require 'states.levels.level_five'
}

local cur_level = 1

--print(levels[2]["name"])

--print(levels[cur_level]["foregrounds_left"])

-- player / enemy stuff
local guards = require "assets.chars.guard"
local focusedGuard --this is being used by the wave checking
local spawn = false -- when true, chance for a spawn is triggered.


-- ui stuff
local gameover = false
local indicator = false
local waveCorrect = false
local cube = love.graphics.newImage('assets/animations/splash_cube.png')
local swishfont = love.graphics.newFont('assets/fonts/LovedbytheKing.ttf', 20)

local props = require "assets.propfactory"

local fading = true
local game_music
local bgm_params 

function level:enter(state)

	-- -- Test for intro, set to true if into has finished not used otherwise.
	-- intro_completed = false

	love.graphics.setDefaultFilter('nearest')

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

	--panel iterates at half screen

	level:reInit()

	-- set timer to go from intro to play
	-- Timer.add(1, function() status = "play" end)
	Timer.addPeriodic(levels[cur_level]["spawnDelay"], function() spawn = true end)

	--static props
	--props:populate()

	-- play music
	game_music = love.audio.newSource( "assets/audio/cephelopod.mp3", "stream" )
	game_music:setLooping( true )
	game_music:setVolume(0.5)
	love.audio.play( game_music )

	-- fade in / out 
	-- fading = true
	self.fade_params = { opacity = 255 }
	bgm_params = { volume = 0.5 }
	-- Timer.add(1/60, function()
	-- 	Timer.tween(0.25, self.fade_params, { opacity = 0 }, 'in-out-sine')
	-- 	Timer.add(0.25, function()
	-- 		fading = false
	-- 	end)
	-- end)
	Timer.tween(0.25, bgm_params, { volume = 0.8 })

end

function level:reInit()

	for k,v in pairs(package.loaded) do
		if string.match(k,"level_") then
			package.loaded[k] = purge(package.loaded[k])
		end
	end

	levels = {
	require 'states.levels.level_one',
	require 'states.levels.level_two',
	require 'states.levels.level_three',
	require 'states.levels.level_four',
	require 'states.levels.level_five'
}

	--build initial background panels
	for i,v in ipairs(levels) do
		for key,value in pairs(levels[i]["background_panels"]) do 
			value.x = background_imagedata_1:getWidth() * (key-1)
			value.image = background_panel_images[math.random(table.getn(background_panel_images))]
			if key == 1 then
				value.current = true
			else 
				value.current = false
			end
		end
	end

	--build initial foreground panels
	for i,v in ipairs(levels) do
		for key,value in pairs(levels[i]["foreground_panels"]) do 
			value.x = foreground_imagedata_1:getWidth() * (key-1)
			value.image = foreground_panel_images[math.random(table.getn(foreground_panel_images))]

			if key == 1 then
				value.current = true
			else 
				value.current = false
			end
		end
	end

	--build entry doors
	for _,v in ipairs(levels) do
		v.entry_door.image = love.graphics.newImage('assets/images/start_door.png')
		v.entry_door.x = 0
		v.entry_door.y = 0

		v.exit_door.image = love.graphics.newImage('assets/images/end_door.png')
		v.exit_door.x = 197
		v.exit_door.y = 0
	end

	cur_level = 1
	hero:init()
	purge(guards.current_guards)

	guards:particlePurge()

	props:populate()

	gameover = false
end

-- function level:leave(dt)
-- 	fading = true

-- end

function level:update(dt)
	--update all timers
	Timer.update(dt)

	if levels[cur_level]["pre_intro"] == false then

		Timer.tween(0.50, self.fade_params, { opacity = 0 }, 'in-out-sine',
		            function () levels[cur_level]["pre_intro"] = true
		            	fading = false
		             end)
		levels[cur_level]["pre_intro"] = true

	elseif hero.x == 20 and not levels[cur_level]["intro_completed"] then
		levels[cur_level]["status"] = "play"
		hero.state = levels[cur_level]["status"]
		levels[cur_level]["intro_completed"] = true
	end

	if levels[cur_level]["status"] == "play" or levels[cur_level]["status"] == "outro" then

		--move entry door 
		if levels[cur_level]["entry_door"]["alive"] then
			levels[cur_level]["entry_door"]["x"] = levels[cur_level]["entry_door"]["x"] - levels[cur_level]["level_speed"] * dt;
			if levels[cur_level]["entry_door"]["x"] <= -200 then
				levels[cur_level]["entry_door"]["alive"] = false
				levels[cur_level]["entry_door"]["image"] = nil
			end
		end

		props:update(dt, levels[cur_level]["level_speed"])

	end

	--update player/enemys
	if hero.lives == 0 then
		gameover = true
	end
	if gameover then
		level:gameover()
		return
	end

	-- Don't spawn at end of level.
	if levels[cur_level]["backgrounds_left"] > 0 then
		level:spawner()
	end


	hero:update(dt)
	guards:update(dt)

	if levels[cur_level]["status"] == "play" or levels[cur_level]["status"] == "outro" then

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
			end
		end

		if levels[cur_level]["status"] == "play" and levels[cur_level]["foregrounds_left"] == 0 and levels[cur_level]["backgrounds_left"] == 0 then
			
			--search furthest background and put a door there
			for furthest_key, furthest_value in pairs(levels[cur_level]["foreground_panels"]) do 
				if furthest_value.furthest then
					levels[cur_level]["exit_door"]["x"] = furthest_value.x + levels[cur_level]["exit_door"]["x"]
					levels[cur_level]["exit_door"]["alive"] = true
					levels[cur_level]["exit_door"]["distance"] = levels[cur_level]["exit_door"]["x"]
					levels[cur_level]["status"] = "outro"
					break
				end
			end
		end

		if levels[cur_level]["status"] == "outro" then
			if levels[cur_level]["exit_door"]["distance"] > 200 then 
				levels[cur_level]["exit_door"]["x"] = levels[cur_level]["exit_door"]["x"] - levels[cur_level]["level_speed"] * dt
				levels[cur_level]["exit_door"]["distance"] = levels[cur_level]["exit_door"]["distance"] - levels[cur_level]["level_speed"] * dt
			else
				levels[cur_level]["status"] = "exit"
			end 
		end
	end

	if levels[cur_level]["status"] == "exit" then
		if hero.state ~= "stand" and not hero.leaving then
			hero.state = "stand"
			Timer.add(1, function() hero.state = "exit"; hero.leaving = true end)
		end

		if hero.x > 250 then
			levels[cur_level]["status"] = "quit"
		end
	end

	if levels[cur_level]["status"] == "quit" then

		if not fading then
			fading = true
			Timer.tween(0.5, self.fade_params, { opacity = 255 }, 'in-out-sine',
			            function () level:newLevel() end)
		end
	end

	if self.fading then
		game_music:setVolume(self.bgm_params.volume)
	end
end

function level:newLevel()

	if cur_level == 5 then
		--??
	else
		cur_level = cur_level + 1
		hero:newLevel()
		props:populate()
		fading = false
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

	--if levels[cur_level]["entry_door"]["alive"] then
	--	love.graphics.draw(levels[cur_level]["entry_door"]["image"], levels[cur_level]["entry_door"]["x"], levels[cur_level]["entry_door"]["y"])
	--end

	if levels[cur_level]["exit_door"]["alive"] then
		love.graphics.draw(levels[cur_level]["exit_door"]["image"], levels[cur_level]["exit_door"]["x"], levels[cur_level]["exit_door"]["y"])
	end

	--static props
	props:draw()

	-- draw life count
	for i=1,hero.lives do
		--love.graphics.draw(cube, 40*i, 50)
		love.graphics.draw(hero.life, 15*i, 10)
	end

	if gameover then
		--draw text
		love.graphics.setColor(255, 255, 255, 255)
		love.graphics.setFont(swishfont)
		love.graphics.printf("YOU DIED :'(", 30, 30, 100, 'center')



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

	if levels[cur_level]["entry_door"]["alive"] then
		love.graphics.draw(levels[cur_level]["entry_door"]["image"], levels[cur_level]["entry_door"]["x"], levels[cur_level]["entry_door"]["y"])
	end

	love.graphics.pop()

	if fading then
		love.graphics.setColor(33, 33, 33, self.fade_params.opacity)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	end
end

function level:keypressed(key, unicode)
	local wave

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

	if key == "p" then
		guards:spawnParticle("pass", 128, 80)
	end

	if wave then level:checkWave(wave) end
end

function level:checkWave(wave)
	-- NOTE: we still need to account for a guard not being waved at... this is also a failure but should be tracked elsewhere... (in guard maybe?)
	if level:checkArea() then
		if wave == focusedGuard.expectedWave then
			--flip this guards wavedAt to true.
			focusedGuard:successWave()
			waveCorrect = true
			guards:spawnParticle("pass", focusedGuard.x + 6, focusedGuard.speed)
		else
			focusedGuard:failWave()
			waveCorrect = false
			guards:spawnParticle("fail", focusedGuard.x + 6, focusedGuard.speed)
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

	if button == 1 then
		wave = "A"
	elseif button == 2 then
		wave = "B"
	elseif button == 3 then
		wave = "X"
	elseif button == 4 then
		wave = "Y"
	end
	
	if joystick:isGamepadDown("y") then
		wave = "Y"
	end
	if joystick:isGamepadDown("x") then
		wave = "X"
	end
	if joystick:isGamepadDown("b") then
		wave = "B"
	end
	if joystick:isGamepadDown("a") then
		wave = "A"
	end

	if wave == "Y" then
		hero:saluteY()
	elseif wave == "X" then
		hero:saluteX()
	elseif wave == "B" then
		hero:saluteB()
	elseif wave == "A" then
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
	guards:spawnParticle("lose", hero.x + 6, 0)
	guards:particlePause()
	-- level:stopNearestGuard()
	--levels[cur_level]["level_speed"] = 0
	level:reInit()
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
		if nearest.x < 100 then
			nearest.speed = 0
			-- hero:stopHero() --only want the hero to stop once the guard has reached them.
			nearest:stopGuard()

		end
	end
	--printTable(nearest)
end

return level