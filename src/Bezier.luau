--!strict

-- Quintessential reference: https://pomax.github.io/bezierinfo/

local Bezier = {}
Bezier.__index = Bezier

export type Bezier<T> = typeof(setmetatable({} :: {
	curve: (t: number, ...T) -> T,
	size: number,
	lengths: {number},
	points: {T}?
}, Bezier))


function Bezier.new<T>(curve: (t: number, ...T) -> T, size: number, points: {T}?): Bezier<T>
	local self = setmetatable({
		curve = curve,
		size = size, -- Sample size, or number of segments, for rectification
		lengths = table.create(size)
	}, Bezier)
	
	if points then
		self:SetPoints(unpack(points))
	end
	
	return self
end


function Bezier.SetPoints<T>(self: Bezier<T>, ...: T)
	self.points = {...}
	
	-- Calculate arc length with linear subdivisions
	local p1: any = self.curve(0, ...)
	local length = 0
	
	for i = 1, self.size do
		local p2: any = self.curve(i / self.size, ...)
		length += (p2 - p1).Magnitude
		self.lengths[i] = length
		p1 = p2
	end
end


function Bezier.Calculate<T>(self: Bezier<T>, t: number): T
	if not self.points then
		error("Points not set", 2)
	end
	return self.curve(t, unpack(self.points))
end


-- Points on a bezier curve are not uniformly distributed, so this
-- method provides a uniform mapping via arc length parametrization 
function Bezier.CalculateUniform<T>(self: Bezier<T>, t: number): T
	if not self.points then
		error("Points not set", 2)
	end
	
	-- Binary search for largest sum < target
	local targetLength = t * self.lengths[self.size]
	local min, max, index = 1, self.size, 0
	
	while min < max do
		index = (min + max) // 2
		if self.lengths[index] < targetLength then
			min = index + 1
		else
			max = index
		end
	end
	
	-- Roll back if target is exceeded
	if self.lengths[index] > targetLength then
		index -= 1
	end
	
	-- Interpolate between lengths if needed
	local lengthBefore = self.lengths[index] or 0
	if lengthBefore == targetLength then
		index /= self.size
	else
		local lengthAfter = self.lengths[index + 1]
		local fraction = (targetLength - lengthBefore) / (lengthAfter - lengthBefore)
		index = (index + fraction) / self.size
	end
	
	return self:Calculate(index)
end


function Bezier.Linear<T>(t: number, p0: T, p1: T): T
	return p0 + (p1 :: any - p0) * t :: any
end


function Bezier.Quad<T>(t: number, p0: T, p1: T, p2: T): T
	local t = t :: any
	return ((1 - t)^2 * p0) + (2 * (1 - t) * t * p1) + (t^2 * p2)
end


function Bezier.Cubic<T>(t: number, p0: T, p1: T, p2: T, p3: T): T
	local t = t :: any
	return ((1 - t)^3 * p0) + (3 * (1 - t)^2 * t * p1) + (3 * (1 - t) * t^2 * p2) + (t^3 * p3)
end


return table.freeze(Bezier)