local function getRentalVehicleNetworkId(licensePlate, storedNetworkId)
    licensePlate = TrimLicensePlate(licensePlate)
    if licensePlate == '' then return end

    local playerCoords = GetEntityCoords(cache.ped)
    if type(storedNetworkId) == 'number' and storedNetworkId ~= 0 then
        local storedVehicle = NetworkGetEntityFromNetworkId(storedNetworkId)
        if storedVehicle ~= 0 and DoesEntityExist(storedVehicle)
            and TrimLicensePlate(GetVehicleNumberPlateText(storedVehicle)) == licensePlate
            and #(playerCoords - GetEntityCoords(storedVehicle)) <= 100.0 then
            return storedNetworkId
        end
    end

    local nearbyVehicles = GetGamePool('CVehicle')
    for vehicleIndex = 1, #nearbyVehicles do
        local nearbyVehicle = nearbyVehicles[vehicleIndex]
        if nearbyVehicle ~= 0 and DoesEntityExist(nearbyVehicle)
            and TrimLicensePlate(GetVehicleNumberPlateText(nearbyVehicle)) == licensePlate
            and #(playerCoords - GetEntityCoords(nearbyVehicle)) <= 100.0 then
            return NetworkGetNetworkIdFromEntity(nearbyVehicle)
        end
    end
end

local function findClearSpawnPoint(spawnPoints)
    local vehicles = GetGamePool('CVehicle')
    for spawnIndex = 1, #spawnPoints do
        local point = spawnPoints[spawnIndex]
        local occupied = false
        for vehicleIndex = 1, #vehicles do
            local nearbyVehicle = vehicles[vehicleIndex]
            if nearbyVehicle ~= 0 and DoesEntityExist(nearbyVehicle) and #(vector3(point.x, point.y, point.z) - GetEntityCoords(nearbyVehicle)) <= 2.0 then
                occupied = true
                break
            end
        end
        if not occupied then return point end
    end
end

lib.callback.register('MrNewbVehicleRentals:Callback:CreateVehicle', function(vehicleModel, deskName)
    local desk = Config.Agencies and Config.Agencies[deskName]
    if not desk then return 0 end

    local spawnPoint = findClearSpawnPoint(desk.vehicleSpawn)
    if not spawnPoint then return 0 end

    local modelHash = lib.requestModel(vehicleModel)
    if not modelHash then return 0 end

    local vehicle = CreateVehicle(modelHash, spawnPoint.x, spawnPoint.y, spawnPoint.z, spawnPoint.w or 0.0, true, false)
    SetModelAsNoLongerNeeded(modelHash)
    if vehicle == 0 or not DoesEntityExist(vehicle) then return 0 end

    local licensePlate = MakeRentalPlate(desk.platePrefix)
    SetVehicleNumberPlateText(vehicle, licensePlate)
    SetVehicleHasBeenOwnedByPlayer(vehicle, true)
    SetVehicleNeedsToBeHotwired(vehicle, false)
    SetVehRadioStation(vehicle, 'OFF')
    SetVehicleFuelLevel(vehicle, 100.0)
    bridge.vehiclefuel.set(vehicle, 100.0)
    SetNetworkIdCanMigrate(NetworkGetNetworkIdFromEntity(vehicle), true)

    return NetworkGetNetworkIdFromEntity(vehicle), licensePlate
end)

RegisterNetEvent('MrNewbVehicleRentals:Client:DeleteVehicle', function(vehicleNetworkId)
    if source ~= 65535 then return end
    if type(vehicleNetworkId) ~= 'number' or vehicleNetworkId == 0 then return end
    local vehicle = NetworkGetEntityFromNetworkId(vehicleNetworkId)
    if vehicle ~= 0 and DoesEntityExist(vehicle) then DeleteEntity(vehicle) end
end)

function OpenRentalMenu(deskName)
    local desk = Config.Agencies and Config.Agencies[deskName]
    if not desk then return end

    local menuOptions = {
        {
            title = deskName,
            description = locale('RentalMenus.TitleDescription'),
            icon = 'fa-solid fa-car',
            iconColor = 'orange',
        },
    }

    for _, vehicleForRent in pairs(desk.stock or {}) do
        menuOptions[#menuOptions + 1] = {
            title = vehicleForRent.label,
            description = locale('RentalMenus.MenuDescription', vehicleForRent.label, vehicleForRent.price),
            icon = 'fa-solid fa-car',
            iconColor = 'orange',
            onSelect = function()
                TriggerServerEvent('MrNewbVehicleRentals:Server:RentVehicle', deskName, vehicleForRent.model)
            end,
        }
    end

    local inventoryItems = bridge.inventory.getInventoryItems()
    if type(inventoryItems) == 'table' then
        for _, inventoryItem in pairs(inventoryItems) do
            local paperwork = inventoryItem.metadata or inventoryItem.info
            if inventoryItem.name == 'rental_paperwork' and type(paperwork) == 'table'
                and paperwork.rentalLocation == deskName and paperwork.plate
                and getRentalVehicleNetworkId(paperwork.plate, paperwork.vehNetId) then
                menuOptions[#menuOptions + 1] = {
                    title = locale('RentalMenus.ReturnTitle'),
                    description = locale('RentalMenus.ReturnDescription', paperwork.plate),
                    icon = 'fa-solid fa-car',
                    iconColor = 'red',
                    onSelect = function()
                        TriggerServerEvent('MrNewbVehicleRentals:Server:ReturnVehicle', deskName, paperwork.plate, inventoryItem.slot)
                    end,
                }
            end
        end
    end

    bridge.menu.openMenu({
        id = ('mrnewb_rental_%s'):format(deskName:gsub('%s+', '_'):lower()),
        title = deskName,
        options = menuOptions,
    })
end