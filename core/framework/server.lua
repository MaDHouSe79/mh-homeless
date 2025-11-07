-- [[ ===================================================== ]] --
-- [[                MH Homeless by MaDHouSe79              ]] --
-- [[ ===================================================== ]] --
Framework, CreateCallback, CreateUseableItem, AddCommand, SharedItems = nil, nil, nil, nil, nil
sql, ply = {}, {}

if GetResourceState("es_extended") ~= 'missing' then
    Framework = exports['es_extended']:getSharedObject()
    CreateCallback = Framework.RegisterServerCallback
    CreateUseableItem = Framework.CreateUseableItem
    AddCommand = Framework.RegisterCommand
    SharedItems = nil

    sql = {table = "owned_vehicles", owner = "owner", state = "stored"}
    ply = {table = "users", owner = "identifier", inventory = "inventory"}

    function GetPlayers()
        return Framework.Players
    end

    function GetPlayer(source)
        return Framework.GetPlayerFromId(source)
    end

    function GetJob(source)
        return Framework.GetPlayerFromId(source).job
    end

    function GetCitizenId(src)
        local xPlayer = GetPlayer(src)
        return xPlayer.identifier
    end

    function GetCitizenFullname(src)
        local xPlayer = GetPlayer(src)
        return xPlayer.name
    end

elseif GetResourceState("qb-core") ~= 'missing' then
    Framework = exports['qb-core']:GetCoreObject()
    CreateCallback = Framework.Functions.CreateCallback
    CreateUseableItem = Framework.Functions.CreateUseableItem
    AddCommand = Framework.Commands.Add
    SharedItems = Framework.Shared.Items

    sql = {table = "player_vehicles", owner = "citizenid", state = "state"}
    ply = {table = "players", owner = "citizenid", inventory = "inventory"}

    function GetPlayers()
        return Framework.Players
    end

    function GetPlayer(source)
        return Framework.Functions.GetPlayer(source)
    end

    function GetJob(source)
        return Framework.Functions.GetPlayer(source).PlayerData.job
    end

    function GetPlayerDataByCitizenId(citizenid)
        return Framework.Functions.GetPlayerByCitizenId(citizenid) or Framework.Functions.GetOfflinePlayerByCitizenId(citizenid)
    end

    function GetCitizenId(src)
        local xPlayer = GetPlayer(src)
        return xPlayer.PlayerData.citizenid
    end

    function GetCitizenFullname(src)
        local xPlayer = GetPlayer(src)
        return xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname
    end

elseif GetResourceState("qbx_core") ~= 'missing' then
    Framework = exports['qb-core']:GetCoreObject()
    CreateCallback = Framework.Functions.CreateCallback
    CreateUseableItem = Framework.Functions.CreateUseableItem
    AddCommand = Framework.Commands.Add
    SharedItems = Framework.Shared.Items

    sql = {table = "player_vehicles", owner = "citizenid", state = "state"}
    ply = {table = "players", owner = "citizenid", inventory = "inventory"}

    function GetPlayers()
        return Framework.Players
    end

    function GetPlayer(source)
        return Framework.Functions.GetPlayer(source)
    end

    function GetJob(source)
        return Framework.Functions.GetPlayer(source).PlayerData.job
    end

    function GetPlayerDataByCitizenId(citizenid)
        return Framework.Functions.GetPlayerByCitizenId(citizenid) or Framework.Functions.GetOfflinePlayerByCitizenId(citizenid)
    end

    function GetCitizenId(src)
        local xPlayer = GetPlayer(src)
        return xPlayer.PlayerData.citizenid
    end

    function GetCitizenFullname(src)
        local xPlayer = GetPlayer(src)
        return xPlayer.PlayerData.charinfo.firstname .. ' ' .. xPlayer.PlayerData.charinfo.lastname
    end

end

function Notify(src, message, type, length)
    if GetResourceState("ox_lib") ~= 'missing' then
        lib.notify(src, {title = "MH Homeless", description = message, type = type})
    else
        Framework.Functions.Notify(src, {text = "MH Homeless", caption = message}, type, length)
    end
end