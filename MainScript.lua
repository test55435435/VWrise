repeat task.wait() until game:IsLoaded()

local GuiLibrary
local VWFunctions

shared.RiseMode = true

local inputService = game:GetService("UserInputService")

local queueonteleport = syn and syn.queue_on_teleport or queue_on_teleport or function() end
local isfile = isfile or function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end

assert(not shared.RiseExecuted, "Rise Already Injected")
shared.RiseExecuted = true
shared.VapeExecuted = true

for i,v in pairs({"rise", "rise/CustomModules", "rise/Profiles", "rise/Assets", "rise/Libraries", "rise/fonts"}) do if not isfolder(v) then makefolder(v) end end

local function riseGithubRequest(scripturl)
    print("1", scripturl)
	local suc, res = pcall(function() return game:HttpGet('https://raw.githubusercontent.com/VapeVoidware/VWRise/main/'..scripturl, true) end)
	writefile("rise/"..scripturl, res)
	return readfile("rise/"..scripturl)
end

local suc, err = pcall(function()
	return getrenv().require(game:GetService("CoreGui").RobloxGui.Modules.ErrorPrompt)
end)
if (not suc) then shared.CheatEngineMode = true end

local function downloadFonts()
	local function downloadFont(path)
	    print("2", path)
		riseGithubRequest(path)
	end
	local res1 = "https://api.github.com/repos/VapeVoidware/VWRise/contents/fonts"
	local res = game:HttpGet(res1, true)
	local fonts = {}
	if res ~= '404: Not Found' then 
		for i,v in next, game:GetService("HttpService"):JSONDecode(res) do 
			if type(v) == 'table' and v.name then 
				table.insert(fonts, v.name) 
			end
		end
	end
	for i, v in pairs(fonts) do
	    print("3", i, v)
        downloadFont("fonts/"..fonts[i])
        task.wait()
    end
end
downloadFonts()
shared.GuiLibraryFont = Font.new(
    "rbxasset://fonts/families/GothamSSm.json", 
    Enum.FontWeight.Medium,
    Enum.FontStyle.Normal -- Normal
)
local UIS = game:GetService("UserInputService")
shared.ClickGUIScale = UIS.TouchEnabled and 1.1 or 1
shared.ClickUIARC = UIS.TouchEnabled and 1.4 or 1.3

GuiLibrary = pload("GuiLibrary.lua", true, true)
VWFunctions = pload("Libraries/VoidwareFunctions.lua", true, true)

GuiLibrary.SelfDestructEvent.Event:Connect(function() VWFunctions.SelfDestructEvent:Fire() end)

VWFunctions.GlobaliseObject("GuiLibrary", GuiLibrary)
VWFunctions.GlobaliseObject("VoidwareFunctions", VWFunctions)
VWFunctions.GlobaliseObject("VWFunctions", VWFunctions)

VWFunctions.GlobaliseObject("cprint", function(tbl) if tbl and type(tbl) == "table" then for i,v in pairs(tbl) do print(tbl, i, v) end end end)

shared.VoidwareFunctions = VWFunctions
getgenv().VoidwareFunctions = VWFunctions

shared.risegui = GuiLibrary
shared.GuiLibrary = GuiLibrary

VoidwareFunctions.Controllers:register("UpdateUI", {UIUpdate = Instance.new("BindableEvent")})
GuiLibrary.GUIColorChanged.Event:Connect(function()
	local h, s, v = GuiLibrary.MainColor:ToHSV()
	VoidwareFunctions.Controllers:get("UpdateUI").UIUpdate:Fire(h,s,v)
end)

local saveSettingsLoop = coroutine.create(function()
	if inputService.TouchEnabled then return end
	repeat
		GuiLibrary.SaveSettings()
        task.wait(10)
	until not shared.RiseExecuted or not shared.GuiLibrary
end)

local function encode(tbl)
    return game:GetService("HttpService"):JSONEncode(tbl)
end
VoidwareFunctions.GlobaliseObject("encode", encode)
local function decode(tbl)
    return game:GetService("HttpService"):JSONDecode(tbl)
end
VoidwareFunctions.GlobaliseObject("decode", decode)

