slot0 = class("BackYardThemeTemplateMsgBox", import("....base.BaseSubView"))
slot0.TYPE_TEXT = 1
slot0.TYPE_IMAGE = 2

slot0.getUIName = function (slot0)
	return "BackYardThemeTemplateMsgBox"
end

slot0.OnLoaded = function (slot0)
	slot0.frame = slot0:findTF("frame/window1")
	slot0.content = slot0:findTF("frame/window1/content"):GetComponent(typeof(Text))
	slot0.frame1 = slot0:findTF("frame/window2")
	slot0.content1 = slot0:findTF("frame/window2/content"):GetComponent(typeof(Text))
	slot0.icon = slot0:findTF("frame/window2/mask/icon"):GetComponent(typeof(RawImage))
	slot0.cancelBtn = slot0:findTF("frame/btns/cancel")
	slot0.cancelBtnTxt = slot0:findTF("frame/btns/cancel/Text"):GetComponent(typeof(Text))
	slot0.confirmBtn = slot0:findTF("frame/btns/confirm")
	slot0.confirmBtnTxt = slot0:findTF("frame/btns/confirm/Text"):GetComponent(typeof(Text))
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_PANEL)
	onButton(slot0, slot0.cancelBtn, function ()
		slot0:Hide()

		if slot0.Hide.onCancel then
			slot0.onCancel()
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.confirmBtn, function ()
		slot0:Hide()

		if slot0.Hide.onYes then
			slot0.onYes()
		end
	end, SFX_PANEL)
end

slot0.SetUp = function (slot0, slot1)
	slot0.onYes = slot1.onYes
	slot0.onCancel = slot1.onCancel
	slot0.cancelBtnTxt.text = slot1.cancelTxt or i18n("word_cancel")
	slot0.confirmBtnTxt.text = slot1.confirmTxt or i18n("word_ok")

	if (slot1.type or slot0.TYPE_TEXT) == slot0.TYPE_TEXT then
		slot0.content.text = slot1.content
	elseif slot2 == slot0.TYPE_IMAGE then
		slot0.content1.text = slot1.content

		BackYardThemeTempalteUtil.GetTexture(slot1.srpiteName, slot1.md5, function (slot0)
			if not IsNil(slot0.icon) and slot0 then
				slot0.icon.texture = slot0
			end
		end)
	end

	setActive(slot0.frame, slot2 == slot0.TYPE_TEXT)
	setActive(slot0.frame1, slot2 == slot0.TYPE_IMAGE)
	setActive(slot0.cancelBtn, not slot1.hideNo)
	slot0.Show(slot0)
end

slot0.Show = function (slot0)
	slot0.super.Show(slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
end

slot0.Hide = function (slot0)
	slot0.icon.texture = nil

	slot0.super.Hide(slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)
end

slot0.OnDestroy = function (slot0)
	slot0:Hide()
end

return slot0
