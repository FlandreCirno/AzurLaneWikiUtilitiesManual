slot0 = class("BackYardDecorationMsgBox", import("....base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "BackYardDecorationMsgBox"
end

slot0.OnLoaded = function (slot0)
	slot0.frame = slot0:findTF("frame")
	slot0.cancelBtn = slot0:findTF("frame/control/cancel_btn")
	slot0.deleteBtn = slot0:findTF("frame/control/delete_btn")
	slot0.saveBtn = slot0:findTF("frame/control/save_btn")
	slot0.applyBtn = slot0:findTF("frame/control/set_btn")
	slot0.input = slot0:findTF("frame/bound/input")
	slot0.name = slot0:findTF("frame/bound/Name")
	slot0.nameText = slot0:findTF("Text", slot0.name):GetComponent(typeof(Text))
	slot0.desc = slot0:findTF("frame/bound/desc"):GetComponent(typeof(Text))
	slot0.icon = slot0:findTF("frame/bound/Icon"):GetComponent(typeof(Image))
	slot0.iconRaw = slot0:findTF("frame/bound/Icon_raw"):GetComponent(typeof(RawImage))
	slot0.innerMsgbox = slot0:findTF("msg")
	slot0.innerMsgboxContent = slot0.innerMsgbox:Find("bound/Text"):GetComponent(typeof(Text))
	slot0.innerMsgboxComfirmBtn = slot0.innerMsgbox:Find("btns/btn1")
	slot0.innerMsgboxCancelBtn = slot0.innerMsgbox:Find("btns/btn2")
	slot0.scrollTitleText = slot0.innerMsgbox:Find("bound/title"):GetComponent(typeof(Text))
	slot0.scrollText = slot0.innerMsgbox:Find("bound/scrollrect/Text"):GetComponent(typeof(Text))
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end)
	onButton(slot0, slot0.cancelBtn, function ()
		slot0:Hide()
	end)
	onButton(slot0, slot0.deleteBtn, function ()
		if slot0.theme:IsPushed() then
			slot0:ShowInnerMsgBox(i18n("backyard_decoration_theme_template_delete_tip"), function ()
				slot0:emit(BackYardDecorationMediator.DELETE_THEME, slot0.theme.id)
				slot0.emit:Hide()
			end, true)
		else
			slot0.emit(slot0, BackYardDecorationMediator.DELETE_THEME, slot0.theme.id)
			slot0.emit:Hide()
		end
	end)
	onButton(slot0, slot0.saveBtn, function ()
		if wordVer(slot0) > 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("backyard_theme_name_forbid"))

			return
		end

		slot0:emit(BackYardDecorationMediator.SAVE_THEME, slot0.theme.id, slot0)
		slot0:Hide()
	end)
	onButton(slot0, slot0.applyBtn, function ()
		slot0.emit(slot1, BackYardDecorationMediator.APPLY_THEME, slot0.theme, function (slot0, slot1)
			slot0.contextData.applyCnt = ((slot0.contextData.applyCnt or 0) + 1) % 5

			gcAll(slot0.contextData.applyCnt == 0)

			if slot0 then
				slot0:emit(BackYardDecorationMediator.ADD_FURNITURES, slot0.theme.id, slot1, slot1)
				slot0:Hide()
			else
				slot0:ShowInnerMsgBox(i18n("backyarad_theme_replace", slot0.theme:getName()), function ()
					slot0:emit(BackYardDecorationMediator.ADD_FURNITURES, slot0.theme.id, slot0, )
					slot0.emit:HideInnerMsgBox()
					slot0.emit.HideInnerMsgBox:Hide()
				end)
			end
		end)
	end)
	onInputChanged(slot0, slot0.input, function ()
		if not slot0.unEmpty then
			setText(slot0.desc, i18n("backyard_theme_save_tip", getInputText(slot0.input)))
		end
	end)
end

slot0.Show = function (slot0, slot1, slot2)
	slot0.super.Show(slot0)

	slot0.theme = slot1
	slot0.unEmpty = slot2

	if slot2 then
		slot0:ApplyTheme()
	else
		slot0:NewTheme()
	end

	setActive(slot0.frame, true)
	setActive(slot0._tf, true)
	setActive(slot0.innerMsgbox, false)
	setActive(slot0.input, not slot2)
	setActive(slot0.name, slot2)
	setActive(slot0.cancelBtn, not slot2)
	setActive(slot0.deleteBtn, slot2 and not slot1:IsSystem())
	setActive(slot0.applyBtn, slot2)
	setActive(slot0.saveBtn, not slot2)
end

slot0.ApplyTheme = function (slot0)
	slot0.nameText.text = slot0.theme.getName(slot1)
	slot0.desc.text = i18n("backyard_theme_set_tip", slot0.theme.getName(slot1))

	if not slot0.theme:IsSystem() and (BackYardThemeTempalteUtil.FileExists(slot1:GetTextureIconName()) or slot1:IsPushed()) then
		setActive(slot0.iconRaw.gameObject, false)
		setActive(slot0.icon.gameObject, false)
		BackYardThemeTempalteUtil.GetTexture(slot1:GetTextureIconName(), slot1:GetIconMd5(), function (slot0)
			if not IsNil(slot0.iconRaw) and slot0 then
				setActive(slot0.iconRaw.gameObject, true)

				slot0.iconRaw.texture = slot0
			end
		end)
	else
		setActive(slot0.iconRaw.gameObject, false)
		setActive(slot0.icon.gameObject, true)

		slot0.icon.sprite = LoadSprite("furnitureicon/" .. slot1.getIcon(slot1))
	end
end

slot0.NewTheme = function (slot0)
	setInputText(slot0.input, i18n("backyard_theme_defaultname") .. slot2)

	slot0.desc.text = i18n("backyard_theme_save_tip", i18n("backyard_theme_defaultname") .. slot0.theme.id)
	slot0.icon.sprite = LoadSprite("furnitureicon/default_theme")
end

slot0.ShowInnerMsgBox = function (slot0, slot1, slot2, slot3, slot4)
	setActive(slot0.frame, false)
	setActive(slot0.innerMsgbox, true)
	setActive(slot0.innerMsgboxCancelBtn, slot3)

	if slot4 then
		slot0.innerMsgboxContent.text = ""
		slot0.scrollTitleText.text = slot4
		slot0.scrollText.text = slot1
	else
		slot0.scrollTitleText.text = ""
		slot0.scrollText.text = ""
		slot0.innerMsgboxContent.text = slot1
	end

	onButton(slot0, slot0.innerMsgboxComfirmBtn, function ()
		if slot0 then
			slot0()
		end
	end, SFX_PANEL)

	if slot3 then
		onButton(slot0, slot0.innerMsgboxCancelBtn, function ()
			setActive(slot0.innerMsgbox, false)
			setActive(slot0.frame, true)
		end, SFX_PANEL)
	end
end

slot0.HideInnerMsgBox = function (slot0)
	setActive(slot0.frame, true)
	setActive(slot0.innerMsgbox, false)
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0
