slot0 = class("WSAtlasWorld", import(".WSAtlas"))
slot0.Fields = {
	isDragging = "boolean",
	tfMapModel = "userdata",
	tfModel = "userdata",
	tfAreaScene = "userdata",
	nowArea = "number",
	dragTrigger = "userdata",
	wsTimer = "table",
	twRotateId = "number",
	isTransAnim = "boolean",
	areaLockPressingAward = "table",
	entranceTplDic = "table",
	twFocusIds = "table"
}
slot0.Listeners = {
	onUpdatePortTaskMark = "OnUpdatePortTaskMark",
	onUpdateActiveEntrance = "OnUpdateActiveEntrance",
	onUpdatePressingAward = "OnUpdatePressingAward",
	onUpdateProgress = "OnUpdateProgress"
}
slot0.EventUpdateselectEntrance = "WSAtlasWorld.EventUpdateselectEntrance"
slot0.baseDistance = -217.4
slot0.frontDistance = -101.6237
slot0.basePoint = Vector2(1024, 550)
slot0.baseMoveDistance = 100
slot0.baseDuration = 0.8
slot0.selectOffsetPos = Vector2(107, 61)

slot0.Dispose = function (slot0)
	slot0:DisposeEntranceTplDic()
	slot0.super.Dispose(slot0)
end

slot0.Init = function (slot0)
	slot0.super.Init(slot0)

	slot0.entranceTplDic = {}
	slot0.twFocusIds = {}
	slot0.areaLockPressingAward = {}
end

slot0.UpdateAtlas = function (slot0, slot1)
	if slot0.atlas ~= slot1 then
		slot0:RemoveAtlasListener()
		slot0:DisposeEntranceTplDic()

		slot0.atlas = slot1

		slot0:AddAtlasListener()
		slot0:NewEntranceTplDic()
		slot0:UpdateModelMask()
		slot0:OnUpdateActiveEntrance(nil, nil, slot0.atlas:GetActiveEntrance())
		slot0:OnUpdatePressingAward()
	end
end

slot0.AddAtlasListener = function (slot0)
	if slot0.atlas then
		slot0.atlas:AddListener(WorldAtlas.EventUpdatePortTaskMark, slot0.onUpdatePortTaskMark)
	end

	slot0.super.AddAtlasListener(slot0)
end

slot0.RemoveAtlasListener = function (slot0)
	if slot0.atlas then
		slot0.atlas:RemoveListener(WorldAtlas.EventUpdatePortTaskMark, slot0.onUpdatePortTaskMark)
	end

	slot0.super.RemoveAtlasListener(slot0)
end

slot0.LoadModel = function (slot0, slot1)
	slot2 = {}

	if not slot0.tfModel then
		table.insert(slot2, function (slot0)
			PoolMgr.GetInstance():GetPrefab("model/worldmapmodel", "WorldMapModel", true, function (slot0)
				if slot0.transform then
					slot0.tfModel = tf(slot0)

					setParent(slot0.tfModel, slot0.tfMapModel, false)
				else
					slot1:ReturnPrefab("model/worldmapmodel", "WorldMapModel", slot0, true)
				end

				return slot2()
			end)
		end)
	end

	seriesAsync(slot2, function ()
		return existCall(existCall)
	end)
end

slot0.ReturnModel = function (slot0)
	if slot0.tfModel then
		PoolMgr.GetInstance():ReturnPrefab("model/worldmapmodel", "WorldMapModel", go(slot0.tfModel), true)
	end
end

