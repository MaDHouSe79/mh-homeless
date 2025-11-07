-- [[ ===================================================== ]] --
-- [[                MH Homeless by MaDHouSe79              ]] --
-- [[ ===================================================== ]] --
local function DoesStashIdExist(id)
    local players = MySQL.query.await("SELECT * FROM "..sql.table)
    for k, player in pairs(players) do
        if player ~= nil then
            local items = json.decode(player.items)
            if items ~= nil then
                for k, item in pairs(items) do
                    if item.info ~= nil and item.info.stash_id ~= nil then
                        if item.info.stash_id == id then
                            return true
                        end
                    end
                end
            end
        end
    end
    return false
end

CreateUseableItem('homeless_shelter', function(source)
    local src = source
    TriggerClientEvent('mh-homeless:client:spawnhome', src, "prop_homeles_shelter_02")
end)

CreateUseableItem('homeless_trolley', function(source)
    local src = source
    TriggerClientEvent('mh-homeless:client:spawntrolley', src, "prop_skid_trolley_2")
end)

-- mh-homeless:server:onjoin
RegisterNetEvent("mh-homeless:server:onjoin", function()
    local src = source
    TriggerClientEvent('mh-homeless:client:onjoin', src, {status = true, config = SV_Config})
end)

RegisterNetEvent("mh-homeless:server:openStash", function(data)
    local src = source
    local Player = GetPlayer(src)
    if not Player then return end
    local citizenid = Player.PlayerData.citizenid
    local item = nil

    if data.type == 'trolly' then
        if SV_Config.InventoryScript == "qb-inventory" then
            item = exports['qb-inventory']:GetItemByName(src, 'homeles_trolley')
        elseif SV_Config.InventoryScript == "ox_inventory" then
        end
    elseif data.type == 'shelter' then
        if SV_Config.InventoryScript == "qb-inventory" then
            item = exports['qb-inventory']:GetItemByName(src, 'homeles_shelter') 
        elseif SV_Config.InventoryScript == "ox_inventory" then
        end
    end

    local owner = citizenid
    if item.info ~= nil and item.info.stash_id ~= nil then
        owner = item.info.stash_id
    end

    if data.type == 'trolly' then
        if SV_Config.InventoryScript == "qb-inventory" then
            exports['qb-inventory']:OpenInventory(src, 'homeles_trolly_stash_' .. owner, {maxweight = 50000, slots = 10})
        elseif SV_Config.InventoryScript == "ox_inventory" then
            exports.ox_inventory:openInventory(src, 'stash', 'homeles_trolly_stash_' .. owner, {maxweight = 50000, slots = 10})
        end
    elseif data.type == 'shelter' then
        if SV_Config.InventoryScript == "qb-inventory" then
            exports['qb-inventory']:OpenInventory(src, 'homeles_shelter_stash_' .. owner, {maxweight = 500000, slots = 20})
        elseif SV_Config.InventoryScript == "ox_inventory" then
            exports.ox_inventory:openInventory(src, 'stash', 'homeles_shelter_stash_' .. owner, {maxweight = 500000, slots = 20})
        end  
    end
end)

RegisterNetEvent("mh-homeless:server:buy_shelter_item", function(data)
    local src = source
    local Player = GetPlayer(src)
    local price = 0
    if Player then
        local citizenid = Player.PlayerData.citizenid
        local item = {}
        if data.type == "shelter" then
            item = {name = "homeles_shelter", price = Config.Shop.prices.shelter.price}
        elseif data.type == "trolly" then
            item = {name = "homeles_trolley", price = Config.Shop.prices.strolly.price}
        end
        local cash = Player.Functions.GetMoney('cash')
        if cash >= item.price then
            Player.Functions.RemoveMoney('cash', item.price)
            local id = nil
            local busy = true
            while busy do
                id = math.random(10000000, 99999999)
                if not DoesStashIdExist(id) then busy = false end
                Wait(100)
            end
            local info = {stash_id = id, owner = citizenid}
            if SV_Config.InventoryScript == "qb-inventory" then
                exports['qb-inventory']:AddItem(src, item.name, 1, nil, info, nil)
            elseif SV_Config.InventoryScript == "qb-ox_inventory" then
                exports.ox_inventory:AddItem(src, item.name, 1, nil, info, nil)
            end
        else
            Notify(src, "je hebt niet genoeg geld op zak...", "error", 5000)
        end
    end
end)