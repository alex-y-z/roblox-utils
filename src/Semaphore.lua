--!strict

local Semaphore = {}
Semaphore.__index = Semaphore

type Request = {count: number, thread: thread}

export type Semaphore = typeof(setmetatable({} :: {
	items: number,
	queue: {Request}
}, Semaphore))


function Semaphore.new(items: number): Semaphore
	return setmetatable({
		items = items,
		queue = {}
	}, Semaphore)
end


function Semaphore.binary(): Semaphore
	return Semaphore.new(1)
end


function Semaphore.Acquire(self: Semaphore, count: number?): ...any
	self.items -= count or 1
	if self.items < 0 then
		table.insert(self.queue, {
			count = count or 1,
			thread = coroutine.running()
		})
		return coroutine.yield()
	end
end


function Semaphore.Release(self: Semaphore, count: number?)
	self.items += count or 1
	while self.queue[1] and (self.items >= self.queue[1].count) do
		local request = table.remove(self.queue, 1) :: Request
		coroutine.resume(request.thread)
	end
end


return table.freeze(Semaphore)