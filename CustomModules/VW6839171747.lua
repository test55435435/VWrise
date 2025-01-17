--- Auto made file for 6839171747
--- doors game
local GuiLibrary = shared.GuiLibrary
local vapeConnections = {}
GuiLibrary.SelfDestructEvent.Event:Connect(function()
	for i, v in pairs(vapeConnections) do
		if v.Disconnect then pcall(function() v:Disconnect() end) continue end
		if v.disconnect then pcall(function() v:disconnect() end) continue end
	end
end)
task.spawn(function()
    local isNew = false
    if (not isfolder('mspaint')) then makefolder('mspaint'); isNew = true end
    if (not isfolder('mspaint/doors')) then makefolder('mspaint/doors'); isNew = true end
    if (not isfolder('mspaint/doors/settings')) then makefolder('mspaint/doors/settings'); isNew = true end
    if isNew then
        local dir = 'mspaint/doors/settings'
        writefile(dir.."/autoload.txt", "pro")
        local suc, data = pcall(function()
            return game:HttpGet("https://raw.githubusercontent.com/Erchobg/VoidwareProfiles/main/mspaint/doors/settings/pro.json", true)
        end)
        if suc then
            writefile(dir.."/pro.json", data)
        end
    end
    local interactable_buttons_table = {
        [1] = {
            ["Name"] = "Yes",
            ["Function"] = function() GuiLibrary.SelfDestruct() end
        },
        [2] = {
            ["Name"] = "No",
            ["Function"] = function() end
        }
    }
    local function InfoNotification2(title, text, delay, button_table)
        local suc, res = pcall(function()
            local frame = GuiLibrary.CreateInteractableNotification(title or "Voidware", text or "Successfully called function", delay or 7, "assets/InfoNotification.png", button_table)
            return frame
        end)
        return (suc and res)
    end
    local function load()
        local suc2, err2 = pcall(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/VapeVoidware/VW-Add/main/mspaint.lua", true))() end)
        return {Data1 = suc2, Data2 = err2}
    end
    local data = load()
    if (not data.Data1) then
        errorNotification("Voidware x mspaint - Doors", "Failure loading mspaint! Error: "..tostring(data.Data2), 7)
    end
    InfoNotification2("Voidware x mspaint - Doors", "The core script has just loaded! Would you like to uninject vw?", 10000000, interactable_buttons_table)
end)
run(function()
    local Highlight_CoreConnections = {}
    Highlight_CoreConnections["SelfDestructEvent"] = Instance.new("BindableEvent")
    local Highlight = {Enabled = false}
    local Highlight_Types = {"Item", "Door", "Closet", "Entity"}
    local Highlight_Table = {}
    local Highlight_Toggle = {}
    local Highlight_Color = {}
    for i,v in pairs(Highlight_Types) do
        Highlight_Table[v] = {}
        Highlight_Color[v] = {Hue = 0, Sat = 0, Value = 0}
        Highlight_Toggle[v] = {Enabled = false}
    end
    local Highlight_Folder = workspace:FindFirstChild("Highlight_Folder") or Instance.new("Folder", workspace)
    Highlight_Folder.Name = "Highlight_Folder"
    local Transparent_Closet = {Enabled = false}
    local Transparent_Closet_Table = {}
    local Highlight_Connections = {}
    local function add_esp(obj, Type, text, room)
        if (not obj) then return warn("[add_esp]: Nil object gotten!") end
        if string.find(string.lower(text), "nil") then return warn("[add_esp]: nil text value detected!") end
        for i,v in pairs(Highlight_Table) do
            for i2, v2 in pairs(v) do
                if v2.Object == obj then
                    if v2.Main then return end
                end
            end
        end
        if (not Highlight_Toggle[Type].Enabled) then return end
        local esp_color = Color3.fromHSV(Highlight_Color[Type].Hue, Highlight_Color[Type].Sat, Highlight_Color[Type].Value)
        local esp = Instance.new("Highlight")
        esp.Name = "Highlight_"..(obj.Name or "unknown_obj_name")
        esp.Parent = Highlight_Folder
        esp.Adornee = obj
        esp.FillColor = esp_color

        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "NameTag"
        billboardGui.Adornee = obj
        billboardGui.Size = UDim2.new(0, 100, 0, 50)
        billboardGui.StudsOffset = Vector3.new(0, 0, 0) 
        --[[if placeAbove then
            billboardGui.StudsOffset = Vector3.new(0, 2, 0) 
        else
            billboardGui.StudsOffset = Vector3.new(0, 0, 0) 
        end--]]
        billboardGui.AlwaysOnTop = true
        billboardGui.Parent = obj

        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = text
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextScaled = true
        nameLabel.TextColor3 = esp_color
        nameLabel.Parent = billboardGui

        --[[local connection = game:GetService("RunService").RenderStepped:Connect(function()
            pcall(function()
                if obj and obj:IsDescendantOf(workspace) then
                    local lplr = game.Players.LocalPlayer
                    local char = lplr.Character
                    local head = char:FindFirstChild("Head")
                    if head then
                        local distance = (obj.Position - head.Position).Magnitude
                        billboardGui.Size = UDim2.new(0, math.clamp(1000 / distance, 50, 150), 0, math.clamp(500 / distance, 25, 75))
                    end
                end
            end)
        end)
        table.insert(Highlight_Connections, connection)--]]

        table.insert(Highlight_Table[Type], {
            Main = esp,
            BillGUI = billboardGui,
            NameGUI = nameLabel,
            --Connection = connection,
            Room = room,
            Object = obj
        })

        Highlight_CoreConnections.SelfDestructEvent.Event:Connect(function()
            pcall(function()
                esp:Destroy()
                BillGUI:Destroy()
            end)
        end)
    end
    local function check_esp(newTable)
        local function isValid(room)
            for i,v in pairs(newTable) do 
                if v == room then
                    return true 
                end 
            end
            return false
        end
        for i,v in pairs(Highlight_Table) do
            for i2, v2 in pairs(v) do
                if (not isValid(v2.Room)) then
                    pcall(function()
                        v2.Main:Destroy()
                        v2.BillGUI:Destroy()
                        --v2.Connection:Disconnect()
                    end)
                end
            end
        end
    end
    local function is_connection(con)
        for i,v in pairs(Highlight_Connections) do
            if v == con then return true end
        end
        return false
    end
    local oldTable = {}
    Highlight = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = "1[DOORS] Highlight V3",
        Function = function(callback)
            if callback then
                Highlight_Folder = workspace:FindFirstChild("Highlight_Folder") or Instance.new("Folder", workspace)
                Highlight_Folder.Name = "Highlight_Folder"
                task.spawn(function()
                    --repeat
                        local valid_rooms = {}
                        for i,v in pairs(game.workspace.CurrentRooms:GetChildren()) do
                            if v:FindFirstChild("Door") then 
                                if (not v:FindFirstChild("Door"):GetAttribute("Opened")) then
                                    table.insert(valid_rooms, v)
                                end
                            end
                        end
                        local function check_rooms(valid_rooms)
                            check_esp(valid_rooms)
                            for i,v in pairs(valid_rooms) do
                                local room50_key = {}
                                local function check_child(v2)
                                    if v2.Name == "Door" and v2.ClassName == "Model" and v2:FindFirstChild("Door") then
                                        local num = v2:GetAttribute("RoomID")
                                        add_esp(v2:FindFirstChild("Door"), "Door", "Room "..tostring(num), v)
                                    elseif v2.Name == "RushMoving" and v2.ClassName == "Model" then
                                        add_esp(v2, "Entity", "Rush", v)
                                    elseif v2.Name == "Eyes" and v2.ClassName == "Model" and v2:FindFirstChild("Core") then
                                        add_esp(v2, "Entity", "Eyes", v)
                                    end
                                end
                                local checked = {}
                                local function isChecked(a)
                                    for i,v in pairs(checked) do
                                        if v == a then return true end
                                    end
                                    return false
                                end
                                local function check_descendant(v2)
                                    if v2.Name == "GoldPile" then
                                        local gold = v2:GetAttribute("GoldValue")
                                        add_esp(v2, "Item", tostring(gold).." gold", v)
                                    elseif v2.Name == "DrawerContainer" then
                                        local con = v2.ChildAdded:Connect(function(child)
                                            if child.Name == "GoldPile" and child.ClassName == "Model" then
                                                local gold = child:GetAttribute("GoldValue")
                                                if gold then
                                                    add_esp(child, "Item", tostring(gold).." gold", v)
                                                end
                                            elseif child.Name == "Bandage" and child.ClassName == "Model" then
                                                add_esp(child, "Item", "Bandage", v)
                                            end
                                        end)
                                        if (not is_connection(con)) then 
                                            table.insert(Highlight_Connections, con)
                                        end
                                    elseif v2.Name == "Bandage" then
                                        add_esp(v2, "Item", "Bandage", v)
                                    elseif v2.Name == "KeyObtain" then
                                        add_esp(v2, "Item", "Key", v)
                                    elseif v2.Name == "LeverForGate" and v2:FindFirstChild("ActivateEventPrompt") then
                                        add_esp(v2, "Item", "Lever", v)
                                    elseif v2.Name == "Candle" and v2.ClassName == "Model" then
                                        add_esp(v2, "Item", "Candle", v)
                                    elseif v2.Name == "FigureRig" and v2.ClassName == "Model" then
                                        add_esp(v2, "Entity", "Figure", v)
                                    elseif v2.Name == "LiveHintBook" and v.Name == "50" and v2.ClassName == "Model" and v2.Parent.Name == "Modular_Bookshelf" and v2.Parent.ClassName == "Model" then
                                        add_esp(v2, "Item", "Book", v)
                                    elseif v.Name == "50" and v2.Name == "Number" and v2.ClassName == "MeshPart" and v2:GetAttribute("ID") and v2:FindFirstChild("Hint") and v2.Parent.Name == "Padlock" and v2.Parent.ClassName == "Model" and #room50_key < 5 then
                                        local num = tostring(v2:GetAttribute("ID"))
                                        if (not string.find(string.lower(num), "nil")) then
                                            for i,v in pairs(room50_key) do
                                                if v.Object ~= v2 then
                                                    table.insert(room50_key, {
                                                        Object = v2,
                                                        Number = num
                                                    })
                                                    if #room50_key > 4 then
                                                        local real_code = ""
                                                        for i,v in pairs(room50_key) do
                                                            real_code = real_code..v.Number
                                                        end
                                                        warningNotification("Voidware", "The code for the padlock is "..real_code, 7)
                                                    end
                                                end
                                            end
                                        end
                                    elseif v2.Name == "Wardrobe" and v2.ClassName == "Model" and v2:FindFirstChild("Main") and v2.Parent.Name == "Assets" and v2.Parent.ClassName == "Folder" and v2:FindFirstChild("Door1") and v2:FindFirstChild("Door2") then
                                        add_esp(v2, "Closet", "Closet", v)
                                        if Transparent_Closet.Enabled then
                                            local door1 = v2:FindFirstChild("Door1")
                                            local door2 = v2:FindFirstChild("Door2")
                                            local oldtran1 = v2:FindFirstChild("Door1").Transparency
                                            local oldtran2 = v2:FindFirstChild("Door2").Transparency
                                            door1.Transparency = 0.7
                                            door2.Transparency = 0.7
                                            table.insert(Transparent_Closet_Table, {
                                                Object = door1,
                                                Change = oldtran1
                                            })
                                            table.insert(Transparent_Closet_Table, {
                                                Object = door2,
                                                Change = oldtran2
                                            })
                                        end
                                    end
                                end
                                local function check_children()
                                    for i2, v2 in pairs(v:GetChildren()) do
                                        if (not isChecked(v2)) then
                                            table.insert(checked, v2)
                                            check_child(v2)
                                        end
                                    end
                                end
                                local function check_descendants()
                                    for i2, v2 in pairs(v:GetDescendants()) do
                                        if (not isChecked(v2)) then
                                            table.insert(checked, v2)
                                            check_descendant(v2)
                                        end
                                    end
                                end
                                local con1 = v.ChildAdded:Connect(function(child) if (not isChecked(child)) then check_child(child) end end)
                                local con2 = v.DescendantAdded:Connect(function(descendant) if (not isChecked(descendant)) then check_descendant(descendant) end end)
                                local con3 = workspace.ChildAdded:Connect(function(child) if (not isChecked(child)) then check_child(child) end end)
                                table.insert(Highlight_Connections, con1)
                                table.insert(Highlight_Connections, con2)
                                table.insert(Highlight_Connections, con3)
                                check_children()
                                check_descendants()
                            end
                        end
                        check_rooms(valid_rooms)
                        game.workspace.CurrentRooms.ChildAdded:Connect(function()
                            valid_rooms = {}
                            for i,v in pairs(game.workspace.CurrentRooms:GetChildren()) do
                                if v:FindFirstChild("Door") then 
                                    if (not v:FindFirstChild("Door"):GetAttribute("Opened")) then
                                        table.insert(valid_rooms, v)
                                    end
                                end
                            end
                            check_rooms(valid_rooms)
                        end)
                        --[[if valid_rooms ~= oldTable then
                            oldTable = valid_rooms
    
                        end--]]
                        --task.wait(0.1)
                    --until (not Highlight.Enabled)
                end)
            else
                task.spawn(function()
                    Highlight_CoreConnections.SelfDestructEvent:Fire()
                    pcall(function()
                        for i,v in pairs(Highlight_Table) do
                            for i2, v2 in pairs(v) do
                                v2.Main:Destroy()
                                v2.BillGUI:Destroy()
                                --v2.Connection:Disconnect()
                            end
                        end
                        Highlight_Folder:Destroy()
                    end)
                    for i, v in pairs(Highlight_Connections) do
                        if v.Disconnect then pcall(function() v:Disconnect() end) continue end
                        if v.disconnect then pcall(function() v:disconnect() end) continue end
                    end
                    Highlight_Table = {}
                    for i,v in pairs(Highlight_Types) do
                        Highlight_Table[v] = {}
                    end
                    for i,v in pairs(Transparent_Closet_Table) do
                        pcall(function()
                            v.Object.Transparency = v.Change
                        end)
                    end
                end)
            end
        end
    })
    for i,v in pairs(Highlight_Types) do
        Highlight_Color[v] = Highlight.CreateColorSlider({
            Name = v.." Color",
            Function = function(h,s,v1)
                for i2,v2 in pairs(Highlight_Table[v]) do
                    v2.Main.FillColor = Color3.fromHSV(h,s,v1)
                    v2.NameGUI.TextColor3 = Color3.fromHSV(h,s,v1)
                end
            end
        })
        Highlight_Color[v].Object.Visible = false
        Highlight_Toggle[v] = Highlight.CreateToggle({
            Name = v.." Color",
            Function = function(callback)
                if callback then
                    Highlight_Color[v].Object.Visible = true
                    if Highlight.Enabled then
                        Highlight.ToggleButton(false)
                        Highlight.ToggleButton(false)
                    end
                else
                    Highlight_Color[v].Object.Visible = false
                    if Highlight.Enabled then
                        Highlight.ToggleButton(false)
                        Highlight.ToggleButton(false)
                    end
                end
            end
        })
    end
    Transparent_Closet = Highlight.CreateToggle({
        Name = "Transparent Closet",
        Function = function(callback)
            if callback then
                if Highlight.Enabled then
                    Highlight.ToggleButton(false)
                    Highlight.ToggleButton(false)
                end
            else
                for i,v in pairs(Transparent_Closet_Table) do
                    pcall(function()
                        v.Object.Transparency = v.Change
                    end)
                end
            end
        end
    })
