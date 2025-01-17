repeat task.wait() until game:IsLoaded()
repeat task.wait() until warningNotification
warningNotification("Voidware - Bedwarz", "Patched", 10)
return false
task.spawn(function()
    repeat task.wait() until warningNotification
    warningNotification("Voidware - Bedwarz", "Credits go to lwclowny#0 on discord!", 10)
    task.wait(1.5)
    warningNotification("Voidware - Bedwarz", "Warning! Some or all modules are currently patched :( sorry", 10)
end) --- eee sk1dded#0 moment
-- Initialize Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()  -- Ensure you have the correct URL for OrionLib

-- Create the window
local Window = OrionLib:MakeWindow({
    Name = "Voidware x Bedwarz - made by lwclowny#0 :D",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "OrionTest"
})

-- Create the main tab
local MainTab = Window:MakeTab({
    Name = "Main",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Create the misc tab
local MiscTab = Window:MakeTab({
    Name = "Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

-- Variables for cooldown
local cooldown = 0.1

-- Function to change walk speed
local function changeWalkSpeed(speed)
    local player = game:GetService("Players").LocalPlayer
    if player and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
        player.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = speed
    end
end

-- Infinite jump function
local infiniteJumpEnabled = false
local UserInputService = game:GetService("UserInputService")
UserInputService.JumpRequest:Connect(function()
    if infiniteJumpEnabled and game:GetService("Players").LocalPlayer.Character then
        local humanoid = game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- Break All Beds functionality
local breakAllBedsActive = false

local function breakAllBeds()
    spawn(function()
        while breakAllBedsActive do
            for _, bed in pairs(workspace.Map.Beds:GetChildren()) do
                local args = {
                    [1] = bed,
                    [2] = "Wooden Pickaxe"
                }
                game:GetService("ReplicatedStorage").Remotes.DamageBlock:InvokeServer(unpack(args))
                wait(0.1) -- Slight delay to avoid overwhelming the server
            end
            wait(0.1)
        end
    end)
end

MainTab:AddToggle({
    Name = "Break All Beds",
    Default = false,
    Callback = function(value)
        breakAllBedsActive = value
        if value then
            breakAllBeds()
        end
    end
})

local killAllPlayersActive = false

-- Function to apply CrossbowHit to a specific player
local function applyCrossbowHitToPlayer(player)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        local args = {
            [1] = Vector3.new(0.06453713774681091, -0.03380536660552025, 0.997342586517334),
            [2] = player.Character,
            [3] = 400
        }
        game:GetService("ReplicatedStorage").Remotes.CrossbowHit:FireServer(unpack(args))
    end
end

-- Function to kill all players except the local player
local function killAllPlayers()
    spawn(function()
        while killAllPlayersActive do
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player ~= game:GetService("Players").LocalPlayer then
                    print("Killing player: " .. player.Name) -- Debugging line
                    applyCrossbowHitToPlayer(player)
                end
            end
            wait(0.1) -- Adjusted delay to reduce server strain
        end
    end)
end

-- Adding a toggle to the GUI to enable or disable the Kill All Players feature
MainTab:AddToggle({
    Name = "Kill All Players",
    Default = false,
    Callback = function(value)
        killAllPlayersActive = value
        if value then
            killAllPlayers()
        end
    end
})


-- Function to give resources
local function giveResource(resourceType, amount)
    local args = {
        [1] = resourceType,
        [2] = amount
    }
    game:GetService("ReplicatedStorage").Remotes.GetBlock:FireServer(unpack(args))
end

-- Variables to store amounts and active states
local emeraldAmount = 10000
local ironAmount = 10000
local diamondAmount = 10000
local customItemsAmount = 10000

-- Add textboxes and toggles for giving resources
MainTab:AddTextbox({
    Name = "Amount for Emerald",
    Default = "10000",
    TextDisappear = true,
    Callback = function(value)
        emeraldAmount = tonumber(value) or 10000
    end
})

local givingEmeralds = false
MainTab:AddToggle({
    Name = "Give Emerald",
    Default = false,
    Callback = function(value)
        givingEmeralds = value
        if value then
            spawn(function()
                while givingEmeralds do
                    giveResource("Emerald", emeraldAmount)
                    wait(cooldown)
                end
            end)
        end
    end
})

MainTab:AddTextbox({
    Name = "Amount for Iron",
    Default = "10000",
    TextDisappear = true,
    Callback = function(value)
        ironAmount = tonumber(value) or 10000
    end
})

local givingIron = false
MainTab:AddToggle({
    Name = "Give Iron",
    Default = false,
    Callback = function(value)
        givingIron = value
        if value then
            spawn(function()
                while givingIron do
                    giveResource("Iron", ironAmount)
                    wait(cooldown)
                end
            end)
        end
    end
})

MainTab:AddTextbox({
    Name = "Amount for Diamond",
    Default = "10000",
    TextDisappear = true,
    Callback = function(value)
        diamondAmount = tonumber(value) or 10000
    end
})

local givingDiamonds = false
MainTab:AddToggle({
    Name = "Give Diamond",
    Default = false,
    Callback = function(value)
        givingDiamonds = value
        if value then
            spawn(function()
                while givingDiamonds do
                    giveResource("Diamond", diamondAmount)
                    wait(cooldown)
                end
            end)
        end
    end
})

-- Function to get custom items
local customItemsActive = false

-- Variables for custom item type and amount
local customItemsType = "Wool"  -- Default item type
local customItemsAmount = 10000

-- Function to get custom items
local function getCustomItems()
    spawn(function()
        while customItemsActive do
            local args = {
                [1] = customItemsType,
                [2] = customItemsAmount
            }
            game:GetService("ReplicatedStorage").Remotes.GetBlock:FireServer(unpack(args))
            wait(cooldown)
        end
    end)
end

-- Add textboxes and toggles for custom items
MainTab:AddTextbox({
    Name = "Custom Item Type",
    Default = "Wool",  -- Default item type
    TextDisappear = true,
    Callback = function(value)
        customItemsType = value
    end
})

MainTab:AddTextbox({
    Name = "Amount for Custom Items",
    Default = "10000",
    TextDisappear = true,
    Callback = function(value)
        customItemsAmount = tonumber(value) or 10000
    end
})

MainTab:AddToggle({
    Name = "Get Custom Items in Shop",
    Default = false,
    Callback = function(value)
        customItemsActive = value
        if value then
            getCustomItems()
        end
    end
})

local giveItemActive = false
local numberOfExecutions = 1

-- Function to give the player 3rd inventory item
local function giveItem()
    spawn(function()
        while giveItemActive do
            for i = 1, numberOfExecutions do
                local args = {
                    [1] = "3",
                    [2] = "One"
                }
                game:GetService("ReplicatedStorage").Remotes.DropItem:FireServer(unpack(args))
                wait(0.0000001)  -- Cooldown of 0.0000001 seconds
            end
            wait(0.0000001)  -- Cooldown between executions
        end
    end)
end

-- Textbox to specify the number of executions
MainTab:AddTextbox({
    Name = "Numbers of drop items",
    Default = "1",
    TextDisappear = true,
    Callback = function(value)
        local num = tonumber(value)
        if num then
            numberOfExecutions = num
        else
            numberOfExecutions = 1
        end
    end
})

-- Toggle to activate/deactivate the function
MainTab:AddToggle({
    Name = "Give Player 3rd Inventory",
    Default = false,
    Callback = function(value)
        giveItemActive = value
        if value then
            giveItem()
        end
    end
})

local targetPlayerName = ""
local damageAmount = 0
local toggleStatus = false

-- Function to get full player name from a shortcut
local function getFullPlayerName(partialName)
    local players = game.Players:GetPlayers()
    for _, player in ipairs(players) do
        if player.Name:lower():sub(1, #partialName) == partialName:lower() then
            return player.Name
        end
    end
    return nil
end

-- Function to deal damage
local function dealDamage()
    local player = game.Players.LocalPlayer
    local targetPlayer = game.Players:FindFirstChild(targetPlayerName)

    if targetPlayer then
        local args = {
            [1] = targetPlayer.Character and targetPlayer.Character.Humanoid,
            [2] = damageAmount
        }

        game:GetService("ReplicatedStorage").Remotes.DamageHumanoid:FireServer(unpack(args))
    else
        OrionLib:MakeNotification({
            Name = "Error",
            Content = "Player not found!",
            Image = "rbxassetid://4483345998",
            Time = 5
        })
    end
end

-- Toggle for enabling/disabling the damage loop
local damageToggle = Window:MakeTab({
    Name = "Damage",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

damageToggle:AddToggle({
    Name = "Give Health",
    Default = false,
    Callback = function(value)
        toggleStatus = value
        while toggleStatus do
            dealDamage()
            wait(0.1) -- Adjust the delay as needed
        end
    end    
})

-- Textbox for selecting the damage amount
damageToggle:AddTextbox({
    Name = "Damage Amount",
    Default = "-100000",
    TextDisappear = true,
    Callback = function(value)
        damageAmount = tonumber(value)
    end    
})

-- Textbox for selecting the player's name
damageToggle:AddTextbox({
    Name = "Player Name",
    Default = "",
    TextDisappear = true,
    Callback = function(value)
        local fullPlayerName = getFullPlayerName(value)
        if fullPlayerName then
            targetPlayerName = fullPlayerName
        else
            OrionLib:MakeNotification({
                Name = "Error",
                Content = "Player not found!",
                Image = "rbxassetid://4483345998",
                Time = 5
            })
        end
    end    
})

local function applyKnockbackToAllPlayers()
    local players = game:GetService("Players"):GetPlayers()
    local localPlayer = game.Players.LocalPlayer

    for _, player in pairs(players) do
        if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local args = {
                [1] = player.Character.HumanoidRootPart,
                [2] = Vector3.new(-29.347702026367188, 87.36488342285156, -38.80836868286133)
            }
            game:GetService("ReplicatedStorage").Remotes.Knockback:FireServer(unpack(args))
        end
    end
end

MainTab:AddToggle({
    Name = "Knockback All Players",
    Default = false,
    Callback = function(Value)
        knockbackEnabled = Value
        if knockbackEnabled then
            knockbackConnection = game:GetService("RunService").RenderStepped:Connect(function()
                applyKnockbackToAllPlayers()
            end)
        else
            if knockbackConnection then
                knockbackConnection:Disconnect()
                knockbackConnection = nil
            end
        end
    end
})

-- Add a textbox and toggle to the misc tab for changing walk speed
MiscTab:AddTextbox({
    Name = "Walk Speed",
    Default = "",
    TextDisappear = true,
    Callback = function(value)
        local speed = tonumber(value)
        if speed then
            MiscTab:AddToggle({
                Name = "Activate Walk Speed",
                Default = false,
                Callback = function(toggleValue)
                    if toggleValue then
                        changeWalkSpeed(speed)
                    else
                        changeWalkSpeed(16)  -- Reset to default walk speed
                    end
                end
            })
        end
    end
})

-- Add a toggle for infinite jump to the misc tab
MiscTab:AddToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(value)
        infiniteJumpEnabled = value
    end
})

-- Add ESP loadstring to the misc tab
MiscTab:AddButton({
    Name = "ESP",
    Callback = function()
        loadstring(game:HttpGet("https://pastebin.com/raw/iv9qAHZP"))()
    end
})

local UniversalTab = Window:MakeTab({
    Name = "Universal Scripts",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false,
    BorderColor = Color3.fromRGB(128, 0, 128)
})

-- Add Universal Scripts label
UniversalTab:AddLabel("Universal Scripts")

-- Add Inf Yield script button
UniversalTab:AddButton({
    Name = "Load Inf Yield",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Inf-yeild-New-Version-1836"))()
    end
})

-- Add Nameless Admin script button
UniversalTab:AddButton({
    Name = "Load Nameless Admin",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Nameless-Admin-Official-15022"))()
    end
})

-- Add Remote Spy script button
UniversalTab:AddButton({
    Name = "Load Remote Spy",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-Just-A-Script-Rewrite-12363"))()
    end
})

-- Add Fly Mobile script button
UniversalTab:AddButton({
    Name = "Load Fly Mobile",
    Callback = function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Universal-Script-FLY-GUI-V3-8031"))()
    end
})

local InfJumpTab = Window:MakeTab({
    Name = "Inf Jump Player",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local UserInputService = game:GetService("UserInputService")
local targetPlayerName = game:GetService("Players").LocalPlayer.Name
local infJumpActive = false
local targetPlayerJumpConnection

local function onJumpRequest()
    if infJumpActive then
        local targetPlayer = game:GetService("Players"):FindFirstChild(targetPlayerName)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            for i = 1, 10 do
                local args = {
                    [1] = targetPlayer.Character.HumanoidRootPart,
                    [2] = Vector3.new(-29.347702026367188, 87.36488342285156, -38.80836868286133)
                }
                game:GetService("ReplicatedStorage").Remotes.Knockback:FireServer(unpack(args))
                wait(i * 0.5)  -- Waits 0.5, 1.0, 1.5, ... , 5.0 seconds for each iteration
            end
        end
    end
end

-- Monitor target player's jump button press
local function monitorTargetPlayerJump()
    if infJumpActive then
        local targetPlayer = game:GetService("Players"):FindFirstChild(targetPlayerName)
        if targetPlayer then
            targetPlayer.CharacterAdded:Connect(function(character)
                local humanoid = character:WaitForChild("Humanoid")
                -- Connect to the Jump event
                humanoid.Jumping:Connect(onJumpRequest)
                -- Monitor Jump button press
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if not gameProcessed and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode == Enum.KeyCode.Space then
                        onJumpRequest()
                    end
                end)
            end)

            if targetPlayer.Character then
                local humanoid = targetPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Jumping:Connect(onJumpRequest)
                end
            end
        end
    end
end

-- Add textbox to the Inf Jump tab for specifying target player
InfJumpTab:AddTextbox({
    Name = "Target Player Username",
    Default = game:GetService("Players").LocalPlayer.Name,  -- Default is local player
    TextDisappear = true,
    Callback = function(value)
        -- Find player with name matching or containing the input value
        for _, player in pairs(game:GetService("Players"):GetPlayers()) do
            if player.Name:lower():find(value:lower()) then
                targetPlayerName = player.Name
                break
            end
        end
        if infJumpActive then
            monitorTargetPlayerJump()
        end
    end
})

-- Add toggle to the Inf Jump tab to activate/deactivate Inf Jump
InfJumpTab:AddToggle({
    Name = "Activate Inf Jump",
    Default = false,
    Callback = function(value)
        infJumpActive = value
        if value then
            monitorTargetPlayerJump()
        else
            -- Disconnect connections if deactivated
            if targetPlayerJumpConnection then
                targetPlayerJumpConnection:Disconnect()
                targetPlayerJumpConnection = nil
            end
        end
    end
})

OrionLib:Init()