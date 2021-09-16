slot0 = class("WSAtlasOverall", import(".WSAtlas"))
slot0.windowSize = Vector2(1747, 776)
slot0.Fields = {
	tfMarkScene = "userdata",
	tfActiveMarkRect = "userdata"
}
slot0.Listeners = {
	onUpdateActiveEntrance = "OnUpdateActiveEntrance"
}

slot0.Dispose = function (slot0)
	if slot0.tfActiveMarkRect then
		slot0:RemoveExtraMarkPrefab(slot0.tfActiveMarkRect)
		Destroy(slot0.tfActiveMarkRect)
	end

	slot0:RemoveExtraMarkPrefab(slot0.tfMarkScene)
	slot0.super.Dispose(slot0)
end

slot0.LoadScene = function (slot0, slot1)
	SceneOpMgr.Inst:LoadSceneAsync("scenes/worldoverview", "WorldOverview", LoadSceneMode.Additive, function (slot0, slot1)
		slot0.transform = tf(slot0:GetRootGameObjects()[0])

		setActive(slot0.transform, false)

		slot0.tfEntity = slot0.transform:Find("entity")
		slot0.tfMapScene = slot0.tfEntity:Find("map_scene")
		slot0.tfMapSelect = slot0.tfMapScene:Find("selected_layer")
		slot0.tfSpriteScene = slot0.tfEntity:Find("sprite_scene")
		slot0.tfMarkScene = slot0.tfEntity:Find("mark_scene")
		slot0.defaultSprite = slot0.tfEntity:Find("decolation_layer/edge"):GetComponent("SpriteRenderer").material
		slot0.addSprite = slot0.tfEntity:Find("map_scene/mask_layer"):GetComponent("SpriteRenderer").material

		slot0:UpdateCenterEffectDisplay()
		slot0:BuildActiveMark()

		slot0.cmPointer = slot0.tfEntity:Find("Plane"):GetComponent(typeof(PointerInfo))
		slot2 = nowWorld

		slot0.cmPointer:AddColorMaskClickListener(function (slot0, slot1)
			if slot0:ColorToEntrance(slot0) then
				slot1.onClickColor(slot2, slot1.position)
			end
		end)
		setActive(slot0.tfEntity.Find(slot4, "Plane"), false)

		slot0.tfCamera = slot0.transform:Find("Main Camera")

		CameraFittingSettin(slot0.tfCamera)

		return existCall(slot1)
	end)
end

slot0.ReturnScene = function (slot0)
	if slot0.tfEntity then
		SceneOpMgr.Inst:UnloadSceneAsync("scenes/worldoverview", "WorldOverview")

		slot0.cmPointer = nil
	end
end

slot0.BuildActiveMark = function (slot0)
	slot0.super.BuildActiveMark(slot0)
	slot0:DoUpdatExtraMark(slot0.tfActiveMark, "overview_player", true)

	slot0.tfActiveMarkRect = tf(GameObject.New())
	slot0.tfActiveMarkRect.gameObject.layer = Layer.UI
	slot0.tfActiveMarkRect.name = "active_mark_rect"

	slot0.tfActiveMarkRect:SetParent(slot0.tfSpriteScene, false)
	setActive(slot0.tfActiveMarkRect, false)
	slot0:DoUpdatExtraMark(slot0.tfActiveMarkRect, "overview_player_rect", true)
end

slot0.OnUpdateActiveEntrance = function (slot0, slot1, slot2, slot3)
	slot0.super.OnUpdateActiveEntrance(slot0, slot1, slot2, slot3)

	if slot3 then
		slot0.tfActiveMarkRect.localPosition = slot0.tfActiveMark.localPosition
	end

	setActive(slot0.tfActiveMarkRect, slot3)
end

slot0.UpdateStaticMark = function (slot0, slot1, slot2)
	slot0:RemoveExtraMarkPrefab(slot0.tfMarkScene)

	slot3 = pairs
	slot4 = slot1 or {}

	for slot6, slot7 in slot3(slot4) do
		if slot7 then
			if (slot0.atlas:GetEntrance(slot6):HasPort() and slot2[1]) or slot2[2] then
				slot0:LoadExtraMarkPrefab(slot0.tfMarkScene, slot9, function (slot0)
					tf(slot0).localPosition = WorldConst.CalcModelPosition(slot0, slot1.spriteBaseSize)
				end)
			end
		end
	end

	slot0.super.UpdateStaticMark(slot0, slot1)
end

slot0.UpdateTargetEntrance = function (slot0, slot1)
	slot0.tfActiveMark.localEulerAngles = Vector3(0, calcPositionAngle(slot0.atlas:GetEntrance(slot1).config.area_pos[1] - slot0.atlas:GetActiveEntrance().config.area_pos[1], slot0.atlas.GetEntrance(slot1).config.area_pos[2] - slot0.atlas.GetActiveEntrance().config.area_pos[2]), 0)
end

return slot0
