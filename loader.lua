local visible = true
local copymsg = "Copied to clipboard!"
local api = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
api.script_id = "-" -- unsure if im gonna make a new script yet

local function validateKey(key)
    local status = api.check_key(key)
    if status.code == "KEY_VALID" then
		local seconds_left = status.data.auth_expire - os.time()
        local days = math.floor(seconds_left / 86400)
        local hours = math.floor((seconds_left % 86400) / 3600)
        local minutes = math.floor((seconds_left % 3600) / 60)
        local seconds = seconds_left % 60
        local time_left = string.format("%dd %dh %dm %ds", days, hours, minutes, seconds)
        return true, "Key is valid! Time left: " .. time_left
    elseif status.code == "KEY_HWID_LOCKED" then
        return false, "Key is linked to a different device (HWID). Please reset it using Luarmor's Discord bot."
    elseif status.code == "KEY_INCORRECT" or status.code == "KEY_INVALID" then
		return false, "Key is incorrect or deleted."
    else
        return false, "Failed to check key."
    end
    return false, "Unknown error, should never happen."
end

local function load(key)
	script_key = key
    api.load_script()
end

if not isfolder("Riddance") then
    makefolder("Riddance")
end

if isfile("Riddance/key.txt") then
    local file = readfile("Riddance/key.txt")
    if validateKey(file) then
        visible = false
        load(file)
    end
end

if visible then
    local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/deividcomsono/lib/main/Library.lua"))()
    local win = lib:CreateWindow({
        Title = "Riddance Key System",
        ToggleKeybind = Enum.KeyCode.G,
        SetMobileButtonSide = "Left",
        DisableSearch = true,
        ShowCustomCursor = false,
        Size = UDim2.fromOffset(400, 300),
        Center = true,
        AutoShow = true
    })

    local tab = win:AddKeyTab("Key", "key"),

    tab:AddLabel({
        Text = "Riddance Key System",
        DoesWrap = true,
        Size = 20,
    })

    tab:AddButton({
        Text = "Linkvertise",
        Func = function()
            setclipboard("https://ads.luarmor.net/get_key?for=Riddance_Premium_Linkvertise-IbUHRQbdLbnF")
            lib:Notify(copymsg, 5)
        end
    })

    tab:AddButton({
        Text = "Lootlabs",
        Func = function()
            setclipboard("https://ads.luarmor.net/get_key?for=Riddance_Premium_Lootlabs-uIsDXzXErYSY")
            lib:Notify(copymsg, 5)
        end
    })

    tab:AddButton({
        Text = "Work.ink",
        Func = function()
            setclipboard("https://ads.luarmor.net/get_key?for=Riddance_Premium_Workink-vUfZJgriPsXO")
            lib:Notify(copymsg, 5)
        end
    })

    tab:AddButton({
        Text = "Join Discord",
        Func = function()
            setclipboard("https://discord.gg/hbHEv8QvE9")
            lib:Notify(copymsg, 5)
        end
    })

    tab:AddKeyBox(function(_, key)
        local valid, msg = validateKey(key)
        if valid then
            writefile("Riddance/key.txt", key)
            lib:Notify(msg, 5)
			lib:Unload()
            load(key)
        else
            lib:Notify(msg, 5)
        end
    end)
end
