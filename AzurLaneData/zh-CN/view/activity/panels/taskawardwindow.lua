function slot1(slot0)
	function slot2(slot0)
		for slot4, slot5 in ipairs(slot0.tasklist) do
			if type(slot5) == "table" then
				for slot9, slot10 in ipairs(slot5) do
					if slot10 == slot0 then
						return slot4
					end
				end
			elseif slot0 == slot5 then
				return slot4
			end
		end
	end

	slot3 = getProxy(TaskProxy)
	slot4 = nil

	for slot8 = #_.flatten(slot0.tasklist), 1, -1 do
		if slot3.getFinishTaskById(slot3, slot1[slot8]) and slot10:isReceive() then
			slot4 = slot9
		end
	end

	if not slot4 and slot0.tasklist[math.min(slot0.index, #slot0.tasklist)] then
		slot4 = slot6[1]
	end

	slot0.UIlist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setText(slot2:Find("title/Text"), "PHASE " .. slot2(slot3))
			setText(slot2:Find("target/title"), slot1:getTaskById(slot0[slot1 + 1]) or slot1:getFinishTaskById(slot3) or Task.New({
				id = slot3
			}):getConfig("name"))
			setText(slot2:Find("target/Text"), "")

			if GetPerceptualSize(slot1.getTaskById(slot0[slot1 + 1]) or slot1.getFinishTaskById(slot3) or Task.New():getConfig("name")) > 15 then
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

			if slot2:Find("target/icon") and slot3.resIcon and slot3.resIcon ~= "" then
				setActive(slot2:Find("target/icon"), true)
				LoadImageSpriteAsync(slot3.resIcon, slot2:Find("target/icon/image"), false)
			else
				setActive(slot2:Find("target/icon"), false)
			end

			updateDrop(slot2:Find("award"), slot7)
			onButton(slot3.binder, slot2:Find("award"), function ()
				slot0.binder:emit(BaseUI.ON_DROP, slot0.binder)
			end, SFX_PANEL)
			setActive(slot2.Find(slot2, "award/mask"), slot4:isReceive() or (slot4 and slot3 < slot4))
		end
	end)
	slot0.UIlist.align(slot5, #slot1)
end

class("TaskAwardWindow", import(".PtAwardWindow")).Show = function (slot0, slot1)
	slot0.tasklist = slot1.tasklist
	slot0.ptId = slot1.ptId
	slot0.totalPt = slot1.totalPt
	slot0.index = slot1.index or 1

	slot0:updateResIcon(slot1.resId, slot1.resIcon, slot1.type)
	slot0(slot0)

	slot0.totalTxt.text = slot0.totalPt
	slot0.totalTitleTxt.text = i18n("award_window_pt_title")

	setActive(slot0._tf, true)
end

return class("TaskAwardWindow", import(".PtAwardWindow"))
