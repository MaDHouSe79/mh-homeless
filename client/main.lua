-- [[ ===================================================== ]] --
-- [[                MH Homeles by MaDHouSe79               ]] --
-- [[ ===================================================== ]] --
local config = nil
local home = nil
local trolly = nil
local shopPed = nil
local lastCoords = nil
local liggen = false
local isEdit = false
local useingObj = nil

local function DeleteTrolly(entity)
    if trolly ~= nil then
        if DoesEntityExist(entity) then
            SetEntityAsMissionEntity(entity, true, true)
            DeleteEntity(entity)
            trolly = nil
        end
    end
end

local function DeleteHome(entity)
    if home ~= nil then
        if DoesEntityExist(entity) then
            SetEntityAsMissionEntity(entity, true, true)
            DeleteEntity(entity)
            home = nil
        end
    end
end

local function DeleteShopPed()
    if shopPed ~= nil then
        if DoesEntityExist(shopPed) then
            SetEntityAsMissionEntity(shopPed, true, true)
            DeleteEntity(shopPed)
            shopPed = nil
        end
    end
end

local function DeleteShoppingCar()
    if shoppingCar ~= nil then
        if DoesEntityExist(shoppingCar) then
            SetEntityAsMissionEntity(shoppingCar, true, true)
            DeleteEntity(shoppingCar)
            shoppingCar = nil
        end
    end
end

local function Liggen()
    local playerPed = GetPlayerPed(-1)
    if lastCoords == nil then lastCoords = GetEntityCoords(playerPed) end
    local coords = GetEntityCoords(home)
    SetEntityCoords(playerPed, coords.x, coords.y, coords.z + 0.02)
    SetEntityHeading(playerPed, 0.0)
    FreezeEntityPosition(playerPed, true)
    LoadAnimDict('anim@gangops@morgue@table@')
    TaskPlayAnim(playerPed, 'anim@gangops@morgue@table@', 'body_search', 8.0, 1.0, -1, 1, 0, 0, 0, 0)
    liggen = true
end

local function Opstaan()
    local playerPed = GetPlayerPed(-1)
    if lastCoords ~= nil then
        SetEntityCoords(playerPed, lastCoords)
        lastCoords = nil
    end
    FreezeEntityPosition(playerPed, false)
    ClearPedTasks(playerPed)
    lastCoords = nil
    liggen = false
end

