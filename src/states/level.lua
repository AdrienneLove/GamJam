local level = {}

local Timer = require "lib.hump.timer"

hero = require "assets.chars.hero"

--level vars

local levels = {
	require 'states.levels.level_one',
	require 'states.levels.level_two',
	require 'states.levels.level_three',
	require 'states.levels.level_four',
	require 'states.levels.level_five',
	require 'states.levels.level_six',
	require 'states.levels.level_seven',
	require 'states.levels.level_eight',
	require 'states.levels.level_nine',
	require 'states.levels.level_ten'
}

local cur_level -- set in level:reInit()

-- player / enemy stuff
local guards = require "assets.chars.guard"
local particle = require "assets.particles"
local focusedGuard --this is being used by the wave checking
local spawn = false -- when true, chance for a spawn is triggered.
local spawn_dt = 0.0


-- ui stuff
local buttonfont = love.graphics.newFont('assets/fonts/munro.ttf', 32)
local hintfont = love.graphics.newFont('assets/fonts/arcadeclassic.TTF', 10)

--for ending
local gameover_font = love.graphics.newFont('assets/fonts/arcadeclassic.TTF', 20)
local tute_font = love.graphics.newFont( "assets/fonts/munro.ttf", 14)

hintfont:setFilter("nearest", "nearest", 1)
buttonfont:setFilter("nearest", "nearest", 1)
tute_font:setFilter("nearest", "nearest", 1)
gameover_font:setFilter("nearest", "nearest", 1)

local loadscreen = require "states.loadscreen"

local gameover = false
local gameoverY = 40 --inital position of gameover text
local gameover_locked = true
local gameover_sound = love.audio.newSource("assets/audio/error_style_1_echo_001.ogg", "static")
local indicator = false
local waveCorrect = false
--local cube = love.graphics.newImage('assets/animations/splash_cube.png')
local colourPressed = "none"
local swishfont = love.graphics.newFont('assets/fonts/arcadeclassic.TTF', 40)

local props = require "assets.propfactory"

local fading = true
local show_loading = false
local show_end = false
local game_music
local bgm_params 

function level:enter(state)

	love.graphics.setDefaultFilter('nearest')
	swishfont:setFilter("nearest", "nearest", 1)
	hintfont:setFilter("nearest", "nearest", 1)
	buttonfont:setFilter("nearest", "nearest", 1)

	--load in panel data for foreground and background
	background_imagedata_start = love.image.newImageData('assets/images/start.gif')
	background_imagedata_1 = love.image.newImageData('assets/images/wall2.png')
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

	--images for ellipse trigger area
	ellipse_img = love.graphics.newImage('assets/images/ellipse.png')
	ellipse_front = love.graphics.newImage('assets/images/ellipse_effect_front.png')
	ellipse_back = love.graphics.newImage('assets/images/ellipse_effect_back.png')

	--images needed for ui button display
	green = love.graphics.newImage('assets/images/colourGreen.png')
	blue = love.graphics.newImage('assets/images/colourBlue.png')
	yellow = love.graphics.newImage('assets/images/colourYellow.png')
	red = love.graphics.newImage('assets/images/colourRed.png')

	end_screen = love.graphics.newImage('assets/images/end_screen.png')

	cur_level = 1
	level:reInit()

	-- play music
	game_music = love.audio.newSource( "assets/audio/cephelopod.ogg", "stream" )
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
		require 'states.levels.level_five',
		require 'states.levels.level_six',
		require 'states.levels.level_seven',
		require 'states.levels.level_eight',
		require 'states.levels.level_nine',
		require 'states.levels.level_ten'
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

	gameover = false
	show_end = false

	hero:init()

	-- Make sure we have a fresh set of guards.
	purge(guards.current_guards)

	particle:purge()
	particle:start()

	-- fade in / out 
	-- fading = true
	self.fade_params = { opacity = 255, opacity_door = 0 }
	self.bgm_params = { volume = 0.5 }
	Timer.tween(0.25, self.fade_params, { opacity = 0, opacity_door = 255 }, 'in-out-sine')
	Timer.tween(0.5, self.bgm_params, { volume = 0.5 })

	props:populate(levels[cur_level]["panels_left"])