slot0.LoadScene = function (slot0, slot1)
	SceneOpMgr.Inst:LoadSceneAsync("scenes/worldmap3d", "WorldMap3D", LoadSceneMode.Additive, function (slot0, slot1)
		slot0.transform = tf(slot0:GetRootGameObjects()[0])

		setActive(slot0.transform, false)

		slot0.tfEntity = slot0.transform:Find("entity")
		slot0.tfAreaScene = slot0.tfEntity:Find("area_scene")
		slot0.tfMapScene = slot0.tfEntity:Find("map_scene")
		slot0.tfMapModel = slot0.tfEntity:Find("model")
		slot0.tfMapSelect = slot0.tfMapScene:Find("selected_layer")
		slot0.tfSpriteScene = slot0.tfEntity:Find("sprite_scene")
		slot0.tfCamera = slot0.transform:Find("Main Camera")
		slot0.tfCamera:GetComponent("Camera").depthTextureMode = UnityEngine.DepthTextureMode.Depth
		slot0.defaultSprite = slot0.tfEntity:Find("decolation_layer/edge"):GetComponent("SpriteRenderer").material
		slot0.addSprite = slot0.tfEntity:Find("map_scene/mask_layer"):GetComponent("SpriteRenderer").material
		slot0.dragTrigger = slot0.tfEntity:Find("Plane"):GetComponent("EventTriggerListener")
		slot3 = Vector2(0.2, 0.2) * slot0.frontDistance / slot0.baseDistance

		slot0.dragTrigger:AddDragFunc(function (slot0, slot1)
			slot0.isDragging = true

			if not slot0.nowArea or slot0:CheckIsTweening() then
				return
			end

			if slot0.selectEntrance then
				slot0:UpdateSelect()
			end

			slot0.tfCamera.localPosition = slot0.tfCamera.localPosition - Vector3(slot1.x * slot1.delta.x, 0, (slot1.y * slot1.delta.y) / math.sin(Vector3))

			if CAMERA_MOVE_OPEN then
				slot3 = slot0.tfSpriteScene:InverseTransformPoint(slot0.transform:TransformPoint(slot0.tfCamera.localPosition))

				warning(Vector2(slot3 - Vector3(slot3.y / -math.tan(slot4) * math.sin(slot5), slot3.y, slot3.y / -math.tan(slot4) * math.cos(math.rad(slot0.tfEntity.localEulerAngles.y))).x, slot3 - Vector3(slot3.y / -math.tan(slot4) * math.sin(slot5), slot3.y, slot3.y / -math.tan(slot4) * math.cos(math.rad(slot0.tfEntity.localEulerAngles.y))).z) * PIXEL_PER_UNIT + slot3.spriteBaseSize / 2)
			end
		end)
		slot0.dragTrigger.AddDragEndFunc(slot4, function (slot0, slot1)
			slot0.isDragging = false
		end)
		slot0.UpdateCenterEffectDisplay(slot4)
		slot0:BuildActiveMark()

		slot4 = nowWorld
		slot0.cmPointer = slot0.tfEntity:Find("Plane"):GetComponent(typeof(PointerInfo))

		slot0.cmPointer:AddColorMaskClickListener(function (slot0, slot1)
			if slot0.isDragging then
				return
			end

			if slot1:ColorToEntrance(slot0) then
				slot0.onClickColor(slot2, slot1.position)
			end
		end)

		return existCall(slot0.tfCamera.localEulerAngles.x / 180 * math.pi)
	end)
end

slot0.ReturnScene = function (slot0)
	slot0:ReturnModel()

	if slot0.transform then
		slot1 = slot0.tfMapScene:GetComponent("FMultiSpriteRenderCtrl")
		slot1.alpha = 1

		slot1:UpdateAlpha()

		slot2 = slot0.tfAreaScene:GetComponent("FMultiSpriteRenderCtrl")
		slot2.alpha = 1

		slot2:UpdateAlpha()
		SceneOpMgr.Inst:UnloadSceneAsync("scene/worldmap3d", "WorldMap3D")

		slot0.cmPointer = nil
	end
end

slot0.ShowOrHide = function (slot0, slot1)
	slot0.super.ShowOrHide(slot0, slot1)

	if slot1 then
		SceneManager.SetActiveScene(SceneManager.GetSceneByName("WorldMap3D"))
	else
		SceneManager.SetActiveScene(SceneManager.GetSceneByName("main"))
	end
end

slot0.GetOffsetMapPos = function (slot0)
	slot3 = math.rad(-slot0.tfEntity.localEulerAngles.y)

	return Vector2(slot0.selectOffsetPos.x * math.cos(slot3) - slot0.selectOffsetPos.y * math.sin(slot3), slot0.selectOffsetPos.y * math.cos(slot3) + slot0.selectOffsetPos.x * math.sin(slot3))
end

slot0.UpdateSelect = function (slot0, slot1, slot2, slot3)
	if slot1 then
		slot0.nowArea = slot1:GetAreaId()

		slot0:FocusPos(Vector2(slot1.config.area_pos[1], slot1.config.area_pos[2]) + slot0:GetOffsetMapPos(), nil, 1, true, function ()
			slot0.super.UpdateSelect(slot1, slot2)
			slot1:DispatchEvent(slot0.EventUpdateselectEntrance, , , )
		end)
	else
		slot0.super.UpdateSelect(slot0, slot1)
		slot0:DispatchEvent(slot0.EventUpdateselectEntrance, slot1, slot2, slot3)
	end
