slot0 = class("BackYardThemeTemplateSortPanel", import("....base.BaseSubView"))
slot1 = {
	"sort_default",
	"sort_time",
	"sort_like"
}

function slot2(slot0)
	return i18n(slot0[slot0])
end

slot0.GetChineseByIndex = function (slot0)
	return slot0(slot0)
end

slot0.getUIName = function (slot0)
	return "BackYardThemeTemplateSortPanel"
end

slot0.OnLoaded = function (slot0)
	slot0.tpl = slot0:findTF("main/tpl")
	slot0.container = slot0:findTF("main/content")
	slot0.confirmBtn = slot0:findTF("main/confirm")
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0.confirmBtn, function ()
		slot0:Hide()

		if slot0.Hide.OnConfirm then
			slot0.OnConfirm()
		end
	end, SFX_PANEL)

	function slot1(slot0, slot1)
		setActive(slot0:Find("mark"), slot1)
	end

	slot0.btns = {}

	for slot5 = 1, 3, 1 do
		onButton(slot0, slot6, function ()
			if slot0.index then
				slot1(slot0.btns[slot0.index], false)
			end

			slot1(slot2, true)

			if slot1.OnChange then
				slot0.OnChange(slot3)
			end

			slot0.index = slot4
		end, SFX_PANEL)
		setText(cloneTplTo(slot0.tpl, slot0.container).Find(slot6, "Text"), slot0(slot5))

		if slot5 == 1 then
			triggerButton(slot6)
		end

		slot0.btns[slot5] = slot6
	end
end

slot0.GetSortArr = function (slot0)
	if slot0 == 1 then
		return "id"
	elseif slot0 == 2 then
		return "time"
	elseif slot0 == 3 then
		return "likeCnt"
	end
end

slot0.SetUp = function (slot0)
	slot0:Show()
end

slot0.Show = function (slot0)
	slot0.super.Show(slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
end

slot0.Hide = function (slot0)
	slot0.super.Hide(slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0
