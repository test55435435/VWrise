warn("Big games - my restaurant")
local GuiLibrary = shared.GuiLibrary
task.spawn(function()
    local isNew = false
    local requiredFolders = {"Rayfield", "Cheat"}
    for i,v in pairs(requiredFolders) do
        if (not isfolder(v)) then makefolder(v); isNew = true end
    end
    if (not isfolder('Rayfield/Configurations')) then makefolder('Rayfield/Configurations'); isNew = true end
    if isNew then
        local DownloadTable = {
            {
                Dir = 'Rayfield/Configurations',
                File = 'MyRestaurant.rfld',
                Url = 'https://raw.githubusercontent.com/Erchobg/VoidwareProfiles/main/MyRestaurant/Rayfield/Configurations/MyRestaurant.rfld'
            },
            {
                Dir = 'Cheat',
                File = 'config.txt',
                Url = 'https://raw.githubusercontent.com/Erchobg/VoidwareProfiles/main/MyRestaurant/Cheat/config.txt'
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
    if getgenv and not getgenv().Shared then getgenv().Shared = {} end
    local function load()
        local suc_1, err_1 = pcall(function()
            loadstring(game:HttpGet('https://pastebin.com/raw/z7TFbGEL'))()
        end)
        local suc_2, err_2 = pcall(function()
            loadstring(game:HttpGet("https://gist.githubusercontent.com/SpencerDevv/4127570215e413bf8ab4e074791bcf45/raw/78b977974b36e2d5cde7a28dab7f9a464dd1a2c1/betaV5"))()
        end)
        return {
            ["Script #1"] = {
                Suc = suc_1,
                Err = err_1
            },
            ["Script #2"] = {
                Suc = suc_2,
                Err = err_2
            }
        }
    end
    local data = load()
    local loadSuc = true
    for i,v in pairs(data) do
        if (not v.Suc) then loadSuc = false; errorNotification("Voidware - My Restaurant", "Failure loading "..i.."! Error: "..tostring(v.Err), 7) end
    end
    if getgenv and not getgenv().require then InfoNotification("Voidware - My Restaurant", "Function 'require' not found! Script 1 will not be able to load.", 3) end
    --if loadSuc then InfoNotification2("Voidware - My Restaurant", "The core scripts had just loaded! Would you like to uninject vw?", 10000000, interactable_buttons_table) end
end)