ESX = nil TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Menu --
local open = false 

local MenuVehicle = RageUI.CreateMenu("Gestion Véhicule", "INTERACTION")
local MenuSpeed = RageUI.CreateSubMenu(MenuVehicle, "Limiteur de vitesse", "INTERACTION")
MenuVehicle.Display.Header = true MenuVehicle.Closed = function() open = false end

-- Pour calculer la vitesse > Vitesse/3.6 Exemple 30/3.6 = 8.33 (puis arrondir)
local limit, speedLimitActive, door, hood, chest = "Aucune Limitation", false, 1, 1, 1

function OpenMenuSpeedLimit() 
    if open then open = false RageUI.Visible(MenuVehicle, false) return else open = true RageUI.Visible(MenuVehicle, true)
        Citizen.CreateThread(function()
            while open do 
                RageUI.IsVisible(MenuVehicle, function()
                    local ped = PlayerPedId()
                    local vehicle = GetVehiclePedIsUsing(ped)

                    RageUI.Separator("↓     ~g~Gestion véhicule     ~s~↓")
                    RageUI.Checkbox("Éteindre le moteur", nil, CheckboxActive, {}, {
                        onChecked = function()
                            CheckboxActive = true
                            SetVehicleEngineOn(vehicle, false, false, true)
                        end,
                        onUnChecked = function()
                            CheckboxActive = false
                            SetVehicleEngineOn(vehicle, true, false, true)
                        end
                    })

                    RageUI.List("Ouvrir porte:", {
                        {Name = "~o~Avant gauche~s~", Value = 1},
                        {Name = "~o~Avant droite~s~", Value = 2},
                        {Name = "~y~Arrière gauche~s~", Value = 3},
                        {Name = "~y~Arrière droite~s~", Value = 4}
                    }, door, nil, {}, true, {
                        onListChange = function(Index)
                            door = Index;
                        end,
                        
                        onSelected = function(Index)
                            if Index == 1 then 
                                if not openBeforeDoorLeft then
                                    openBeforeDoorLeft = true
                                    SetVehicleDoorOpen(vehicle, 0, false, false)
                                elseif not closeBeforeDoorLeft then
                                    closeBeforeDoorLeft = true
                                    SetVehicleDoorShut(vehicle, 0, false, false)
                                end
                            end

                            if Index == 2 then 
                                if not openBeforeDoorRight then
                                    openBeforeDoorRight = true
                                    SetVehicleDoorOpen(vehicle, 1, false, false)
                                elseif not closeBeforeDoorRight then
                                    closeBeforeDoorRight = true
                                    SetVehicleDoorShut(vehicle, 1, false, false)
                                end
                            end

                            if Index == 3 then 
                                if not openBackDoorLeft then
                                    openBackDoorLeft = true
                                    SetVehicleDoorOpen(vehicle, 2, false, false)
                                elseif not closeBackDoorLeft then
                                    closeBackDoorLeft = true
                                    SetVehicleDoorShut(vehicle, 2, false, false)
                                end
                            end

                            if Index == 4 then 
                                if not openBackDoorRight then
                                    openBackDoorRight = true
                                    SetVehicleDoorOpen(vehicle, 3, false, false)
                                elseif not closeBackDoorRight then
                                    closeBackDoorRight = true
                                    SetVehicleDoorShut(vehicle, 3, false, false)
                                end
                            end
                        end
                    })

                    RageUI.List("Capot", {
                        {Name = "~g~Ouvrir~s~", Value = 1},
                        {Name = "~r~Fermer~s~", Value = 2}
                    }, hood, nil, {}, true, {
                        onListChange = function(Index)
                            hood = Index;
                        end,
                        
                        onSelected = function(Index)
                            if Index == 1 then 
                                SetVehicleDoorOpen(vehicle, 4, false, false)
                            end

                            if Index == 2 then 
                                SetVehicleDoorShut(vehicle, 4, false, false)
                            end
                        end
                    })

                    RageUI.List("Coffre", {
                        {Name = "~g~Ouvrir~s~", Value = 1},
                        {Name = "~r~Fermer~s~", Value = 2}
                    }, chest, nil, {}, true, {
                        onListChange = function(Index)
                            chest = Index;
                        end,
                        
                        onSelected = function(Index)
                            if Index == 1 then 
                                SetVehicleDoorOpen(vehicle, 5, false, false)
                            end

                            if Index == 2 then 
                                SetVehicleDoorShut(vehicle, 5, false, false)
                            end
                        end
                    })

                    RageUI.Button("Limiteur de vitesse", nil, {RightLabel = "~y~→→→"}, true, {}, MenuSpeed)

                    RageUI.Separator("↓     ~r~Fermeture     ~s~↓") 
                    RageUI.Button("~r~Fermer", nil, {RightLabel = "~y~→→"}, true, {
                        onSelected = function() 
                            RageUI.CloseAll() 
                            open = false 
                        end
                    })
                end)

                RageUI.IsVisible(MenuSpeed, function()
                    local plyPed = PlayerPedId()
                    local plyVehicle = GetVehiclePedIsIn(plyPed, false)
                    CarSpeed = GetEntitySpeed(plyVehicle) * 3.6
                    if CarSpeed <= 40.0 then
                        RageUI.Separator("↓     ~g~Personalisé     ~s~↓")
                        RageUI.Button("Limitation: ~r~"..limit, nil, {RightLabel = "~y~→"}, true, {
                            onSelected = function()
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    local speedlimit = KeyboardInput("Rentrer une vitesse", "", 10)
                                    limit, speedLimitActive = speedlimit.."km/h", true
                                    SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), speedlimit/3.7)
                                else
                                    ESX.ShowNotification("Vous devez être dans un véhicule !")
                                end
                            end
                        })

                        RageUI.Separator("↓     ~g~Limiteur de vitesse     ~s~↓")
                        RageUI.Button("Limitation ~g~30km/h", nil, {RightLabel = "~y~→"}, true, {
                            onSelected = function()
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    speedLimitActive = true
                                    SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 8.1)
                                else
                                    ESX.ShowNotification("Vous devez être dans un véhicule !")
                                end
                            end
                        })

                        RageUI.Button("Limitation ~g~50km/h", nil, {RightLabel = "~y~→"}, true, {
                            onSelected = function()
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    speedLimitActive = true
                                    SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 13.7)
                                else
                                    ESX.ShowNotification("Vous devez être dans un véhicule !")
                                end
                            end
                        })

                        RageUI.Button("Limitation ~g~80km/h", nil, {RightLabel = "~y~→"}, true, {
                            onSelected = function()
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    speedLimitActive = true
                                    SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 22.0)
                                else
                                    ESX.ShowNotification("Vous devez être dans un véhicule !")
                                end
                            end
                        })

                        RageUI.Button("Limitation ~g~120km/h", nil, {RightLabel = "~y~→"}, true, {
                            onSelected = function()
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    speedLimitActive = true
                                    SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 33.0)
                                else
                                    ESX.ShowNotification("Vous devez être dans un véhicule !")
                                end
                            end
                        })

                        RageUI.Separator("↓     ~o~Désactiver     ~s~↓")
                        RageUI.Button("Désactivation", nil, {RightLabel = "~y~→"}, true, {
                            onSelected = function()
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    limit, speedLimitActive = "Aucune Limitation", false
                                    SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 0.0)
                                else
                                    ESX.ShowNotification("Vous devez être dans un véhicule !")
                                end
                            end
                        })

                        RageUI.Separator("↓     ~r~Fermeture     ~s~↓") 
                        RageUI.Button("~r~Fermer", nil, {RightLabel = "~y~→→"}, true, {
                            onSelected = function() 
                                RageUI.CloseAll() 
                                open = false 
                            end
                        })
                    else
                        RageUI.Separator("")
                        RageUI.Separator("~r~Vous roulez trop vite pour")
                        RageUI.Separator("~r~activer le limiteur de vitesse !")
                        RageUI.Separator("Votre vitesse: ~r~"..math.ceil(CarSpeed).."km/h")
                        RageUI.Separator("")

                        if speedLimitActive then 
                            RageUI.Separator("↓     ~o~Désactiver     ~s~↓")
                            RageUI.Button("Désactivation", nil, {RightLabel = "~y~→"}, true, {
                            onSelected = function()
                                if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                    limit, speedLimitActive = "Aucune Limitation", false
                                    SetVehicleMaxSpeed(GetVehiclePedIsIn(PlayerPedId(), false), 0.0)
                                else
                                    ESX.ShowNotification("Vous devez être dans un véhicule !")
                                end
                            end
                        })
                        end

                        RageUI.Separator("↓     ~r~Fermeture     ~s~↓") 
                        RageUI.Button("~r~Fermer", nil, {RightLabel = "~y~→→"}, true, {
                            onSelected = function() 
                                RageUI.CloseAll() 
                                open = false 
                            end
                        })
                    end
                end)
            Wait(0)
            end
        end)
    end
end

function KeyboardInput(TextEntry, ExampleText, MaxStringLenght)
    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLenght)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end
        
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult() 
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end

RegisterCommand("speed", function(source, args, rawcommand) 
    OpenMenuSpeedLimit() 
end, false)

Keys.Register('G', 'G', 'Ouvrir le menu gestion véhicule', function()
    OpenMenuSpeedLimit()
end)