end

slot0.UpdateModelMask = function (slot0)
	slot0.super.UpdateModelMask(slot0)
	slot0:UpdateAreaLock()
end

slot0.UpdateEntranceMask = function (slot0, slot1)
	slot2 = slot0.entranceTplDic[slot1.id]

	if slot1:HasPort() then
		slot2:UpdatePort(slot0.atlas.transportDic[slot1.id], slot0.atlas.taskPortDic[slot1:GetPortId()])
	end

	slot0.super.UpdateEntranceMask(slot0, slot1)
end

slot0.OnUpdateProgress = function (slot0, slot1, slot2, slot3)
	slot0.super.OnUpdateProgress(slot0, slot1, slot2, slot3)
	slot0:UpdateAreaLock()
end

slot0.UpdateAreaLock = function (slot0)
	for slot4 = 1, 5, 1 do
		slot5 = nowWorld:CheckAreaUnlock(slot4)

		setActive(slot0.tfAreaScene:Find("lock_layer/" .. slot4), not slot5)
		setActive(slot0.tfMapScene:Find("mask_layer/" .. slot4), slot5)

		if slot5 and slot0.areaLockPressingAward[slot4] then
			for slot9, slot10 in ipairs(slot0.areaLockPressingAward[slot4]) do
				slot0.entranceTplDic[slot10]:UpdatePressingAward()
			end

			slot0.areaLockPressingAward[slot4] = nil
		end
	end
end

slot0.OnUpdateActiveEntrance = function (slot0, slot1, slot2, slot3)
	slot0.super.OnUpdateActiveEntrance(slot0, slot1, slot2, slot3)

	if slot3 then
		slot0:DoUpdatExtraMark(slot0.tfActiveMark, "mark_active_1", not slot3:HasPort())
		slot0:DoUpdatExtraMark(slot0.tfActiveMark, "mark_active_port", slot3.HasPort())
	end

	slot4 = slot3 and slot3:GetAreaId()

	for slot8 = 1, 5, 1 do
		setActive(slot0.tfAreaScene:Find("selected_layer/B" .. slot8 .. "_2"), slot8 == slot4)
		setActive(slot0.tfAreaScene:Find("base_layer/B" .. slot8), slot8 ~= slot4)
	end
end

slot0.OnUpdatePressingAward = function (slot0, slot1, slot2, slot3)
	slot3 = slot3 or slot0.atlas.transportDic

	for slot7, slot8 in pairs(slot3) do
		if slot8 then
			if nowWorld:CheckAreaUnlock(slot0.atlas:GetEntrance(slot7):GetAreaId()) then
				slot0.entranceTplDic[slot7]:UpdatePressingAward()
			else
				slot0.areaLockPressingAward[slot9] = slot0.areaLockPressingAward[slot9] or {}

				table.insert(slot0.areaLockPressingAward[slot9], slot7)
			end
		end
	end

	slot0.super.OnUpdatePressingAward(slot0, slot1, slot2, slot3)
end

slot0.OnUpdatePortTaskMark = function (slot0, slot1, slot2, slot3)
	for slot7, slot8 in pairs(slot3) do
		if slot8 then
			slot9 = slot0.atlas:GetEntrance(slot7)

			slot0.entranceTplDic[slot7]:UpdatePort(slot0.atlas.transportDic[slot9.id], slot0.atlas.taskPortDic[slot9:GetPortId()])
		end
	end
end

slot0.NewEntranceTplDic = function (slot0)
	for slot4, slot5 in pairs(slot0.atlas.entranceDic) do
		slot0.entranceTplDic[slot5.id] = slot0:NewEntranceTpl(slot5)
	end
end

slot0.DisposeEntranceTplDic = function (slot0)
	WPool:ReturnArray(_.values(slot0.entranceTplDic))

	slot0.entranceTplDic = {}
end

