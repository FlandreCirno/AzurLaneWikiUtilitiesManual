slot0 = class("PtAwardWindow")

slot0.Ctor = function (slot0, slot1, slot2)
	slot0._tf = slot1
	slot0.binder = slot2
	slot0.UIlist = UIItemList.New(slot0._tf:Find("window/panel/list"), slot0._tf:Find("window/panel/list/item"))
	slot0.ptTF = slot0._tf:Find("window/pt")
	slot0.totalTxt = slot0._tf:Find("window/pt/Text"):GetComponent(typeof(Text))
	slot0.totalTitleTxt = slot0._tf:Find("window/pt/title"):GetComponent(typeof(Text))
	slot0.totalTitleIcon = slot0._tf:Find("window/pt/icon/image"):GetComponent(typeof(Image))
	slot0.closeBtn = slot0._tf:Find("window/top/btnBack")
	slot0.ptIcon = slot0._tf:Find("window/pt/icon")

	onButton(slot0.binder, slot0._tf, function ()
		slot0:Hide()
	end, SFX_PANEL)
	onButton(slot0.binder, slot0.closeBtn, function ()
		slot0:Hide()
	end, SFX_PANEL)
end

slot0.UpdateList = function (slot0, slot1, slot2, slot3)
	slot0.UIlist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot3 = slot0[slot1 + 1]
			slot4 = slot1[slot1 + 1]
			slot5 = GetPerceptualSize(slot2.resTitle)

			if PLATFORM_CODE == PLATFORM_JP then
				if slot5 > 15 then
					GetComponent(slot2:Find("target/Text"), typeof(Text)).fontSize = 26
					GetComponent(slot2:Find("target/title"), typeof(Text)).fontSize = 26
				elseif slot5 > 12 then
					GetComponent(slot2:Find("target/Text"), typeof(Text)).fontSize = 28
					GetComponent(slot2:Find("target/title"), typeof(Text)).fontSize = 28
				elseif slot5 > 10 then
					GetComponent(slot2:Find("target/Text"), typeof(Text)).fontSize = 30
					GetComponent(slot2:Find("target/title"), typeof(Text)).fontSize = 30
				else
					GetComponent(slot2:Find("target/Text"), typeof(Text)).fontSize = 32
					GetComponent(slot2:Find("target/title"), typeof(Text)).fontSize = 32
				end
			end

			setText(slot2:Find("title/Text"), "PHASE " .. slot1 + 1)
			setText(slot2:Find("target/Text"), slot4)

			if slot2:Find("target/icon") and slot2.resIcon and slot2.resIcon ~= "" then
				setActive(slot2:Find("target/icon"), true)
				LoadImageSpriteAsync(slot2.resIcon, slot2:Find("target/icon/image"), false)
			else
				setActive(slot2:Find("target/icon"), false)
			end

			setText(slot2:Find("target/title"), HXSet.hxLan(slot2.resTitle))
			updateDrop(slot2:Find("award"), slot6, {
				hideName = true
			})
			onButton(slot2.binder, slot2:Find("award"), function ()
				slot0.binder:emit(BaseUI.ON_DROP, slot0.binder)
			end, SFX_PANEL)
			setActive(slot2.Find(slot2, "award/mask"), slot1 + 1 <= slot3)
		end
	end)
	slot0.UIlist.align(slot4, #slot1)
end

slot0.Show = function (slot0, slot1)
	slot2 = slot1.dropList
	slot3 = slot1.targets
	slot4 = slot1.level
	slot5 = slot1.count
	slot6 = slot1.resId
	slot8 = ""
	slot0.resIcon = nil

	if slot1.type == 2 then
		slot0.cntTitle = i18n("pt_total_count", i18n("pt_cosume", slot8))
		slot0.resTitle = i18n("pt_cosume", slot8)
		slot0.cntTitle = string.gsub(slot0.cntTitle, "：", "")
	elseif slot7 == 3 then
		slot0.cntTitle = i18n("pt_ship_now")
		slot0.resTitle = i18n("pt_ship_goal")
	elseif slot7 == 4 then
		slot0.cntTitle = i18n("cumulative_victory_now_tip")
		slot0.resTitle = i18n("cumulative_victory_target_tip")
	else
		slot0.cntTitle = i18n("pt_total_count", slot8)
		slot0.resTitle = i18n("target_get_tip")
		slot0.cntTitle = string.gsub(slot0.cntTitle, "：", "")
	end

	slot0:updateResIcon(slot1.resId, slot1.resIcon, slot1.type)
	slot0:UpdateList(slot2, slot3, slot4)

	slot0.totalTxt.text = slot5
	slot0.totalTitleTxt.text = HXSet.hxLan(slot0.cntTitle)

	Canvas.ForceUpdateCanvases()
	setActive(slot0._tf, true)
end

slot0.updateResIcon = function (slot0, slot1, slot2, slot3)
	if slot3 == 2 or (slot3 ~= 3 and slot3 ~= 4) then
		if slot1 then
			slot0.resIcon = pg.item_data_statistics[id2ItemId(slot1)].icon
		elseif slot2 then
			slot0.resIcon = slot2
		end

		if slot0.ptIcon and slot0.resIcon and slot0.resIcon ~= "" then
			setActive(slot0.ptIcon, true)
			LoadImageSpriteAsync(slot0.resIcon, slot0.totalTitleIcon, false)
		else
			setActive(slot0.ptIcon, false)
		end
	end
end

slot0.Hide = function (slot0)
	setActive(slot0._tf, false)
end

slot0.Dispose = function (slot0)
	slot0:Hide()
	removeOnButton(slot0._tf)
	removeOnButton(slot0.closeBtn)
end

return slot0