end

function level:leave(dt)
	-- Switching out ungracefully hurts the ears.
	game_music:setVolume(0.0)
end

function level:update(dt)
	--update all timers
	Timer.update(dt)
	fever:update(Timer)
	
	game_music:setVolume(self.bgm_params.volume)

	if levels[cur_level]["pre_intro"] == false then

			Timer.tween(0.50, self.fade_params, { opacity = 0 }, 'in-out-sine',
			            function () fading = false
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

	if gameover then
		return
	end

	-- Don't spawn at end or during intro of level.
	if levels[cur_level]["backgrounds_left"] > 0 and levels[cur_level]["status"] ~= "intro" then
		level:spawner(dt)
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
			gameover = true
			level:gameover()
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
	if cur_level == 10 then
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
			Timer.add(2, function()
				Timer.tween(0.25, self.bgm_params, { volume = 0.5 }, 'in-out-sine')
				Timer.tween(0.5, self.fade_params, { opacity = 255 }, 'in-out-sine', function () 
					show_loading = false
					cur_level = cur_level + 1
					hero:newLevel()
					props:populate(levels[cur_level]["panels_left"])
					fading = false
				end)
				
			end)
		end)
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

	if levels[cur_level]["exit_door"]["alive"] then
		love.graphics.draw(levels[cur_level]["exit_door"]["image"], levels[cur_level]["exit_door"]["x"], levels[cur_level]["exit_door"]["y"])
	end

	--static props
	props:draw()

	if fever.enabled then
		love.graphics.setColor(10, 10, 10, 150)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		love.graphics.setColor(255,255,255,255)
	end

	--draw particles
	particle:draw()

	-- wave detect / indicator for the zone that enemies can receive waves in
	-- LEAVING THIS IN as it will kind of become the light effect

	-- if levels[cur_level]["status"] ~= "exit" and levels[cur_level]["status"] ~= "intro" then
	-- 	--love.graphics.ellipse("fill", 75, 103, 20, 4, math.rad(0), 30)
	-- 	love.graphics.setColor(255, 255, 255, 120)
	-- 	love.graphics.draw(ellipse_img, 75, 103)
	-- end
	local colour = {
		r = 255,
		g = 255,
		b = 255
	}
	if colourPressed == "blue" then
		colour.r = 135
		colour.g = 199
		colour.b = 255
		love.graphics.setColor(colour.r, colour.g, colour.b, 155)
		if guardsInArea > 0 then
			love.graphics.draw(ellipse_back, 51, 94)
		end
	elseif colourPressed == "yellow" then
		colour.r = 247
		colour.g = 227
		colour.b = 114
		love.graphics.setColor(colour.r, colour.g, colour.b, 155)
		if guardsInArea > 0 then
			love.graphics.draw(ellipse_back, 51, 94)
		end
	elseif colourPressed == "red" then
		colour.r = 250
		colour.g = 156
		colour.b = 137
		love.graphics.setColor(colour.r, colour.g, colour.b, 155)
		if guardsInArea > 0 then
			love.graphics.draw(ellipse_back, 51, 94)
		end
	elseif colourPressed == "green" then
		colour.r = 112
		colour.g = 232
		colour.b = 111
		love.graphics.setColor(colour.r, colour.g, colour.b, 155)
		if guardsInArea > 0 then
			love.graphics.draw(ellipse_back, 51, 94)
		end
	end
	guardsInArea = table.getn(level:checkArea())
	if levels[cur_level]["status"] ~= "exit" and levels[cur_level]["status"] ~= "intro" then
		--love.graphics.ellipse("fill", 75, 103, 20, 4, math.rad(0), 30)
		--love.graphics.setColor(255, 255, 255, 120)
		love.graphics.setColor(colour.r, colour.g, colour.b, 140)
		love.graphics.draw(ellipse_img, 51, 94)
	end

	--draw enemies
	guards:draw()

	if colourPressed == "blue" then
		love.graphics.setColor(colour.r, colour.g, colour.b, 160)
		if guardsInArea > 0 then
			love.graphics.draw(ellipse_front, 51, 94)
		end
	elseif colourPressed == "yellow" then
		love.graphics.setColor(colour.r, colour.g, colour.b, 160)
		if guardsInArea > 0 then
			love.graphics.draw(ellipse_front, 51, 94)
		end
	elseif colourPressed == "red" then
		love.graphics.setColor(colour.r, colour.g, colour.b, 160)
		if guardsInArea > 0 then
			love.graphics.draw(ellipse_front, 51, 94)
		end
	elseif colourPressed == "green" then
		love.graphics.setColor(colour.r, colour.g, colour.b, 160)
		if guardsInArea > 0 then
			love.graphics.draw(ellipse_front, 51, 94)
		end
	end
	love.graphics.setColor(255, 255, 255, 255)

	--draw hero
	hero:draw(dt)

	--draw entry door on 
	if levels[cur_level]["entry_door"]["alive"] then
		love.graphics.draw(levels[cur_level]["entry_door"]["image"], levels[cur_level]["entry_door"]["x"], levels[cur_level]["entry_door"]["y"])
	end

	if levels[cur_level]["entry_door"]["alive"] then
		love.graphics.draw(levels[cur_level]["entry_door"]["image"], levels[cur_level]["entry_door"]["x"], levels[cur_level]["entry_door"]["y"])
	end

	-- UI buttons	
	love.graphics.setFont(buttonfont)
	if not next(love.joystick.getJoysticks()) then
		--keyboard layout
		love.graphics.setColor(90, 90, 90, 255)
		if colourPressed == "blue" then
			love.graphics.setColor(255, 255, 255, 255)
		end
		love.graphics.draw(blue, 8, 116)

		love.graphics.setColor(90, 90, 90, 255)
		if colourPressed == "yellow" then
			love.graphics.setColor(255, 255, 255, 255)
		end
		love.graphics.draw(yellow, 17, 107)

		love.graphics.setColor(90, 90, 90, 255)
		if colourPressed == "green" then
			love.graphics.setColor(255, 255, 255, 255)
		end
		love.graphics.draw(green, 17, 116)

		love.graphics.setColor(90, 90, 90, 255)
		if colourPressed == "red" then
			love.graphics.setColor(255, 255, 255, 255)
		end
		love.graphics.draw(red, 26, 116)
		love.graphics.setColor(255, 255, 255, 255)

		love.graphics.scale(0.2)
		love.graphics.printf("A",  	8*SCALE, 	116*SCALE,	8*SCALE, "center")
		love.graphics.printf("W",	17*SCALE, 	107*SCALE,	8*SCALE, "center")
		love.graphics.printf("S", 	17*SCALE, 	116*SCALE,	8*SCALE, "center")
		love.graphics.printf("D", 	26*SCALE, 	116*SCALE,	8*SCALE,"center")
		love.graphics.scale(SCALE)


	else
		-- gamepad layout
		love.graphics.setColor(90, 90, 90, 255)
		if colourPressed == "blue" then
			love.graphics.setColor(255, 255, 255, 255)
		end
		love.graphics.draw(blue, 9, 110)

		love.graphics.setColor(90, 90, 90, 255)
		if colourPressed == "yellow" then
			love.graphics.setColor(255, 255, 255, 255)
		end
		love.graphics.draw(yellow, 15, 104)


		love.graphics.setColor(90, 90, 90, 255)
		if colourPressed == "green" then
			love.graphics.setColor(255, 255, 255, 255)
		end
		love.graphics.draw(green, 15, 116)

		love.graphics.setColor(90, 90, 90, 255)
		if colourPressed == "red" then
			love.graphics.setColor(255, 255, 255, 255)
		end
		love.graphics.draw(red, 21, 110)
		love.graphics.setColor(255, 255, 255, 255)

		love.graphics.scale(0.2)
		love.graphics.printf("X",  	9*SCALE, 	110*SCALE,	8*SCALE, "center")
		love.graphics.printf("Y",	15*SCALE, 	104*SCALE,	8*SCALE, "center")
		love.graphics.printf("A", 	15*SCALE, 	116*SCALE,	8*SCALE, "center")
		love.graphics.printf("B", 	21*SCALE, 	110*SCALE,	8*SCALE,"center")
		love.graphics.scale(SCALE)
	end

	love.graphics.setColor(255,255,255,255)

	-- draw life count
	for i=1,hero.lives do
		love.graphics.draw(hero.life, 15*i, 10)
	end

	-- gameover text / fade
	if gameover then
		love.graphics.setColor(33, 33, 33, 80)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		--draw text
		love.graphics.setColor(0, 0, 0, 150)
		love.graphics.setFont(gameover_font)
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

	love.graphics.setColor(255,255,255,255)
	love.graphics.setFont(swishfont, 20)
	love.graphics.printf("Level "..cur_level, 5, 5, love.graphics.getWidth()-20, "right" )

	
	if fever.enabled then
		love.graphics.setColor(fever.current.r,fever.current.g,fever.current.b,fever.opacity)
		love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
		love.graphics.setColor(255,255,255,255)
	end

	if show_loading then
		loadscreen:draw(cur_level)
	end

	if show_end then
		love.graphics.draw(end_screen, 0, 0, 0, love.graphics.getWidth() / end_screen:getWidth(), love.graphics.getHeight() / end_screen:getHeight())
		love.graphics.setFont(swishfont, 90)
		love.graphics.printf('You escaped!', 550, 128, love.graphics.getWidth() / 4, "center", 0, 2)
		love.graphics.setFont(tute_font, 14)
		love.graphics.printf('Press BACK on the credits screen', 550, 234, love.graphics.getWidth() / 4, "center", 0, 2)
		love.graphics.printf('to unlock a new mode!', 550, 256, love.graphics.getWidth() / 4, "center", 0, 2)

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

		if wave then level:checkWave(wave) end

	else
		if not gameover_locked then
			level:reInit()
		end
	end
