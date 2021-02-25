local currentLaunderer = 0
local launderBlip = nil
local lastSpot = 1
local laundering = -1
local launderNPC = nil
ESX = nil

Citizen.CreateThread(
    function()
        while ESX == nil do
            TriggerEvent(
                "esx:getSharedObject",
                function(obj)
                    ESX = obj
                end
            )
            Citizen.Wait(0)
        end
        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(10)
        end
        TriggerServerEvent("otaku_moneylaunderer:getLaunderer")
    end
)

RegisterNetEvent("esx:playerLoaded")
AddEventHandler(
    "esx:playerLoaded",
    function(xPlayer)
        ESX.PlayerData = xPlayer
    end
)

RegisterNetEvent("esx:setJob")
AddEventHandler(
    "esx:setJob",
    function(job)
        ESX.PlayerData.job = job
    end
)

function drawTxt(text, font, centre, x, y, scale, r, g, b, a)
    SetTextFont(font)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(centre)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

function isNearMoneyLaunderer()
    if laundering <= 0 and Config.launderLocations[currentLaunderer] then
        local ply = GetPlayerPed(-1)
        local plyCoords = GetEntityCoords(ply, 0)
        local distance = GetDistanceBetweenCoords(Config.launderLocations[currentLaunderer].pos, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)

        if isEmergencyStaff() and distance < 20 then
            -- move the launderer
            TriggerServerEvent("otaku_moneylaunderer:setLaunderer")
        end

        if (distance <= 3) then
            lastSpot = currentLaunderer
        end

        if distance ~= nil then
            return distance
        end
    end

    return 999
end

function isNearSpecificMoneyLaunderer(launderer)
    local ply = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ply, 0)
    local distance = GetDistanceBetweenCoords(Config.launderLocations[launderer].pos, plyCoords["x"], plyCoords["y"], plyCoords["z"], true)
    if (distance < 5) then
        return true
    end
end

function isEmergencyStaff()
    if ESX.PlayerData.job ~= nil and (ESX.PlayerData.job.name == "police" or ESX.PlayerData.job.name == "ambulance") then
        return true
    else
        return false
    end
end

Citizen.CreateThread(
    function()
        local dirtyWaitTime = 20000
        while true do
            Citizen.Wait(dirtyWaitTime)
            dirtyWaitTime = 500

            local ply = GetPlayerPed(-1)
            if isNearMoneyLaunderer() <= 5.0 and not IsPedInAnyVehicle(ply) and laundering == -1 then
                dirtyWaitTime = 0
                drawTxt("Press ~g~E~s~ to begin laundering your money.", 0, 1, 0.5, 0.8, 0.6, 255, 255, 255, 255)

                if IsControlJustPressed(1, 38) then
                    local plyPos = GetEntityCoords(ply, true)

                    ESX.ShowAdvancedNotification(
                        "Money Laundering",
                        "Stick around, I need to take a look at the cash first, I won't be long!",
                        "fas fa-money-bill",
                        "blue"
                    )

                    RequestAnimDict("mp_common")
                    while (not HasAnimDictLoaded("mp_common")) do
                        Citizen.Wait(0)
                    end

                    TaskPlayAnim(launderNPC, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
                    TaskPlayAnim(ply, "mp_common", "givetake2_a", 100.0, 200.0, 0.3, 120, 0.2, 0, 0, 0)
                    Citizen.Wait(15000)

                    if isNearSpecificMoneyLaunderer(lastSpot) and not IsPedInAnyVehicle(ply) then
                        TriggerServerEvent("otaku_moneylaunderer:launderMoney", lastSpot)
                        laundering = lastSpot
                    else
                        ESX.ShowAdvancedNotification("Money Laundering", "Hey, where'd you go?", "fas fa-money-bill", "blue")
                    end
                end
            end
        end
    end
)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(1000)
            local ply = GetPlayerPed(-1)
            if
                laundering > 0 and
                    (not isNearSpecificMoneyLaunderer(laundering) or IsPedBeingStunned(closestPed) or
                        IsEntityPlayingAnim(closestPed, "random@mugging3", "handsup_standing_base", 3) or
                        IsPedInAnyVehicle(ply))
             then
                TriggerServerEvent("otaku_moneylaunderer:stopLaundering")
                laundering = -1
            end
        end
    end
)

