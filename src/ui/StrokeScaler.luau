--------------------------------------------------------------------------------
-- IMPORTANT SETTINGS
--------------------------------------------------------------------------------
-- The screen size at which the UI was designed.
-- Run print(workspace.CurrentCamera.ViewportSize) and paste the numbers here.
local BASE_SCREEN_SIZE = Vector2.new(1366, 768)

-- The change in pixels (in either dimension) required for update.
-- ViewportSize changes rapidly, and it is generally redundant, and even expensive
-- in the case of text objects, to continuously update stroke thickness.
local UPDATE_THRESHOLD = 100

-- When true, stroke objects will be automatically detected within the PlayerGui.
-- It's best to manually tag strokes to avoid listening for new descendants.
local AUTO_TAG = false
--------------------------------------------------------------------------------

local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local CollectionService = game:GetService("CollectionService")

local TAG_NAME = "StrokeScaler"
local CAMERA = workspace.CurrentCamera
local MIN_BASE_DIM = math.min(BASE_SCREEN_SIZE.X, BASE_SCREEN_SIZE.Y)


local StrokeScaler = {
	lastScreenSize = Vector2.zero,
	strokes = {}
}


function StrokeScaler:Start()
	
	-- Detect strokes within the PlayerGui
	if AUTO_TAG then
		local playerGui = Players.LocalPlayer:WaitForChild("PlayerGui", 30)
		
		local function TagStroke(guiObject: Instance)
			if guiObject:IsA("UIStroke") then
				guiObject:AddTag(TAG_NAME)
			end
		end
		
		playerGui.DescendantAdded:Connect(TagStroke)
		
		for _, guiObject in playerGui:GetDescendants() do
			TagStroke(guiObject)
		end
	end
	
	-- Register strokes
	CollectionService:GetInstanceAddedSignal(TAG_NAME):Connect(function(stroke: UIStroke)
		self:Register(stroke)
	end)
	
	for _, stroke in CollectionService:GetTagged(TAG_NAME) do
		self:Register(stroke)
	end
	
	-- Clear memory on removal
	CollectionService:GetInstanceRemovedSignal(TAG_NAME):Connect(function(stroke: UIStroke)
		self:Disconnect(stroke)
	end)
	
	-- Consider scaling strokes on viewport resize
	CAMERA:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		self:Scale()
	end)
end


function StrokeScaler:Register(stroke: UIStroke)
	if stroke:IsDescendantOf(StarterGui) then
		return -- Ignore StarterGui
	end
	
	self.strokes[stroke] = stroke.Thickness
	
	-- Set initial scale
	local minScreenRatio = math.min(CAMERA.ViewportSize.X, CAMERA.ViewportSize.Y) / MIN_BASE_DIM
	stroke.Thickness = stroke.Thickness * minScreenRatio
end


function StrokeScaler:Scale()
	local screenSize = CAMERA.ViewportSize
	local deltaSize = screenSize - self.lastScreenSize
	if math.abs(deltaSize.X) < UPDATE_THRESHOLD and math.abs(deltaSize.Y) < UPDATE_THRESHOLD then
		return -- Below threshold
	end
	
	self.lastScreenSize = screenSize
	
	-- Resize all strokes proportional to the minimum screen ratio
	local minScreenRatio = math.min(screenSize.X, screenSize.Y) / MIN_BASE_DIM
	for stroke, initThickness in self.strokes do
		stroke.Thickness = initThickness * minScreenRatio
	end
end


function StrokeScaler:Disconnect(stroke: UIStroke)
	stroke.Thickness = self.strokes[stroke]
	self.strokes[stroke] = nil
end


return StrokeScaler