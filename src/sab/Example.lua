local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ThisiYann/magang/refs/heads/main/src/sab/Library.lua"))()

local Window = Library:CreateWindow("ArtHub")

Window:Notify("Welcome!", "ArtHub Loaded!", 5)

local MainTab = Window:CreateTab("Main")
local PlayerTab = Window:CreateTab("Player")
local MiscTab = Window:CreateTab("Misc")

local FarmSection = MainTab:CreateSection("Farm")

FarmSection:CreateToggle("Auto Fish", function(value)
	Window:Notify("Auto Fish", value and "Enabled" or "Disabled", 3)
end)

FarmSection:CreateToggle("Auto Buy Best Rod", function(value)
	Window:Notify("Auto Buy", value and "Enabled" or "Disabled", 3)
end)

FarmSection:CreateTextBox("Sell Threshold", "ex 10k, 10m,..", function(value)
	Window:Notify("Threshold Set", "Value: " .. value, 3)
end)

FarmSection:CreateToggle("Auto Sell Pets", function(value)
	Window:Notify("Auto Sell Pets", value and "Enabled" or "Disabled", 3)
end)

FarmSection:CreateToggle("Auto Buy Brainrot", function(value)
	Window:Notify("Auto Buy", value and "Enabled" or "Disabled", 3)
end)

local AutoSection = MainTab:CreateSection("Auto Actions")

AutoSection:CreateButton("Execute All", function()
	Window:Notify("Execute", "All actions executed!", 3)
end)

AutoSection:CreateDropdown("Select Mode", {"Fast", "Normal", "Slow", "Custom"}, function(value)
	Window:Notify("Mode Changed", "Selected: " .. value, 3)
end)

local StatsSection = PlayerTab:CreateSection("Player Stats")

StatsSection:CreateSlider("Walk Speed", 16, 100, 16, function(value)
	local player = game.Players.LocalPlayer
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.WalkSpeed = value
	end
end)

StatsSection:CreateSlider("Jump Power", 50, 200, 50, function(value)
	local player = game.Players.LocalPlayer
	if player.Character and player.Character:FindFirstChild("Humanoid") then
		player.Character.Humanoid.JumpPower = value
	end
end)

StatsSection:CreateToggle("Infinite Jump", function(value)
	Window:Notify("Infinite Jump", value and "Enabled" or "Disabled", 3)
end)

local VisualSection = PlayerTab:CreateSection("Visual")

VisualSection:CreateToggle("ESP Enabled", function(value)
	Window:Notify("ESP", value and "Enabled" or "Disabled", 3)
end)

VisualSection:CreateDropdown("ESP Color", {"Red", "Green", "Blue", "Yellow", "Purple"}, function(value)
	Window:Notify("ESP Color", "Changed to: " .. value, 3)
end)

VisualSection:CreateSlider("ESP Distance", 100, 1000, 500, function(value)
	Window:Notify("ESP Distance", tostring(value) .. " studs", 2)
end)

local SettingsSection = MiscTab:CreateSection("Settings")

SettingsSection:CreateToggle("Anti-AFK", function(value)
	Window:Notify("Anti-AFK", value and "Enabled" or "Disabled", 3)
end)

SettingsSection:CreateToggle("Auto-Respawn", function(value)
	Window:Notify("Auto-Respawn", value and "Enabled" or "Disabled", 3)
end)

SettingsSection:CreateButton("Reset Settings", function()
	Window:Notify("Reset", "All settings have been reset", 3)
end)

local InfoSection = MiscTab:CreateSection("Information")

InfoSection:CreateTextBox("Discord Tag", "Enter your tag", function(value)
	Window:Notify("Discord Tag", "Saved: " .. value, 3)
end)

InfoSection:CreateButton("Copy Discord Link", function()
	Window:Notify("Discord", "Link copied to clipboard!", 3)
end)
