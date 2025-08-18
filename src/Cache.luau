--!strict

local Cache = { index = {} }
Cache.__index = Cache

export type Cache = typeof(setmetatable({} :: {
	items: {}
}, Cache))


function Cache.new(name: string)
	if Cache.index[name] then
		return Cache.index[name]
	end
	
	local self = setmetatable({
		items = {}
	}, Cache)
	
	Cache.index[name] = self
	return self
end


function Cache.Get<T>(self: Cache, key: string, onMiss: () -> T): T
	if not self.items[key] then
		self.items[key] = onMiss()
	end
	return self.items[key]
end


function Cache.Set(self: Cache, key: string, item: any)
	self.items[key] = item
end


function Cache.Remove(self: Cache, key: string)
	self.items[key] = nil
end


function Cache.Clear(self: Cache)
	table.clear(self.items)
end


return table.freeze(Cache)