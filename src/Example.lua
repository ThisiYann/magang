-- Load UI Library
local ArtUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThisiYann/magang/refs/heads/main/src/Library.lua"))()

-- Create Window
local Window = ArtUI:Window({
    Title   = "@ArtHub |",                -- Main title
    Footer  = " made by Arta",              -- Text after title
    -- Image   = 123456,            -- Texture ID (Optional)
    -- Color   = Color3.fromRGB(0, 208, 255),  -- UI color (Optional)
    -- Theme   = 123456,                   -- Background theme ID (Optional)
    Version = 1,                            -- Config version (change to reset configs)
})

-- Notification Example
ArtUI:MakeNotify({
    Title = "@ArtHub",
    Description = "Notification",
    Content = "Example notification",
    Delay = 4
})

-- Create Tabs
local Tabs = {
    Info = Window:AddTab({ Name = "Info", Icon = "info" }),
    Main = Window:AddTab({ Name = "Main", Icon = "user" }),
}

--[[ Create Tab
 local Tab = Window:AddTab({
    Name = "Tab",
    Icon = "home"
}) ]]

-- Create Section
X1 = Tabs.Info:AddSection("@ArtHub | Section")
-- X1 = Tabs.Info:AddSection("Section Name", false) -- Default closed
-- X1 = Tabs.Info:AddSection("Section Name", true) -- Always open

-- Paragraph
X1:AddParagraph({
    Title = "@ArtHub | Paragraph With Icon",
    Content = "Content",
    Icon = "star",
})

-- Paragraph with Button
X1:AddParagraph({
    Title = "Join Our Discord",
    Content = "Join Us!",
    Icon = "discord",
    ButtonText = "Copy Discord Link",
    ButtonCallback = function()
        local link = "https://discord.gg/9jm5aKHZvG"
        if setclipboard then
            setclipboard(link)
            ArtUI("Successfully Copied!")
        end
    end
})

-- Divider
X1:AddDivider()

-- Sub Section
X1:AddSubSection("SUB SECTION")

-- Opened Section
OpenedSection = Tabs.Main:AddSection("@ArtHub | Opened Section", true)

-- Panel Section
PanelSection = Tabs.Main:AddSection("@ArtHub | Panel")

-- Panel with 2 Buttons
PanelSection:AddPanel({
    Title = "@ArtHub | Discord",
    Content = "Optional Subtitle", -- Optional
    ButtonText = "Copy Discord Link",
    ButtonCallback = function()
        if setclipboard then
            setclipboard("https://discord.gg/9jm5aKHZvG")
            ArtUI("Discord link copied to clipboard.")
        else
            ArtUI("Executor doesn't support setclipboard.")
        end
    end,
    SubButtonText = "Open Discord",
    SubButtonCallback = function()
        ArtUI("Opening Discord link...")
        task.spawn(function()
            game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/chloex")
        end)
    end
})

-- Panel with Input and Button
PanelSection:AddPanel({
    Title = "@ArtHub | Utility",
    Placeholder = "https://discord.com/api/webhooks/...",
    ButtonText = "Rejoin Server",
    ButtonCallback = function()
        ArtUI("Rejoining server...")
        task.wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end
})

-- Panel with Input and 2 Buttons
PanelSection:AddPanel({
    Title = "@ArtHub | Webhook",
    Placeholder = "https://discord.com/api/webhooks/...",
    ButtonText = "Save Webhook",
    ButtonCallback = function(url)
        if url == "" then
            ArtUI("Please enter webhook URL first.")
            return
        end
        _G.ChloeWebhook = url
        ConfigData.WebhookURL = url
        SaveConfig()
        ArtUI("Webhook saved.")
    end,
    SubButtonText = "Test Webhook",
    SubButtonCallback = function()
        if not _G.ChloeWebhook or _G.ChloeWebhook == "" then
            ArtUI("Webhook not set.")
            return
        end
        ArtUI("Sending test webhook...")
        task.spawn(function()
            local HttpService = game:GetService("HttpService")
            local data = { content = "Test webhook from @ArtHub." }
            pcall(function()
                HttpService:PostAsync(_G.ChloeWebhook, HttpService:JSONEncode(data))
            end)
        end)
    end
})

