ys = ys or {}
ys.Battle.BattleBuffCastSkill = class("BattleBuffCastSkill", ys.Battle.BattleBuffEffect)
ys.Battle.BattleBuffCastSkill.__name = "BattleBuffCastSkill"
ys.Battle.BattleBuffCastSkill.FX_TYPE = ys.Battle.BattleBuffEffect.FX_TYPE_CASTER

ys.Battle.BattleBuffCastSkill.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)

	slot0._castCount = 0
	slot0._fireSkillDMGSum = 0
end

ys.Battle.BattleBuffCastSkill.GetEffectType = function (slot0)
	return slot0.FX_TYPE
end

ys.Battle.BattleBuffCastSkill.GetGroupData = function (slot0)
	return slot0._group
end

ys.Battle.BattleBuffCastSkill.SetArgs = function (slot0, slot1, slot2)
	slot0._level = slot2:GetLv()
	slot0._skill_id = slot0._tempData.arg_list.skill_id
	slot0._target = slot0._tempData.arg_list.target or "TargetSelf"
	slot0._check_target = slot3.check_target
	slot0._check_weapon = slot3.check_weapon
	slot0._time = slot3.time or 0
	slot0._nextEffectTime = pg.TimeMgr.GetInstance():GetCombatTime() + slot0._time
	slot0._minTargetNumber = slot3.minTargetNumber or 0
	slot0._maxTargetNumber = slot3.maxTargetNumber or 10000
	slot0._minWeaponNumber = slot3.minWeaponNumber or 0
	slot0._maxWeaponNumber = slot3.maxWeaponNumber or 10000
	slot0._rant = slot3.rant or 10000
	slot0._streak = slot3.streakRange
	slot0._dungeonTypeList = slot3.dungeonTypeList
	slot0._effectAttachData = slot3.effectAttachData
	slot0._group = slot3.group
	slot0._srcBuff = slot2
end

ys.Battle.BattleBuffCastSkill.onBulletCreate = function (slot0, slot1, slot2, slot3)
	if not slot0:equipIndexRequire(slot3.equipIndex) then
		return
	end

	slot3._bullet.SetBuffFun(slot4, slot0._tempData.arg_list.bulletTrigger, function (slot0, slot1)
		if slot0 and slot0:IsAlive() then
			slot0:castSkill(slot0, slot1)
		end
	end)
end

ys.Battle.BattleBuffCastSkill.onTrigger = function (slot0, slot1, slot2, slot3)
	return slot0:castSkill(slot1, slot3, slot2)
end

ys.Battle.BattleBuffCastSkill.castSkill = function (slot0, slot1, slot2, slot3)
	if slot0:IsInCD(pg.TimeMgr.GetInstance():GetCombatTime()) then
		return "overheat"
	end

	if not slot0.Battle.BattleFormulas.IsHappen(slot0._rant) then
		return "chance"
	end

	if slot0._check_target then
		if not slot0:getTargetList(slot1, slot0._check_target, slot0._tempData.arg_list) then
			return "check target none"
		end

		if #slot5 < slot0._minTargetNumber then
			return "check target min"
		end

		if slot0._maxTargetNumber < slot6 then
			return "check target max"
		end
	end

	if slot0._check_weapon then
		if #slot1:GetEquipmentList(slot0._tempData.arg_list) < slot0._minWeaponNumber then
			return "check weapon min"
		end

		if slot0._maxWeaponNumber < slot6 then
			return "check weapon max"
		end
	end

	if slot0._hpUpperBound or slot0._hpLowerBound then
		slot5 = nil

		if not slot0:hpIntervalRequire(((slot2 and slot2.unit) or slot1:GetHPRate()) and slot2.unit:GetHPRate()) then
			return "check hp"
		end
	end

	if slot0._attrInterval and not slot0:attrIntervalRequire(slot0.Battle.BattleAttr.GetBase(slot1, slot0._attrInterval)) then
		return "check interval"
	end

	if slot0._streak and not slot1.GetWinningStreak(slot0._streak) then
		return "check winning streak"
	end

	if slot0._dungeonTypeList and not slot1.GetDungeonType(slot0._dungeonTypeList) then
		return "check dungeon"
	end

	if slot0._effectAttachData and not slot0:BuffAttachDataCondition(slot3) then
		return "check attach data"
	end

	slot1.super.onTrigger(slot0, slot1)

	for slot9, slot10 in ipairs(slot5) do
		slot11 = true

		if slot0._group then
			for slot16, slot17 in pairs(slot12) do
				for slot21, slot22 in ipairs(slot17._effectList) do
					if slot22:GetEffectType() == slot1.FX_TYPE and slot22:GetGroupData() and slot22:GetGroupData().id == slot0._group.id and slot0._group.level < slot23.level then
						slot11 = false

						break
					end
				end
			end
		end

		if slot11 then
			slot0:spell(slot10)
		end
	end

	slot0:enterCoolDown(slot4)