slot0.NewEntranceTpl = function (slot0, slot1)
	slot2 = WPool:Get(WSEntranceTpl)

	slot2.transform:SetParent(slot0.tfSpriteScene, false)

	slot2.transform.localPosition = WorldConst.CalcModelPosition(slot1, slot0.spriteBaseSize)
	slot2.tfArea = slot0.tfAreaScene:Find("display_layer")
	slot2.tfMap = slot0.tfMapScene:Find("display_layer")

	slot2:Setup()
	slot2:UpdateEntrance(slot1)

	return slot2
end

slot0.FindEntranceTpl = function (slot0, slot1)
	return slot0.entranceTplDic[slot1.id]
end

slot0.UpdateScale = function (slot0, slot1)
	slot0.tfCamera.localPosition = slot0.tfCamera.localPosition + Vector3(0, -math.sin(slot2) * ((slot0.baseDistance * (1 - (slot1 or 0)) + slot0.frontDistance * (slot1 or 0)) - slot0.tfCamera.localPosition.y / -math.sin(slot2)), math.cos(slot0.tfCamera.localEulerAngles.x / 180 * math.pi) * ((slot0.baseDistance * (1 - (slot1 or 0)) + slot0.frontDistance * (slot1 or 0)) - slot0.tfCamera.localPosition.y / -math.sin(slot2)))
end

slot0.FocusPos = function (slot0, slot1, slot2, slot3, slot4, slot5)
	if slot0.twRotateId then
		LeanTween.cancel(slot0.twRotateId)

		slot0.twRotateId = nil
	end

	slot3 = slot3 or 0
	slot2 = 0

	if not slot1 then
		slot6 = math.rad(-slot2)
		slot1 = Vector2(slot0.basePoint - slot0.spriteBaseSize / 2.x * math.cos(slot6) - slot0.basePoint - slot0.spriteBaseSize / 2.y * math.sin(slot6), slot0.basePoint - slot0.spriteBaseSize / 2.y * math.cos(slot6) + slot0.basePoint - slot0.spriteBaseSize / 2.x * math.sin(slot6)) + slot0.spriteBaseSize / 2
	end

	slot6 = math.rad(slot0.tfEntity.localEulerAngles.y - slot2)
	slot8 = slot0.transform:InverseTransformPoint(slot0.tfSpriteScene:TransformPoint(slot7))
	slot9 = math.rad(slot0.tfCamera.localEulerAngles.x)
	slot10 = slot8 - Vector3(0, slot8.y, slot8.y / -math.tan(slot9)) + Vector3(0, slot0.tfCamera.localPosition.y, slot0.tfCamera.localPosition.y / -math.tan(slot9)) + Vector3(0, -math.sin(slot9) * ((slot0.baseDistance * (1 - slot3) + slot0.frontDistance * slot3) - slot8 - Vector3(0, slot8.y, slot8.y / -math.tan(slot9)) + Vector3(0, slot0.tfCamera.localPosition.y, slot0.tfCamera.localPosition.y / -math.tan(slot9)).y / -math.sin(slot9)), math.cos(slot9) * ((slot0.baseDistance * (1 - slot3) + slot0.frontDistance * slot3) - slot8 - Vector3(0, slot8.y, slot8.y / -math.tan(slot9)) + Vector3(0, slot0.tfCamera.localPosition.y, slot0.tfCamera.localPosition.y / -math.tan(slot9)).y / -math.sin(slot9)))

	if slot4 then
		slot13 = math.min(Vector3.Distance(slot0.tfCamera.localPosition, slot10) / slot0.baseMoveDistance, 1) * slot0.baseDuration
		slot14 = math.min(math.abs(slot2 - slot0.tfEntity.localEulerAngles.y) / 180, 1) * slot0.baseDuration

		table.insert(slot15, function (slot0)
			table.insert(slot0.twFocusIds, slot1)
			slot0.wsTimer:AddTween(LeanTween.moveLocal(go(slot0.tfCamera), LeanTween.moveLocal, ):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(slot0)).uniqueId)
		end)
		table.insert(slot15, function (slot0)
			table.insert(slot0.twFocusIds, slot1)
			slot0.wsTimer:AddTween(LeanTween.rotateY(go(slot0.tfEntity), LeanTween.rotateY, ):setEase(LeanTweenType.easeInOutSine):setOnComplete(System.Action(slot0)).uniqueId)
		end)
		parallelAsync(slot15, function ()
			existCall(existCall)
		end)

		return
	end

	slot0.tfCamera.localPosition = slot10
	slot0.tfEntity.localEulerAngles = Vector3(0, slot2, 0)

	return existCall(slot5)
