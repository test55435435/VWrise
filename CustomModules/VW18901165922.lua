warn("Big games - PETS GO")
local GuiLibrary = shared.GuiLibrary
task.spawn(function()
    local isNew = false
    local requiredFolders = {"Speed_Hub"}
    for i,v in pairs(requiredFolders) do
        if (not isfolder(v)) then makefolder(v); isNew = true end
    end
    if (not isfile('Speed_Hub/PETGO.json')) then isNew = true end
    if isNew then
        local DownloadTable = {
            {
                Dir = 'Speed_Hub',
                File = 'PETGO.json',
                Url = 'https://raw.githubusercontent.com/Erchobg/VoidwareProfiles/main/PETSGO/Speed_Hub/PETGO.json'
            }
        }
        for i,v in pairs(DownloadTable) do
            local suc, data = pcall(function()
                return game:HttpGet(v.Url, true)
            end)
            if suc then writefile(v.Dir.."/"..v.File, data) end
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
        local suc_1, err_1 = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/AhmadV99/Speed-Hub-X/main/Speed%20Hub%20X.lua", true))()
        end)
        return {
            ["Script #1"] = {
                Suc = suc_1,
                Err = err_1
            }
        }
    end
    local data = load()
    local loadSuc = true
    for i,v in pairs(data) do
        if (not v.Suc) then loadSuc = false; errorNotification("Voidware - PETSGO", "Failure loading "..i.."! Error: "..tostring(v.Err), 7) end
    end
    if loadSuc then InfoNotification2("Voidware - PETSGO", "The core scripts had just loaded! Would you like to uninject vw?", 10000000, interactable_buttons_table) end
end)