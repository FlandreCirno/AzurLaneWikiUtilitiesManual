ys = ys or {}
slot1 = class("BattleMap")
ys.Battle.BattleMap = slot1
slot1.__name = "BattleMap"
slot2 = pg.map_data
slot1.LAYERS = {
	"close",
	"mid",
	"long",
	"sky",
	"sea"
}

slot1.Ctor = function (slot0, slot1)
	slot0._go = GameObject.New("scenes")
	slot0.mapLayerCtrls = {}
	slot0.materialList = {}
	slot2 = pg.map_data[slot1]

	for slot6, slot7 in ipairs(slot0.LAYERS) do
		setParent(GameObject.New(slot7 .. "Layer"), slot0._go, false)

		if slot7 ~= "sky" then
			GetOrAddComponent(slot8, "MapLayerCtrl").leftBorder = slot2.range_left
			GetOrAddComponent(slot8, "MapLayerCtrl").rightBorder = slot2.range_right
			slot9.speedToLeft = slot2[slot7 .. "_speed"] or 0
			slot9.speedScaler = 1

			table.insert(slot0.mapLayerCtrls, slot9)
		end

		slot10 = string.split(slot2[slot7 .. "_pos"], ";")
		slot11 = string.split(slot2[slot7 .. "_scale"], ";")

		for slot15, slot16 in ipairs(slot9) do
			slot17 = slot1.Battle.BattleResourceManager.GetInstance():InstMap(slot16)

			setParent(slot17, slot8, false)

			tf(slot17).localPosition = string2vector3(slot10[slot15])
			tf(slot17).localScale = string2vector3(slot11[slot15])

			if slot17:GetComponent(typeof(MeshRenderer)) then
				table.insert(slot0.materialList, {
					material = slot18.sharedMaterial,
					offset = slot18.sharedMaterial.GetTextureOffset(slot19, "_SeaTex")
				})
			end
		end

		if slot7 == "sea" then
			slot0._buffer = slot8.transform:Find("gelidai(Clone)")

			if slot0._buffer then
				slot0._bufferRenderer = slot0._buffer:GetComponent("SpriteRenderer")
				slot0._bufferRenderer.color = Color.New(1, 1, 1, 0)
			end
		end
	end

	slot0:UpdateSpeedScaler()

	return slot0._go
end

slot1.ShiftSurface = function (slot0, slot1, slot2, slot3, slot4)
	if slot0._shiftTimer then
		return
	end

	slot5 = slot1
	slot6 = nil

	if slot2 < slot1 then
		slot6 = -1
	elseif slot1 < slot2 then
		slot6 = 1
	else
		return
	end

	slot0._shiftTimer = pg.TimeMgr.GetInstance().AddBattleTimer(slot8, "", -1, slot3, function ()
		if (slot0 - slot1) * slot2 > 0 then
			slot3.Battle.BattleVariable.AppendMapFactor("seaSurfaceShift", )
			slot4:UpdateMapOffset()
			slot4:UpdateSpeedScaler()

			slot1 = slot4 + slot2
		else
			pg.TimeMgr.GetInstance():RemoveBattleTimer(slot4._shiftTimer)

			slot4._shiftTimer = nil

			if slot5 then
				slot5()
			end
		end
	end, true)
end

slot1.UpdateSpeedScaler = function (slot0)
	slot0:setSpeedScaler(slot0.Battle.BattleVariable.MapSpeedRatio)
end

slot1.UpdateBufferAlpha = function (slot0, slot1)
	slot0._bufferRenderer.color = Color.New(1, 1, 1, slot1 * 0.1)
end

slot1.SetExposeLine = function (slot0, slot1, slot2, slot3)
	function instantiateLine(slot0, slot1)
		slot2 = slot0.Battle.BattleResourceManager.GetInstance():InstMap(slot1)

		setParent(slot2, slot3, false)

		slot5 = slot2:GetComponent("SpriteRenderer").bounds.extents.max
		tf(slot2).localScale = Vector3.New(slot2 * tf(slot2).localScale.x, tf(slot2).localScale.y, tf(slot2).localScale.z)
		tf(slot2).localPosition = Vector3.New(slot0 - slot2.GetComponent("SpriteRenderer").bounds.extents.x * slot2, tf(slot2).localPosition.y, tf(slot2).localPosition.z)
	end

	instantiateLine(slot2, "visionLine")

	if slot3 then
		instantiateLine(slot3, "exposeLine")
	end
end

slot1.setSpeedScaler = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0.mapLayerCtrls) do
		slot6.speedScaler = slot1
	end
end

slot1.UpdateMapOffset = function (slot0)
	slot2 = -0.0005 * slot0.Battle.BattleVariable.MapSpeedRatio

	for slot6, slot7 in ipairs(slot0.materialList) do
		slot7.offset.x = slot7.offset.x + slot2

		slot7.material:SetTextureOffset("_SeaTex", slot7.offset)
	end
end

slot1.Dispose = function (slot0)
	if slot0._shiftTimer then
		pg.TimeMgr.GetInstance():RemoveBattleTimer(slot0._shiftTimer)
	end

	if slot0._go then
		Object.Destroy(slot0._go)

		slot0._go = nil
		slot0._buffer = nil
		slot0._bufferRenderer = nil
	end
end

slot1.GetMapResNames = function (slot0, slot1)
	return string.split(pg.map_data[slot0][slot1 .. "_shot"], ";")
end

slot1.setActive = function (slot0, slot1)
	SetActive(slot0._go, slot1)
end

return
