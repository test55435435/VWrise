local VData = {}

local Api_Url = "https://whitelist.vapevoidware.xyz/GlobalFunctions.json"

assert(not shared.GlobalFunctionsHandlerExecuted, "Vape Already Injected 2")
shared.GlobalFunctionsHandlerExecuted = true

task.spawn(function()
    repeat task.wait() until VoidwareFunctions
    VoidwareFunctions.SelfDestructEvent.Event:Connect(function()
        shared.GlobalFunctionsHandlerExecuted = nil
    end)    
end)

function VData.GetUserSha(plr)
    repeat task.wait() until shared.vapewhitelist
    repeat task.wait() until shared.vapewhitelist.loaded

    if shared.vapewhitelist.localprio > 0 then
        local plrstr = shared.vapewhitelist:hash(plr.Name..plr.UserId)
		return true, plrstr
    else
        return false, nil
    end
end

VData.GetVoidwareAPI = function()
    return game:HttpGet(Api_Url, true)
end

VData.olddata = isfile('vape/Libraries/vdata.json') and readfile('vape/Libraries/vdata.json') or nil

local function waitForWL()
    repeat task.wait() until shared.vapewhitelist
    repeat task.wait() until shared.vapewhitelist.loaded
end

local function isValidSha(sha)
    if sha then
        sha = tostring(sha)
        local wlUsers = shared.vapewhitelist.data.WhitelistedUsers
        if type(wlUsers) == "table" then
            for i,v in pairs(wlUsers) do
                local cw = wlUsers[i]
                if cw["hash"] == sha then
                    if cw["level"] then
                        cw["level"] = tonumber(cw["level"])
                        if cw["level"] > shared.vapewhitelist.localprio then
                            return true, cw
                        end
                    end
                end
            end
            return false, nil
        else
            return false, nil
        end
    else
        return false, nil
    end
end

local function getWLTag(data)
    if data and type(data) == "table" then
        if data["tags"] and type(data["tags"]) == "table" then
            if data["tags"][1] and type(data["tags"][1]) == "table" then
                if data["tags"][1]["text"] then
                    data["tags"][1]["text"] = tostring(data["tags"][1]["text"])
                    return true, data["tags"][1]["text"]
                else
                    return false, nil
                end
            else
                return false, nil
            end
        else
            return false, nil
        end
    else
        return false, nil
    end
end

local function isValidCommand(cmd)
    if type(shared.vapewhitelist.commands) == "table" then
        for i,v in pairs(shared.vapewhitelist.commands) do
            task.wait(0.3)
            local cc = shared.vapewhitelist.commands[i]
            if i == cmd then
                return true, cc
            end
        end
        return false, nil
    else
        return false, nil
    end
end

