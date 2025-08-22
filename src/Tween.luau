--!strict

local TweenService = game:GetService("TweenService")

local Promise = require(script.Parent.Promise) -- evaera/roblox-lua-promise

type Callback = () -> ()


local Tween = {}


function Tween.Create(instance: Instance, info: TweenInfo, goal: {[string]: any}, onCompleted: Callback?): Tween
	local tween = TweenService:Create(instance, info, goal)
	if onCompleted then
		tween.Completed:Once(onCompleted)
	end
	return tween
end


function Tween.Play(instance: Instance, info: TweenInfo, goal: {[string]: any}, onCompleted: Callback?)
	local tween = TweenService:Create(instance, info, goal)
	if onCompleted then
		tween.Completed:Once(onCompleted)
	end
	tween:Play()
end


function Tween.PlaySequence(tweens: {Tween}, onCompleted: Callback?)
	task.spawn(function()
		for _, tween in tweens do
			tween:Play()
			tween.Completed:Wait()
		end
		
		if onCompleted then
			onCompleted()
		end
	end)
end


function Tween.PlayAll(tweens: {Tween}, onCompleted: Callback?): any
	local promise = Promise.new(function(resolve, _, onCancel)
		local promises = table.create(#tweens)
		
		for _, tween in tweens do
			table.insert(promises, Promise.fromEvent(tween.Completed))
			tween:Play()
		end
		
		Promise.all(promises):andThen(resolve)
		
		onCancel(function()
			for _, tween in tweens do
				tween:Cancel()
			end
		end)
	end)
	
	if onCompleted then
		promise:andThen(onCompleted)
	end
	
	return promise
end


function Tween.PlayGroup(info: TweenInfo, goalMap: {[Instance]: {[string]: any}}, onCompleted: Callback?): any?
	if onCompleted then
		local tweens = {}
		for instance, goal in goalMap do
			table.insert(tweens, TweenService:Create(instance, info, goal))
		end
		return Tween.PlayAll(tweens, onCompleted)
	else
		for instance, goal in goalMap do
			TweenService:Create(instance, info, goal):Play()
		end
		return
	end
end


return table.freeze(Tween)