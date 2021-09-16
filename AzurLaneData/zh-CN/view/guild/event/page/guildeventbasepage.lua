slot0 = class("GuildEventBasePage", import("....base.BaseSubView"))

slot0.Show = function (slot0, slot1, slot2, slot3)
	slot0:UpdateData(slot1, slot2, slot3)
	slot0.super.Show(slot0)
	pg.UIMgr:GetInstance():BlurPanel(slot0._tf)
	slot0:OnShow()

	slot0.inAnim = true

	slot0:EnterAnim(function ()
		slot0.inAnim = false
	end)
end

slot0.SetHideCallBack = function (slot0, slot1)
	slot0.exitCallback = slot1
end

slot0.UpdateData = function (slot0, slot1, slot2, slot3)
	slot0.guild = slot1
	slot0.player = slot2
	slot0.extraData = slot3
end

slot0.Hide = function (slot0, slot1)
	function slot2()
		slot0.inAnim = false

		slot1.super.Hide(slot1.super.Hide)
		pg.UIMgr:GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)

		if not slot0._tf and slot0.exitCallback then
			slot0.exitCallback()
		end
	end

	if not slot1 then
		slot0.inAnim = true

		slot0.ExistAnim(slot0, slot2)
	else
		slot2()
	end
end

slot0.OnDestroy = function (slot0)
	slot0:Hide(true)
end

slot0.emit = function (slot0, ...)
	if slot0.inAnim then
		return
	end

	slot0.super.emit(slot0, ...)
end

slot0.EnterAnim = function (slot0, slot1)
	slot1()
end

slot0.ExistAnim = function (slot0, slot1)
	slot1()
end

slot0.OnShow = function (slot0)
	return
end

return slot0