local function Read_Global_Commands_Data(data)
    local directory = 'vape/Libraries/processdata.txt'
    local processfile = isfile(directory) and readfile(directory) or "{}"
    local processdata = game:GetService("HttpService"):JSONDecode(processfile) or {}

    if data and type(data) == "table" then
        for i, v in pairs(data) do
            task.wait(0.5)
            local cdata = data[i]
            local actionid = tostring(cdata["id"] or "")
            
            if cdata["Expiry"] then
                local expirytime = cdata["Expiry"]
                local currentTime = os.time()
                local expiryts = os.time({
                    year = tonumber(string.sub(expirytime, 1, 4)),
                    month = tonumber(string.sub(expirytime, 6, 7)),
                    day = tonumber(string.sub(expirytime, 9, 10)),
                    hour = tonumber(string.sub(expirytime, 12, 13)),
                    min = tonumber(string.sub(expirytime, 15, 16)),
                    sec = tonumber(string.sub(expirytime, 18, 19))
                })
                if currentTime > expiryts then
                    processdata[actionid] = true
                    writefile(directory, game:GetService("HttpService"):JSONEncode(processdata))
                    continue
                end
            end
            
            if actionid == "cmdrp" or (actionid ~= "" and (not processdata[actionid])) then
                print('cmd executed')
                if cdata["Command"] and cdata["Sender"] and type(cdata["Sender"]) == "table" and cdata["Receiver"] and cdata["Type"] then
                    cdata["Command"] = tostring(cdata["Command"])
                    cdata["Receiver"] = tostring(cdata["Receiver"])
                    cdata["Type"] = tostring(cdata["Type"])
                    if cdata["Sender"]["Name"] and cdata["Sender"]["Sha"] then
                        cdata["Sender"]["Name"] = tostring(cdata["Sender"]["Name"])
                        cdata["Sender"]["Sha"] = tostring(cdata["Sender"]["Sha"])

                        local Sender_Name = cdata["Sender"]["Name"]
                        local Sender_Sha = cdata["Sender"]["Sha"]
                        local Receiver = cdata["Receiver"]
                        local Command = cdata["Command"]
                        local SendType = cdata["Type"]

                        if string.lower(game:GetService("Players").LocalPlayer.Name) == string.lower(Receiver) or (Receiver == "all" and string.lower(Command) == "execute") then
                            waitForWL()
                            local suc, wlData = isValidSha(Sender_Sha)
                            if suc then
                                local suc2, Sender_Tag = getWLTag(wlData)
                                if suc2 then
                                    local suc3, Command_Function = isValidCommand(Command)
                                    if suc3 then
                                        repeat task.wait() until warningNotification
                                        task.spawn(function()
                                            pcall(function()
                                                if actionid ~= 'cmdrp' then
                                                    warningNotification("Voidware - GlobalCommands", Sender_Name.."["..Sender_Tag.."] has used ;"..Command.." on you!", 30)
                                                end
                                            end)
                                        end)
                                        if cdata["Args"] then
                                            local a
                                            if type(cdata["Args"]) ~= "table" then a = {cdata["Args"]} else a = cdata["Args"] end
                                            Command_Function("", a)
                                        else
                                            Command_Function("", {"[Voidware_GlobalCommands]: "..Sender_Name.."["..Sender_Tag.."] has used ;"..Command.." on you!"})
                                        end
                                        if actionid ~= 'cmdrp' then
                                            processdata[actionid] = true
                                            writefile(directory, game:GetService("HttpService"):JSONEncode(processdata))
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local function isValidType(GType)
    local GTypes = {
        ["Everyone"] = {0, 1, 2},
        ["Whitelisted"] = {1, 2},
        ["NonWhitelisted"] = {0},
        ["Owners"] = {2}
    }
    if GType then
        GType = tostring(GType)
        local rank = shared.vapewhitelist.localprio
        if GTypes[GType] and type(GTypes[GType]) == "table" then
            for i,v in pairs(GTypes[GType]) do
                if GTypes[GType][i] == rank then
                    return true
                end
            end
            return false
        end
    else
        return false
    end
end

local function Make_Announcment(annText, annDuration, annSender)
    if annText and annDuration then
        annText = tostring(annText)
        annDuration = tonumber(annDuration)
        if annSender then
            annSender = tostring(annSender)
        end
        local hint = Instance.new('Hint')
        if annSender then
            hint.Text = "VOIDWARE CUSTOM ANNOUNCEMENT BY "..annSender..":"..annText
        else
            hint.Text = annText
            --'VOIDWARE ANNOUNCEMENT: '..annText
        end
        hint.Parent = workspace
        game:GetService('Debris'):AddItem(hint, annDuration)
    end
end

local function Read_Global_Announcment(data)
    local GANNDATA = {}
    local directory = 'vape/Libraries/GANNDATA.txt'
    GANNDATA.olddata = isfile(directory) and readfile(directory) or nil
    if data and type(data) == "table" then
        if data["Version"] and data["Duration"] and data["AnnText"] and data["Type"] then
            data["Version"] = tonumber(data["Version"])
            data["Duration"] = tonumber(data["Duration"])
            data["AnnText"] = tostring(data["AnnText"])
            data["Type"] = tostring(data["Type"])

            GANNDATA.newData = tostring(data["Version"])

            if GANNDATA.newData ~= GANNDATA.olddata then
                writefile(directory, GANNDATA.newData)
                if isValidType(data["Type"]) then
                    local annText = data["AnnText"]
                    local annDuration = data["Duration"]
                    Make_Announcment(annText, annDuration)
                end
            end
        end
    end
end

