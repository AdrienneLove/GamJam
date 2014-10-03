local level = {}

local Timer = require "lib.hump.timer"

--level vars
local level_speed = 140
local backgrounds_left = 4
local foregrounds_left = backgrounds_left
local status = "intro" -- other states are play, dead, outro and exit

--background stuff
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


function level:enter(state)

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

   		if key == 1 then
   			value.image = love.graphics.newImage(background_imagedata_1)
   			value.current = true
   		else 
   			value.image = background_panel_images[math.random(0, table.getn(background_panel_images))]
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
	entry_door.image = love.graphics.newImage('assets/images/door1.png')
	entry_door.x = 56
	entry_door.y = 34

	exit_door.image = love.graphics.newImage('assets/images/door2.png')
	exit_door.x = 100
	exit_door.y = 34

	-- set timer to go from intro to play
	Timer.add(1, function() status = "play" end)


end

function level:leave()
	
end

function level:update(dt)
	--update all timers
	Timer.update(dt)

	if status == "play" or status == "outro" then

		--move entry door 
		if entry_door.alive then
			entry_door.x = entry_door.x - level_speed * dt;
			if entry_door.x <= -200 then
				entry_door.alive = false
				entry_door.image = nil
			end
		end

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
			status = "outro"
			
			--search furthest background and put a door there
			for furthest_key, furthest_value in pairs(foreground_panels) do 
				if furthest_value.furthest then 
					exit_door.x = furthest_value.x + exit_door.x
					exit_door.alive = true
					exit_door.distance = exit_door.x
					break
				end
			end
		end

		if status == "outro" then
			if exit_door.distance > 100 then 
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
	
	love.graphics.pop()
end

function level:keypressed(key, unicode)
	-- navigate menu
	if key == "q" then
		love.event.push("quit")
	end

end

return level