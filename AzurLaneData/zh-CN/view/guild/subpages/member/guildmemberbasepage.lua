slot0 = class("GuildMemberBasePage", import("....base.BaseSubView"))

slot0.SetCallBack = function (slot0, slot1, slot2)
	slot0.onShowCallBack = slot1
	slot0.onHideCallBack = slot2
end

slot0.OnLoaded = function (slot0)
	slot0.buttonContainer = slot0:findTF("frame/opera")
	slot0.buttonPos = Vector3(pg.UIMgr:GetInstance().OverlayMain.transform.InverseTransformPoint(slot1, slot0.buttonContainer.position).x, pg.UIMgr.GetInstance().OverlayMain.transform.InverseTransformPoint(slot1, slot0.buttonContainer.position).y, 0)
end

slot0.Show = function (slot0, slot1, slot2, slot3, slot4)
	if slot4 then
		slot4()
	end

	slot0.guildVO = slot1
	slot0.playerVO = slot2
	slot0.memberVO = slot3

	if not slot0:ShouldShow() then
		return
	end

	slot0:OnShow()
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
	slot0.super.Show(slot0)
	slot0._tf:SetAsLastSibling()
	slot0.onShowCallBack(slot0.buttonPos)
end

slot0.Hide = function (slot0)
	if slot0:isShowing() then
		pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)
	end

	if slot0.circle.childCount > 0 then
		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. slot0.circle:GetChild(0).gameObject.name, slot0.circle.GetChild(0).gameObject.name, slot0.circle.GetChild(0).gameObject)
	end

	slot0.super.Hide(slot0)
	slot0.onHideCallBack()
end

slot0.OnDestroy = function (slot0)
	slot0:Hide()
end

slot0.ShouldShow = function (slot0)
	return true
end

slot0.OnShow = function (slot0)
	return
end

return slot0
