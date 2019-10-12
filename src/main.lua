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

	if _table == nil then
		return
	end

	for k,v in pairs(_table) do
		if type(v) == table then
			purge(v)
		else
			_table[k] = nil
		end
	end

	for i,v in ipairs(_table) do
		if type(v) == table then
			purge(v)
		else
			_table[i] = nil
		end
	end
end

fever = {
	enabled = false,
	opacity = 0,
	fading = false,
	fade_time = .12,
	colours = {
		{r=0,g=0,b=255},
		{r=0,g=255,b=0},
		{r=255,g=0,b=0},
		{r=255,g=255,b=0} -- yellow
	},
}

fever.current  = fever.colours[math.random(1,4)]

function fever:update(timer)
	if self.enabled then
		if self.fading == false then
			timer.tween(self.fade_time, self, {opacity = 80}, 'in-out-sine',
			            function()
			            	timer.tween(self.fade_time, self, {opacity = 0}, 'in-out-sine',
			            	            function()
			            	            	self.fading = false
			            	            	self.current = self.colours[math.random(1,4)]
			            	            	end)
			            	end)
			self.fading = true
		end
	end
end
