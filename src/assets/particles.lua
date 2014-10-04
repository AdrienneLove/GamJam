
local tween = require 'lib.tween'

local particle = {}

local particles = {}
local particle_types = {
	pass = {image = love.graphics.newImage('assets/images/BubbleStar.png')},
	fail = {image = love.graphics.newImage('assets/images/BubbleX.png')},
	lose = {image = love.graphics.newImage('assets/images/BubbleExclamation.png')}
}

particle.allow_particles = true
particle.particles = particles
particle.particle_types = particle_types

function particle:spawn(type, _x, _speed)

	if self.allow_particles == false then
		return
	end
	
	temp = {}
	temp.x = _x
	temp.y = 88
	temp.speed = _speed

	if type == "pass" then
		temp.image = self.particle_types["pass"].image
	elseif type == "fail" then
		temp.image = self.particle_types["fail"].image
	elseif type == "lose" then
		temp.image = self.particle_types["lose"].image
	else
		print("Unrecognized particle type")
		return
	end

	temp.image:setFilter('nearest','nearest')

	temp.tween = tween.new(1, temp, {y = 0}, "outInElastic")

	table.insert(self.particles, temp)
end

function particle:update(dt)
	for i, v in ipairs(self.particles) do
		complete = v.tween:update(dt)

		v.x = v.x - v.speed * dt

		if (complete == true) then
			table.remove(self.particles, i)
		end
	end
end

function particle:draw()
	love.graphics.setColor(255, 255, 255, 255)
	for i, v in ipairs(self.particles) do
		if v.y < 72 then
			love.graphics.draw(v.image, v.x, v.y)
		end
	end
end

function particle:pause()
	self.allow_particles = false
	for i, v in ipairs(self.particles) do
			v.speed = 0
	end
end

function particle:purge()
	for i, v in ipairs(self.particles) do
		table.remove(self.particles, i)
	end
	self.particles = {}
end

function particle:start()
	self.allow_particles = true
end

return particle