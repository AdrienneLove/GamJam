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
local panels = {
	{ x = 0, image = nil, current = false, furthest = false},
	{ x = 0, image = nil, current = false, furthest = false},
	{ x = 0, image = nil, current = false, furthest = true}
}


function level:enter(state)

	love.graphics.setDefaultFilter('nearest')
	--panel iterates at half screen
	current_panel = 1

	--load in background panel data
	background_imagedata_start = love.image.newImageData('assets/images/start.gif')
	background_imagedata_1 = love.image.newImageData('assets/images/224x126.gif')
	background_imagedata_end = love.image.newImageData('assets/images/end.gif')

	--create as many image items as needed
	background_panels = { 
		love.graphics.newImage(background_imagedata_1),
		love.graphics.newImage(background_imagedata_1),
		love.graphics.newImage(background_imagedata_1),
		love.graphics.newImage(background_imagedata_1)
	}

	--build initial panels
	for key,value in pairs(panels) do 
		
		value.x = background_imagedata_1:getWidth() * (key-1)

   		if key == 1 then
   			value.image = love.graphics.newImage(background_imagedata_start)
   			value.current = true
   		else 
   			value.image = background_panels[math.random(table.getn(background_panels))]
   			value.current = false
   		end

	end

	-- set timer to go from intro to play
	Timer.add(1, function() status = "play" end)


end

function level:leave()
	
end

function level:update(dt)
	--update all timers
	Timer.update(dt)

	if status == "play" then
		-- check for panel out of range and slap another on the end!
		for key, value in pairs(panels) do 
			-- move panels
			value.x = value.x - level_speed * dt

			if value.x <  background_imagedata_1:getWidth()*-1 then

				-- set item values and assign a new random image
				value.image = background_panels[math.random(table.getn(background_panels))]
				value.x = background_imagedata_1:getWidth()*2
				value.current = false

				-- set current panel
				if key+1 > table.getn(panels) then
					panels[1].current = true
				else 
					panels[key+1].current = false
				end

				--search furthest and replace it, set this x to new furthest location
				for furthest_ket, furthest_value in pairs(panels) do 
					if furthest_value.furthest then 
						value.x = furthest_value.x + furthest_value.image:getWidth()
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

	--draw panels 1, 2 and 3
	for key, value in pairs(panels) do 
		love.graphics.draw(value.image, value.x, 0)
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