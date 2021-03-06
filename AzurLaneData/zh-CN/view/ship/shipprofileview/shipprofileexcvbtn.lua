slot0 = class("ShipProfileExCvBtn", import(".ShipProfileCvBtn"))

slot0.Init = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot0.super.Init(slot0, slot1, slot2, slot3, slot4)

	slot0.favor = slot5
	slot7, slot8 = nil

	if string.find(slot4.key, ShipWordHelper.WORD_TYPE_MAIN) then
		mainIndex = tonumber(slot9)
		slot7, slot8 = ShipWordHelper.ExistExCv(slot2.id, ShipWordHelper.WORD_TYPE_MAIN, mainIndex, slot5)
	else
		slot7, slot8 = ShipWordHelper.ExistExCv(slot2.id, slot6, nil, slot5)
	end

	if slot0.wordData.cvPath and slot8 then
		slot0.wordData.cvPath = slot0.wordData.cvPath .. "_ex" .. slot8
	end

	slot0.wordData.matchFavor = slot8
	slot0.wordData.textContent = slot7
	slot0.wordData.maxfavor = slot5
end

slot0.Update = function (slot0)
	setActive(slot0._tf, not (slot0.voice.unlock_condition[1] < 0 or slot0.wordData.textContent == nil or slot0.wordData.textContent == "nil" or slot0.wordData.textContent == ""))

	if not (slot0.voice.unlock_condition[1] < 0 or slot0.wordData.textContent == nil or slot0.wordData.textContent == "nil" or slot0.wordData.textContent == "") then
		slot0:UpdateCvBtn()
		slot0:UpdateIcon()
	end
end

slot0.UpdateCvBtn = function (slot0)
	slot3, slot4 = slot0.shipGroup.VoiceReplayCodition(slot2, slot0.voice)
	slot0.nameTxt.text = (slot3 and slot1.voice_name .. "Ex") or "???"

	setActive(slot0.tagDiff, ShipWordHelper.ExistDifferentExWord(slot0.skin.id, slot1.key, slot0.wordData.mainIndex, slot0.favor))

	if not slot3 then
		onButton(nil, slot0._tf, function ()
			pg.TipsMgr.GetInstance():ShowTips(pg.TipsMgr.GetInstance().ShowTips)
		end, SFX_PANEL)
	end
end

return slot0
