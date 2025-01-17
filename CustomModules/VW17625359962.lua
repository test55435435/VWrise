repeat task.wait() until game:IsLoaded()
local GuiLibrary = shared.GuiLibrary

local function load()
    task.spawn(function()
        local suc, err = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/Kona3366/Rat.dev-Repository/main/loadstring.lua"))()
        end)
        if suc then
            local function InfoNotification(title, text, delay, button_table)
                local suc, res = pcall(function()
                    local frame = GuiLibrary.CreateNotification(title or "Voidware", text or "Successfully called function", delay or 7, "assets/InfoNotification.png", button_table)
                    return frame
                end)
                return (suc and res)
            end
            InfoNotification("Voidware x Rivals Loader", "Successfully loaded the script! Please check its credits and support its creator", 3)
        else
            errorNotification("Voidware x Rivals Loader", "Failure loading the script! Error was sent in the console (type /console)", 3)
        end
        writefile('vape/Libraries/RivalsScriptDecision.txt', "yes")
    end)
end

local interactable_buttons_table = {
	[1] = {
		["Name"] = "Yes",
		["Function"] = function()
			load()
		end
	},
	[2] = {
		["Name"] = "No",
		["Function"] = function() writefile("vape/Libraries/RivalsScriptDecision.txt", "no") end
	}
}
local function InfoNotification2(title, text, delay, button_table)
	local suc, res = pcall(function()
		local frame = GuiLibrary.CreateInteractableNotification(title or "Voidware", text or "Successfully called function", delay or 7, "assets/InfoNotification.png", button_table)
		return frame
	end)
	return (suc and res)
end
if not isfile('vape/Libraries/RivalsScriptDecision.txt') or readfile('vape/Libraries/RivalsScriptDecision.txt') == "no" then 
    InfoNotification2("Voidware x Rivals", "Would you like to load a script made specifically for the game Rivals?", 10000000, interactable_buttons_table)
else
    load()
end