local Search = GuiLibrary.CreateWindow({
	Name = "Search",
	Icon = "vape/assets/CoreSearch.png",
	IconSize = 15
})
local Combat = GuiLibrary.CreateWindow({
	Name = "Combat",
	Icon = "vape/assets/CoreAttack.png",
	IconSize = 15
})
local World = GuiLibrary.CreateWindow({
	Name = "Movement",
	Icon = "vape/assets/CoreMovement.png",
	IconSize = 16
})
GuiLibrary.ObjectsThatCanBeSaved["WorldWindow"] = GuiLibrary.ObjectsThatCanBeSaved["MovementWindow"]
local Utility = GuiLibrary.CreateWindow({
	Name = "Player",
	Icon = "vape/assets/CorePlayer.png",
	IconSize = 17
})
GuiLibrary.ObjectsThatCanBeSaved["UtilityWindow"] = GuiLibrary.ObjectsThatCanBeSaved["PlayerWindow"]
local Render = GuiLibrary.CreateWindow({
	Name = "Render",
	Icon = "vape/assets/CoreRender.png",
	IconSize = 17
})
local Blatant = GuiLibrary.CreateWindow({
	Name = "Exploit",
	Icon = "vape/assets/CoreAttack.png",
	IconSize = 16
})
GuiLibrary.ObjectsThatCanBeSaved["BlatantWindow"] = GuiLibrary.ObjectsThatCanBeSaved["ExploitWindow"]
local Legit = GuiLibrary.CreateWindow({
	Name = "Legit",
	Icon = "vape/assets/CoreGhost.png",
	IconSize = 16
})
GuiLibrary.ObjectsThatCanBeSaved["OtherWindow"] = GuiLibrary.ObjectsThatCanBeSaved["LegitWindow"]
local Settings = GuiLibrary.CreateWindow({
	Name = "Settings",
	Icon = "vape/assets/CoreSettings.png",
	IconSize = 16
})
local RestartVoidware = {Enabled = false}
RestartVoidware = GuiLibrary.ObjectsThatCanBeSaved.SettingsWindow.Api.CreateOptionsButton({
	Name = "Restart",
	Function = function(call)
		if call then GuiLibrary.Uninject(); pload("NewMainScript.lua") end
	end,
	NoSave = true,
	HoverText = "Restarts VW Rise",
	Default = false
})
local Uninject = {Enabled = false}
Uninject = GuiLibrary.ObjectsThatCanBeSaved.SettingsWindow.Api.CreateOptionsButton({
	Name = "Uninject",
	Function = function(call) if call then GuiLibrary.Uninject() end end,
	NoSave = true,
	HoverText = "Uninjects VW Rise",
	Default = false
})
local SaveProfiles = {Enabled = false}
SaveProfiles = GuiLibrary.ObjectsThatCanBeSaved.SettingsWindow.Api.CreateOptionsButton({
	Name = "SaveProfiles",
	Function = function(call) if call then GuiLibrary.SaveProfiles(); SaveProfiles.ToggleButton(false) end end,
	NoSave = true,
	HoverText = "Saves your current config of VW Rise",
	Default = false
})
local GUIbind = GuiLibrary.CreateGUIBind("Settings")
local Interface = {Enabled = false}
Interface = GuiLibrary.ObjectsThatCanBeSaved.SettingsWindow.Api.CreateOptionsButton({
    Name = "Interface",
    Function = function(call)
        for i, v in pairs(GuiLibrary.Interface) do 
            v.Visible = call
        end
    end,
    HoverText = "The clients Interface with all information",
    ExtraText = function() return GuiLibrary.CurrentTheme end,
    Default = true,
	Restricted = true
})
local BackGroundDropdown = Interface.CreateDropdown({
    Name = "BackGround",
    Function = function(val)
        GuiLibrary.Settings.bkg = val == "Normal"
        GuiLibrary.UpdateTextGUI()
    end,
    List = {"Normal", "Off"}
})

local ModulesDropdown = Interface.CreateDropdown({
    Name = "Modules to Show",
    Function = function(val)
        GuiLibrary.Settings.mode = val
        GuiLibrary.UpdateTextGUI()
    end,
    List = {"Exclude Render", "All", "Only bound"}
})

