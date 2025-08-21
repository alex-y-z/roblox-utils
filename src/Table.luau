--!strict

type Array = {any}
type Table = {[any]: any}


local Table = {}


function Table.Map<S, T>(domain: {S}, fn: (S) -> T): {T}
	local codomain = {}
	for _, element in domain do
		table.insert(codomain, fn(element))
	end
	return codomain
end


function Table.Extend(base: Array, extension: Array): Array
	return table.move(extension, 1, #extension, #base + 1, base)
end


function Table.Count(array: Array, query: any): number
	local total = 0
	local foundAt = table.find(array, query)
	while foundAt do
		foundAt = table.find(array, query, foundAt + 1)
		total += 1
	end
	return total
end


function Table.Reverse(array: Array): Array
	local result = table.create(#array)
	for i = #array, 1, -1 do
		table.insert(result, array[i])
	end
	return result
end


function Table.GetSize(tbl: Table): number
	local size = 0
	for _, value in tbl do
		size += 1
	end
	return size
end


function Table.IsEmpty(tbl: Table): boolean
	return (next(tbl) == nil)
end


function Table.DeepFreeze(tbl: Table)
	table.freeze(tbl)
	for _, value in tbl do
		if type(value) == "table" then
			Table.DeepFreeze(value)
		end
	end
end


function Table.DeepCopy(tbl: Table): Table
	local copy = {}
	for key, value in tbl do
		if type(value) == "table" then
			copy[key] = Table.DeepCopy(value)
		else
			copy[key] = value
		end
	end
	return copy
end


return table.freeze(Table)