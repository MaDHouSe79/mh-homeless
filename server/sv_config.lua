-- [[ ===================================================== ]] --
-- [[                MH Homeless by MaDHouSe79              ]] --
-- [[ ===================================================== ]] --
SV_Config = {}

SV_Config.Framework = "qb"                 -- qb/qbx/esx
SV_Config.InventoryScript = "qb-inventory" -- qb-inventory or ox_inventory
SV_Config.TargetScript    = "qb-target"    -- qb-target or ox_target


SV_Config.Shop = {
    label = "Shelter Shop",
    model = "a_m_m_tramp_01",
    coords = vector4(3.1764, -1215.0737, 26.7030, 269.4839),
    prices = {
        shelter = {price = 500},
        strolly = {price = 100},
    }
}