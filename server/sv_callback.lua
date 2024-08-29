local root = GetResourcePath(GetCurrentResourceName())
local apiKey = GetConvar('FIVEMANAGE_MEDIA_API_KEY', '')
lib.callback.register('getMugshotUrl', function (playerid, mugshot)
    local path = exports.mugshot:ConvertBase64(mugshot, apiKey)
    return path
    -- return mugshot
end)