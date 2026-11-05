local isVerifying = false
local currentRequestId = nil

RegisterCommand('verifhp', function()
    TriggerServerEvent('verif:requestQR')
end)

RegisterNetEvent('verif:openUI', function(requestId)
    currentRequestId = requestId
    isVerifying = true
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open',
        requestId = requestId
    })

    -- Polling status setiap 3 detik
    CreateThread(function()
        while isVerifying do
            Wait(3000)
            if currentRequestId then
                TriggerServerEvent('verif:checkStatus', currentRequestId)
            end
        end
    end)
end)

RegisterNetEvent('verif:success', function(phoneHash)
    isVerifying = false
    currentRequestId = nil
    SetNuiFocus(false, false)
    SendNUIMessage({ action = 'close' })
    print("Verifikasi Berhasil! Phone Hash: " .. phoneHash)
    -- Simpan phoneHash ke data player jika diperlukan
end)

RegisterNUICallback('close', function(data, cb)
    isVerifying = false
    currentRequestId = nil
    SetNuiFocus(false, false)
    cb('ok')
end)