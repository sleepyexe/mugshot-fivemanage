local id = 0
local mugshotCaches = {}
local answers = {}

local RegisterPedheadshot = RegisterPedheadshot

local function getMugshot(ped, transparent)
	if not ped then
		return ""
	end
	id += 1

	local handle = RegisterPedheadshot(ped)
	local timer = 2000
	while not handle or not IsPedheadshotReady(handle) or not IsPedheadshotValid(handle) and timer > 0 do
		Wait(10)
		timer -= 10
	end

	local mugshotTxd = "none"
	if IsPedheadshotReady(handle) and IsPedheadshotValid(handle) then
		mugshotCaches[id] = handle
		mugshotTxd = GetPedheadshotTxdString(handle)
	end

	SendNUIMessage({
		type = "convert",
		pMugShotTxd = mugshotTxd,
		removeImageBackGround = transparent or false,
		id = id,
	})

	local p = promise.new()
	answers[id] = p
	return Citizen.Await(p)
end
exports("getMugshot", getMugshot)

RegisterNUICallback("Answer", function(data)
	if mugshotCaches[data.Id] then
		UnregisterPedheadshot(mugshotCaches[data.Id])
		mugshotCaches[data.Id] = nil
	end
	local url = lib.callback.await('getMugshotUrl', false, data.Answer)
	answers[data.Id]:resolve(url)
	answers[data.Id] = nil
end)

AddEventHandler("onResourceStop", function(resourceName)
	if GetCurrentResourceName() ~= resourceName then
		return
	end
	for k, v in pairs(mugshotCaches) do
		UnregisterPedheadshot(v)
	end
	mugshotCaches = {}
	id = 0
end)

RegisterCommand('testmugshot', function (src, a, b)
    local img = getMugshot(cache.ped, true)
	lib.setClipboard(img)
end)