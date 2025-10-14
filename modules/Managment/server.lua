---@diagnostic disable: duplicate-set-field
ManagmentObj = {}
ManagmentClass = {}
ManagmentClass.__index = ManagmentClass

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

function ManagmentClass:processReturn(src, plate, netId, slot)
    if not self.activeRentals[netId] then return end
    if self.activeRentals[netId].plate ~= plate then return end
    local veh = NetworkGetEntityFromNetworkId(netId)
    if not DoesEntityExist(veh) then return end
    local ped = GetPlayerPed(src)
    local pedCoords = GetEntityCoords(ped)
    local turnInCoords = vector3(self.position.x, self.position.y, self.position.z)
    if #(pedCoords - turnInCoords) > 5.0 then return Bridge.Notify.SendNotify(src, locale("RentalMenus.ReturnToFar"), "error", 3000) end
    Bridge.Framework.AddAccountBalance(src, "bank", self.activeRentals[netId].price)
    DeleteEntity(veh)
    Bridge.Inventory.RemoveItem(src, "rental_paperwork", 1, slot)
    self.activeRentals[netId] = nil
end

function ManagmentClass:processRental(src, vehiclemodel)
    if not self.stock[vehiclemodel] then return end
    local vehicleData = self.stock[vehiclemodel]
    local price = vehicleData.price
    local playerMoney = Bridge.Framework.GetAccountBalance(src, "bank")
    if playerMoney < 0 then return Bridge.Notify.SendNotify(src, locale("RentalMenus.NoMoney"), "error", 3000) end
    if playerMoney < price then return Bridge.Notify.SendNotify(src, locale("RentalMenus.NoMoney"), "error", 3000) end
    local netId, plate = Bridge.Callback.Trigger("MrNewbVehicleRentals:Callback:CreateVeh", src, vehiclemodel, self.vehicleSpawn)
    if not netId or not plate then return Bridge.Notify.SendNotify(src, locale("RentalMenus.NoSpawn"), "error", 3000) end
    Bridge.Framework.RemoveAccountBalance(src, "bank", price)
    local veh = NetworkGetEntityFromNetworkId(netId)
    local vehState = Entity(veh).state
    vehState:set('rental', true, true)
    vehState:set('door', 1, true)
    SetVehicleDoorsLocked(veh, 1)
    self.activeRentals[netId] = {plate = plate, price = price}
    local first, last = Bridge.Framework.GetPlayerName(src)
    local joined = string.format("%s %s", first, last)
    Bridge.Inventory.AddItem(src, "rental_paperwork", 1, nil, { plate = plate, description = locale("RentalMenus.PaperWorkItem", self.id, vehicleData.label, plate, joined) }, false)
end

RegisterNetEvent("MrNewbVehicleRentals:Server:RentVehicle", function(id, vehiclemodel)
    local src = source
    local obj = ManagmentObj[id]
    if not obj then return end
    obj:processRental(src, vehiclemodel)
end)

RegisterNetEvent("MrNewbVehicleRentals:Server:ReturnVehicle", function(id, plate, netid, slot)
    local src = source
    local obj = ManagmentObj[id]
    if not obj then return end
    obj:processReturn(src, plate, netid, slot)
end)

AddEventHandler('onResourceStart', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
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