end)
run(function()
    local AutoInteract = {Enabled = false}
    local FastInteract = {Enabled = false}
    local AutoInteract_Connections = {}
    local AutoInteract_Messages = {}
    local function safeNotify(msg, room, target)
        local function canProceed()
            for i,v in pairs(AutoInteract_Messages) do
                if v.msg == msg and v.room == room and v.target == target then return false end
            end
            return true
        end
        if canProceed() then
            warningNotification("Voidware", msg, 5)
        end
    end
    local oldTable = {}
    AutoInteract = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = "1[DOORS] AutoInteract",
        Function = function(callback)
            if callback then
                task.spawn(function()
                    repeat 
                        local valid_rooms = {}
                        for i,v in pairs(game.workspace.CurrentRooms:GetChildren()) do
                            if v:FindFirstChild("Door") then 
                                if (not v:FindFirstChild("Door"):GetAttribute("Opened")) then
                                    table.insert(valid_rooms, v)
                                end
                            end
                        end
                        if valid_rooms ~= oldTable then
                            oldTable = valid_rooms
                            for i,v in pairs(valid_rooms) do
                                local function check_child(v2)
                                    if v2.Name == "Door" and v2.ClassName == "Model" and v2:FindFirstChild("Door") and v2:FindFirstChild("Lock") and FastInteract.Enabled then
                                        local prompt = v2:FindFirstChild("Lock"):FindFirstChild("UnlockPrompt")
                                        if prompt then
                                            if prompt.ClassName == "ProximityPrompt" then
                                                local room = tostring(v2:GetAttribute("RoomID"))
                                                if (not string.find(string.lower(room), "nil")) then
                                                    if prompt.HoldDuration ~= 0 then
                                                        prompt.HoldDuration = 0
                                                        --safeNotify("Locked door detected for room "..room.."! Set the proximityprompt delay to 0", v, prompt)
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                                local function check_descendant(v2)
                                    local prompt
                                    if v2.Name == "LootPrompt" and v2.ClassName == "ProximityPrompt" then
                                        prompt = v2
                                    elseif v2.Name == "ModulePrompt" and v2.ClassName == "ProximityPrompt" then
                                        prompt = v2
                                    elseif v2.Name == "UnlockPrompt" and v2.Parent.Name == "Lock" and v2.Parent.ClassName == "MeshPart" then
                                        prompt = v2
                                    elseif v2.Name == "ActivateEventPrompt" and v2.Parent.Name == "Knobs" and v2.Parent.Parent.Name == "DrawerContainer" then
                                        prompt = v2
                                    elseif v2.Name == "ActivateEventPrompt" and v2.Parent.Name == "LeverForGate" then
                                        prompt = v2
                                    elseif v2.Name == "ActivateEventPrompt" and v2.Parent.Name == "LiveHintBook" and v.Name == "50" and v2.Parent.ClassName == "Model" then
                                        prompt = v2
                                    end
                                    if prompt then
                                        if prompt.ClassName == "ProximityPrompt" then
                                            task.spawn(function() pcall(function() fireproximityprompt(prompt, 1) end) end)
                                        end
                                    end
                                end
                                local function check_children()
                                    for i2, v2 in pairs(v:GetChildren()) do
                                        check_child(v2)
                                    end
                                end
                                local function check_descendants()
                                    for i2, v2 in pairs(v:GetDescendants()) do
                                        check_descendant(v2)
                                    end
                                end
                                check_children()
                                check_descendants()
                                local con1 = v.DescendantAdded:Connect(function(descendant)
                                    check_descendant(descendant)
                                end)
                                local con2 = v.ChildAdded:Connect(function(child)
                                    check_child(child)
                                end)
                                table.insert(AutoInteract_Connections, con1)
                                table.insert(AutoInteract_Connections, con2)
                            end
                        end
                        task.wait(0.1)
                    until (not AutoInteract.Enabled)
                end)
            else
                for i, v in pairs(AutoInteract_Connections) do
                    if v.Disconnect then pcall(function() v:Disconnect() end) continue end
                    if v.disconnect then pcall(function() v:disconnect() end) continue end
                end
            end
        end
    })
    FastInteract = AutoInteract.CreateToggle({
        Name = "Fast Interact",
        Function = function() end,
        Default = true
    })
