function slot1(slot0, slot1, slot2, slot3)
	slot0.UIlist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot2.resTitle = string.gsub(slot2.resTitle, ":", "")

			setText(slot2:Find("title/Text"), "PHASE " .. slot1 + 1)
			setText(slot2:Find("target/Text"), slot4)
			setText(slot2:Find("target/title"), slot2.resTitle)
			updateDrop(slot2:Find("award"), slot5, {
				hideName = true
			})
			onButton(slot2.binder, slot2:Find("award"), function ()
				slot0.binder:emit(BaseUI.ON_DROP, slot0.binder)
			end, SFX_PANEL)
			setActive(slot2.Find(slot2, "award/mask"), table.contains(slot0[slot1 + 1], slot1[slot1 + 1]))

			if GetPerceptualSize(slot4) > 15 then
				GetComponent(slot2:Find("target/Text"), typeof(Text)).fontSize = 26
				GetComponent(slot2:Find("target/title"), typeof(Text)).fontSize = 26
			elseif slot6 > 12 then
				GetComponent(slot2:Find("target/Text"), typeof(Text)).fontSize = 28
				GetComponent(slot2:Find("target/title"), typeof(Text)).fontSize = 28
			elseif slot6 > 10 then
				GetComponent(slot2:Find("target/Text"), typeof(Text)).fontSize = 30
				GetComponent(slot2:Find("target/title"), typeof(Text)).fontSize = 30
			else
				GetComponent(slot2:Find("target/Text"), typeof(Text)).fontSize = 32
				GetComponent(slot2:Find("target/title"), typeof(Text)).fontSize = 32
			end

			if slot2:Find("target/icon") and slot2.resIcon and slot2.resIcon ~= "" then
				setActive(slot2:Find("target/icon"), true)
				LoadImageSpriteAsync(slot2.resIcon, slot2:Find("target/icon/image"), false)
			else
				setActive(slot2:Find("target/icon"), false)
			end
		end
	end)
	slot0.UIlist.align(slot4, #slot1)
end

class("ReturnerAwardWindow", import(".PtAwardWindow")).Show = function (slot0, slot1)
	slot0.cntTitle = i18n("pt_total_count", slot7)
	slot0.resTitle = i18n("pt_count", slot7)

	slot0:updateResIcon(slot1.resId, slot1.resIcon, slot1.type)
	slot0(slot0, slot2, slot1.targets, slot1.fetchList)

	slot0.totalTxt.text = slot1.count
	slot0.totalTitleTxt.text = slot0.cntTitle

	setActive(slot0._tf, true)
end

return class("ReturnerAwardWindow", import(".PtAwardWindow"))
