slot0 = class("AutoLoader")
slot1 = false
slot2 = false
slot3 = import("view.util.RequestPackages.LoadPrefabRequestPackage")
slot4 = import("view.util.RequestPackages.LoadReferenceRequestPackage")
slot5 = import("view.util.RequestPackages.GetSpineRequestPackage")
slot6 = import("view.util.RequestPackages.GetPrefabRequestPackage")
slot7 = import("view.util.RequestPackages.GetSpriteRequestPackage")
slot8 = import("view.util.RequestPackages.ReturnPrefabRequestPackage")
slot9 = import("view.util.RequestPackages.ReturnSpineRequestPackage")
slot10 = import("view.util.RequestPackages.DestroyAtlasPoolRequestPackage")
slot0.PartLoading = bit.lshift(1, 0)
slot0.PartLoaded = bit.lshift(1, 1)

slot0.Ctor = function (slot0)
	slot0._loadingRequest = {}
	slot0._returnRequest = {}
	slot0._instKeyDict = {}
	slot0._keyInstDict = {}
end

slot0.GenerateUID4LoadingRequest = function (slot0)
	slot0._uidCounter = (slot0._uidCounter or 0) + 1

	return slot0._uidCounter
end

slot0.GetPrefab = function (slot0, slot1, slot2, slot3, slot4)
	slot0:ClearRequest(slot4)

	slot4 = slot4 or slot0:GenerateUID4LoadingRequest()
	slot5 = nil
	slot6 = slot0.New(slot1, slot2 or "", function (slot0)
		slot0._loadingRequest[] = nil
		slot0._instKeyDict[slot0] = slot0._instKeyDict
		slot0._keyInstDict[] = slot0
		slot0._returnRequest[] = slot2.New(slot2.New, , slot0)

		if slot2.New then
			slot5(slot0)
		end
	end)
	slot5 = slot6

	if slot2 then
		print("AutoLoader Loading Path: " .. slot1 .. " Name: " .. slot2 .. " ;")
	end

	slot0._loadingRequest[slot4] = slot5

	slot5:Start()

	return slot4
end

slot0.GetPrefabBYStopLoading = function (slot0, slot1, slot2, slot3, slot4)
	slot0:ClearRequest(slot4, slot0.PartLoading)

	slot4 = slot4 or slot0:GenerateUID4LoadingRequest()
	slot5 = nil
	slot6 = slot1:New(slot2 or "", function (slot0)
		slot0._loadingRequest[] = nil

		slot0:ClearRequest(slot0.ClearRequest, slot2.PartLoaded)

		slot0._instKeyDict[slot0] = slot0._instKeyDict
		slot0._keyInstDict[] = slot0
		slot0._returnRequest[] = slot0.ClearRequest.New(slot2.PartLoaded, slot5, slot0)

		if slot0 then
			slot6(slot0)
		end
	end)
	slot5 = slot6

	if slot3 then
		print("AutoLoader Loading Path: " .. slot1 .. " Name: " .. slot2 .. " ;")
	end

	slot0._loadingRequest[slot4] = slot5

	slot5:Start()

	return slot4
end

slot0.ReturnPrefab = function (slot0, slot1)
	slot0:ClearRequest(slot0._instKeyDict[go(slot1)])
end

slot0.GetSpine = function (slot0, slot1, slot2, slot3)
	if not slot1 or #slot1 < 0 then
		return
	end

	slot0:ClearRequest(slot3)

	slot3 = slot3 or slot0:GenerateUID4LoadingRequest()
	slot4 = nil
	slot5 = slot0.New(slot1 or "", function (slot0)
		slot0._loadingRequest[] = nil
		slot0._instKeyDict[slot0] = slot0._instKeyDict
		slot0._keyInstDict[] = slot0
		slot0._returnRequest[] = slot2.New(slot2.New, slot0)

		if slot2.New then
			slot4(slot0)
		end
	end)
	slot4 = slot5

	if slot2 then
		print("AutoLoader Loading Spine: " .. slot1 .. " ;")
	end

	slot0._loadingRequest[slot3] = slot4

	slot4:Start()

	return slot3
end

slot0.ReturnSpine = function (slot0, slot1)
	slot0:ClearRequest(slot0._instKeyDict[go(slot1)])
end

slot0.GetSprite = function (slot0, slot1, slot2, slot3, slot4)
	slot3:GetComponent(typeof(Image)).enabled = false

	slot0:GetSpriteDirect(slot1, slot2 or "", function (slot0)
		slot0.enabled = true
		slot0.sprite = slot0

		if slot0 then
			slot0:SetNativeSize()
		end
	end, slot6)

	return tf(slot3)
end

slot0.GetSpriteDirect = function (slot0, slot1, slot2, slot3, slot4)
	slot0:ClearRequest(slot4)

	slot4 = slot4 or slot0:GenerateUID4LoadingRequest()
	slot5 = nil
	slot6 = slot0.New(slot1, slot2, function (slot0)
		slot0._loadingRequest[] = nil

		if slot0._loadingRequest then
			slot2(slot0)
		end
	end)
	slot5 = slot6

	if slot1 then
		print("AutoLoader Loading Atlas: " .. slot1 .. " Name: " .. slot2 .. " ;")
	end

	slot0._loadingRequest[slot4] = slot5

	slot5:Start()

	slot0._returnRequest[slot1] = slot2.New(slot1)

	return slot4
