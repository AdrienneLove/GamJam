local tween = require "lib.tween"

local loadscreen = {}

loading_screens = love.graphics.newImage('assets/images/loading_screen_dummy.png')

local arrow_image = love.graphics.newImage("assets/images/levelarrow.png")

local initial = {x = 533, y = 137}
local offset = {x = -16, y = 40}
local arrow_x = 0
local arrow_y = 0

local bounceoffset = {x = 0}
local bouncey = tween.new(1, bounceoffset, {x = 50}, "outCirc")

function loadscreen:draw(cur_level)
	love.graphics.draw(loading_screens, 0, 0, 0, love.graphics.getWidth() / loading_screens:getWidth(), love.graphics.getHeight() / loading_screens:getHeight())

	local complete = bouncey:update(0.01)
	if complete == true then
		bouncey:reset()
	end
	arrow_x = initial.x + offset.x * cur_level + bounceoffset.x
	arrow_y = initial.y + offset.y * cur_level
	love.graphics.draw(arrow_image, arrow_x, arrow_y, 0, love.graphics.getWidth() / loading_screens:getWidth(), love.graphics.getHeight() / loading_screens:getHeight())
end

return loadscreen