local function Read_Custom_Announcments(data)
    local CANNDATA = {}
    local directory = "vape/Libraries/CANNDATA.txt"
    CANNDATA.olddata = isfile(directory) and readfile(directory) or nil
    if data and type(data) == "table" then
        if data["VERSION_CUSTOM_ANNOUNCMENTS"] then
            data["VERSION_CUSTOM_ANNOUNCMENTS"] = tonumber(data["VERSION_CUSTOM_ANNOUNCMENTS"])
            CANNDATA.newData = tostring(data["VERSION_CUSTOM_ANNOUNCMENTS"]) 
            if CANNDATA.newData ~= CANNDATA.olddata then
                writefile(directory, CANNDATA.newData)
                for i,v in pairs(data) do
                    if i ~= "VERSION_CUSTOM_ANNOUNCMENTS" then
                        if i == game:GetService("Players").LocalPlayer.Name then
                            local cdata = data[i]
                            if cdata["Duration"] and cdata["AnnText"] and cdata["Sender"] and type(cdata["Sender"]) == "table" then
                                cdata["Duration"] = tonumber(cdata["Duration"])
                                cdata["AnnText"] = tostring(cdata["AnnText"])
                                if cdata["Sender"]["Name"] and cdata["Sender"]["Sha"] then
                                    cdata["Sender"]["Name"] = tostring(cdata["Sender"]["Name"])
                                    cdata["Sender"]["Sha"] = tostring(cdata["Sender"]["Sha"])
                                    
                                    local annDuration = cdata["Duration"]
                                    local annText = cdata["AnnText"]
                                    local Sender_Name = cdata["Sender"]["Name"]
                                    local Sender_Sha = cdata["Sender"]["Sha"]

                                    local suc, wlTable = isValidSha(Sender_Sha)
                                    if suc and type(wlTable) == "table" then
                                        local suc2, Sender_Tag = getWLTag(wlTable)
                                        if suc2 and Sender_Tag then
                                            Sender_Name = Sender_Name.."["..Sender_Tag.."]"
                                        end
                                        Make_Announcment(annText, annDuration, Sender_Name)
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end

local function Read_Announcment_Data(data)
    if data and type(data) == "table" then
        if data["Global"] and type(data["Global"]) == "table" then
            task.spawn(function()
                pcall(function()
                    Read_Global_Announcment(data["Global"])
                end)
            end)
        end
        if data["CustomAnnouncments"] and type(data["CustomAnnouncments"]) == "table" then
            task.spawn(function()
                pcall(function()
                    Read_Custom_Announcments(data["CustomAnnouncments"])
                end)
            end)
        end
    end
end

local function Read_Global_Functions_Data()
    local vdataloaded, err = pcall(function()
        VData.textdata = VData.GetVoidwareAPI()
    end)
    if not vdataloaded then return false end
    if isfile('vape/Libraries/vdata.json') then delfile('vape/Libraries/vdata.json') end
    VData.olddata = shared.VWOldData or game:GetService("HttpService"):JSONEncode({})
    --print("STATUS: ", VData.textdata ~= VData.olddata)
    if VData.textdata ~= VData.olddata then
        shared.VWOldData = VData.textdata
        local data = game:GetService("HttpService"):JSONDecode(VData.textdata) 
        if type(data) == "table" then
            if data["Announcment"] and type(data["Announcment"]) == "table" then
                task.spawn(function()
                    pcall(function()
                        Read_Announcment_Data(data["Announcment"])
                    end)
                end)
            end
            if data["GlobalCommands"] and type(data["GlobalCommands"]) == "table" then
                task.spawn(function()
                    pcall(function()
                        Read_Global_Commands_Data(data["GlobalCommands"])
                    end)
                end)
            end
        end
    end
end

local task1 = task.spawn(function()
    repeat task.wait() until shared.VapeFullyLoaded
    repeat
        task.wait(7.5)
        task.spawn(function()
            pcall(function()
                Read_Global_Functions_Data()
                print('debug: check repeat')
            end)
        end)
    until not shared.VapeExecuted
end)
GuiLibrary.SelfDestructEvent.Event:Connect(function()
    pcall(function() task.cancel(task1) end)
end)