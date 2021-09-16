slot0 = class("XiaotianeSwimsuitSkinPage", import(".TemplatePage.SkinTemplatePage"))

slot0.OnInit = function (slot0)
	slot0.super.OnInit(slot0)

	slot0.rtDayImage = slot0.bg:Find("day_image")
	slot0.rtCharacter = slot0.bg:Find("character")
end

slot0.OnUpdateFlush = function (slot0)
	slot0.super.OnUpdateFlush(slot0)
	setText(slot0.dayTF, i18n("activity_permanent_progress") .. slot0.nday .. "/" .. #slot0.taskGroup)
	GetImageSpriteFromAtlasAsync("ui/activityuipage/xiaotianeswimsuitskinpage_atlas", tostring(slot0.nday), slot0.rtDayImage, true)

	if not slot0.model then
		PoolMgr.GetInstance():GetSpineChar("xiaotiane_2", true, function (slot0)
			if slot0.model then
				return
			end

			slot0.model = slot0
			tf(slot0).localScale = Vector3(1, 1, 1)

			slot0:GetComponent("SpineAnimUI"):SetAction("stand2", 0)
			setParent(slot0, slot0.rtCharacter)
		end)
	end
end

slot0.OnDestroy = function (slot0)
	if slot0.model then
		PoolMgr.GetInstance():ReturnSpineChar("xiaotiane_2", slot0.model)

		slot0.prefab1 = nil
		slot0.model1 = nil
	end

	slot0.super.OnDestroy(slot0)
end

return slot0
