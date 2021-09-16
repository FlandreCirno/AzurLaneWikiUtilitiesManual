slot0 = class("WSMapArtifact", import("...BaseEntity"))
slot0.Fields = {
	transform = "userdata",
	prefab = "string",
	theme = "table",
	attachment = "table",
	moduleTF = "userdata",
	item_info = "table"
}

slot0.Build = function (slot0)
	slot0.transform = GetOrAddComponent(GameObject.New(), "RectTransform")
	slot0.transform.name = "model"
end

slot0.Dispose = function (slot0)
	slot0:Unload()
	Destroy(slot0.transform)
	slot0:Clear()
end

slot0.Setup = function (slot0, slot1, slot2, slot3)
	slot0.item_info = slot1
	slot0.theme = slot2
	slot0.attachment = slot3

	slot0:Load()
end

slot0.Load = function (slot0)
	slot0.prefab = slot0.item_info[3]

	PoolMgr.GetInstance():GetPrefab(WorldConst.ResChapterPrefab .. slot1, slot0.item_info[3], true, function (slot0)
		if slot0.prefab then
			slot0.moduleTF = tf(slot0)

			slot0.moduleTF:SetParent(slot0.transform, false)
			slot0:Init()
		else
			slot1:ReturnPrefab(WorldConst.ResChapterPrefab .. slot2, slot1, slot0)
		end
	end)
end

slot0.Unload = function (slot0)
	if slot0.prefab and slot0.moduleTF then
		PoolMgr.GetInstance():ReturnPrefab(WorldConst.ResChapterPrefab .. slot0.prefab, slot0.prefab, slot0.moduleTF.gameObject, true)
	end

	slot0.prefab = nil
	slot0.moduleTF = nil
end

slot0.Init = function (slot0)
	if not IsNil(slot0.moduleTF:GetComponent(typeof(UnityEngine.UI.Graphic))) then
		slot1.raycastTarget = false
	end

	for slot6 = 0, slot0.moduleTF:GetComponentsInChildren(typeof(UnityEngine.UI.Graphic), true).Length - 1, 1 do
		slot2[slot6].raycastTarget = false
	end

	slot3 = Vector2.zero
	slot4 = Vector3.one
	slot5 = Vector3.zero

	if slot0.attachment then
		slot3 = slot0.attachment:GetDeviation()
		slot4 = slot0.attachment:GetScale()
		slot5 = (slot0.attachment:GetMillor() and Vector3(0, 180, 0)) or Vector3.zero
	else
		slot3 = Vector2(slot0.item_info[4], slot0.item_info[5])
	end

	slot0.transform.anchoredPosition = slot3
	slot0.transform.localScale = slot4
	slot0.transform.localEulerAngles = slot5
end

return slot0
