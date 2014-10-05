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

local cur_level -- set in level:reInit()

-- player / enemy stuff
local guards = require "assets.chars.guard"
local particle = require "assets.particles"
local focusedGuard --this is being used by the wave checking
local spawn = false -- when true, chance for a spawn is triggered.


-- ui stuff
local hintfont = love.graphics.newFont('assets/fonts/ARCADECLASSIC.ttf', 10)
hintfont:setFilter("nearest", "nearest", 1)


local gameover = false
local gameoverY = 40 --inital position of gameover text
local gameover_locked = true
local gameover_sound = love.audio.newSource("assets/audio/error_style_1_echo_001.ogg", "static")
local indicator = false
local waveCorrect = false
--local cube = love.graphics.newImage('assets/animations/splash_cube.png')
local colorPressed = "none"
local swishfont = love.graphics.newFont('assets/fonts/ARCADECLASSIC.ttf', 20)

local props = require "assets.propfactory"

local fading = true
local show_loading = false
local show_end = false
local game_music
local bgm_params 

function level:enter(state)

	-- -- Test for intro, set to true if into has finished not used otherwise.
	-- intro_completed = false

	love.graphics.setDefaultFilter('nearest')
	swishfont:setFilter("nearest", "nearest", 1)

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

	--images needed for ui button display
	green = love.graphics.newImage('assets/images/colourGreen.png')
	blue = love.graphics.newImage('assets/images/colourBlue.png')
	yellow = love.graphics.newImage('assets/images/colourYellow.png')
	red = love.graphics.newImage('assets/images/colourRed.png')

	loading_screens = {
		love.graphics.newImage('assets/images/level2.png'),
		love.graphics.newImage('assets/images/level3.png'),
		love.graphics.newImage('assets/images/level4.png'),
		love.graphics.newImage('assets/images/level5.png')
	}

	end_screen = love.graphics.newImage('assets/images/end_screen.png'),

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
	game_music:setVolume(0.0)
	love.audio.play( game_music )

	-- fade in / out 
	self.fade_params = { opacity = 255 }
	self.bgm_params = { volume = 0.0 }
	Timer.tween(0.5, self.bgm_params, { volume = 0.5 })



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

	particle:purge()
	particle:start()

	-- fade in / out 
	-- fading = true
	self.fade_params = { opacity = 255, opacity_door = 0 }
	self.bgm_params = { volume = 0.5 }
	Timer.tween(0.25, self.fade_params, { opacity = 0, opacity_door = 255 }, 'in-out-sine')
	Timer.tween(0.5, self.bgm_params, { volume = 0.5 })

	props:populate()


	gameover = false
end

-- function level:leave(dt)
-- 	fading = true

-- end

function level:update(dt)
	--update all timers
	Timer.update(dt)
	
	game_music:setVolume(self.bgm_params.volume)

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

	-- Don't spawn at end or during intro of level.
	if levels[cur_level]["backgrounds_left"] > 0 and levels[cur_level]["status"] ~= "intro" then
		level:spawner()
	end

	hero:update(dt)
	guards:update(dt)
	particle:update(dt)

	local missed = guards:leavecheck(dt)
	if missed == true then
		nearest = guards.current_guards[1]
		nearest:failWave()
		if hero.lives > 1 then
			particle:spawn("fail", nearest.x + 6, nearest.speed)
			hero:eatLife()
		else
			hero:eatLife()
			nearest.x  = nearest.x + 50
		end
	end

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

				--print(levels[cur_level]["foregrounds_left"])
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
			Timer.tween(0.5, self.fade_params, { opacity = 255 }, 'in-out-sine', function () 
				level:newLevel() 
			end)
		end
	end
end

function level:newLevel()

	fading = true
	if cur_level == 5 then
		hero.state = "exit"
		show_end = true
		Timer.tween(0.25, self.bgm_params, { volume = 0.0 }, 'linear')
		Timer.tween(0.5, self.fade_params, { opacity = 0 }, 'in-out-sine', function ()
			Timer.add(10,function() Gamestate.switch(require "states.credits")
				end)
		end)
	else
		hero.state = "exit"
		show_loading = true
		Timer.tween(0.25, self.bgm_params, { volume = 0.0 }, 'linear')
		Timer.tween(0.5, self.fade_params, { opacity = 0 }, 'in-out-sine', function ()
			Timer.add(1, function()
				Timer.tween(0.25, self.bgm_params, { volume = 0.5 }, 'in-out-sine')
				Timer.tween(0.5, self.fade_params, { opacity = 255 }, 'in-out-sine', function () 
					show_loading = false
					cur_level = cur_level + 1
					hero:newLevel()
					props:populate()
					fading = false
				end)
				
			end)
		end)
	end