end)
run(function()
    local EntityNotify = {Enabled = false}
    local EntityNotify_Connections = {}
    EntityNotify = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = "1[DOORS] EntityNotify",
        Function = function(callback)
            if callback then
                task.spawn(function()
                    local function check_child(v2, deleted)
                        if v2.Name == "RushMoving" and v2.ClassName == "Model" then
                            if deleted then
                                errorNotification("Voidware", "Rush has despawned!", 5)
                            else
                                errorNotification("Voidware", "Rush has spawned!", 5)
                            end
                        elseif string.find(string.lower(v2.Name), "ambush") then 
                            if deleted then
                                errorNotification("Voidware", "Ambush has despawned!", 5)
                            else
                                errorNotification("Voidware", "Ambush has spawned!", 5)
                            end
                        elseif v2.Name == "Eyes" and v2:FindFirstChild("Core") then
                            if deleted then
                                errorNotification("Voidware", "Eyes has despawned!", 5)
                            else
                                errorNotification("Voidware", "Eyes has spawned!", 5)
                            end
                        elseif v2.Name == "Screech" and v2.ClassName == "Model" then
                            if deleted then
                                errorNotification("Voidware", "Screech has despawned!", 5)
                            else
                                errorNotification("Voidware", "Screech has spawned!", 5)
                            end
                        end
                    end
                    local checked = {}
                    local function isChecked(a)
                        for i,v in pairs(checked) do
                            if v == a then return true end
                        end
                        return false
                    end
                    local function check_children()
                        for i2, v2 in pairs(workspace:GetChildren()) do
                            if (not isChecked(v2)) then
                                table.insert(checked, v2)
                                check_child(v2)
                            end
                        end
                    end
                    local con1 = workspace.ChildAdded:Connect(function(child) if (not isChecked(child)) then table.insert(checked, child); check_child(child) end end)
                    local con2 = workspace.Camera.ChildAdded:Connect(function(child) if (not isChecked(child)) then table.insert(checked, child); check_child(child) end end)
                    local con3 = workspace.Camera.ChildRemoved:Connect(function(child) if isChecked(child) then check_child(child, true) end end)
                    table.insert(EntityNotify_Connections, con1)
                    table.insert(EntityNotify_Connections, con2)
                    table.insert(EntityNotify_Connections, con3)
                    check_children()
                end)
            else
                for i, v in pairs(EntityNotify_Connections) do
                    if v.Disconnect then pcall(function() v:Disconnect() end) continue end
                    if v.disconnect then pcall(function() v:disconnect() end) continue end
                end
            end
        end
    })
