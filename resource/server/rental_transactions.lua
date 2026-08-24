local rentalDesks = {}
local rentalsByPlate = {}

local function getDeskIfPlayerIsClose(src, deskName)
    local playerPed = GetPlayerPed(src)
    if playerPed == 0 or not DoesEntityExist(playerPed) then return end
    if type(deskName) ~= 'string' or deskName == '' or #deskName > 64 then return end

    local desk = rentalDesks[deskName]
    if not desk or not desk.position then return end
    if #(GetEntityCoords(playerPed) - vector3(desk.position.x, desk.position.y, desk.position.z)) > 8.0 then
        return nil, 'far'
    end

    return desk
end

for deskName, deskConfig in pairs(Config.Agencies or {}) do
    rentalDesks[deskName] = {
        id = deskName,
        position = deskConfig.coords,
        stock = deskConfig.stock or {},
        vehicleSpawn = deskConfig.vehicleSpawn or {},
        platePrefix = deskConfig.platePrefix,
    }
end

RegisterNetEvent('MrNewbVehicleRentals:Server:RentVehicle', function(deskName, vehicleModel)
    local src = source
    local desk = getDeskIfPlayerIsClose(src, deskName)
    if not desk then return end
    if type(vehicleModel) ~= 'string' or vehicleModel == '' or #vehicleModel > 32 then return end

    local vehicleForRent = desk.stock[vehicleModel]
    local rentalPrice = vehicleForRent and tonumber(vehicleForRent.price)
    if not vehicleForRent or not rentalPrice or rentalPrice < 0 then return end

    local renterIdentifier = bridge.framework.getIdentifier(src)
    if not renterIdentifier then return end

    if (tonumber(bridge.framework.getMoney(src, 'bank')) or 0) < rentalPrice then
        bridge.notifications.notify(src, { description = locale('RentalMenus.NoMoney'), type = 'error', duration = 3000 })
        return
    end

    if not bridge.inventory.canCarryItem(src, 'rental_paperwork', 1) then return end

    local vehicleNetworkId, licensePlate = lib.callback.await('MrNewbVehicleRentals:Callback:CreateVehicle', src, vehicleModel, deskName)
    if type(vehicleNetworkId) ~= 'number' or vehicleNetworkId == 0 then
        bridge.notifications.notify(src, { description = locale('RentalMenus.SpawnFailed'), type = 'error', duration = 3000 })
        return
    end

    local rentalVehicle = NetworkGetEntityFromNetworkId(vehicleNetworkId)
    for _ = 1, 40 do
        if rentalVehicle ~= 0 and DoesEntityExist(rentalVehicle) then break end
        Wait(50)
        rentalVehicle = NetworkGetEntityFromNetworkId(vehicleNetworkId)
    end
    Wait(500)
    if rentalVehicle == 0 or not DoesEntityExist(rentalVehicle) or GetEntityModel(rentalVehicle) ~= joaat(vehicleModel) then
        bridge.notifications.notify(src, { description = locale('RentalMenus.SpawnFailed'), type = 'error', duration = 3000 })
        TriggerClientEvent('MrNewbVehicleRentals:Client:DeleteVehicle', src, vehicleNetworkId)
        return
    end

    licensePlate = TrimLicensePlate(licensePlate)
    if licensePlate == '' or rentalsByPlate[licensePlate] then
        for _ = 1, 20 do
            local nextPlate = MakeRentalPlate(desk.platePrefix)
            if not rentalsByPlate[nextPlate] then
                licensePlate = nextPlate
                break
            end
        end
        if licensePlate == '' or rentalsByPlate[licensePlate] then
            bridge.notifications.notify(src, { description = locale('RentalMenus.SpawnFailed'), type = 'error', duration = 3000 })
            DeleteEntity(rentalVehicle)
            return
        end
        SetVehicleNumberPlateText(rentalVehicle, licensePlate)
    end

    if not bridge.framework.removeMoney(src, 'bank', rentalPrice, 'vehicle_rental') then
        bridge.notifications.notify(src, { description = locale('RentalMenus.NoMoney'), type = 'error', duration = 3000 })
        DeleteEntity(rentalVehicle)
        return
    end

    Entity(rentalVehicle).state:set('rental', true, true)
    SetVehicleDoorsLocked(rentalVehicle, 1)
    bridge.vehiclekeys.give(src, rentalVehicle, licensePlate)

    local renterName = select(1, bridge.framework.getCharacterName(renterIdentifier)) or 'Unknown'
    rentalsByPlate[licensePlate] = {
        renter = renterIdentifier,
        deskName = desk.id,
        price = rentalPrice,
        vehicleNetworkId = vehicleNetworkId,
        vehicleModel = GetEntityModel(rentalVehicle),
    }

    if not bridge.inventory.addItem(src, 'rental_paperwork', 1, {
        plate = licensePlate,
        rentalLocation = desk.id,
        vehNetId = vehicleNetworkId,
        vehName = vehicleForRent.label,
        renter = renterName,
        description = locale('RentalMenus.PaperWorkItem', desk.id, vehicleForRent.label, licensePlate, renterName),
    }) then
        bridge.vehiclekeys.remove(src, rentalVehicle, licensePlate)
        DeleteEntity(rentalVehicle)
        rentalsByPlate[licensePlate] = nil
        bridge.framework.addMoney(src, 'bank', rentalPrice, 'vehicle_rental')
    end
end)