end

function level:draw()
	love.graphics.setBackgroundColor(33, 33, 33, 255)
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

	-- wave detect / indicator for the zone that enemies can receive waves in
	-- LEAVING THIS IN as it will kind of become the light effect
	if level:isGuardInRange() then
		love.graphics.setColor(220, 220, 220, 140)
		if colourPressed == "blue" then
			love.graphics.setColor(55, 121, 205, 140)
		elseif colourPressed == "yellow" then
			love.graphics.setColor(226, 200, 52, 140)
		elseif colourPressed == "red" then
			love.graphics.setColor(220, 52, 52, 140)
		elseif colourPressed == "green" then
			love.graphics.setColor(30, 165, 29, 140)
		end

		love.graphics.ellipse("fill", 75, 103, 20, 4, math.rad(0), 30)
	end

	--draw indicators.
	--if colourPressed ==
	if colourPressed == "blue" then
		love.graphics.setColor(255, 255, 255, 255)
	else
		love.graphics.setColor(90, 90, 90, 255)
	end
	love.graphics.draw(blue, 55, 116)

	if colourPressed == "yellow" then
		love.graphics.setColor(255, 255, 255, 255)
	else
		love.graphics.setColor(90, 90, 90, 255)
	end
	love.graphics.draw(yellow, 66, 116)

	if colourPressed == "green" then
		love.graphics.setColor(255, 255, 255, 255)
	else
		love.graphics.setColor(90, 90, 90, 255)
	end
	love.graphics.draw(green, 77, 116)

	if colourPressed == "red" then
		love.graphics.setColor(255, 255, 255, 255)
	else
		love.graphics.setColor(90, 90, 90, 255)
	end
	love.graphics.draw(red, 88, 116)


	
	--draw particles
	particle:draw()

	--draw enemies
	guards:draw()

	--draw hero
	hero:draw(dt)

	--draw entry door on 
	if levels[cur_level]["entry_door"]["alive"] then
		love.graphics.draw(levels[cur_level]["entry_door"]["image"], levels[cur_level]["entry_door"]["x"], levels[cur_level]["entry_door"]["y"])
	end

	if levels[cur_level]["entry_door"]["alive"] then
		love.graphics.draw(levels[cur_level]["entry_door"]["image"], levels[cur_level]["entry_door"]["x"], levels[cur_level]["entry_door"]["y"])
	end

	-- gameover text / fade
	if gameover and self.fading ~= false then
		love.graphics.setColor(33, 33, 33, 80)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		--draw text
		love.graphics.setColor(0, 0, 0, 150)
		love.graphics.setFont(swishfont)
		if gameoverY > 30 then		
			love.graphics.printf("Game over", 62, gameoverY+2, 100, 'center')
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.printf("Game over", 60, gameoverY, 100, 'center')
			gameoverY = gameoverY - .5
		else
			love.graphics.printf("Game over", 62, 32, 100, 'center')
			love.graphics.setColor(255, 255, 255, 255)
			love.graphics.printf("Game over", 60, 30, 100, 'center')

			love.graphics.setFont(hintfont)
			love.graphics.printf("press any button to restart level", 60, 48, 100, 'center')
			love.graphics.setFont(swishfont)

			gameover_locked = false
		end
	end



	love.graphics.pop()

	--show loading screen and end screen outside of graphics scaling 
	love.graphics.scale(1)
	
	if show_loading then
		love.graphics.draw(loading_screens[cur_level], 0, 0, 0, love.graphics.getWidth() / loading_screens[cur_level]:getWidth(), love.graphics.getHeight() / loading_screens[cur_level]:getHeight())
	end

	if show_end then
		love.graphics.draw(end_screen, 0, 0, 0, love.graphics.getWidth() / end_screen:getWidth(), love.graphics.getHeight() / end_screen:getHeight())
	end

	if fading then
		love.graphics.setColor(33, 33, 33, self.fade_params.opacity)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
	end




