-- Various utilities of our own making.


-- Table printing functions
-- Useful for development and debugging, prints to console.
--
-- usage example: 
-- table = { thing = "butts", image = love.graphics.newImage("file.png") }
-- printTable(table)
--
-- CONSOLE PRINTOUT:
-- [thing = butts, image = DATATYPE WOOPSIE]

function printTable(t)
	s = tableString(t)
	return print(s)
end

function tableString(t)
	result = "["
	len = tableLength(t)
	for key,value in pairs(t) do
		result = result .. key .. " = "
		if type(value) == "table" then
			--it is a table, so fetch the values
			--if the value is at the last index
			result = result .. tableString(value)
			if valIndex(t, value) ~= len then
				result = result .. ", "
			end
		elseif type(value) == "userdata" then
			result = result .. "DATATYPE image"
			if valIndex(t, value) ~= len then
				result = result .. ", "
			end
		elseif type(value) == "boolean" then
			if value then
				result = result .. "true"
			else
				result = result .. "false"
			end
			if valIndex(t, value) ~= len then
				result = result .. ", "
			end
		elseif type(value) == "function" then
			result = result .. "DATATYPE function"
			if valIndex(t, value) ~= len then
				result = result .. ", "
			end
		else
			--the value isnt a nested table, just add the value
			--check if it's key is at the last index
			if keyIndex(t, key) == len then
				result = result .. value
			else
				result = result .. value .. ", "
			end
		end
	end
	result = result .. "]"
	return result
end

--returns the length of the given table (not zero indexed)
function tableLength(t)
  local count = 0
  for _ in pairs(t) do 
  	count = count + 1 
  end
  return count
end

--returns the first index of the given value
--returns 0 if not found.
function valIndex(t, val)
	index = 0
	for k,v in pairs(t) do
		index = index + 1
		if v == val then
			return index
		end
	end
	return index
end

--returns the first index of the given key
--returns 0 if not found.
function keyIndex(t, key)
	index = 0
	for k,v in pairs(t) do
		index = index + 1
		if k == key then
			return index
		end
	end
	return index
end

--shallow copy of a table (used for copying characters into stored players)
function table.copy(t)
  local t2 = {}
  for k,v in pairs(t) do
    t2[k] = v
  end
  return t2
end

--ellipsis drawing function
function love.graphics.ellipse(mode, x, y, a, b, phi, points)
  phi = phi or 0
  points = points or 10
  if points <= 0 then points = 1 end

  local two_pi = math.pi*2
  local angle_shift = two_pi/points
  local theta = 0
  local sin_phi = math.sin(phi)
  local cos_phi = math.cos(phi)

  local coords = {}
  for i = 1, points do
    theta = theta + angle_shift
    coords[2*i-1] = x + a * math.cos(theta) * cos_phi 
                      - b * math.sin(theta) * sin_phi
    coords[2*i] = y + a * math.cos(theta) * sin_phi 
                    + b * math.sin(theta) * cos_phi
  end

  coords[2*points+1] = coords[1]
  coords[2*points+2] = coords[2]

  love.graphics.polygon(mode, coords)
end