end

slot0.FocusPosInArea = function (slot0, slot1, slot2, slot3)
	if slot1 then
		slot0:FocusPos(Vector2(pg.world_regions_data[slot1].regions_pos[1], pg.world_regions_data[slot1].regions_pos[2]), pg.world_regions_data[slot1].regions_rotation[1], 1, slot2, slot3)
	else
		slot0:FocusPos(slot0.basePoint, 0, 0, slot2, slot3)
	end
end

slot0.SwitchArea = function (slot0, slot1, slot2, slot3)
	slot4 = {}

	if slot2 and tobool(slot1) ~= tobool(slot0.nowArea) then
		table.insert(slot4, function (slot0)
			slot0:SwitchMode(slot0.SwitchMode, slot0, slot0)
		end)
	end

	table.insert(slot4, function (slot0)
		setActive(slot0.tfAreaScene, not slot1)
		setActive(slot0.tfMapScene, setActive)
		setActive(slot0.tfMapModel, not slot1)
		slot0()
	end)

	slot0.nowArea = slot1

	parallelAsync({
		function (slot0)
			seriesAsync(slot0, slot0)
		end,
		function (slot0)
			slot0:FocusPosInArea(slot0.FocusPosInArea, slot0, slot0)
		end
	}, function ()
		return existCall(existCall)
	end)
end

slot0.SwitchMode = function (slot0, slot1, slot2, slot3)
	function slot4(slot0)
		setActive(slot0.tfAreaScene, true)

		slot1 = slot0.tfAreaScene:GetComponent("FMultiSpriteRenderCtrl")

		slot1:Init()

		slot1.alpha = (slot1 and 1) or 0

		slot1:UpdateAlpha()
		table.insert(slot0.twFocusIds, slot2)
		slot0.wsTimer:AddTween(LeanTween.value(go(slot0.tfAreaScene), (slot1 and 1) or 0, (not slot1 or 0) and 1, LeanTween.value.baseDuration):setOnUpdate(System.Action_float(function (slot0)
			slot0.alpha = slot0
		end)).setOnComplete(slot2, System.Action(function ()
			slot0.alpha = 1

			slot0:UpdateAlpha()
			setActive(slot0.tfAreaScene, not slot2)

			return slot3()
		end)).uniqueId)
	end

	function slot5(slot0)
		setActive(slot0.tfMapScene, true)

		slot1 = slot0.tfMapScene:GetComponent("FMultiSpriteRenderCtrl")

		slot1:Init()

		slot1.alpha = (not slot1 or 0) and 1

		slot1:UpdateAlpha()
		table.insert(slot0.twFocusIds, slot2)
		slot0.wsTimer:AddTween(LeanTween.value(go(slot0.tfMapScene), (not slot1 or 0) and 1, (slot1 and 1) or 0, LeanTween.value.baseDuration):setOnUpdate(System.Action_float(function (slot0)
			slot0.alpha = slot0
		end)).setOnComplete(slot2, System.Action(function ()
			slot0.alpha = 1

			slot0:UpdateAlpha()
			setActive(slot0.tfMapScene, slot2)

			return slot3()
		end)).uniqueId)
	end

	function slot6(slot0)
		setActive(slot0.tfMapModel, true)

		slot2 = slot1.baseDuration

		table.insert(slot1, function (slot0)
			slot1 = slot0.tfModel:Find("Terrain_LOD9_perfect")

			slot1:GetComponent("MeshRenderer").material:SetFloat("_Invisible", (slot1 and 1) or 0)
			table.insert(slot0.twFocusIds, slot3)
			slot0.wsTimer:AddTween(LeanTween.value(go(slot1), (slot1 and 1) or 0, (not slot1 or 0) and 1, slot2):setOnUpdate(System.Action_float(function (slot0)
				slot0:SetFloat("_Invisible", slot0)
			end)).setOnComplete(slot3, System.Action(function ()
				slot0(slot1, "_Invisible", (not slot0.SetFloat or 0) and 1)
				"_Invisible"()
			end)).uniqueId)
		end)
		table.insert(slot1, function (slot0)
			slot1 = slot0.tfModel:Find("decolation_model")

			slot1:GetComponent("FMultiSpriteRenderCtrl"):Init()

			slot2.alpha = (slot1 and 1) or 0

			slot2:UpdateAlpha()
			table.insert(slot0.twFocusIds, slot3)
			slot0.wsTimer:AddTween(LeanTween.value(go(slot1), (slot1 and 1) or 0, (not slot1 or 0) and 1, slot2):setOnUpdate(System.Action_float(function (slot0)
				slot0.alpha = slot0
			end)).setOnComplete(slot3, System.Action(function ()
				slot0.alpha = 1

				slot0:UpdateAlpha()
				slot0()
			end)).uniqueId)
		end)
		parallelAsync(slot1, function ()
			setActive(slot0.tfMapModel, not slot1)

			return not slot1()
		end)
	end

	function slot7()
		slot0:BreathRotate(not slot1)

		return existCall(not slot1)
	end

	if slot2 then
		parallelAsync({
			slot4,
			slot5,
			slot6
		}, function ()
			return slot0()
		end)
	else
		return slot7()
	end