end

function level:checkWave(wave)

	local temp_guards = level:checkArea()
	waveCorrect = false

	-- Look for a successful wave, if we find one do stuff and break.
	for _,guard in ipairs(temp_guards) do
		if wave == guard.expectedWave and guard.isWavedAt == false then
			guard:successWave()
			particle:spawn("pass", guard.x + 6, guard.speed)
			waveCorrect = true
			break
		end
	end

	-- If no guard is correct, find the first guard that hasn't already
	-- been waved at and make them the failed wave guard.
	if waveCorrect == false then
		for _,guard in ipairs(temp_guards) do
			if guard.isWavedAt == false then
				guard:failWave()
				particle:spawn("fail", guard.x + 6, guard.speed)
				hero:eatLife()
				break
			end
		end
	end

	indicator = true
end

-- Search current_guards and return all guards that are inside wave area.
function level:checkArea()
	local temp_guards = {}

	for i,guard in ipairs(guards.current_guards) do
		if guards.current_guards[i]["x"] > 42 and guards.current_guards[i]["x"] < 95 then
			table.insert(temp_guards, guard)
		end
	end

	return temp_guards
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

function level:spawner(dt)
	spawn_dt = spawn_dt + dt
	local spawn = false
	local roll = math.random(1,100)

	-- Use own dt to compare against level spawn frequency.
	if spawn_dt > levels[cur_level]["spawnDelay"] and not gameover then
		spawn_dt =  spawn_dt - levels[cur_level]["spawnDelay"]
		spawn = true
	end

	if spawn and roll < levels[cur_level]["spawnChance"] then
		guard = math.random(table.getn(levels[cur_level]["guard_types"]))
		guards:newGuard(guard, levels[cur_level]["enemySpeed"])
	end
end

function level:gameover()
	spawnChance = 0
	spawn = false
	particle:spawn("lose", hero.x + 6, 0)
	particle:pause()
	level:stopNearestGuard()
	levels[cur_level]["level_speed"] = 0

	love.audio.play(gameover_sound)
	guards.current_guards[1].x = 58
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