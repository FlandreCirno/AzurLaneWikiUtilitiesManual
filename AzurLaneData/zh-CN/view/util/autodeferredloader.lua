slot0 = class("AutoDeferredLoader", import(".Autoloader"))
slot1 = import("view.util.RequestPackages.GetSpineRequestPackage")
slot2 = import("view.util.RequestPackages.GetPrefabRequestPackage")
slot3 = import("view.util.RequestPackages.GetSpriteRequestPackage")
slot4 = import("view.util.RequestPackages.ReturnPrefabRequestPackage")
slot5 = import("view.util.RequestPackages.ReturnSpineRequestPackage")
slot6 = import("view.util.RequestPackages.DestroyAtlasPoolRequestPackage")

slot0.GetPrefab = function (slot0, slot1, slot2, slot3, slot4)
	slot0:ClearRequest(slot4, slot0.PartLoading)

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
	slot0._loadingRequest[slot4 or #slot0._loadingRequest + 1] = slot6

	slot6:Start()
end

slot0.GetSpine = function (slot0, slot1, slot2, slot3)
	if not slot1 or #slot1 < 0 then
		return
	end

	slot0:ClearRequest(slot3, slot0.PartLoading)

	slot4 = nil
	slot5 = slot1 or "":New(function (slot0)
		slot0._loadingRequest[] = nil

		slot0:ClearRequest(slot0.ClearRequest, slot2.PartLoaded)

		slot0._instKeyDict[slot0] = slot0._instKeyDict
		slot0._keyInstDict[] = slot0
		slot0._returnRequest[] = slot0.ClearRequest.New(slot2.PartLoaded, slot0)

		if slot0 then
			slot5(slot0)
		end
	end)
	slot0._loadingRequest[slot3 or #slot0._loadingRequest + 1] = slot5

	slot5:Start()
end

slot0.GetSprite = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = slot3:GetComponent(typeof(Image))

	slot0:ClearRequest(slot6)

	slot8 = slot0.New(slot1, slot2 or "", function (slot0)
		slot0._loadingRequest[] = nil
		slot0._loadingRequest.enabled = true
		slot2.sprite = slot0

		if nil then
			slot2:SetNativeSize()
		end
	end)
	slot0._loadingRequest[tf(slot3)] = slot8

	slot8.Start(nil)

	slot0._returnRequest[slot1] = slot1:New()
end

slot0.GetRequestPackage = function (slot0, slot1, slot2)
	return slot0.super.GetRequestPackage(slot0, slot1, slot2)
end

return slot0