RegisterNetEvent("otaku_moneylaunderer:updateLaunderer")
AddEventHandler(
    "otaku_moneylaunderer:updateLaunderer",
    function(launderer)
        if launderer ~= currentLaunderer then
            currentLaunderer = launderer
            laundering = -1

            if not isEmergencyStaff() then
                launderBlip = AddBlipForCoord(Config.launderLocations[launderer].pos)
                SetBlipSprite(launderBlip, 408)
                SetBlipAsShortRange(launderBlip, true)
                BeginTextCommandSetBlipName("STRING")
                AddTextComponentString("Money Launderer")
                EndTextCommandSetBlipName(launderBlip)
            end

            launderNPC = createPed("mp_m_forgery_01", Config.launderLocations[launderer].pos, 0.0, false)
            FreezeEntityPosition(launderNPC, true)
        end
    end
)

RegisterNetEvent("otaku_moneylaunderer:removeLaunderer")
AddEventHandler(
    "otaku_moneylaunderer:removeLaunderer",
    function()
        if launderBlip ~= nil then
            RemoveBlip(launderBlip)
        end

        if launderNPC ~= nil then
            ClearPedTasksImmediately(launderNPC)
            ClearPedSecondaryTask(launderNPC)

            local reaction = math.random(1, 3)

            if reaction == 1 then
                TaskReactAndFleePed(launderNPC, GetPlayerPed(-1))
            elseif reaction == 2 then
                TaskPlayAnim(launderNPC, "random@arrests", "idle_2_hands_up", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                Citizen.Wait(4000)
                TaskPlayAnim(launderNPC, "random@arrests", "kneeling_arrest_idle", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                Citizen.Wait(500)
                TaskPlayAnim(launderNPC, "random@arrests@busted", "enter", 8.0, 1.0, -1, 2, 0, 0, 0, 0)
                Citizen.Wait(1000)
                TaskPlayAnim(launderNPC, "random@arrests@busted", "idle_a", 8.0, 1.0, -1, 9, 0, 0, 0, 0)
                TriggerEvent(
                    "otaku_moneylaunderer:talk",
                    "~g~*Launderer* ~w~ Ah shit, get out of here, hide the cash, I can't go back to jail, not again!",
                    25
                )
            elseif reaction == 3 then
                TaskPlayAnim(launderNPC, "anim@mp_player_intcelebrationmale@wank", "wank", 8.0, 1.0, -1, 49, 0, 0, 0, 0)
            end

            SetPedAsNoLongerNeeded(launderNPC)
            launderNPC = nil
        end
    end
)

createPed = function(model, coords, heading, networked)
    local hash = GetHashKey(model)
    while not HasModelLoaded(hash) do
        Wait(0)
        RequestModel(hash)
    end
    local ped = CreatePed(4, hash, coords, heading, networked, false)
    SetEntityAsMissionEntity(ped, true, true)
    SetEntityInvincible(ped, true)
    SetPedHearingRange(ped, 0.0)
    SetPedSeeingRange(ped, 0.0)
    SetPedAlertness(ped, 0.0)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedFleeAttributes(ped, 0, 0)
    return ped
end

RegisterNetEvent("otaku_moneylaunderer:talk")
AddEventHandler(
    "otaku_moneylaunderer:talk",
    function(text, time)
        if launderNPC ~= nil and DoesEntityExist(launderNPC) and isNearMoneyLaunderer() < 30 then
            local endTime = GetGameTimer() + 1000 * time
            while endTime >= GetGameTimer() do
                local x = GetEntityCoords(launderNPC)
                DrawText3D(vector3(x.x, x.y, x.z + 1.0), text)
                Wait(0)
            end
        end
    end
)

function DrawText3D(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local pX, pY, pZ = table.unpack(GetGameplayCamCoords())

    SetTextScale(0.4, 0.4)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextEntry("STRING")
    SetTextCentre(1)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()

    AddTextComponentString(text)
    DrawText(_x, _y)
end