-- Button Section
local BtnSection = Tabs.Main:AddSection("@ArtHub | Button")

-- Single Button
BtnSection:AddButton({
    Title = "Open Discord",
    Callback = function()
        ArtUI("Opening Discord...")
        task.spawn(function()
            game:GetService("GuiService"):OpenBrowserWindow("https://discord.gg/chloex")
        end)
    end
})

-- Double Button
BtnSection:AddButton({
    Title = "Rejoin",
    SubTitle = "Server Hop",
    Callback = function()
        ArtUI("Rejoining server...")
        task.wait(1)
        game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
    end,
    SubCallback = function()
        ArtUI("Finding new server...")
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Servers = Http:JSONDecode(game:HttpGetAsync("https://games.roblox.com/v1/games/" ..
            game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        for _, v in pairs(Servers.data) do
            if v.playing < v.maxPlayers then
                TPS:TeleportToPlaceInstance(game.PlaceId, v.id, game.Players.LocalPlayer)
                return
            end
        end
        ArtUI("No available servers found.")
    end
})

-- Toggle Section
local ToggleSection = Tabs.Main:AddSection("@ArtHub | Toggle")

-- Single Toggle
ToggleSection:AddToggle({
    Title = "Toggle",
    Content = "Content",
    Default = false,
    Callback = function(value)
        ArtUI("Toggle set to: " .. value)
    end
})

-- Toggle with Subtitle
ToggleSection:AddToggle({
    Title = "Toggle",
    Title2 = "Wih Subtitle",
    Content = "Content",
    Default = false,
    Callback = function(v)
        ArtUI("Toggle set to: " .. v)
    end
})

-- Slider Section
local SliderSection = Tabs.Main:AddSection("@ArtHub | Slider")

-- Fishing Delay Slider
SliderSection:AddSlider({
    Title = "Slider",
    Content = "Content",
    Min = 1,
    Max = 100,
    Increment = 1,
    Default = 1,
    Callback = function(value)
        ArtUI("Delay set to: " .. tostring(value) .. " seconds.")
    end
})

-- Input Section
local InputSection = Tabs.Main:AddSection("@ArtHub | Input")

-- Text Input
InputSection:AddInput({
    Title = "Input",
    Content = "Content",
    Default = "",
    Callback = function(value)
        ArtUI("Username set to: " .. value)
    end
})

-- Dropdown Section
local DropdownSection = Tabs.Main:AddSection("@ArtHub | Dropdown")

-- Basic Dropdown
DropdownSection:AddDropdown({
    Title = "Basic Dropdown",
    Content = "Content",
    Options = { "Hi", "Hello", "Sup", "Banana" },
    Default = "Hi",
    Callback = function(value)
        ArtUI("Basic Dropdown set to: " .. value)
    end
})

-- Multi-Select Dropdown
DropdownSection:AddDropdown({
    Title = "Multi Dropdown",
    Content = "Content",
    Multi = true,
    Options = { "Banana", "Apple", "Papaya", "Mango" },
    Default = { "Banana" },
    Callback = function(selected)
        ArtUI("Multi Dropdown set to: " .. table.concat(selected, ", "))
    end
})

-- Dynamic Dropdown
local DynamicDropdown = DropdownSection:AddDropdown({
    Title = "Dynamic Dropdown",
    Content = "Content",
    Options = {},
    Default = nil,
    Callback = function(value)
        ArtUI("Dynamic Dropdown set to: " .. value)
    end
})

-- Update dropdown options dynamically
task.spawn(function()
    task.wait(1)
    local genderList = { "Man", "Woman", "Boy", "Girl" }
    DynamicDropdown:SetValues(genderList, "Man")
end)

-- Config auto-saves/loads all elements. Use SaveConfig() if needed.
