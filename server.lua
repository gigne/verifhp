RegisterNetEvent('verif:requestQR', function()
    local src = source
    local identifiers = GetPlayerIdentifiers(src)

    PerformHttpRequest('https://siapa.info/checkid/create.php', function(errorCode, resultData)
        if errorCode == 200 then
            local data = json.decode(resultData)
            if data then
                if data.status == 'already_verified' then
                    -- Langsung verifikasi dengan hash
                    TriggerClientEvent('verif:success', src, data.phone_hash)
                elseif data.status == 'success' then
                    -- Buka UI QRIS
                    TriggerClientEvent('verif:openUI', src, data.requestId)
                end
            end
        end
    end, 'POST', json.encode({ identifiers = identifiers }), { ['Content-Type'] = 'application/json' })
end)

RegisterNetEvent('verif:checkStatus', function(requestId)
    local src = source
    PerformHttpRequest('https://siapa.info/checkid/check.php', function(errorCode, resultData)
        if errorCode == 200 then
            local data = json.decode(resultData)
            if data and data.status == 'verified' then
                TriggerClientEvent('verif:success', src, data.phone_hash)
            end
        end
    end, 'POST', json.encode({ identifiers = identifiers }), { ['Content-Type'] = 'application/json' })
end)