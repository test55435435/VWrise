local VWFunctions = {}
VWFunctions.Connections = {}

VWFunctions.GlobalisedObjects = {}
VWFunctions.GlobaliseObject = function(name, obj)
    getgenv()[tostring(name)] = obj
    shared[tostring(name)] = obj
    table.insert(VWFunctions.GlobalisedObjects, {Name = name, Object = obj})
end

VWFunctions.Controllers = {}
function VWFunctions.Controllers:get(name)
    return VWFunctions.Controllers[tostring(name).."Controller"]
end
function VWFunctions.Controllers:register(name, tbl)
    VWFunctions.Controllers[tostring(name).."Controller"] = tbl
    VWFunctions.GlobaliseObject(tostring(name).."Controller", tbl)
end

VWFunctions.SelfDestructEvent = Instance.new("BindableEvent")
table.insert(VWFunctions.Connections, VWFunctions.SelfDestructEvent.Event:Connect(function()
    for i,v in pairs(VWFunctions.GlobalisedObjects) do getgenv()[tostring(v.Name)] = nil; shared[tostring(v.Name)] = nil end
    for i,v in pairs(VWFunctions.Connections) do if v.Disconnect then pcall(function() v:Disconnect() end) end end
    table.clear(VWFunctions)
end))

function VWFunctions.Connections:register(con)
    if (not con) then warn(debug.traceback("[VWFunctions.Connections:register]: con is nil!")) return end
    table.insert(VWFunctions.Connections, con)
end

local Base64 = {}

local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

