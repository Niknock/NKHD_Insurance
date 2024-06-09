ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        if Config.ESX == 'old' then
                TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        elseif Config.ESX == 'new' then
            ESX = exports["es_extended"]:getSharedObject()
        else
            print('Wrong ESX Type!')
        end
    end
end)

Citizen.CreateThread(function()
    local blip = AddBlipForCoord(Config.Marker.x, Config.Marker.y, Config.Marker.z)

    SetBlipSprite(blip, 380)
    SetBlipDisplay(blip, 4)
    SetBlipScale(blip, 0.8)
    SetBlipColour(blip, 17)
    SetBlipAsShortRange(blip, true)

    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(_U('blip'))
    EndTextCommandSetBlipName(blip)

    local marker = vector3(Config.Marker.x, Config.Marker.y, Config.Marker.z)
    while true do
        Citizen.Wait(0)
        DrawMarker(1, marker.x, marker.y, marker.z - 1, 0, 0, 0, 0, 0, 0, 1.5, 1.5, 1.0, 255, 255, 255, 200, 0, 0, 0, 0)
    end
end)

RegisterNetEvent('showInsuranceMenu')
AddEventHandler('showInsuranceMenu', function()
    ESX.UI.Menu.CloseAll()

    local elements = {}
    ESX.TriggerServerCallback('getOwnedVehicles', function(ownedVehicles)
        for _, vehicle in ipairs(ownedVehicles) do
            
            local insuranceLabel = {}
            if vehicle.insured == 1 then insuranceLabel = _U('insured_menu') else insuranceLabel = _U('notinsured_menu') end
                

            table.insert(elements, {
                label = string.format("%s (%s)", vehicle.plate, insuranceLabel),
                value = vehicle.plate
            })
        end

        ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'insurance_menu',
            {
                title    = _U('blip'),
                align    = 'top-left',
                elements = elements
            },
            function(data, menu)
                menu.close()

                TriggerServerEvent('nkhd:insureVehicle', source, data.current.value)
                TriggerEvent('nkhd:removemoneyclient', source)
            end,
            function(data, menu)
                menu.close()
            end
        )
    end)
end)

RegisterNetEvent('nkhd:removemoneyclient')
AddEventHandler('nkhd:removemoneyclient', function()
    TriggerServerEvent('nkhd:removemoney', source)
end)

RegisterNetEvent('nkhd:notifinssuc')
AddEventHandler('nkhd:notifinssuc', function()
    ShowNotification(_U('insured'))
end)


Citizen.CreateThread(function()
    local inRange = false
    while true do
       inRange = false
       local myPed = PlayerPedId()
       local myCoords = GetEntityCoords(myPed)
       local targetCoords = vec(Config.Marker.x, Config.Marker.y, Config.Marker.z)
       local distance = #(myCoords - targetCoords)
       if distance < 1.5 then
           inRange = true         
            ESX.ShowHelpNotification(_U('inrange'))
           if IsControlJustPressed(0, 38) then
             inRange = false
             TriggerEvent('showInsuranceMenu')
          end
       end
       Citizen.Wait(0)
    end
end)


function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end