Gamestate = require "lib.hump.gamestate"
-- an animation extends anim8, see https://github.com/kikito/anim8
anim8 = require 'lib.anim8'

math.randomseed(os.time())

function love.load()
	local splash = require "states.splash"
	Gamestate.switch(splash)
	Gamestate.registerEvents()
end

-- Deep clean to set all values on each level to nil.
function purge(_table)
	for k,v in pairs(_table) do
		if type(v) == table then
			purge(v)
		else
			_table[k] = nil
		end
	end

	for i,v in pairs(_table) do
		if type(v) == table then
			purge(v)
		else
			_table[i] = nil
		end
	end
end