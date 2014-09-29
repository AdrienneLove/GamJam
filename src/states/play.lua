local play = {}

-- Animation example using anim8 instead of AnAL as it looks better documented and more coherent https://github.com/kikito/anim8
local anim8 = require 'lib.anim8'

local rimon_walk_spritemap, animation

function play:enter(state)
	rimon_walk_spritemap = love.graphics.newImage('assets/images/rimon_walk.png')
	local g = anim8.newGrid(78, 114, rimon_walk_spritemap:getWidth(), rimon_walk_spritemap:getHeight())
	animation = anim8.newAnimation(g('1-8',1), 0.1)
end

function play:leave()
	
end

function play:update(dt)
	animation:update(dt)
end

function play:draw()
	-- push graphics stack
	love.graphics.push()

	--set background
	love.graphics.setBackgroundColor(33, 33, 33, 255)

	--draw test anim
	love.graphics.setColor(255, 255, 255, 255)
	animation:draw(rimon_walk_spritemap, love.graphics.getWidth()/2-39, love.graphics.getHeight()/2-300)

	--draw text
	love.graphics.setColor(255, 156, 255, 255)
	love.graphics.setNewFont(30)
	love.graphics.printf("I know they make you fur-ious but my cat puns are su-purr-ior.", love.graphics.getWidth()/2-250, love.graphics.getHeight()/2-25, 500, 'center')

	--pop graphics stack
	love.graphics.pop()

end

function play:keypressed(key, unicode)

end

return play