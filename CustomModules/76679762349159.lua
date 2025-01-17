local vape = shared.vape
InfoNotification("Voidware", "Bedwarz gaming :moneyface:", 1)
local GuiLibrary = vape

local cloneref = function(obj)
	return obj
end

local playersService = cloneref(game:GetService('Players'))
local replicatedStorage = cloneref(game:GetService('ReplicatedStorage'))
local runService = cloneref(game:GetService('RunService'))
local inputService = cloneref(game:GetService('UserInputService'))
local tweenService = cloneref(game:GetService('TweenService'))
local httpService = cloneref(game:GetService('HttpService'))
local textChatService = cloneref(game:GetService('TextChatService'))
local collectionService = cloneref(game:GetService('CollectionService'))
local contextActionService = cloneref(game:GetService('ContextActionService'))
local coreGui = cloneref(game:GetService('CoreGui'))
local starterGui = cloneref(game:GetService('StarterGui'))

local gameCamera = game.Workspace.CurrentCamera
local lplr = playersService.LocalPlayer
local assetfunction = getcustomasset

local vape = shared.vape
local entitylib = loadstring(game:HttpGet("https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/refs/heads/main/libraries/entity.lua", true))()

local store = {}
function store:getLocalHand()
	if entitylib.isAlive then
		for i,v in pairs(lplr.Character:GetChildren()) do
			if v.ClassName == "Tool" then return v.Name end
		end
	end
end

function store:getPickaxe()
	if entitylib.isAlive then
		if (not lplr:findFirstChild("HotbarFolder")) then errorNotification("Voidware", "Failure fetching pickaxe! Folder not found.", 3) end
		local items = lplr:FindFirstChild("HotbarFolder"):GetChildren() 
		for i,v in pairs(items) do
			local att = v:GetAttribute("ItemName")
			if att and tostring(att):find("Pickaxe") then return tostring(att) end
		end
	end
end

function store:getSword()
	if entitylib.isAlive then
		if (not lplr:findFirstChild("HotbarFolder")) then errorNotification("Voidware", "Failure fetching sword! Folder not found.", 3) end
		local items = lplr:FindFirstChild("HotbarFolder"):GetChildren() 
		for i,v in pairs(items) do
			local att = v:GetAttribute("ItemName")
			if att and tostring(att):find("Sword") then return tostring(att) end
		end
	end
end

local bedwarz = {
	Remotes = game:GetService("ReplicatedStorage"):WaitForChild("Remotes")
}
local function dumpRemote(root, path)
    local suc, res = pcall(function()
        local cur = root
        for seg in string.gmatch(path, "[^/]+") do
            if not cur then return nil end
            cur = cur:FindFirstChild(seg)
        end
        return cur
    end)
    return suc and res or nil
end

function bedwarz:Get(path, root)
    local remote = dumpRemote(root or self.Remotes, path)
    if remote then
        return remote
    else
		errorNotification("Voidware - Bedwarz", "Failure grabing remote: "..tostring(path), 5)
        return {
            FireServer = function() end,
            InvokeServer = function() end,
			Name = path
        }
    end
end

local run = function(func)
	task.spawn(function()
		local suc, err = pcall(function() func() end)
		if (not suc) then errorNotification("Voidware - bedwarz", 'Failure executing function: '..tostring(err), 3); warn(debug.traceback(tostring(err))) end
	end)
end

local function getNearestBed()
	if entitylib.isAlive then
		local plrTeam = lplr.Team and lplr.Team.Name or ""
		local nearestBed = nil
		local shortestDistance = math.huge

		for _, bed in pairs(game:GetService("Workspace"):WaitForChild("Beds"):GetChildren()) do
			if bed:IsA("Model") and bed:FindFirstChild("BedHitbox") then
				if bed.Name ~= plrTeam then 
					local bedHitbox = bed.BedHitbox
					local dis = (entitylib.character.HumanoidRootPart.Position - bedHitbox.Position).Magnitude
					if dis < shortestDistance then
						shortestDistance = dis
						nearestBed = bedHitbox
					end
				end
			end
		end
		return nearestBed
	end
end

run(function()
	local Killaura = {Enabled = false}
	local Slowmode = {Value = 2}
	local Range = {Value = 15}
	local Targets = {Walls = {Enabled = false}, Players = {Enabled = false}, NPCs = {Enabled = false}}

	Killaura = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Killaura",
		Function = function(call)
			if call then
				task.spawn(function()
					repeat task.wait(Slowmode.Value/10);
						if entitylib.isAlive then
							local ent = entitylib.EntityPosition({
								Part = 'RootPart',
								Range = Range.Value,
								Players = true
							})
							if ent then
								local lookvec = (ent.RootPart.Position - entitylib.character.RootPart.Position).Unit
								bedwarz:Get("ToolRemotes/OnSwordHit"):FireServer(store:getSword(), lookvec, ent.Character, Slowmode.Value/10)
							end
						end
					until (not Killaura.Enabled)
				end)
			end
		end,
		ExtraText = 'Attack players around you\nwithout aiming at them.'
	})

	Range = Killaura.CreateSlider({
		Name = "Range",
		Function = function() end,
		Min = 1,
		Max = 15,
		Default = 15
	})

	Slowmode = Killaura.CreateSlider({
		Name = "Slowmode",
		Function = function() end,
		Min = 2, 
		Max = 10,
		Default = 2
	})
end)

run(function()
	local Nuker = {Enabled = false}
	local Slowmode = {Value = 4}
	Nuker = GuiLibrary.ObjectsThatCanBeSaved.WorldWindow.Api.CreateOptionsButton({
		Name = "Nuker",
		Function = function(call)
			if call then
				task.spawn(function()
					repeat task.wait(Slowmode.Value/10);
						if entitylib.isAlive then
							local bed = getNearestBed()
							if bed ~= nil then
								bedwarz:Get("ToolRemotes/DamageBlock"):FireServer(store:getPickaxe(), bed, Slowmode.Value/10)
							end
						end
					until (not Nuker.Enabled)
				end)
			end
		end,
		HoverText = 'Break blocks around you automatically'
	})

	Slowmode = Nuker.CreateSlider({
		Name = "Slowmode",
		Function = function() end,
		Min = 2,
		Max = 10,
		Default = 2.5
	})
end)

run(function()
	GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Disabler",
		Function = function(call)
			if call then
				bedwarz:Get("OnFallDamage").Name = "BYPASS_OnFallDamage"
				bedwarz:Get("Suffocate").Name = "BYPASS_Suffocate"
				bedwarz:Get("Knockback", lplr.PlayerScripts).Name = "BYPASS_Knockback"
				InfoNotification("Disabler", "Disabled FallDamage, Suffocation and Knockback.", 1.5)
			else
				bedwarz:Get("BYPASS_OnFallDamage").Name = "OnFallDamage"
				bedwarz:Get("BYPASS_Suffocate").Name = "Suffocate"
				bedwarz:Get("BYPASS_Knockback", lplr.PlayerScripts).Name = "Knockback"
				InfoNotification("Disabler", "Re-Enabled FallDamage, Suffocation and Knockback.", 1.5)
			end
		end
	})
end)