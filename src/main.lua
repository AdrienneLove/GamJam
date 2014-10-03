Gamestate = require "lib.hump.gamestate"
-- an animation extends anim8, see https://github.com/kikito/anim8
anim8 = require 'lib.anim8'

function love.load()
	local splash = require "states.splash"
	Gamestate.switch(splash)
	Gamestate.registerEvents()
end


