---@diagnostic disable: duplicate-set-field
ManagmentObj = {}
ManagmentClass = {}
ManagmentClass.__index = ManagmentClass

---The initial object creation
---@param id string
---@param position table
---@param model string
---@param stock number
---@param vehicleSpawn table
---@return table
function ManagmentClass:new(id, position, model, stock, vehicleSpawn)
    local obj = {
        id = id,
        position = position,
        model = model,
        stock = stock,
        vehicleSpawn = vehicleSpawn,
        activeRentals = {},
    }
    setmetatable(obj, self)
    ManagmentObj[id] = obj
    return obj
end

function ManagmentClass:destroy()
    for k, v in pairs(self.activeRentals) do
        local veh = NetworkGetEntityFromNetworkId(k)
        if DoesEntityExist(veh) then DeleteEntity(veh) end
    end
end

---Will process the return of a rental vehicle
---@param src number
---@param plate string
---@param netId number
---@param slot number
function ManagmentClass:processReturn(src, plate, netId, slot)
    if not self.activeRentals[netId] then return end
    if self.activeRentals[netId].plate ~= plate then return end
    local veh = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(veh) then return end
    local ped = GetPlayerPed(src)
    local pedCoords = GetEntityCoords(ped)
    local turnInCoords = vector3(self.position.x, self.position.y, self.position.z)
    if #(pedCoords - turnInCoords) > 5.0 then return Bridge.Notify.SendNotify(src, locale("RentalMenus.ReturnToFar"), "error", 3000) end
    local vehCoords = GetEntityCoords(veh)
    if #(turnInCoords - vehCoords) > 100.0 then return Bridge.Notify.SendNotify(src, locale("RentalMenus.ReturnToFar"), "error", 3000) end
    local storedData = self.activeRentals[netId]
    if not storedData then return end
    local identifier = Bridge.Framework.GetPlayerIdentifier(src)
    if storedData.renter ~= identifier then return end
    Bridge.Framework.AddAccountBalance(src, "bank", storedData.price)
    DeleteEntity(veh)
    Bridge.Inventory.RemoveItem(src, "rental_paperwork", 1, slot)
    self.activeRentals[netId] = nil
end

---Will process the rental of a vehicle
---@param src number
---@param vehiclemodel string
function ManagmentClass:processRental(src, vehiclemodel)
    if not self.stock[vehiclemodel] then return end
    local vehicleData = self.stock[vehiclemodel]
    local price = vehicleData.price
    local playerMoney = Bridge.Framework.GetAccountBalance(src, "bank")
    if playerMoney < 0 then return Bridge.Notify.SendNotify(src, locale("RentalMenus.NoMoney"), "error", 3000) end
    if playerMoney < price then return Bridge.Notify.SendNotify(src, locale("RentalMenus.NoMoney"), "error", 3000) end
    local netId, plate = Bridge.Callback.Trigger("MrNewbVehicleRentals:Callback:CreateVeh", src, vehiclemodel, self.vehicleSpawn)
    if not netId or not plate then return Bridge.Notify.SendNotify(src, locale("RentalMenus.NoSpawn"), "error", 3000) end
    if not Bridge.Framework.RemoveAccountBalance(src, "bank", price) then return end
    local veh = NetworkGetEntityFromNetworkId(netId)
    local vehState = Entity(veh).state
    vehState:set('rental', true, true)
    vehState:set('door', 1, true)
    SetVehicleDoorsLocked(veh, 1)
    local identifier = Bridge.Framework.GetPlayerIdentifier(src)
    self.activeRentals[netId] = {renter = identifier, plate = plate, price = price}
    local first, last = Bridge.Framework.GetPlayerName(src)
    local joined = string.format("%s %s", first, last)
	return Bridge.Inventory.AddItem(src, "rental_paperwork", 1, nil, {plate = plate, rentalLocation = self.id, vehNetId = netId, vehName = vehicleData.label, renter = joined, description = locale("RentalMenus.PaperWorkItem", self.id, vehicleData.label, plate, joined)})
end

---Will handle rental requests
---@param id string
---@param vehiclemodel string
RegisterNetEvent("MrNewbVehicleRentals:Server:RentVehicle", function(id, vehiclemodel)
    local src = source
    local obj = ManagmentObj[id]
    if not obj then return end
    local ped = GetPlayerPed(src)
    local pedCoords = GetEntityCoords(ped)
    local rentCoords = vector3(obj.position.x, obj.position.y, obj.position.z)
    if #(pedCoords - rentCoords) > 100.0 then return end
    obj:processRental(src, vehiclemodel)
end)

---This will handle return requests
---@param id string
---@param plate string
---@param netid number
---@param slot number
RegisterNetEvent("MrNewbVehicleRentals:Server:ReturnVehicle", function(id, plate, netid, slot)
    local src = source
    local obj = ManagmentObj[id]
    if not obj then return end
    local ped = GetPlayerPed(src)
    local pedCoords = GetEntityCoords(ped)
    local rentCoords = vector3(obj.position.x, obj.position.y, obj.position.z)
    if #(pedCoords - rentCoords) > 100.0 then return end
    obj:processReturn(src, plate, netid, slot)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    Bridge.Version.AdvancedVersionChecker("MrNewb/patchnotes", resourceName)
    Bridge.Version.AdvancedVersionChecker("MrNewb/patchnotes", "community_bridge")
    for k, v in pairs(Config.Managment) do
        ManagmentClass:new(k, v.coords, v.model, v.stock, v.vehicleSpawn)
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    for k, v in pairs(ManagmentObj) do
        v:destroy()
    end
end)