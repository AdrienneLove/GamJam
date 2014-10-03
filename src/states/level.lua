local level = {}

local background_panels
local background_panel_1
local current_panel

local level_speed = 100

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
	background_imagedata_1 = love.image.newImageData('assets/images/224x126.gif')

	--create as many image items as needed
	background_panels = { 
		love.graphics.newImage(background_imagedata_1),
		love.graphics.newImage(background_imagedata_1),
		love.graphics.newImage(background_imagedata_1),
		love.graphics.newImage(background_imagedata_1)
	}

	for key,value in pairs(panels) do 
		
		value.x = background_imagedata_1:getWidth() * (key-1)
		print(value.x)
   		value.image = background_panels[1]

   		if key == 1 then
   			value.current = true
   		else 
   			value.current = false
   		end

	end

	--todo grab a random panel instead of 1, 2 & 3


end

function level:leave()
	
end

function level:update(dt)
	-- move panels
	panels[1].x = panels[1].x - level_speed * dt
	panels[2].x = panels[2].x - level_speed * dt
	panels[3].x = panels[3].x - level_speed * dt

	-- check for panel out of range and slap another on the end!
	for key, value in pairs(panels) do 
		if value.x <  background_imagedata_1:getWidth()*-1 then

			-- set item values and assign a new random image
			value.image = background_panels[4]
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

function level:draw()
	love.graphics.push()
	love.graphics.scale( SCALE )

	--draw panels 1, 2 and 3
	love.graphics.draw(panels[1].image, panels[1].x, 0)
	love.graphics.draw(panels[1].image, panels[2].x, 0)
	love.graphics.draw(panels[1].image, panels[3].x, 0)
	
	love.graphics.pop()
end

function level:keypressed(key, unicode)
	-- navigate menu
	if key == "q" then
		love.event.push("quit")
	end

end

return level