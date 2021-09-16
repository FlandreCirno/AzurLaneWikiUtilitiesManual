ys.Battle.BattleConstPlayerUnit = class("BattleConstPlayerUnit", ys.Battle.BattlePlayerUnit)
ys.Battle.BattleConstPlayerUnit.__name = "BattleConstPlayerUnit"
slot2 = ys.Battle.BattleConst.EquipmentType

ys.Battle.BattleConstPlayerUnit.setWeapon = function (slot0, slot1)
	slot3 = slot0._tmpData.base_list
	slot0._proficiencyList = {}

	for slot7 = 1, #slot0._tmpData.default_equip_list, 1 do
		table.insert(slot0._proficiencyList, slot0._tmpData.equipment_proficiency[slot7] or 1)
	end

	slot4 = slot0._proficiencyList
	slot5 = slot0._tmpData.preload_count

	for slot9, slot10 in ipairs(slot2) do
		if slot9 <= Ship.WEAPON_COUNT then
			slot11 = slot4[slot9]
			slot12 = slot5[slot9]

			function slot13(slot0, slot1, slot2)
				for slot7 = 1, slot0[slot1], 1 do
					slot9 = slot2:AddWeapon(slot0, slot1, slot2, slot3, slot1).GetTemplateData(slot8).type

					if slot7 <= slot4 and (slot9 == slot5.POINT_HIT_AND_LOCK or slot9 == slot5.MANUAL_TORPEDO or slot9 == slot5.DISPOSABLE_TORPEDO) then
						slot8:SetModifyInitialCD()
					end
				end
			end

			slot13(slot1[slot9] or slot2[slot9])
		end
	end

	slot6 = #slot2

	for slot11, slot12 in ipairs(slot7) do
		if slot12 and slot12 ~= -1 then
			slot0:AddWeapon(slot12, nil, nil, slot4[slot11 + slot6] or 1, slot11 + slot6)
		end
	end
end

ys.Battle.BattleConstPlayerUnit.IsAlive = function (slot0)
	return true
end

ys.Battle.BattleConstPlayerUnit.HideWaveFx = function (slot0)
	slot0:DispatchEvent(ys.Event.New(ys.Battle.BattleUnitEvent.HIDE_WAVE_FX))
end

ys.Battle.BattleConstPlayerUnit.UpdateHPAction = function (slot0, slot1, ...)
	slot0.super.UpdateHPAction(slot0, slot1, ...)

	if slot1.dHP <= 0 then
		slot0:DispatchEvent(ys.Event.New(ys.Battle.BattleUnitEvent.ADD_BLINK, {
			blink = {
				blue = 1,
				peroid = 0.1,
				red = 1,
				green = 1,
				duration = 0.1
			}
		}))
	end
end

return