local function SpawnHome(coords, prop)
    if DoesEntityExist(home) then 
        SetEntityAsMissionEntity(home, true, true)
        DeleteEntity(home)
        home = nil
    end
    if home == nil then
        local model = GetHashKey(prop)
        LoadModel(model)
        local forward = GetEntityForwardVector(PlayerPedId())
        local x, y, z = table.unpack(coords + forward * 3.0)
        home = CreateObject(model, x, y, z - 1.0, false, false, false)
        RequestCollisionAtCoord(x, y, z)
        SetVehicleOnGroundProperly(home)
        SetEntityDrawOutline(home, true)
        if config.TargetScript == "ox_target" then
            exports["qb-target"]:addEntity(home, {
                {
                    name = "homeles_shelter1",
                    icon = "",
                    label = "Opstaan",
                    action = function(entity)
                        Opstaan()
                    end,
                    canInteract = function(entity, distance, data)
                        if isEdit then return false end
                        if not liggen then return false end
                        return true
                    end,
                    distance = 2.0
                },                
                {
                    name = "homeles_shelter2",
                    icon = "",
                    label = "Liggen",
                    action = function(entity)
                        Liggen()
                    end,
                    canInteract = function(entity, distance, data)
                        if isEdit then return false end
                        if liggen then return false end
                        return true
                    end,
                    distance = 2.0
                },
                {
                    name = "homeles_shelter3",
                    icon = "",
                    label = "Oppakken",
                    action = function(entity)
                        DeleteHome(entity)
                    end,
                    canInteract = function(entity, distance, data)
                        if isEdit then return false end
                        if liggen then return false end
                        return true
                    end,
                    distance = 2.0
                },
                {
                    name = "homeles_shelter4",
                    icon = "",
                    label = "Opslag",
                    action = function(entity)
                        TriggerServerEvent('mh-homeless:server:openStash', {type='shelter'})
                    end,
                    canInteract = function(entity, distance, data)
                        if isEdit then return false end
                        if not liggen then return false end
                        return true
                    end,
                    distance = 2.0
                },
            })
        elseif config.TargetScript == "qb-target" then
            exports["qb-target"]:AddTargetEntity(home, {
                options = {
                    {
                        name = "homeles_shelter1",
                        icon = "",
                        label = "Opstaan",
                        action = function(entity)
                            Opstaan()
                        end,
                        canInteract = function(entity, distance, data)
                            if isEdit then return false end
                            if not liggen then return false end
                            return true
                        end
                    },                
                    {
                        name = "homeles_shelter2",
                        icon = "",
                        label = "Liggen",
                        action = function(entity)
                            Liggen()
                        end,
                        canInteract = function(entity, distance, data)
                            if isEdit then return false end
                            if liggen then return false end
                            return true
                        end
                    },
                    {
                        name = "homeles_shelter3",
                        icon = "",
                        label = "Oppakken",
                        action = function(entity)
                            DeleteHome(entity)
                        end,
                        canInteract = function(entity, distance, data)
                            if isEdit then return false end
                            if liggen then return false end
                            return true
                        end
                    },
                    {
                        name = "homeles_shelter4",
                        icon = "",
                        label = "Opslag",
                        action = function(entity)
                            TriggerServerEvent('mh-homeless:server:openStash', {type='shelter'})
                        end,
                        canInteract = function(entity, distance, data)
                            if isEdit then return false end
                            if not liggen then return false end
                            return true
                        end
                    },
                },
                distance = 2.0
            })
        end
        isEdit = true
        useingObj = home
    end
end

local function SpawnTrolley(coords, prop)
    if DoesEntityExist(trolly) then 
        SetEntityAsMissionEntity(trolly, true, true)
        DeleteEntity(trolly)
        trolly = nil
    end
    if trolly == nil then
        local model = GetHashKey(prop)
        LoadModel(model)
        local forward = GetEntityForwardVector(PlayerPedId())
        local x, y, z = table.unpack(coords + forward * 3.0)
        trolly = CreateObject(model, x, y, z - 1.0, false, false, false)
        RequestCollisionAtCoord(x, y, z)
        SetVehicleOnGroundProperly(trolly)
        SetEntityDrawOutline(trolly, true)
        if config.TargetScript == "ox_target" then
            exports.ox_target:addEntity(trolly, {
                {
                    name = "homeles_trolly1",
                    icon = "",
                    label = "Oppakken",
                    action = function(data)
                        DeleteTrolly(data.entity)
                    end,
                    canInteract = function(entity, distance, data)
                        if isEdit then return false end
                        return true
                    end,
                    distance = 2.0
                }, {
                    name = "homeles_trolly2",
                    icon = "",
                    label = "Opslag",
                    action = function(data)
                        TriggerServerEvent('mh-homeless:server:openStash', {type='trolly'})
                    end,
                    canInteract = function(entity, distance, data)
                        if isEdit then return false end
                        return true
                    end,
                    distance = 2.0
                },                
            })
        elseif config.TargetScript == "qb-target" then
            exports["qb-target"]:AddTargetEntity(trolly, {
                options = {
                    {
                        name = "homeles_trolly1",
                        icon = "",
                        label = "Oppakken",
                        action = function(entity)
                            DeleteTrolly(entity)
                        end,
                        canInteract = function(entity, distance, data)
                            if isEdit then return false end
                            return true
                        end
                    }, {
                        name = "homeles_trolly2",
                        icon = "",
                        label = "Opslag",
                        action = function(entity)
                            TriggerServerEvent('mh-homeless:server:openStash', {type='trolly'})
                        end,
                        canInteract = function(entity, distance, data)
                            if isEdit then return false end
                            return true
                        end
                    },
                },
                distance = 2.0
            })
        end
        isEdit = true
        useingObj = trolly
    end
