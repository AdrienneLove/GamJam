local tween = require "lib.tween"

local loadscreen = {}

local loading_screens = {
		love.graphics.newImage('assets/images/level2.png'),
		love.graphics.newImage('assets/images/level3.png'),
		love.graphics.newImage('assets/images/level4.png'),
		love.graphics.newImage('assets/images/level5.png')
	}

local arrow_image = love.graphics.newImage("assets/images/colourGreen.png")

local initial = {x = 533, y = 137}
local offset = {x = -16, y = 40}
local arrow_x = 0
local arrow_y = 0

local bounceoffset = {x = 0}
local bouncey = tween.new(1, bounceoffset, {x = 50}, "outCirc")

function loadscreen:draw(cur_level)
	loadback = loading_screens[cur_level]
	love.graphics.draw(loadback, 0, 0, 0, love.graphics.getWidth() / loadback:getWidth(), love.graphics.getHeight() / loadback:getHeight())

	local complete = bouncey:update(0.01)
	if complete == true then
		bouncey:reset()
	end
	arrow_x = initial.x + offset.x * cur_level + bounceoffset.x
	arrow_y = initial.y + offset.y * cur_level
	love.graphics.draw(arrow_image, arrow_x, arrow_y, 0, love.graphics.getWidth() / loadback:getWidth(), love.graphics.getHeight() / loadback:getHeight())
end

return loadscreen