local SidebarToggle = Interface.CreateToggle({
    Name = "Sidebar",
    Function = function(val)
        GuiLibrary.Settings.sidebar = val
        GuiLibrary.UpdateTextGUI()
    end,
    Default = true
})

local SuffixToggle = Interface.CreateToggle({
    Name = "Suffix",
    Function = function(val)
        GuiLibrary.Settings.suffix = val
        GuiLibrary.UpdateTextGUI()
    end,
    Default = true
})

local LowercaseToggle = Interface.CreateToggle({
    Name = "Lowercase",
    Function = function(val)
        GuiLibrary.Settings.lowercase = val
        GuiLibrary.UpdateTextGUI()
    end,
	Default = false
})

local RemoveSpacesToggle = Interface.CreateToggle({
    Name = "Remove spaces",
    Function = function(val)
        GuiLibrary.Settings.spaces = not val
        GuiLibrary.UpdateTextGUI()
    end
})

local NotificationsToggle = Interface.CreateToggle({
    Name = "Toggle Notifications",
    Function = function(val)
        GuiLibrary.Settings.notifs = val
        GuiLibrary.UpdateTextGUI()
    end,
    Default = true
})
local TargetInfo = Render.CreateOptionsButton({
	Name = "TargetInfo",
	Function = function(call)
		GuiLibrary.TargetInfo.Visible = call
		GuiLibrary.Settings.targetinfoenabled = call
	end,
	HoverText = "Displays information about the entity you're fighting",
    ExtraText = "Modern"
})
TargetInfo.CreateToggle({
	Name = "Follow Player",
	Function = function(call)
		GuiLibrary.targetinfofollow = call
	end
})
GuiLibrary.CreateThemeCategory({
	Name = "Themes",
	Icon = "vape/assets/CoreSearch.png"
})

local function recodeWindows(tbl) for i,v in pairs(tbl) do GuiLibrary.ObjectsThatCanBeSaved[i.."Window"] = GuiLibrary.ObjectsThatCanBeSaved[v.."Window"] end end
local Rewrite_Windows_Corresponder = {["Funny"] = "Blatant",["Hot"] = "Blatant",["Exploits"] = "Blatant",["Customisation"] = "Utility",["TP"] = "World",["Voidware"] = "Utility"}
recodeWindows(Rewrite_Windows_Corresponder)

GuiLibrary.ObjectsThatCanBeSaved["Friends ColorSliderColor"] = {Api = {Hue = 0.33, Sat = 1, Value = 1}}
GuiLibrary.ObjectsThatCanBeSaved["Use FriendsToggle"] = {Api = {Enabled = false}}
GuiLibrary.ObjectsThatCanBeSaved.TargetsListTextCircleList = {Api = {ObjectList = {}, TargetColorRefresh = Instance.new("BindableEvent"), ObjectListEnabled = {}}}
GuiLibrary["ObjectsThatCanBeSaved"]["Lobby CheckToggle"] = {Api = {Enabled = true}} 
GuiLibrary.ObjectsThatCanBeSaved.FriendsListTextCircleList = {Api = {ObjectList = {}, FriendColorRefresh = Instance.new("BindableEvent"), ObjectListEnabled = {}}}
shared.GuiLibrary.ObjectsThatCanBeSaved["StreamerModeToggle"] = {Api = {Enabled = false}}
GuiLibrary.ObjectsThatCanBeSaved.GUIWindow = {Api = GuiLibrary}
VoidwareFunctions.GlobaliseObject("GUI", GuiLibrary.ObjectsThatCanBeSaved.GUIWindow.Api)
GuiLibrary.ObjectsThatCanBeSaved["Text GUIAlternate TextToggle"] = {Api = {Enabled = false}}
shared.VapeTargetInfo = GuiLibrary
local function InfoNotification(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary.CreateNotification(title or "Voidware", text or "Successfully called function", delay or 7, "assets/InfoNotification.png")
		return frame
	end)
    warn(title..": "..text)
	return (suc and res)
end

