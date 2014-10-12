local tween = require "lib.tween"

local loadscreen = {}

loading_screens = love.graphics.newImage('assets/images/loading_screen_dummy.png')

-- local test_red = love.graphics.newImage('assets/images/colourRed.png')

local arrow_image = love.graphics.newImage("assets/images/levelarrow.png")

local offset = {
	--{x = 730, y = 109} for level 1, not needed
	{x = 767, y = 148},
	{x = 753, y = 169},
	{x = 734, y = 199},
	{x = 714, y = 230},
	{x = 698, y = 260},
	{x = 679, y = 288},
	{x = 662, y = 318},
	{x = 636, y = 349},
	{x = 624, y = 378},
	{x = 800, y = 400}
}

local bounceoffset = {x = -50}
local bouncey = tween.new(1, bounceoffset, {x = -10}, "outCirc")

function loadscreen:draw(cur_level)
	love.graphics.draw(loading_screens, 0, 0, 0, love.graphics.getWidth() / loading_screens:getWidth(), love.graphics.getHeight() / loading_screens:getHeight())

	local complete = bouncey:update(0.01)
	if complete == true then
		bouncey:reset()
	end
	local arrow_x = offset[cur_level].x - arrow_image:getWidth() + bounceoffset.x
	local arrow_y = offset[cur_level].y - arrow_image:getHeight() / 2
	love.graphics.draw(arrow_image, arrow_x, arrow_y, 0, love.graphics.getWidth() / loading_screens:getWidth(), love.graphics.getHeight() / loading_screens:getHeight())
	--debugging the arrow locations
	--[[ for _,off in ipairs(offset) do
		love.graphics.draw(test_red, off.x, off.y, 0, love.graphics.getWidth() / loading_screens:getWidth(), love.graphics.getHeight() / loading_screens:getHeight())
	end ]]-- 
end

return loadscreen