end

slot0.GetOffSpriteRequest = function (slot0, slot1)
	slot0:ClearRequest(slot1)
end

slot0.LoadPrefab = function (slot0, slot1, slot2, slot3, slot4)
	slot0:ClearRequest(slot4)

	slot4 = slot4 or slot0:GenerateUID4LoadingRequest()
	slot5 = nil
	slot6 = slot0.New(slot1, slot2 or "", function (slot0)
		slot0._loadingRequest[] = nil

		if slot0._loadingRequest then
			slot2(slot0)
		end
	end)
	slot5 = slot6

	if slot1 then
		print("AutoLoader Loading Once Path: " .. slot1 .. " Name: " .. slot2 .. " ;")
	end

	slot0._loadingRequest[slot4] = slot5

	slot5:Start()

	return slot4
end

slot0.LoadSprite = function (slot0, slot1, slot2, slot3, slot4)
	slot3:GetComponent(typeof(Image)).enabled = false

	slot0:ClearRequest(slot6)

	slot7 = nil
	slot8 = slot0.New(slot1, slot2 or "", typeof(Sprite), function (slot0)
		slot0._loadingRequest[] = nil
		slot0._loadingRequest.enabled = true
		slot2.sprite = slot0

		if nil then
			slot2:SetNativeSize()
		end
	end)
	slot7 = slot8

	if slot1 then
		print("AutoLoader Loading Once Path: " .. slot1 .. " Name: " .. slot2 .. " ;")
	end

	slot0._loadingRequest[slot6] = slot7

	slot7:Start()

	return slot6
end

slot0.LoadReference = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot0:ClearRequest(slot5)

	slot5 = slot5 or slot0:GenerateUID4LoadingRequest()
	slot6 = nil
	slot7 = slot0.New(slot1, slot2 or "", slot3, function (slot0)
		slot0._loadingRequest[] = nil

		if slot0._loadingRequest then
			slot2(slot0)
		end
	end)
	slot6 = slot7

	if slot1 then
		print("AutoLoader Loading Once Path: " .. slot1 .. " Name: " .. slot2 .. " ;")
	end

	slot0._loadingRequest[slot5] = slot6

	slot6:Start()

	return slot5
end

slot0.DestroyAtlas = function (slot0, slot1)
	slot0:ClearRequest(slot1)
end

slot0.GetRequestPackage = function (slot0, slot1, slot2)
	return (bit.band(slot2 or slot0.PartLoading + slot0.PartLoaded, slot0.PartLoading) > 0 and slot0._loadingRequest[slot1]) or (bit.band(slot2 or slot0.PartLoading + slot0.PartLoaded, slot0.PartLoaded) > 0 and slot0._returnRequest[slot1])
end

slot0.GetLoadingRP = function (slot0, slot1)
	return slot0._loadingRequest[slot1]
end

slot0.ClearRequest = function (slot0, slot1, slot2)
	if (not slot2 or bit.band(slot2, slot0.PartLoading) > 0) and slot0._loadingRequest[slot1] then
		if slot1 then
			print("AutoLoader Unload loading Path: " .. slot0._loadingRequest[slot1].path .. " Name: " .. slot0._loadingRequest[slot1].name .. " ;")
		end

		slot0._loadingRequest[slot1]:Stop()

		slot0._loadingRequest[slot1] = nil
	end

	if not slot2 or bit.band(slot2, slot0.PartLoaded) > 0 then
		if slot0._returnRequest[slot1] then
			if slot1 then
				print("AutoLoader Unload Path: " .. slot0._returnRequest[slot1].path .. " Name: " .. slot0._returnRequest[slot1].name .. " ;")
			end

			slot0._returnRequest[slot1]:Start()

			slot0._returnRequest[slot1] = nil
		end

		if slot0._keyInstDict[slot1] then
			slot0._instKeyDict[slot0._keyInstDict[slot1]] = nil
			slot0._keyInstDict[slot1] = nil
		end
	end
end

slot0.ClearLoadingRequests = function (slot0)
	for slot4, slot5 in pairs(slot0._loadingRequest) do
		if slot0 then
			print("AutoLoader Unload loading Path: " .. slot5.path .. " Name: " .. slot5.name .. " ;")
		end

		slot5:Stop()
	end

	table.clear(slot0._loadingRequest)
end

slot0.ClearRequests = function (slot0)
	for slot4, slot5 in pairs(slot0._loadingRequest) do
		if slot0 then
			print("AutoLoader Unload loading Path: " .. slot5.path .. " Name: " .. slot5.name .. " ;")
		end

		slot5:Stop()
	end

	table.clear(slot0._loadingRequest)

	for slot4, slot5 in pairs(slot0._returnRequest) do
		if slot0 then
			if isa(slot5, slot1) then
				print("AutoLoader Unload Spine: " .. slot5.name .. " ;")
			elseif isa(slot5, slot2) then
				print("AutoLoader Unload Atlas: " .. slot5.path .. " ;")
			else
				print("AutoLoader Unload Path: " .. slot5.path .. " Name: " .. slot5.name .. " ;")
			end
		end

		slot5:Start()
	end

	table.clear(slot0._returnRequest)
	table.clear(slot0._instKeyDict)
	table.clear(slot0._keyInstDict)
end

slot0.Clear = function (slot0)
	slot0:ClearRequests()
end

return slot0