end

local function SpawnShopPed()
    local model = GetHashKey(config.Shop.model)
    LoadModel(model)
    local ped = CreatePed(0, model, config.Shop.coords.x, config.Shop.coords.y, config.Shop.coords.z - 1, config.Shop.coords.w, false, false)
    SetEntityAsMissionEntity(ped, true, true)
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_MOBILE", true)
    SetEntityInvincible(ped, true)
    SetBlockingOfNonTemporaryEvents(ped, true)
    shopPed = ped
    exports["qb-target"]:AddTargetEntity(ped, {
        options = {
            {
                name = "homeles_shelter_shop",
                icon = "",
                label = "Buy a small shelter",
                action = function(entity)
                    TriggerServerEvent('mh-homeless:server:buy_shelter_item', { type = 'shelter' })
                end,
                canInteract = function(entity, distance, data)
                    return true
                end
            },
            {
                name = "homeles_shelter_shop",
                icon = "",
                label = "Buy a trolly",
                action = function(entity)
                    TriggerServerEvent('mh-homeless:server:buy_shelter_item', { type = 'trolly' })
                end,
                canInteract = function(entity, distance, data)
                    return true
                end
            },
        },
        distance = 2.5
    })
end

AddEventHandler('onResourceStop', function(resource)
    if resource == GetCurrentResourceName() then 
        DeleteShopPed()
        DeleteHome()
    end
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == GetCurrentResourceName() then 
        TriggerServerEvent('mh-homeless:server:onjoin')
    end
end)

RegisterNetEvent(OnPlayerLoaded, function()
    TriggerServerEvent('mh-homeless:server:onjoin')
end)

RegisterNetEvent("mh-homeless:client:onjoin", function(data)
    config = data.config
    PlayerData = GetPlayerData()
    isLoggedIn = true
    SpawnShopPed()    
end)

RegisterNetEvent("mh-homeless:client:spawnhome", function(prop)
    SpawnHome(GetEntityCoords(PlayerPedId()), prop)
end)

RegisterNetEvent("mh-homeless:client:spawntrolley", function(prop)
    SpawnTrolley(GetEntityCoords(PlayerPedId()), prop)
end)

CreateThread(function()
    while true do
        local sleep = 2000
        if isLoggedIn and isEdit and useingObj ~= nil then
            sleep = 0
            local coords = GetEntityCoords(useingObj)
            if IsControlJustReleased(0, 172) then -- ARROW UP
                SetEntityCoords(useingObj, vector3(coords.x, coords.y, coords.z + 0.01))
            end
            if IsControlJustReleased(0, 173) then -- ARROW DOWN
                SetEntityCoords(useingObj, vector3(coords.x, coords.y, coords.z - 0.01))
            end
            if IsControlJustReleased(0, 174) then -- ARROW LEFT
                local rotation = GetEntityRotation(useingObj, 1) 
                SetEntityRotation(useingObj, rotation.x, rotation.y , rotation.z - 1.0, 1, true)
            end
            if IsControlJustReleased(0, 175) then -- ARROW RIGHT
                local rotation = GetEntityRotation(useingObj, 1) 
                SetEntityRotation(useingObj, rotation.x, rotation.y, rotation.z + 1.0, 1, true)
            end
            if IsControlJustReleased(0, 38) then -- E Place
                FreezeEntityPosition(useingObj, true)
                SetEntityDrawOutline(useingObj, false)                    
                isEdit = false
                useingObj = nil
            end
        end
        Wait(sleep)
    end
end)  