local spawnedDesks = {}
local deskBlips = {}
local blipCategoryLabeled = false

local function ensureBlipCategoryLabel(category)
    if blipCategoryLabeled then return end
    if type(category) ~= 'number' or category < 12 or category > 133 then return end

    local label = Config.BlipCategoryLabel
    if type(label) ~= 'string' or label == '' then return end

    AddTextEntry('BLIP_CAT_' .. category, label)
    blipCategoryLabeled = true
end

local function createDeskBlip(coords, blipData, deskName)
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, blipData.sprite or 227)
    SetBlipColour(blip, blipData.color or 5)
    SetBlipScale(blip, blipData.scale or 0.8)
    SetBlipAsShortRange(blip, true)

    local category = blipData.category or Config.BlipCategory
    if type(category) == 'number' then
        ensureBlipCategoryLabel(category)
        SetBlipCategory(blip, category)
    end

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(deskName)
    EndTextCommandSetBlipName(blip)
    return blip
end

local function createDeskInteraction(deskName, desk)
    local deskCoords = desk.coords
    local interaction = {
        model = desk.model,
        coords = vector3(deskCoords.x, deskCoords.y, deskCoords.z),
        heading = deskCoords.w or 0.0,
        radius = 100.0,
        options = {
            {
                label = deskName,
                icon = 'fa-solid fa-car',
                distance = 3.0,
                onSelect = function()
                    OpenRentalMenu(deskName)
                end,
            },
        },
    }

    if desk.animdata then interaction.anim = {animDict = desk.animdata.dict, anim = desk.animdata.anim, flag = desk.animdata.flags or 1, } end

    exports[bridge.name]:AddInteraction(('mrnewb_rental_%s'):format(deskName:gsub('%s+', '_'):lower()), interaction)
end

local function spawnRentalDesks()
    for deskName, desk in pairs(Config.Agencies or {}) do
        if spawnedDesks[deskName] then return end
        if type(deskName) ~= 'string' or type(desk) ~= 'table' or not desk.coords then return end

        if desk.blip then
            deskBlips[deskName] = createDeskBlip(desk.coords, desk.blip, deskName)
        end
        createDeskInteraction(deskName, desk)
        spawnedDesks[deskName] = true
    end
end

local function removeRentalDesks()
    for deskName in pairs(spawnedDesks) do
        exports[bridge.name]:RemoveInteraction(('mrnewb_rental_%s'):format(deskName:gsub('%s+', '_'):lower()))
        spawnedDesks[deskName] = nil
    end

    for deskName, blip in pairs(deskBlips) do
        if blip and DoesBlipExist(blip) then
            RemoveBlip(blip)
        end
        deskBlips[deskName] = nil
    end
end

AddEventHandler('Newb_Bridge:client:playerLoad', spawnRentalDesks)
AddEventHandler('Newb_Bridge:client:playerUnload', removeRentalDesks)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    removeRentalDesks()
end)

CreateThread(function()
    Wait(500)
    if next(spawnedDesks) then return end
    spawnRentalDesks()
end)
