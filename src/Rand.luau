--!strict

local Rand = {}
Rand.__index = Rand

export type Rand = typeof(setmetatable({} :: {
	rng: Random
}, Rand))


function Rand.new(seed: number?): Rand
	return setmetatable({
		rng = Random.new(seed)
	}, Rand)
end


-- Adapted methods:

function Rand.NextInteger(self: Rand, min: number, max: number): number
	return self.rng:NextInteger(min, max)
end


function Rand.NextNumber(self: Rand, min: number?, max: number?): number
	return (min and max) and self.rng:NextNumber(min, max) or self.rng:NextNumber()
end


function Rand.Shuffle(self: Rand, array: {any})
	self.rng:Shuffle(array)
end


function Rand.NextUnitVector(self: Rand): Vector3
	return self.rng:NextUnitVector()
end


function Rand.Clone(self: Rand): Rand
	return setmetatable({
		rng = self.rng:Clone()
	}, Rand)
end


-- Extension methods:

function Rand.IntFromRange(self: Rand, range: NumberRange): number
	return self.rng:NextInteger(range.Min, range.Max)
end


function Rand.NumFromRange(self: Rand, range: NumberRange): number
	return self.rng:NextNumber(range.Min, range.Max)
end


function Rand.Sign(self: Rand): number
	return (self.rng:NextNumber() < 0.5) and -1 or 1
end


function Rand.Choose(self: Rand, this: any, that: any): any
	return (self.rng:NextNumber() < 0.5) and this or that
end


function Rand.From(self: Rand, array: {any}): any
	return array[self.rng:NextInteger(1, #array)]
end


function Rand.GetWeightedRandom<T>(self: Rand, weights: {[T]: number}): T
	local totalWeight = 0
	for _, weight in weights do
		totalWeight += weight
	end
	
	if totalWeight <= 0 then
		error("Total weight must be greater than 0", 2)
	end
	
	local randomizer = self.rng:NextNumber(0, totalWeight)
	for item, weight in weights do
		if randomizer <= weight then
			return item
		end
		randomizer -= weight
	end
	
	error("Failed to generate weighted selection", 2)
end


return table.freeze(Rand)