ys = ys or {}
slot1 = class("BattleBuffAddAttr", ys.Battle.BattleBuffEffect)
ys.Battle.BattleBuffAddAttr = slot1
slot1.__name = "BattleBuffAddAttr"
slot1.FX_TYPE = ys.Battle.BattleBuffEffect.FX_TYPE_MOD_ATTR

slot1.Ctor = function (slot0, slot1)
	slot0.Battle.BattleBuffAddAttr.super.Ctor(slot0, slot1)
end

slot1.GetEffectType = function (slot0)
	return slot0.FX_TYPE
end

slot1.SetArgs = function (slot0, slot1, slot2)
	slot0._group = slot0._tempData.arg_list.group or slot2:GetID()

	if slot0._tempData.arg_list.comboDamage then
		slot0._attr = slot0.Battle.BattleAttr.GetCurrent(slot0._caster, "comboTag")
	else
		slot0._attr = slot0._tempData.arg_list.attr
	end

	slot0._number = slot0._tempData.arg_list.number
	slot0._numberBase = slot0._number
end

slot1.onAttach = function (slot0, slot1, slot2)
	slot0:UpdateAttr(slot1)
end

slot1.onStack = function (slot0, slot1, slot2)
	slot0._number = slot0._numberBase * slot2._stack

	slot0:UpdateAttr(slot1)
end

slot1.onRemove = function (slot0, slot1, slot2)
	slot0._number = 0

	slot0:UpdateAttr(slot1)
end

slot1.IsSameAttr = function (slot0, slot1)
	return slot0._attr == slot1
end

slot1.UpdateAttr = function (slot0, slot1)
	if slot0._attr == "injureRatio" then
		slot0:UpdateAttrMul(slot1)
	else
		slot0:UpdateAttrAdd(slot1)
	end

	if slot0._attr == "cloakExposeExtra" or slot0._attr == "cloakRestore" or slot0._attr == "cloakRecovery" then
		slot1:UpdateCloakConfig()
	end
end

slot1.CheckWeapon = function (slot0)
	if slot0._attr == "loadSpeed" then
		return true
	else
		return false
	end
end

slot1.UpdateAttrMul = function (slot0, slot1)
	slot2 = 1
	slot3 = 1
	slot4 = {}
	slot5 = {}

	for slot10, slot11 in pairs(slot6) do
		for slot15, slot16 in ipairs(slot11._effectList) do
			if slot16:GetEffectType() == slot0.FX_TYPE and slot16:IsSameAttr(slot0._attr) then
				slot17 = slot16._number
				slot19 = slot4[slot16._group] or 0
				slot20 = slot5[slot18] or 0

				if slot19 < slot17 and slot17 > 0 then
					slot2 = (slot2 * (1 + slot17)) / (1 + slot19)
					slot19 = slot17
				end

				if slot17 < slot20 and slot17 < 0 then
					slot3 = (slot3 * (1 + slot17)) / (1 + slot20)
					slot20 = slot17
				end

				slot4[slot18] = slot19
				slot5[slot18] = slot20
			end
		end
	end

	slot1.Battle.BattleAttr.FlashByBuff(slot1, slot0._attr, slot2 * slot3 - 1)

	if slot0:CheckWeapon() then
		slot1:FlushReloadingWeapon()
	end
end

slot1.UpdateAttrAdd = function (slot0, slot1)
	slot2, slot3 = slot1:GetHP()
	slot5 = 0
	slot6 = 0
	slot7 = {}
	slot8 = {}

	for slot12, slot13 in pairs(slot4) do
		for slot17, slot18 in ipairs(slot13._effectList) do
			if slot18:GetEffectType() == slot0.FX_TYPE and slot18:IsSameAttr(slot0._attr) then
				slot19 = slot18._number
				slot21 = slot7[slot18._group] or 0
				slot22 = slot8[slot20] or 0

				if slot21 < slot19 and slot19 > 0 then
					slot5 = (slot5 + slot19) - slot21
					slot21 = slot19
				end

				if slot19 < slot22 and slot19 < 0 then
					slot6 = (slot6 + slot19) - slot22
					slot22 = slot19
				end

				slot7[slot20] = slot21
				slot8[slot20] = slot22
			end
		end
	end

	slot1.Battle.BattleAttr.FlashByBuff(slot1, slot0._attr, slot5 + slot6)
	slot1:SetCurrentHP(math.min(slot9, slot2 + math.max(0, slot1:GetMaxHP() - slot3)))

	if slot0:CheckWeapon() then
		slot1:FlushReloadingWeapon()
	end

	slot1._move:ImmuneAreaLimit(slot1.Battle.BattleAttr.IsImmuneAreaLimit(slot1))
	slot1._move:ImmuneMaxAreaLimit(slot1.Battle.BattleAttr.IsImmuneMaxAreaLimit(slot1))
end

return
