slot0 = class("SVPoisonPanel", import("view.base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "SVPoisonPanel"
end

slot0.OnLoaded = function (slot0)
	return
end

slot0.OnInit = function (slot0)
	slot0.rtName = slot0._tf:Find("window/content/name_mask/name")
	slot0.rtDesc = slot0._tf:Find("window/content/intro_view/Viewport/Content/intro")
	slot0.rtPoisonRate = slot0._tf:Find("window/content/poison_rate")
	slot0.rtBg = slot0._tf:Find("bg")
	slot0.btnClose = slot0._tf:Find("window/top/btnBack")
	slot0.btnConfirm = slot0._tf:Find("window/button_container/confirm_btn")

	onButton(slot0, slot0.rtBg, function ()
		slot0:Hide()
	end, SFX_CANCEL)
	onButton(slot0, slot0.btnClose, function ()
		slot0:Hide()
	end, SFX_CANCEL)
	onButton(slot0, slot0.btnConfirm, function ()
		slot0:Hide()
	end, SFX_CANCEL)
end

slot0.OnDestroy = function (slot0)
	return
end

slot0.Show = function (slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
	setActive(slot0._tf, true)
end

slot0.Hide = function (slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)
	setActive(slot0._tf, false)
end

slot0.Setup = function (slot0, slot1)
	setText(slot0.rtName, i18n("world_sairen_title"))
	table.insert(slot2, 1, 0)
	table.insert(slot2, 999)
	eachChild(slot0.rtPoisonRate:Find("bg/ring"), function (slot0)
		if slot1[slot0:GetSiblingIndex() + 1] <= slot0 and slot0 < slot1[slot1 + 1] then
			setActive(slot0, true)

			slot0:GetComponent(typeof(Image)).fillAmount = slot0 / 100

			setText(slot2.rtDesc, i18n("world_sairen_description" .. slot1, slot0))
		else
			setActive(slot0, false)
		end

		setText(slot2.rtPoisonRate:Find("bg/Text"), slot0 .. "%")
	end)
end

return slot0
