Gamestate = require "lib.hump.gamestate"

function love.load()
	local title = require "states.title"
	Gamestate.switch(title)
	Gamestate.registerEvents()
end