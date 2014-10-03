local level = {}

local Timer = require "lib.hump.timer"

--background stuff
local background_panels
local background_panel_1
local current_panel

--level vars
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

-- player / enemy stuff
hero = require "assets.chars.hero"
local cube = love.graphics.newImage('assets/animations/splash_cube.png')
local gameover = false
local guards = require "assets.chars.guard"
local swishfont = love.graphics.newFont('assets/fonts/LovedbytheKing.ttf', 30) 

function level:enter(state)

	love.graphics.setDefaultFilter('nearest')
	--panel iterates at half screen
	current_panel = 1

	--load in panel data for foreground and background
	background_imagedata_start = love.image.newImageData('assets/images/start.gif')
	background_imagedata_1 = love.image.newImageData('assets/images/wall1sketch.png')
	foreground_imagedata_1 = love.image.newImageData('assets/images/floor1sketch.png')
	background_imagedata_end = love.image.newImageData('assets/images/end.gif')

	--create as many image items as needed for background then foreground
	background_panel_images = { 
		love.graphics.newImage(background_imagedata_1),
		love.graphics.newImage(background_imagedata_1),
		love.graphics.newImage(background_imagedata_1),
		love.graphics.newImage(background_imagedata_1)
	}

	foreground_panel_images = {
		love.graphics.newImage(foreground_imagedata_1),
		love.graphics.newImage(foreground_imagedata_1),
		love.graphics.newImage(foreground_imagedata_1),
		love.graphics.newImage(foreground_imagedata_1)
	}

	--build initial background panels
	for key,value in pairs(background_panels) do 
		value.x = background_imagedata_1:getWidth() * (key-1)

   		if key == 1 then
   			value.image = love.graphics.newImage(background_imagedata_start)
   			value.current = true
   		else 
   			value.image = background_panel_images[math.random(table.getn(background_panel_images))]
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

	-- set timer to go from intro to play
	Timer.add(1, function() status = "play" end)

	-- enemy spawn (testers)
	guards:newGuard(2)
	guards:newGuard(1)
	guards:newGuard(3)
	guards:newGuard(4)
end

function level:leave()
	
end

function level:update(dt)
	--update all timers
	Timer.update(dt)

	--update player/enemys
	guards:update(dt)
	hero:update(dt)

	if status == "play" then

		-- move background panels
		for key, value in pairs(background_panels) do 
			-- move panels
			value.x = value.x - level_speed * dt

			if value.x <  background_imagedata_1:getWidth()*-1 then

				-- set item values and assign a new random image
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
				for furthest_ket, furthest_value in pairs(background_panels) do 
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
			end
		end

		-- move foreground panels
		for key, value in pairs(foreground_panels) do 
			-- move panels
			value.x = value.x - level_speed * dt

			if value.x <  foreground_imagedata_1:getWidth()*-1 then

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
				for furthest_ket, furthest_value in pairs(foreground_panels) do 
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

function level:joystickpressed(joystick, button)
	hero:eatLife()
	--print(hero.lives)
	print(button)
	if button == 4 then
		-- Y = 14
		print("Y")
		hero:saluteY()
	end
	if button == 3 then
		-- X = 13
		hero:saluteX()
	end
	if button == 2 then
		-- B = 12
		hero:saluteB()
	end
	if button == 1 then
		-- A = 11
		hero:saluteA()
	end 

end

return level