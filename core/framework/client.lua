-- [[ ===================================================== ]] --
-- [[                MH Homeles by MaDHouSe79               ]] --
-- [[ ===================================================== ]] --
Framework, TriggerCallback, OnPlayerLoaded, OnPlayerUnload = nil, nil, nil, nil
isLoggedIn, PlayerData = false, {}

if GetResourceState("es_extended") ~= 'missing' then
    Framework = exports['es_extended']:getSharedObject()
    TriggerCallback = Framework.TriggerServerCallback
    OnPlayerLoaded = 'esx:playerLoaded'
    OnPlayerUnload = 'esx:playerUnLoaded'

    function GetPlayerData()
        TriggerCallback('esx:getPlayerData', function(data)
            PlayerData = data
        end)
        return PlayerData
    end

    function IsDead()
        return (GetEntityHealth(PlayerPedId()) <= 0)
    end
elseif GetResourceState("qb-core") ~= 'missing' then
    Framework = exports['qb-core']:GetCoreObject()
    TriggerCallback = Framework.Functions.TriggerCallback
    OnPlayerLoaded = 'QBCore:Client:OnPlayerLoaded'
    OnPlayerUnload = 'QBCore:Client:OnPlayerUnload'

    function GetPlayerData()
        return Framework.Functions.GetPlayerData()
    end

    function IsDead()
        return Framework.Functions.GetPlayerData().metadata['isdead']
    end

    RegisterNetEvent('QBCore:Player:SetPlayerData', function(data)
        PlayerData = data
    end)

    RegisterNetEvent('QBCore:Client:UpdateObject', function()
        Framework = exports['qb-core']:GetCoreObject()
    end)
elseif GetResourceState("qbx_core") ~= 'missing' then
    Framework = exports['qb-core']:GetCoreObject()
    TriggerCallback = Framework.Functions.TriggerCallback
    OnPlayerLoaded = 'QBCore:Client:OnPlayerLoaded'
    OnPlayerUnload = 'QBCore:Client:OnPlayerUnload'

    function GetPlayerData()
        return Framework.Functions.GetPlayerData()
    end

    function IsDead()
        return Framework.Functions.GetPlayerData().metadata['isdead']
    end

    RegisterNetEvent('QBCore:Player:SetPlayerData', function(data)
        PlayerData = data
    end)

    RegisterNetEvent('QBCore:Client:UpdateObject', function()
        Framework = exports['qb-core']:GetCoreObject()
    end)
end

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Wait(1)
    end
end

function LoadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do
            Wait(1)
        end
    end
end

function Notify(message, type, length)
    if GetResourceState("ox_lib") ~= 'missing' then
        lib.notify({title = "MH Homeless", description = message, type = type})
    else
        Framework.Functions.Notify({text = "MH Homeless", caption = message}, type, length)
    end
end