end

function level:keypressed(key, unicode)
	local wave

	if not gameover then

		if key == "w" or key == "up" then
			-- Y = 14
			wave = "Y"
			hero:saluteY()
			colourPressed = "yellow"
		end
		if key == "a" or key == "left" then
			-- X = 13
			wave = "X"
			hero:saluteX()
			colourPressed = "blue"
		end
		if key == "d" or key == "right" then
			-- B = 12
			wave = "B"
			hero:saluteB()
			colourPressed = "red"
		end
		if key == "s" or key == "down" then
			-- A = 11
			wave = "A"
			hero:saluteA()
			colourPressed = "green"
		end

		if key == "p" then
			particle:spawn("pass", 128, 80)
		end

		if wave then level:checkWave(wave) end

	else
		if not gameover_locked then
			level:reInit()
		end
	end
end

function level:checkWave(wave)
	-- NOTE: we still need to account for a guard not being waved at... this is also a failure but should be tracked elsewhere... (in guard maybe?)
	if level:checkArea() then
		if wave == focusedGuard.expectedWave then
			--flip this guards wavedAt to true.
			focusedGuard:successWave()
			focusedGuard.isWavedAt = true
			waveCorrect = true
			particle:spawn("pass", focusedGuard.x + 6, focusedGuard.speed)
		else
			if focusedGuard.isWavedAt == false then
				focusedGuard:failWave()
				focusedGuard.isWavedAt = true
				waveCorrect = false
				particle:spawn("fail", focusedGuard.x + 6, focusedGuard.speed)
				hero:eatLife()
			end
		end
	else
		--no guard in area, NOM LYF
		waveCorrect = false
		--hero:eatLife()
	end
	indicator = true
end

-- checks the detection area for a guard, returns true / false
function level:checkArea()
	for i=1,table.getn(guards.current_guards) do
		if guards.current_guards[i]["x"] > 42 and guards.current_guards[i]["x"] < 95 then
			focusedGuard = guards.current_guards[i]
			return true
		end
	end
	return false
end

function level:joystickreleased(joystick, button)
	indicator = false
	colourPressed = none
end

function level:keyreleased(key)
	indicator = false
	colourPressed = none
end


function level:joystickpressed(joystick, button)
	local wave

	if not gameover then

		if button == 1 then
			wave = "A"
			colourPressed = "green"
		elseif button == 2 then
			wave = "B"
			colourPressed = "red"
		elseif button == 3 then
			wave = "X"
			colourPressed = "blue"
		elseif button == 4 then
			wave = "Y"
			colourPressed = "yellow"
		end
		
		if joystick:isGamepadDown("y") then
			wave = "Y"
			colourPressed = "yellow"
		end
		if joystick:isGamepadDown("x") then
			wave = "X"
			colourPressed = "blue"
		end
		if joystick:isGamepadDown("b") then
			wave = "B"
			colourPressed = "red"
		end
		if joystick:isGamepadDown("a") then
			wave = "A"
			colourPressed = "green"
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

	else
		if not gameover_locked then
			level:reInit()
		end
	end
end

function level:spawner()
	local roll = math.random(0,100)
	if gameover then
		spawn = false
	end

	if spawn and roll > 0 and roll < levels[cur_level]["spawnChance"] then
		guard = math.random(1,table.getn(levels[cur_level]["guard_types"]))
		guards:newGuard(guard, levels[cur_level]["enemySpeed"])
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
	particle:spawn("lose", hero.x + 6, 0)
	particle:pause()
	level:stopNearestGuard()
	levels[cur_level]["level_speed"] = 0

	love.audio.play(gameover_sound)
	hero.x = 58
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
			hero:stopHero()
			nearest:stopGuard()
		end
	end
	--printTable(nearest)
end

--checks if guard is nearby to show indicator.
function level:isGuardInRange()
	for i=1,table.getn(guards.current_guards) do
		if guards.current_guards[i]["x"] > 45 and guards.current_guards[i]["x"] < 150 then
			return true
		end
	end
	return false
end


return level