Gamestate = require "lib.hump.gamestate"

function love.load()
	--local title = require "states.title"
	--Gamestate.switch(title)
	local splash = require "states.splash"
	Gamestate.switch(splash)
	Gamestate.registerEvents()
end