local bedwarsID = {
	game = {6872274481, 8444591321, 8560631822},
	lobby = {6872265039}
}
local teleportConnection
local function loadRise()
	pload("Universal.lua", true)
	pload("VWUniversal.lua", true)
	local fileName1 = "CustomModules/"..game.PlaceId..".lua"
	local fileName2 = "CustomModules/VW"..game.PlaceId..".lua"
	--local fileName3
	local isGame = table.find(bedwarsID.game, game.PlaceId)
	local isLobby = table.find(bedwarsID.lobby, game.PlaceId)
	local CE = shared.CheatEngineMode and "CE" or ""
	if isGame then
		if game.PlaceId ~= 6872274481 then shared.CustomSaveVape = 6872274481 end
		fileName1 = "CustomModules/"..CE.."6872274481.lua"
		fileName2 = "CustomModules/VW6872274481.lua"
		--if (not shared.CheatEngineMode) then fileName3 = "CustomModules/S6872274481.lua" end
	end
	if isLobby then
		fileName1 = "CustomModules/"..CE.."6872265039.lua"
		fileName2 = "CustomModules/VW6872265039.lua"
	end
	--if CE == "CE" then InfoNotification("Voidware", "Backup mode activated!", 3) end 
	--if shared.CheatEngineMode then InfoNotification(fileName1, fileName2, 2) end
	warn("[CheatEngineMode]: ", tostring(shared.CheatEngineMode))
	warn("[TestingMode]: ", tostring(shared.TestingMode))
	warn("[FileName1]: ", tostring(fileName1), " [FileName2]: ", tostring(fileName2), " [FileName3]: ", tostring(fileName3))
	if shared.VoidDev and shared.LoadDebug then InfoNotification(fileName1, fileName2, 1000) end
	pload(fileName1)
	pload(fileName2)
	--if fileName3 then pload(fileName3) end
	GuiLibrary.LoadSettings()
	pcall(GUIbind.Reload)
	if not shared.VapeSwitchServers then
		InfoNotification("Finished Loading", inputService.TouchEnabled and "Press the button in the top right to open GUI" or "Press "..string.upper(GuiLibrary["GUIKeybind"]).." to open GUI", 5)
	end
	teleportConnection = game:GetService("Players").LocalPlayer.OnTeleport:Connect(function()
		GuiLibrary.SaveSettings()
	end)
	pcall(function()
		local teleportScript = [[
			repeat task.wait() until game:IsLoaded()
			if (not shared.VWEXECUTED) then
				shared.VapeSwitchServers = true
				shared.VWEXECUTED = true
				if shared.VapeDeveloper or shared.VoidDev then
					if isfile('rise/NewMainScript.lua') then
						loadstring(readfile("rise/NewMainScript.lua"))()
					else
						shared.RiseMode = true
						loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VWRise/main/NewMainScript.lua", true))()
					end
				else
					shared.RiseMode = true
					loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VWRise/main/NewMainScript.lua", true))()
				end
			end
		]]

		local settings = {
			{variable = "VapeDeveloper", value = true},
			{variable = "VoidDev", value = true},
			{variable = "ClosetCheatMode", value = true},
			{variable = "VapePrivate", value = true},
			{variable = "NoVoidwareModules", value = true},
			{variable = "ProfilesDisabled", value = true},
			{variable = "NoAutoExecute", value = true},
			{variable = "TeleportExploitAutowinEnabled", value = true},
			{variable = "VapeCustomProfile", custom = true},
			{variable = "TestingMode", value = true},
			{variable = "CheatEngineMode", value = true},
			{variable = "RiseMode", value = true}
		}

		for _, setting in ipairs(settings) do
			if shared[setting.variable] then
				if setting.custom then
					teleportScript = "shared." .. setting.variable .. " = '" .. shared[setting.variable] .. "'\n" .. teleportScript
				else
					teleportScript = "shared." .. setting.variable .. " = true\n" .. teleportScript
				end
			end
		end

		queueonteleport(teleportScript)
	end)
	coroutine.resume(saveSettingsLoop)
	shared.VapeFullyLoaded = true
	shared.RiseFullyLoaded = true
end

GuiLibrary.SelfDestructEvent.Event:Connect(function()
	task.spawn(function()
		coroutine.close(saveSettingsLoop)
	end)
	pcall(function() teleportConnection:Disconnect() end)
end)

loadRise()