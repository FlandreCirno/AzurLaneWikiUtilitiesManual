slot0 = class("SVBossProgress", import("view.base.BaseSubView"))
slot0.HideView = "SVBossProgress.HideView"

slot0.getUIName = function (slot0)
	return "SVBossProgress"
end

slot0.OnLoaded = function (slot0)
	return
end

slot0.OnInit = function (slot0)
	slot0.rtFrame = slot0._tf:Find("frame")
	slot0.rtPanel = slot0.rtFrame:Find("buff_panel/buff_bg")
	slot0.rtInfo = slot0.rtFrame:Find("buff_panel/info")

	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_CANCEL)
end

slot0.OnDestroy = function (slot0)
	return
end

slot0.Show = function (slot0)
	setLocalScale(slot0.rtFrame, Vector3(0.5, 0.5, 0.5))
	LeanTween.cancel(go(slot0.rtFrame))
	LeanTween.scale(slot0.rtFrame, Vector3.one, 0.15)
	setActive(slot0._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
end

slot0.Hide = function (slot0)
	LeanTween.cancel(go(slot0.rtFrame))
	setActive(slot0._tf, false)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)
	slot0:emit(slot0.HideView, slot0.callback)
end

slot0.Setup = function (slot0, slot1, slot2)
	slot0.callback = slot2
	slot4 = 0
	slot5 = slot1.total

	for slot9, slot10 in ipairs(slot3) do
		slot4 = slot4 + slot10.count
	end

	setText(slot0._tf:Find("frame/buff_panel/info/name"), i18n("world_boss_drop_title"))
	setText(slot0._tf:Find("frame/buff_panel/info/value_before"), slot5 - slot4)
	setText(slot0._tf:Find("frame/buff_panel/info/value"), slot5)
end

return slot0
