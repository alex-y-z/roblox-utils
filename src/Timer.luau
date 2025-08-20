--!strict

local Signal = require(script.Parent.Signal) -- Forked from Sleitnick/RbxUtil


local Timer = {}
Timer.__index = Timer

export type Timer = typeof(setmetatable({} :: {
	running: boolean,
	duration: number,
	timeLeft: number,
	speed: number,
	onTick: (number) -> (),
	Stopped: Signal.Signal<any>,
	Completed: Signal.Signal<any>
}, Timer))


function Timer.new(onTick: (number) -> ()): Timer
	return setmetatable({
		running = false,
		duration = 0,
		timeLeft = 0,
		speed = 1,
		onTick = onTick,
		Stopped = Signal.new(),
		Completed = Signal.new()
	}, Timer)
end


function Timer.Start(self: Timer, duration: number?)
	if self.running then
		return
	end
	
	self.running = true
	self.duration = duration or self.duration
	self.timeLeft = duration or self.timeLeft
	
	task.defer(function()
		while self.running and (self.timeLeft > 0) do
			self.onTick(self.timeLeft)
			local dt = task.wait()
			self.timeLeft = math.max(self.timeLeft - dt * self.speed, 0)
		end
		
		if self.timeLeft == 0 then
			self.running = false
			self.Completed:Fire()
		end
	end)
end


function Timer.Stop(self: Timer)
	self.running = false
	self.Stopped:Fire()
end


function Timer.SetSpeed(self: Timer, factor: number)
	self.speed = factor
end


function Timer.Destroy(self: Timer)
	self.Stopped:DisconnectAll()
	self:Stop()
end


return table.freeze(Timer)