end

ys.Battle.BattleBuffCastSkill.IsInCD = function (slot0, slot1)
	return slot1 < slot0._nextEffectTime
end

ys.Battle.BattleBuffCastSkill.spell = function (slot0, slot1)
	slot0._skill = slot0._skill or slot0.Battle.BattleSkillUnit.GenerateSpell(slot0._skill_id, slot0._level, slot1, attData)

	if attach and attach.target then
		slot0._skill:SetTarget({
			attach.target
		})
	end

	slot0._skill:Cast(slot1, slot0._commander)

	slot0._castCount = slot0._castCount + 1
end

ys.Battle.BattleBuffCastSkill.enterCoolDown = function (slot0, slot1)
	if slot0._time and slot0._time > 0 then
		slot0._nextEffectTime = slot1 + slot0._time
	end
end

ys.Battle.BattleBuffCastSkill.Interrupt = function (slot0)
	slot0.super.Interrupt(slot0)

	if slot0._skill then
		slot0._skill:Interrupt()
	end
end

ys.Battle.BattleBuffCastSkill.Clear = function (slot0)
	slot0.super.Clear(slot0)

	if slot0._skill then
		slot0._skill:Clear()

		slot0._skill = nil
	end
end

ys.Battle.BattleBuffCastSkill.BuffAttachDataCondition = function (slot0, slot1)
	slot2 = true

	for slot7, slot8 in ipairs(slot3) do
		for slot12, slot13 in ipairs(slot0._effectAttachData) do
			if slot8.__name == slot13.type then
				slot14 = slot13.type
				slot15 = slot13.value
				slot17 = slot8:GetEffectAttachData()

				if slot13.op == "equal" and slot17 ~= slot15 then
					slot2 = false
				elseif slot16 == "notequal" and slot17 == slot15 then
					slot2 = false
				elseif slot16 == "lessequal" and slot15 < slot17 then
					slot2 = false
				elseif slot16 == "greatequal" and slot17 < slot15 then
					slot2 = false
				elseif slot16 == "great" and slot17 <= slot15 then
					slot2 = false
				elseif slot16 == "less" and slot15 <= slot17 then
					slot2 = false
				end
			end
		end
	end

	return slot2
end

ys.Battle.BattleBuffCastSkill.GetWinningStreak = function (slot0)
	return slot0[1] <= slot0.Battle.BattleDataProxy.GetInstance():GetWinningStreak() and slot1 < slot0[2]
end

ys.Battle.BattleBuffCastSkill.GetDungeonType = function (slot0)
	return table.contains(slot0, pg.expedition_data_template[slot0.Battle.BattleDataProxy.GetInstance():GetInitData().StageTmpId].type)
end

ys.Battle.BattleBuffCastSkill.GetEquipmentList = function (slot0, slot1)
	slot3 = {}

	for slot7, slot8 in ipairs(slot2) do
		slot3[slot7] = slot8
	end

	slot4 = #slot3

	while slot4 > 0 do
		slot6 = true

		if not slot3[slot4].equipment then
			slot6 = false
		else
			slot7 = slot0.Battle.BattleDataFunction.GetEquipDataTemplate(slot5.id)

			if slot1.weapon_group and not table.contains(slot1.weapon_group, slot7.group) then
				slot6 = false
			end

			if slot1.index and not table.contains(slot1.index, slot4) then
				slot6 = false
			end

			if slot1.type and not table.contains(slot1.type, slot7.type) then
				slot6 = false
			end

			if slot1.label then
				slot8 = slot0.Battle.BattleDataFunction.GetWeaponDataFromID(slot5.id).label

				for slot12, slot13 in ipairs(slot1.label) do
					if not table.contains(slot8, slot13) then
						slot6 = false

						break
					end
				end
			end
		end

		if not slot6 then
			table.remove(slot3, slot4)
		end

		slot4 = slot4 - 1
	end

	return slot3
end

ys.Battle.BattleBuffCastSkill.GetCastCount = function (slot0)
	return slot0._castCount
end

ys.Battle.BattleBuffCastSkill.GetSkillFireDamageSum = function (slot0)
	slot0._fireSkillDMGSum = math.max((slot0._skill and slot0._skill:GetDamageSum()) or 0, slot0._fireSkillDMGSum)

	return slot0._fireSkillDMGSum
end

return
