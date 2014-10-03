Gamestate = require "lib.hump.gamestate"

function love.load()
	local splash = require "states.splash"
	Gamestate.switch(splash)
	Gamestate.registerEvents()
end