end

slot0.LowRotation = -5
slot0.HeightRotation = 5
slot0.BreathTime = 18

slot0.BreathRotate = function (slot0, slot1)
	if slot0.twRotateId then
		LeanTween.cancel(slot0.twRotateId)

		slot0.twRotateId = nil
	end

	if not slot1 then
		return
	end

	slot2 = -1

	function slot3()
		slot2 = go(slot1.tfEntity)
		-1 * slot0.twRotateId = slot1(slot2, (slot1 == 1 and slot2.HeightRotation) or slot2.LowRotation, slot2.BreathTime):setEase(LeanTweenType.easeOutSine):setOnComplete(System.Action(function ()
			slot0()
		end)).uniqueId
	end

	slot0.twRotateId = LeanTween.rotateY(go(slot0.tfEntity), slot0.LowRotation, slot0.BreathTime / 2).setEase(slot4, LeanTweenType.easeOutSine):setOnComplete(System.Action(function ()
		slot0()
	end)).setDelay(slot4, 1).uniqueId
end

slot0.CheckIsTweening = function (slot0)
	while #slot0.twFocusIds > 0 and not LeanTween.isTweening(slot0.twFocusIds[1]) do
		table.remove(slot0.twFocusIds, 1)
	end

	return slot0.isTransAnim or #slot0.twFocusIds > 0
end

slot0.ActiveTrans = function (slot0, slot1)
	if slot0.entranceTplDic[slot1.id].portCamp then
	else
		slot3 = slot0.tfMapSelect:Find("A" .. slot1:GetColormaskUniqueID() .. "_2")

		setActive(slot3, true)

		slot3:GetComponent("SpriteRenderer").color.a = 0
		slot3:GetComponent("SpriteRenderer").color = slot3.GetComponent("SpriteRenderer").color

		LeanTween.alpha(go(slot3), 1, 0.3):setOnComplete(System.Action(function ()
			LeanTween.alpha(go(slot0), 0, 0.2):setDelay(0.1):setOnComplete(System.Action(function ()
				slot0(slot1, slot1.selectEntrance == )

				slot3.a = 1
				slot3:GetComponent("SpriteRenderer").color = slot3
			end))
		end))
	end
end

slot0.DisplayTransport = function (slot0, slot1, slot2)
	slot3 = {}

	for slot7, slot8 in pairs(slot0.atlas.transportDic) do
		if slot8 and not slot1[slot7] then
			slot3[slot7] = true
		end
	end

	slot0:UpdateTransMark(slot3, slot2)
end

slot0.UpdateTransMark = function (slot0, slot1, slot2)
	for slot6, slot7 in pairs(slot1) do
		if slot7 then
			slot0.isTransAnim = true

			slot0:ActiveTrans(slot0.atlas:GetEntrance(slot6))
		end
	end

	if slot0.isTransAnim then
		slot0.wsTimer:AddTimer(function ()
			slot0.isTransAnim = false

			false()
		end, 0.6).Start(slot3)
	else
		slot2()
	end
end

slot0.UpdateActiveMark = function (slot0)
	slot1 = nowWorld:GetActiveMap():CkeckTransport()

	eachChild(slot0.tfActiveMark, function (slot0)
		setActive(slot0:Find("base"), slot0)
		setActive(slot0:Find("limit"), not slot0)
	end)
end

return slot0