end)
--[[local Notifications_Table = {}
local function has_already_notified(text)
    for i,v in pairs(Notifications_Table) do
        if v.Text == text then return true end
    end
    return false
end--]]
--[[run(function()
    local Highlight = {Enabled = false}
    local Highlight_Toggle = {
        ["Drawer"] = {Enabled = false},
        ["Door"] = {Enabled = false},
        ["Item"] = {Enabled = false},
        ["Entity"] = {Enabled = false}
    }
    local Highlight_Color = {
        ["Drawer"] = {Hue = 0, Sat = 0, Value = 0},
        ["Door"] = {Hue = 0, Sat = 0, Value = 0},
        ["Item"] = {Hue = 0, Sat = 0, Value = 0},
        ["Entity"] = {Hue = 0, Sat = 0, Value = 0}
    }
    local Highlight_Table = {}
    for i,v in pairs(Highlight_Color) do
        Highlight_Table[i] = Highlight_Table[i] or {}
    end
    local Highlight_Folder = Instance.new("Folder", game.workspace)
    Highlight_Folder.Name = "Highlight-Folder"
    Highlight_Folder.Parent = game.workspace
    local function add_esp(obj, tagName, placeAbove, Type)
        Highlight_Table[Type] = Highlight_Table[Type] or {}
        for i,v in pairs(Highlight_Table[Type]) do if v.Object == obj then return end end
        local esp = Instance.new("Highlight")
        esp.Name = "Highlight_"..(obj.Name or "unknown_obj_name")
        esp.Parent = Highlight_Folder
        esp.Adornee = obj
        esp.FillColor = Color3.fromHSV(Highlight_Color[Type].Hue, Highlight_Color[Type].Sat, Highlight_Color[Type].Value)
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "NameTag"
        billboardGui.Adornee = obj
        billboardGui.Size = UDim2.new(0, 100, 0, 50)
        if placeAbove then
            billboardGui.StudsOffset = Vector3.new(0, 2, 0) 
        else
            billboardGui.StudsOffset = Vector3.new(0, 0, 0) 
        end
        billboardGui.AlwaysOnTop = true
        billboardGui.Parent = obj
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = tagName
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextScaled = true
        nameLabel.TextColor3 = Color3.fromHSV(Highlight_Color[Type].Hue, Highlight_Color[Type].Sat, Highlight_Color[Type].Value)
        nameLabel.Parent = billboardGui
        local connection = game:GetService("RunService").RenderStepped:Connect(function()
            pcall(function()
                if obj and obj:IsDescendantOf(workspace) then
                    local player = game.Players.LocalPlayer
                    local character = player.Character or player.CharacterAdded:Wait()
                    local head = character:FindFirstChild("Head")
        
                    if head then
                        local distance = (obj.Position - head.Position).Magnitude
                        billboardGui.Size = UDim2.new(0, math.clamp(1000 / distance, 50, 150), 0, math.clamp(500 / distance, 25, 75))
                    end
                end
            end)
        end)

        table.insert(Highlight_Table[Type], {
            Main = esp,
            Object = obj,
            BillGUI = billboardGui,
            NameLabel = nameLabel,
            Connection = connection
        })

        GuiLibrary.SelfDestructEvent.Event:Connect(function()
            task.spawn(function()
                pcall(function()
                    connection:Disconnect()
                end)
            end)
        end)
    end
    local function remove_esp(obj, Type)
        Highlight_Table[Type] = Highlight_Table[Type] or {}
        for i,v in pairs(Highlight_Table[Type]) do
            if v.Object == obj then
                pcall(function()
                    v.Main:Destroy()
                    v.BillGUI:Destroy()
                    v.Connection:Disconnect()
                end)
            end
        end
    end
    local function isOpened(door)
        return door:GetAttribute("Opened")
    end
    Highlight = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = "1[DOORS] Highlight",
        Function = function(callback)
            if callback then
                if (not game.workspace:FindFirstChild("Highlight-Folder")) then Highlight_Folder = Instance.new("Folder", game.workspace); Highlight_Folder.Parent = game.workspace; Highlight_Folder.Name = "Highlight-Folder" end
                task.spawn(function()
                    repeat 
                        for i,v in pairs(game.workspace.CurrentRooms:GetChildren()) do
                            if v:FindFirstChild("Assets") then
                                if v.Assets.ClassName == "Folder" then
                                    if v:GetAttribute("RequiresKey") then
                                        local msg = "Locked room detected! Room "..v.Name
                                        if (not has_already_notified(msg)) then
                                            warningNotification("Voidware", msg, 5)
                                            table.insert(Notifications_Table, {
                                                Text = msg,
                                                Time = os.time(),
                                                Type = "locked_room"
                                            })
                                        end
                                    end
                                    for i3,v3 in pairs(v.Assets:GetDescendants()) do
                                        if v3.Name == "GoldPile" then
                                            local value = tostring(v3:GetAttribute("GoldValue"))
                                            local c1 = false
                                            if tonumber(value) > 1 then c1 = true end
                                            local text = value.." coin"..(c1 and "s")
                                            if (not isOpened(v:FindFirstChild("Door"))) then
                                                add_esp(v3, text, false, "Item")
                                            else
                                                remove_esp(v3, "Item")
                                            end
                                        end
                                    end
                                    for i2,v2 in pairs(v.Assets:GetChildren()) do
                                        if v2.Name == "LeverForGate" and v2.ClassName == "Model" then
                                            if (not isOpened(v:FindFirstChild("Door"))) then
                                                add_esp(v2, "Lever", true, "Item")
                                            else
                                                remove_esp(v2, "Item")
                                            end
                                        end
                                        if v2.Name == "KeyObtain" and v2.ClassName == "Model" then
                                            if (not isOpened(v:FindFirstChild("Door"))) then
                                                add_esp(v2, "Key", true, "Item")
                                            else
                                                remove_esp(v2, "Item")
                                            end
                                        end
                                        if v2.Name == "Dresser" and v2.ClassName == "Model" and #v2:GetChildren() > 2 then
                                            for i3, v3 in pairs(v2:GetChildren()) do
                                                if v3.Name == "DrawerContainer" and v3.ClassName == "Model" then
                                                    if v3:FindFirstChild("GoldPile") then
                                                        local value = tostring(v3:FindFirstChild("GoldPile"):GetAttribute("GoldValue"))
                                                        local c1 = false
                                                        if tonumber(value) > 1 then c1 = true end
                                                        local text = value.." coin"..(c1 and "s")
                                                        if (not isOpened(v:FindFirstChild("Door"))) then
                                                            add_esp(v3:FindFirstChild("GoldPile"), text, false, "Item")
                                                        else
                                                            remove_esp(v3:FindFirstChild("GoldPile"), "Item")
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            if v:FindFirstChild("Door") then
                                local msg = "Door "..v.Name
                                if (not v:FindFirstChild("Door"):GetAttribute("Opened")) then
                                    add_esp(v:FindFirstChild("Door"):FindFirstChild("Door"), msg, true, "Door")
                                else
                                    remove_esp(v:FindFirstChild("Door"):FindFirstChild("Door"), "Door")
                                end
                            end
                        end
                        task.wait(0.01)
                    until (not Highlight.Enabled)
                end)
            else
                task.spawn(function()
                    pcall(function()
                        Highlight_Folder:Destroy()
                    end)
                    pcall(function()
                        for i,v in pairs(Highlight_Table) do
                            for i2, v2 in pairs(v) do
                                v2.BillboardGui:Destroy()
                            end
                        end
                    end)
                    Highlight_Table = {}
                end)
            end
        end
    })
    for i,v in pairs(Highlight_Color) do
        v = Highlight.CreateColorSlider({
            Name = tostring(i).." Color",
            Function = function(h,s,v)
                task.spawn(function()
                    repeat task.wait() until #Highlight_Table[tostring(i)] > 0 
                    for i2, v2 in pairs(Highlight_Table[tostring(i)]) do
                        v2.Main.FillColor = Color3.fromHSV(h, s, v)
                        v2.NameLabel.TextColor3 = Color3.fromHSV(h, s, v)
                    end
                end)
            end
        })
        v.Object.Visible = false
    end
    for i,v in pairs(Highlight_Toggle) do
        v = Highlight.CreateToggle({
            Name = tostring(i).." Color Toggle",
            Function = function(callback)
                local module_name = "1[DOORS] Highlight"
                local Type = tostring(i).." Color"
                local full_obj = module_name..Type.."SliderColor"
                if callback then
                    if GuiLibrary.ObjectsThatCanBeSaved[full_obj] then
                        GuiLibrary.ObjectsThatCanBeSaved[full_obj].Object.Visible = true
                    end
                else
                    if GuiLibrary.ObjectsThatCanBeSaved[full_obj] then
                        GuiLibrary.ObjectsThatCanBeSaved[full_obj].Object.Visible = false
                    end
                end
            end
        })
    end
end)--]] -- old highlight
--[[run(function()
    local AutoLoot = {Enabled = false}
    AutoLoot = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = "1[DOORS] AutoLoot",
        Function = function(callback)
            if callback then
                task.spawn(function()
                    repeat
                        for i,v in pairs(game.workspace.CurrentRooms:GetChildren()) do
                            if v:FindFirstChild("Assets") then
                                if v.Assets.ClassName == "Folder" then
                                    for i2,v2 in pairs(v.Assets:GetChildren()) do
                                        if v2.Name == "Dresser" and v2.ClassName == "Model" and #v2:GetChildren() > 2 then
                                            for i3, v3 in pairs(v2:GetChildren()) do
                                                if v3.Name == "DrawerContainer" and v3.ClassName == "Model" then
                                                    if v3:FindFirstChild("GoldPile") then
                                                        task.spawn(function()
                                                            repeat 
                                                                task.wait(0.01)
                                                                fireproximityprompt(v3:FindFirstChild("GoldPile"):FindFirstChild("LootPrompt"), 1)
                                                            until (not v3:FindFirstChild("GoldPile"))
                                                        end)
                                                    else
                                                        if v3:FindFirstChild("Knobs") then
                                                            pcall(function()
                                                                fireproximityprompt(v3:FindFirstChild("Knobs"):FindFirstChild("ActivateEventPrompt"), 1)
                                                            end)
                                                        end
                                                    end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                        task.wait(0.01)
                    until (not AutoLoot.Enabled)
                end)
            end
        end
    })
end)--]] -- old autoloot
--[[run(function()
    local InstantInteract = {Enabled = false}
    InstantInteract = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = "1[DOORS] InstantInteract",
        Function = function(callback)
            if callback then
                task.spawn(function()
                    repeat 
                        for i,v in pairs(game.workspace.CurrentRooms:GetChildren()) do
                            if v:FindFirstChild("Assets") then
                                if v.Assets.ClassName == "Folder" then
                                    if v:GetAttribute("RequiresKey") then
                                        if v:FindFirstChild("Door") then
                                            pcall(function()
                                                local door = v:FindFirstChild("Door")
                                                local lock = door:FindFirstChild("Lock")
                                                if lock then
                                                    local prompt = lock:FindFirstChild("UnlockPrompt")
                                                    prompt.HoldDuration = 0
                                                end
                                                local msg = "Set the interaction time to instant for the locked door in room "..v.Name.."!"
                                                if (not has_already_notified(msg)) then
                                                    warningNotification("Voidware", msg, 5)
                                                    table.insert(Notifications_Table, {
                                                        Text = msg,
                                                        Time = os.time(),
                                                        Type = "locked_door_slowmode"
                                                    })
                                                end
                                            end)
                                        end
                                    end
                                end
                            end
                        end
                        task.wait(0.01)
                    until (not InstantInteract.Enabled)
                end)
            else

            end
        end
    })
end)--]] -- old instant interact
--[[run(function()
    local AutoLoot = {Enabled = false}
    AutoLoot = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = "1[DOORS] AutoLoot V2",
        Function = function(callback)
            if callback then
                task.spawn(function()
                    repeat
                        local lplr = game.Players.LocalPlayer
                        local char = lplr.Character
                        local head = char:WaitForChild("LowerTorso")
                        local valid_rooms = {}
                        for i, v in pairs(game.workspace.CurrentRooms:GetChildren()) do
                            if not v:WaitForChild("Door"):GetAttribute("Opened") then
                                table.insert(valid_rooms, v)
                            end
                        end
                        for i, v in pairs(valid_rooms) do
                            for i2, v2 in pairs(v:GetDescendants()) do
                                task.spawn(function()
                                    pcall(function()
                                        local prompt
                                        if v2.Name == "GoldPile" then
                                            prompt = v2:FindFirstChild("LootPrompt")
                                        elseif v2.Name == "DrawerContainer" then
                                            prompt = v2:FindFirstChild("Knobs"):FindFirstChild("ActivateEventPrompt")
                                        elseif v2.Name == "KeyObtain" then
                                            prompt = v2:FindFirstChild("ModulePrompt")
                                        elseif v2.Name == "Lock" then
                                            prompt = v2:FindFirstChild("UnlockPrompt")
                                        elseif v2.Name == "RolltopContainer" then
                                            prompt = v2:FindFirstChild("Knobs"):FindFirstChild("ActivateEventPrompt")
                                        elseif v2.Name == "Lighter" then
                                            prompt = v2:FindFirstChild("ModulePrompt")
                                        elseif v2.Name == "LeverForGate" then
                                            prompt = v2:FindFirstChild("ActivateEventPrompt")
                                        elseif v2.Name == "Candle" then
                                            prompt = v2:FindFirstChild("ModulePrompt")
                                        end
                                        if prompt then
                                            fireproximityprompt(prompt, 1)
                                            --local distance = (head.Position - prompt.Parent.Position).Magnitude
                                            --print(prompt, distance, prompt.MaxActivationDistance)
                                            --if distance <= prompt.MaxActivationDistance + 10 then
                                            --    print("yes", prompt)
                                            --    fireproximityprompt(prompt, 1)
                                            --end
                                        end
                                    end)
                                end)
                            end
                        end
                        task.wait(0.1)                        
                    until (not AutoLoot.Enabled)
                end)
            end
        end
    })
end)--]] -- old autoloot v2
--[[run(function()
    local Highlight = {Enabled = false}
    local Highlight_Types = {"Item", "Door", "Closet", "Entity"}
    local Highlight_Table = {}
    local Highlight_Color = {}
    local Highlight_Toggle = {}
    local Highlight_Folder = workspace:FindFirstChild("Highlight_Folder") or Instance.new("Folder", workspace)
    Highlight_Folder.Name = "Highlight_Folder"
    for i,v in pairs(Highlight_Types) do 
        Highlight_Table[v] = {}
        Highlight_Color[v] = {Hue = 0, Sat = 0, Value = 0}
        Highlight_Toggle[v] = {Enabled = false}
    end
    local function add_esp(obj, tagName, placeAbove, Type)
        Highlight_Table[Type] = Highlight_Table[Type] or {}
        for i,v in pairs(Highlight_Table[Type]) do if v.Object == obj then return end end
        local esp = Instance.new("Highlight")
        esp.Name = "Highlight_"..(obj.Name or "unknown_obj_name")
        esp.Parent = Highlight_Folder
        esp.Adornee = obj
        esp.FillColor = Color3.fromHSV(100, 100, 100)
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "NameTag"
        billboardGui.Adornee = obj
        billboardGui.Size = UDim2.new(0, 100, 0, 50)
        if placeAbove then
            billboardGui.StudsOffset = Vector3.new(0, 2, 0) 
        else
            billboardGui.StudsOffset = Vector3.new(0, 0, 0) 
        end
        billboardGui.AlwaysOnTop = true
        billboardGui.Parent = obj
        local nameLabel = Instance.new("TextLabel")
        nameLabel.Text = tagName
        nameLabel.Size = UDim2.new(1, 0, 1, 0)
        nameLabel.BackgroundTransparency = 1
        nameLabel.TextScaled = true
        nameLabel.TextColor3 = Color3.fromHSV(100, 100, 100)
        nameLabel.Parent = billboardGui
        local connection = game:GetService("RunService").RenderStepped:Connect(function()
            pcall(function()
                if obj and obj:IsDescendantOf(workspace) then
                    local player = game.Players.LocalPlayer
                    local character = player.Character or player.CharacterAdded:Wait()
                    local head = character:FindFirstChild("Head")
        
                    if head then
                        local distance = (obj.Position - head.Position).Magnitude
                        billboardGui.Size = UDim2.new(0, math.clamp(1000 / distance, 50, 150), 0, math.clamp(500 / distance, 25, 75))
                    end
                end
            end)
        end)

        local ESP_Table = {
            Main = esp,
            Object = obj,
            BillGUI = billboardGui,
            NameLabel = nameLabel,
            Connection = connection
        }

        table.insert(Highlight_Table[Type], ESP_Table)

        GuiLibrary.SelfDestructEvent.Event:Connect(function()
            task.spawn(function()
                pcall(function()
                    connection:Disconnect()
                end)
            end)
        end)
        return ESP_Table
    end
    local ESP_Checking_Table = {}
    local function check_esp_validity(newTable)
        local function isValid(room)
            for i,v in pairs(newTable) do
                if v == room then return true end
            end
            return false
        end
        for i,v in pairs(ESP_Checking_Table) do
            if (not isValid(v.Room)) then
                pcall(function()
                    v.ESP_Table.Main:Destroy()
                    v.ESP_Table.BillGUI:Destroy()
                    v.ESP_Table.Connection:Disconnect()
                end)
            end
        end
    end
    local oldTable = {}
    Highlight = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = "1[DOORS] Highlight V2",
        Function = function(callback)
            if callback then
                local Highlight_Folder = workspace:FindFirstChild("Highlight_Folder") or Instance.new("Folder", workspace)
                Highlight_Folder.Name = "Highlight_Folder"
                task.spawn(function()
                    repeat
                        local valid_rooms = {}
                        for i,v in pairs(game.workspace.CurrentRooms:GetChildren()) do
                            if not v:WaitForChild("Door"):GetAttribute("Opened") then
                                table.insert(valid_rooms, v)
                            end
                        end
                        task.wait(0.1)
                        if valid_rooms == oldTable then return end
                        oldTable = valid_rooms
                        check_esp_validity(valid_rooms)
                        for i,v in pairs(valid_rooms) do
                            for i2,v2 in pairs(v:GetDescendants()) do
                                if v2.Name == "GoldPile" and v2.ClassName == "Model" then
                                    local value = v2:GetAttribute("GoldValue")
                                    local name = tostring(value).." gold"
                                    local esp_table = add_esp(v2, tostring(value).." gold", false, "Item")
                                    table.insert(ESP_Checking_Table, {
                                        ESP_Table = esp_table,
                                        Room = v
                                    })
                                elseif v2.Name == "LeverForGate" and v2.ClassName == "Model" then
                                    local esp_table = add_esp(v2, "Lever", false, "Item")
                                    table.insert(ESP_Checking_Table, {
                                        ESP_Table = esp_table,
                                        Room = v
                                    })
                                elseif v2.Name == "KeyObtain" and v2.ClassName == "Model" then
                                    local esp_table = add_esp(v2, "Key", false, "Item")
                                    table.insert(ESP_Checking_Table, {
                                        ESP_Table = esp_table,
                                        Room = v
                                    })
                                elseif v2.Name == "Door" and v2.ClassName == "Model" then
                                    local obj = v2:FindFirstChild("Door")
                                    local number = v2:GetAttribute("RoomID")
                                    number = tostring(number)
                                    local esp_table = add_esp(obj, "Door "..number, false, "Door")
                                    table.insert(ESP_Checking_Table, {
                                        ESP_Table = esp_table,
                                        Room = v
                                    })
                                elseif string.find(string.lower(v2.Name), "rush") then
                                    local esp_table = add_esp(v2, "Rush", false, "Entity")
                                elseif string.find(string.lower(v2.Name), "eyes") then
                                    local esp_table = add_esp(v2, "Eyes", false, "Entity")
                                elseif v2.Name == "Candle" and v2.ClassName == "Model" then
                                    local esp_table = add_esp(v2, "Candle", false, "Item")
                                    table.insert(ESP_Checking_Table, {
                                        ESP_Table = esp_table,
                                        Room = v
                                    })
                                elseif v2.Name == "Wardrobe" and v2.ClassName == "Model" then
                                    local esp_table = add_esp(v2, "Wardrobe", false, "Item")
                                    table.insert(ESP_Checking_Table, {
                                        ESP_Table = esp_table,
                                        Room = v
                                    })
                                end
                            end
                        end
                    until (not Highlight.Enabled)
                end)
            else
                pcall(function()
                    Highlight_Folder:Destroy()
                    for i,v in pairs(Highlight_Table) do
                        for i2, v2 in pairs(v) do
                            v2.BillGUI:Destroy()
                            v2.Connection:Disconnect()
                        end
                    end
                end)
            end
        end
    })
end)--]] -- old highlight v2
--[[run(function()
    local EntityNotify = {Enabled = false}
    local oldtable = {}
    local Notifications_Table = {}
    local function safeNotify(msg, obj)
        for i,v in pairs(Notifications_Table) do
            if v.Object == obj then return end
        end
        warningNotification("Voidware", msg, 5)
        table.insert(Notifications_Table, {Object = obj, Message = msg, Time = os.time()})
    end
    EntityNotify = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = "1[DOORS] EntityNotify",
        Function = function(callback)
            if callback then
                task.spawn(function()
                    repeat 
                        local newtable = game.workspace:GetDescendants()
                        if newtable ~= oldtable then
                            oldtable = newtable
                            for i,v in pairs(newtable) do
                                if string.find(string.lower(v.Name), "rush") then
                                    safeNotify("Rush has spawned!", v)
                                elseif string.find(string.lower(v.Name), "eyes") then
                                    safeNotify("Eyes has spawned!", v)
                                elseif string.find(string.lower(v.Name), "ambush") then
                                    safeNotify("Ambush has spawned!", v)
                                end
                            end
                        end
                        task.wait(0.1)
                    until (not EntityNotify.Enabled)
                end)
            end
        end
    })
end)--]] -- old entitynotify
--[[local function ac_bypass()
    game:GetService("Players").LocalPlayer.PlayerGui.MainUI.ItemShop:Destroy()
    --require(game:GetService("Players").LocalPlayer.PlayerGui.MainUI.Initiator.Main_Game).freemouse = false
   -- game:GetService("ReplicatedStorage").ClientModules.EntityModules.Void:Destroy()
end
run(function()
    local AnticheatBypass = {Enabled = false}
    AnticheatBypass = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = "1[DOORS] AnticheatBypass",
        Function = function(callback)
            if callback then
                ac_bypass()
            end
        end
    })
end)--]]