---@diagnostic disable: duplicate-set-field
ManagmentObj = {}
ManagmentClass = {}
ManagmentClass.__index = ManagmentClass

function ManagmentClass:new(id, position, model, entityType, blipData, stock, animdata)
    local obj = {
        id = id,
        position = position,
        model = model,
        entityType = entityType,
        blipData = blipData,
        stock = stock,
        animdata = animdata,
    }
    setmetatable(obj, self)
    ManagmentObj[id] = obj
    obj:register()
    return obj
end

function ManagmentClass:register()
    if self.blipData then self.blip = Bridge.Utility.CreateBlip(self.position, self.blipData.sprite, self.blipData.color, self.blipData.scale, self.id, true, 2) end
    Bridge.Entity.Create({
        id = self.id,
        entityType = self.entityType,
        model = self.model,
        coords = self.position,
        heading = self.position.w,
        spawnDistance = 100,
        OnSpawn = function(entityData)
            SetEntityInvincible(entityData.spawned, true)
            FreezeEntityPosition(entityData.spawned, true)
            if self.animdata then
                Bridge.Utility.RequestAnimDict(self.animdata.dict)
                TaskPlayAnim(entityData.spawned, self.animdata.dict, self.animdata.anim, 8.0, -8.0, -1, self.animdata.flags, 0, false, false, false)
            end
            self.entity = entityData.spawned
            self.target = Bridge.Target.AddLocalEntity(entityData.spawned, {
                {
                    name = self.id,
                    label = self.id,
                    icon = "fa-solid fa-car",
                    color = "orange",
                    distance = 3,
                    onSelect = function()
                        self:openRentalMenu()
                    end
                },
            })
        end,
        OnRemove = function(entityData)
            if not entityData.spawned then return end
            Bridge.Target.RemoveLocalEntity(entityData.spawned)
            if self.animdata then RemoveAnimDict(self.animdata.dict) end
            self.entity = nil
            self.target = nil
        end
    })
end

local function checkForMatchedPlate(plate)
    local vehicles = GetGamePool('CVehicle')
    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        local vehPlate = GetVehicleNumberPlateText(vehicle)
        if vehPlate == plate then
            return NetworkGetNetworkIdFromEntity(vehicle)
        end
    end
    return false
end

local function returnVehicleMenuOptions(id)
    local inventory = Bridge.Inventory.GetPlayerInventory()
    local matchedItems = {}
    for k, v in pairs(inventory) do
        if v.name == "rental_paperwork" and v.metadata and v.metadata.plate then
        table.insert(matchedItems, {
                title = locale("RentalMenus.ReturnTitle"),
                description = locale("RentalMenus.ReturnDescription", v.metadata.plate),
                icon = "fa-solid fa-car",
                iconColor = "red",
                onSelect = function()
                    local foundData = checkForMatchedPlate(v.metadata.plate)
                    if not foundData then return Bridge.Notify.SendNotify(locale("RentalMenus.ReturnNoVehicle"), "error", 3000) end
                    Bridge.VehicleKey.RemoveKeys(NetworkGetEntityFromNetworkId(foundData), v.metadata.plate)
                    print(v.metadata.plate)
                    print(foundData)
                    print(v.slot)
                    TriggerServerEvent("MrNewbVehicleRentals:Server:ReturnVehicle", id, v.metadata.plate, foundData, v.slot)
                end
            })
        end
    end
    return matchedItems
end

function ManagmentClass:openRentalMenu()
    local menuOptions = {
        {
            title = self.id,
            description = locale("RentalMenus.TitleDescription"),
            icon = "fa-solid fa-car",
            iconColor = "orange",
        },
    }
    for k, v in pairs(Config.Managment[self.id].stock) do
        table.insert(menuOptions, {
            title = v.label,
            description = locale("RentalMenus.MenuDescription", v.label, v.price),
            icon = "fa-solid fa-car",
            iconColor = "orange",
            onSelect = function()
                TriggerServerEvent("MrNewbVehicleRentals:Server:RentVehicle", self.id, v.model)
            end
        })
    end
    local returnOptions = returnVehicleMenuOptions(self.id)
    if #returnOptions > 0 then
        for k, v in pairs(returnOptions) do
            table.insert(menuOptions, v)
        end
    end
    local menuID = Bridge.Ids.RandomLower(nil, 8)
    Wait(500)
    Bridge.Menu.Open({ id = menuID, title = self.id, options = menuOptions }, false)
end

function ManagmentClass:destroy()
    Bridge.Entity.Destroy(self.id)
    if self.blip then Bridge.Utility.RemoveBlip(self.blip) end
    if self.target then Bridge.Target.RemoveLocalEntity(self.entity) end
    ManagmentObj[self.id] = nil
end

function BuildManagmentObjects()
    for k, v in pairs(Config.Managment) do
        ManagmentClass:new(k, v.coords, v.model, v.entityType, v.blip, v.stock, v.animdata)
    end
end

local function findClearSpawnPoint(spawnPoints)
    local radius = 3.0
    local vehicles = GetGamePool('CVehicle')
    for k, v in pairs(spawnPoints) do
        local isOccupied = false
        for i = 1, #vehicles do
            local vehicle = vehicles[i]
            local vehCoords = GetEntityCoords(vehicle)
            local distance = #(vector3(v.x, v.y, v.z) - vehCoords)
            if distance <= radius then
                isOccupied = true
                break
            end
        end
        if not isOccupied then return v end
    end
    return false
end

local function destroyAll()
    for k, v in pairs(ManagmentObj) do
        v:destroy()
    end
end

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    destroyAll()
end)

Bridge.Callback.Register("MrNewbVehicleRentals:Callback:CreateVeh", function(model, spawnPoints)
    local spawnPosition = findClearSpawnPoint(spawnPoints)
    if not spawnPosition then return false, false end
    local ent, data = Bridge.Utility.CreateVehicle(model, spawnPosition, spawnPosition.w, true)
    Bridge.VehicleKey.GiveKeys(ent, GetVehicleNumberPlateText(ent))
    return data.networkid, GetVehicleNumberPlateText(ent)
end)

AddEventHandler("community_bridge:Client:OnPlayerUnload", function()
    destroyAll()
end)

AddEventHandler("community_bridge:Client:OnPlayerLoaded", function()
    BuildManagmentObjects()
end)