RegisterNetEvent('MrNewbVehicleRentals:Server:ReturnVehicle', function(deskName, licensePlate, inventorySlot)
    local src = source
    local desk, reason = getDeskIfPlayerIsClose(src, deskName)
    if not desk then
        if reason == 'far' then bridge.notifications.notify(src, { description = locale('RentalMenus.ReturnToFar'), type = 'error', duration = 3000 }) end
        return
    end

    licensePlate = TrimLicensePlate(licensePlate)
    if licensePlate == '' or type(inventorySlot) ~= 'number' then return end

    local rental = rentalsByPlate[licensePlate]
    local renterIdentifier = bridge.framework.getIdentifier(src)
    if not rental or rental.deskName ~= desk.id or not renterIdentifier or rental.renter ~= renterIdentifier then return end

    local paperworkItem = bridge.inventory.getSlot(src, inventorySlot)
    local paperwork = paperworkItem and (paperworkItem.metadata or paperworkItem.info)
    if not paperworkItem or paperworkItem.name ~= 'rental_paperwork' or type(paperwork) ~= 'table' then return end
    if TrimLicensePlate(paperwork.plate) ~= licensePlate or paperwork.rentalLocation ~= desk.id then return end

    local rentalVehicle = NetworkGetEntityFromNetworkId(rental.vehicleNetworkId)
    if rentalVehicle == 0 or not DoesEntityExist(rentalVehicle) then
        bridge.notifications.notify(src, { description = locale('RentalMenus.ReturnNoVehicle'), type = 'error', duration = 3000 })
        return
    end

    if TrimLicensePlate(GetVehicleNumberPlateText(rentalVehicle)) ~= licensePlate then return end
    if rental.vehicleModel and GetEntityModel(rentalVehicle) ~= rental.vehicleModel then return end
    if #(GetEntityCoords(rentalVehicle) - vector3(desk.position.x, desk.position.y, desk.position.z)) > 100.0 then
        bridge.notifications.notify(src, { description = locale('RentalMenus.ReturnToFar'), type = 'error', duration = 3000 })
        return
    end

    if not bridge.inventory.removeItem(src, 'rental_paperwork', 1, nil, inventorySlot) then return end

    bridge.framework.addMoney(src, 'bank', rental.price, 'vehicle_rental_return')
    bridge.vehiclekeys.remove(src, rentalVehicle, licensePlate)
    DeleteEntity(rentalVehicle)
    rentalsByPlate[licensePlate] = nil
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    for _, rental in pairs(rentalsByPlate) do
        local vehicle = NetworkGetEntityFromNetworkId(rental.vehicleNetworkId)
        if vehicle ~= 0 and DoesEntityExist(vehicle) then DeleteEntity(vehicle) end
    end
    rentalsByPlate = {}
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    exports[bridge.name]:VersionCheck('MrNewb/patchnotes', resourceName)
end)