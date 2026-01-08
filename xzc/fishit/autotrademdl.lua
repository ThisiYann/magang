return function(Players, LocalPlayer, ReplicatedStorage, Library)
    
    local Module = {}
    
    Module.Config = {
        RefreshInterval = 1, -- seconds
        TradeItemId = "36a63fb5-df50-4d51-9b05-9d226ccd3ce7"
    }
    
    Module.RFInitiateTrade = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/InitiateTrade"]
    Module.RFAwaitTradeResponse = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/AwaitTradeResponse"]
    
    Module.State = {
        AutoAcceptEnabled = false,
        SelectedTradePlayer = nil
    }
    
    function Module.GetPlayerNames()
        local playerNames = {}
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                table.insert(playerNames, plr.Name)
            end
        end
        table.sort(playerNames)
        return playerNames
    end
    
    function Module.SendTradeRequest(targetPlayerName)
        if not targetPlayerName then
            return false
        end
        
        local targetPlayer = Players:FindFirstChild(targetPlayerName)
        if not targetPlayer then
            return false
        end
        
        local success, err = pcall(function()
            Module.RFInitiateTrade:InvokeServer(targetPlayer.UserId, Module.Config.TradeItemId)
        end)
        
        return success
    end
    
    function Module.SetAutoAccept(enabled)
        Module.State.AutoAcceptEnabled = enabled
    end
    
    function Module.GetAutoAcceptState()
        return Module.State.AutoAcceptEnabled
    end
    
    Module.RFAwaitTradeResponse.OnClientInvoke = newcclosure(function(itemData, fromPlayer, serverTime)
        return Module.State.AutoAcceptEnabled
    end)
    
    return Module
end