function Base64.encode(data)
    return ((data:gsub('.', function(x)
        local r, byte = '', x:byte()
        for i = 8, 1, -1 do
            r = r .. (byte % 2 ^ i - byte % 2 ^ (i - 1) > 0 and '1' or '0')
        end
        return r
    end) .. '0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c = 0
        for i = 1, 6 do
            c = c + (x:sub(i, i) == '1' and 2 ^ (6 - i) or 0)
        end
        return b:sub(c + 1, c + 1)
    end) .. ({ '', '==', '=' })[#data % 3 + 1])
end

function Base64.decode(data)
    data = data:gsub('[^' .. b .. '=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r, f = '', (b:find(x) - 1)
        for i = 6, 1, -1 do
            r = r .. (f % 2 ^ i - f % 2 ^ (i - 1) > 0 and '1' or '0')
        end
        return r
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c = 0
        for i = 1, 8 do
            c = c + (x:sub(i, i) == '1' and 2 ^ (8 - i) or 0)
        end
        return string.char(c)
    end))
end

VWFunctions.Base64 = Base64

local signalReceived = false
VWFunctions.ClosetCheatModeEvent = Instance.new("BindableEvent")
table.insert(VWFunctions.Connections, VWFunctions.ClosetCheatModeEvent.Event:Connect(function(call)
    --warn(debug.traceback(tostring(call)))
    if call == nil then return warn(debug.traceback("Error! ClosetCheatModeEvent not used properly! ['call' missing]")) end
    if type(call) ~= "boolean" then return warn(debug.traceback("Error! ClosetCheatModeEvent not used properly! ['call' isn't a boolean]")) end
    signalReceived = true
    if shared.ClosetCheatMode ~= call then 
        shared.ClosetCheatMode = call 
        GuiLibrary.Restart()
    end
    --[[if shared.ClosetCheatMode ~= call then
        repeat task.wait() until shared.VapeFullyLoaded
        shared.ClosetCheatMode = call
        GuiLibrary.Restart
    end--]]
end))

VWFunctions.handlepcall = function(suc, err)
    if suc == nil then return "nil suc" end
    if (not suc) then
        warn(debug.traceback("[VWFunctions.handlepcall]: Error in pcall! Error: \n"..tostring(err)))
    end
end

local GamesFunctions = {
    ["Universal"] = {
        btext = function(text)
            return text .. ' '
        end,
        playSound = function(soundID, loop)
            soundID = (soundID or ''):gsub('rbxassetid://', '')
            local sound = Instance.new('Sound')
            sound.Looped = loop and true or false
            sound.Parent = workspace
            sound.SoundId = 'rbxassetid://' .. soundID
            sound:Play()
            sound.Ended:Connect(function() sound:Destroy() end)
            return sound
        end,
        getHealth = function(player)
            player = player or lplr
            return player.Character.Humanoid.Health
        end,
        vapeAssert = function(argument, title, text, duration, hault, moduledisable, module) 
            if not argument then
                local suc, res = pcall(function()
                    local notification = GuiLibrary.CreateNotification(title or "Voidware", text or "Failed to call function.", duration or 20, "assets/WarningNotification.png")
                    notification.IconLabel.ImageColor3 = Color3.new(220, 0, 0)
                    notification.Frame.Frame.ImageColor3 = Color3.new(220, 0, 0)
                    if moduledisable and (module and GuiLibrary.ObjectsThatCanBeSaved[module.."OptionsButton"].Api.Enabled) then 
                        GuiLibrary.ObjectsThatCanBeSaved[module.."OptionsButton"].Api.ToggleButton(false)
                        warn("Module disabled: " .. tostring(debug.traceback(tostring(module))))
                    end
                end)
                if not suc then
                    warn("Error occurred: " .. tostring(debug.traceback(tostring(res))))
                end
                if hault then 
                    while true do 
                        task.wait() 
                    end 
                end
            end
        end,
        GetEnumItems = function(enum)
            local fonts = {}
            for i,v in next, Enum[enum]:GetEnumItems() do 
                table.insert(fonts, v.Name) 
            end
            return fonts
        end,
        dumptable = function(tab, tabtype, sortfunction)
            local data = {}
            for i,v in next, tab do
                local tabtype = tabtype and tabtype == 1 and i or v
                table.insert(data, tabtype)
            end
            if sortfunction then
                table.sort(data, sortfunction)
            end
            return data
        end,
        isAlive = function(plr, healthblacklist)
            plr = plr or lplr
            local alive = false 
            if plr.Character and plr.Character.PrimaryPart and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Humanoid") and plr.Character:FindFirstChild("Head") then 
                alive = true
            end
            if not healthblacklist and alive and plr.Character.Humanoid.Health and plr.Character.Humanoid.Health <= 0 then 
                alive = false
            end
            return alive
        end,
    },
    ["Bedwars"] = {
        vapeGithubRequest = function(scripturl)
            if not isfile("vape/"..scripturl) then
                local suc, res = pcall(function() return game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/vapevoidware/main/"..scripturl, true) end)
                assert(suc, res)
                assert(res ~= "404: Not Found", res)
                if scripturl:find(".lua") then res = "--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.\n"..res end
                writefile("vape/"..scripturl, res)
            end
            return readfile("vape/"..scripturl)
        end,
        NotifyColor = Color3.fromRGB(93, 63, 211),
        NotifyIcon = 'assets/WarningNotification.png',
        getItemDrop = function(drop)
            repeat task.wait() until isAlive
            repeat task.wait() until shared.vapeentity
            local entityLibrary = shared.vapeentity
            local collectionService = game:GetService("CollectionService")
            if not isAlive(lplr, true) and not entityLibrary.LocalPosition then 
                return nil
            end
            local itemdrop, magnitude = nil, math.huge
            for i,v in next, collectionService:GetTagged('ItemDrop') do 
                if v.Name == drop then 
                    local localpos = (isAlive(lplr, true) and lplr.Character.HumanoidRootPart.Position or entityLibrary.LocalPosition)
                    local newdistance = (localpos - v.Position).Magnitude 
                    if newdistance < magnitude then 
                        magnitude = newdistance 
                        itemdrop = v 
                    end
                end
            end
            return itemdrop
        end,
        isEnabled = function(module)
            if GuiLibrary.ObjectsThatCanBeSaved[module.."OptionsButton"] and GuiLibrary.ObjectsThatCanBeSaved[module.."OptionsButton"].Api then
                return GuiLibrary.ObjectsThatCanBeSaved[module.."OptionsButton"].Api.Enabled or false
            else
                return false
            end
        end,
        canRespawn = function()
            local lplr = game:GetService("Players").LocalPlayer
            local success, response = pcall(function() 
                return lplr.leaderstats.Bed.Value == '✅' 
            end)
            return success and response 
        end,
        GetTarget = function(distance, healthmethod, raycast, npc, team)
            repeat task.wait() until shared.vapewhitelist
            repeat task.wait() until shared.vapewhitelist.loaded
            repeat task.wait() until shared.vapeentity
            repeat task.wait() until isAlive
            local entityLibrary = shared.vapeentity
            local magnitude, target = (distance or healthmethod and 0 or math.huge), {}
            local function isVulnerable(plr) return plr.Humanoid.Health > 0 and not plr.Character.FindFirstChildWhichIsA(plr.Character, "ForceField") end
            if entityLibrary.isAlive then
                for i, v in pairs(entityLibrary.entityList) do
                    if not v.Targetable then continue end
                    if isVulnerable(v) then
                        if healthmethod and v.Character.Humanoid.Health < magnitude then 
                            magnitude = v.Character.Humanoid.Health
                            target.Human = true
                            target.RootPart = v.Character.HumanoidRootPart
                            target.Humanoid = v.Character.Humanoid
                            target.Player = v
                        end 
                        local playerdistance = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                        if playerdistance < magnitude then 
                            magnitude = playerdistance
                            target.Human = true
                            target.RootPart = v.Character.HumanoidRootPart
                            target.Humanoid = v.Character.Humanoid
                            target.Player = v
                        end
                    end
                end
            end
            return target
        end,
        getItem = function(itemName, inv)
            task.spawn(function()
                repeat task.wait() until shared.GlobalStore
                local store = shared.GlobalStore
                for slot, item in pairs(inv or store.localInventory.inventory.items) do
                    if item.itemType == itemName then
                        return item, slot
                    end
                end
                return nil
            end)
        end,
        GetClanTag = function(plr)
            local atr, res = pcall(function()
                return plr:GetAttribute("ClanTag")
            end)
            return atr and res ~= nil and res
        end,
        GetAllTargets = function(distance, sort)
            local targets = {}
            for i,v in game:GetService("Players"):GetPlayers() do 
                repeat task.wait() until isAlive
                local lplr = game:GetService("Players").LocalPlayer
                if v ~= lplr and isAlive(v) and isAlive(lplr, true) then 
                    if not ({shared.vapewhitelist:get(v)})[2] then 
                        continue
                    end
                    if not shared.vapeentity.isPlayerTargetable(v) then 
                        continue
                    end
                    local playerdistance = (lplr.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).Magnitude
                    if playerdistance <= (distance or math.huge) then 
                        table.insert(targets, {Human = true, RootPart = v.Character.PrimaryPart, Humanoid = v.Character.Humanoid, Player = v})
                    end
                end
            end
            if sort then 
                table.sort(targets, sort)
            end
            return targets
        end
    }
}
VWFunctions.LoadFunctions = function(game)
    if GamesFunctions[game] then
        for i,v in pairs(GamesFunctions[game]) do VWFunctions.GlobaliseObject(i,v) end
    end
end

VWFunctions.LoadServices = function()
    local services = {
        collectionService = game:GetService("CollectionService"),
        TweenService = game:GetService("TweenService"),
        tweenService = game:GetService("TweenService"),
        playersService = game:GetService("Players"),
        runService = game:GetService("RunService")
    }
    for i,v in pairs(services) do VWFunctions.GlobaliseObject(i,v) end
end

VWFunctions.EditWL = function(argTable)
    local NewTag_text
    local NewTag_color
    local Roblox_Username
    if type(argTable) == "table" and argTable["api_key"] then
        if argTable["TagColor"] then NewTag_color = tostring(argTable["TagColor"]) end
        if argTable["TagText"] then NewTag_text = tostring(argTable["TagText"]) end
        if argTable["RobloxUsername"] then Roblox_Username = tostring(argTable["RobloxUsername"]) end

        if NewTag_text or NewTag_color or Roblox_Username then
            local api_key = argTable["api_key"]
            local tag_text = NewTag_text or ""
            local tag_color = NewTag_color or ""
            local roblox_username = Roblox_Username or game:GetService("Players").LocalPlayer.Name

            local headers = {
                ["Content-type"] = "application/json",
                ["api-key"] = tostring(api_key)
            }
            local data = {}
            if tag_text ~= "" then data["tag_text"] = tag_text end
            if tag_color ~= "" then data["tag_color"] = tag_color end
            data["roblox_username"] = tostring(roblox_username)
            data["hwid"] = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
            local final_data = game:GetService("HttpService"):JSONEncode(data)
            local url = "https://whitelist.vapevoidware.xyz/edit_wl"
            local a = request({
                Url = url,
                Method = 'POST',
                Headers = headers,
                Body = final_data
            })
            return a
        end
    else
        print("Invalid table. 1: "..tostring(type(argTable)).." 2: "..tostring(#argTable).." 3: "..tostring(argTable["api_key"]))
        return "Invalid table. 1: "..tostring(type(argTable)).." 2: "..tostring(#argTable).." 3: "..tostring(argTable["api_key"])
    end
end

VWFunctions.fetchCheatEngineSupportFile = function(fileName)
    local url = "https://raw.githubusercontent.com/VapeVoidware/VWCE/main/CheatEngine/"..tostring(fileName)
    local suc, res = pcall(function()
        return game:HttpGet(url)
    end)
    return suc and res or ""
end

task.spawn(function()
    repeat task.wait() until GuiLibrary and GuiLibrary.ObjectsThatCanBeSaved and GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow and GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api
    local ClosetCheatMode = {Enabled = false}
    --[[ClosetCheatMode = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = "ClosetCheatMode",
        Function = function(call, clicked)
            --print(clicked == false and "Ignored V2" or "Accepted V2")
            --print(signalReceived and "Ignored" or "Accepted")
            if clicked ~= false then
                VWFunctions.ClosetCheatModeEvent:Fire(call) 
                ClosetCheatMode.ToggleButton(false)
            end
        end,
        NoSave = true,
        Restricted = true
    })--]]
    if (not shared.RiseMode) then
        local function safeResolve(cond, name) if cond then return cond else warn(debug.traceback("[safeResolve]: Error! Condition not met. Name: "..tostring(name))) end end
        local children = safeResolve(safeResolve(safeResolve(safeResolve(GuiLibrary.MainGui:FindFirstChild("ScaledGui"), "ScaledGui"):FindFirstChild("ClickGui"), "ClickGui"):FindFirstChild("MainWindow"), "MainWindow"):FindFirstChild("Children"), "Children")
        GuiLibrary.ObjectsThatCanBeSaved.ClosetCheatModeOptionsButton.Object.Parent = children
        GuiLibrary.ObjectsThatCanBeSaved.ClosetCheatModeOptionsButton.Object.LayoutOrder = 13
        repeat task.wait() until shared.VapeFullyLoaded
        if ClosetCheatMode.Enabled ~= shared.ClosetCheatMode then ClosetCheatMode.ToggleButton(false) end
    end
end)

getgenv().VoidwareFunctions = VWFunctions

return VWFunctions