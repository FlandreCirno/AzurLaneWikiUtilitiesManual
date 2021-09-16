ys = ys or {}
slot1 = ys.Battle.BattleAttr
slot2 = ys.Battle.BattleFormulas
slot3 = ys.Battle.BattleConfig
ys.Battle.BattleBuffDOT = class("BattleBuffDOT", ys.Battle.BattleBuffEffect)
ys.Battle.BattleBuffDOT.__name = "BattleBuffDOT"
ys.Battle.BattleBuffDOT.FX_TYPE = ys.Battle.BattleBuffEffect.FX_TYPE_DOT

ys.Battle.BattleBuffDOT.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)
end

ys.Battle.BattleBuffDOT.GetEffectType = function (slot0)
	return slot0.Battle.BattleBuffEffect.FX_TYPE_DOT
end

ys.Battle.BattleBuffDOT.SetArgs = function (slot0, slot1, slot2)
	slot0._number = slot0._tempData.arg_list.number or 0
	slot0._numberBase = slot0._number
	slot0._time = slot0._tempData.arg_list.time or 0
	slot0._nextEffectTime = pg.TimeMgr.GetInstance():GetCombatTime() + slot0._time
	slot0._maxHPRatio = slot0._tempData.arg_list.maxHPRatio or 0
	slot0._currentHPRatio = slot0._tempData.arg_list.currentHPRatio or 0
	slot0._minRestHPRatio = slot0._tempData.arg_list.minRestHPRatio or 0
	slot0._randExtraRange = slot0._tempData.arg_list.randExtraRange or 0
	slot0._cloakExpose = slot0._tempData.arg_list.cloakExpose or 0
	slot0._exposeGroup = slot0._tempData.arg_list._exposeGroup or slot2:GetID()
	slot0._level = slot0._level or 0

	slot2:SetOrbDuration(slot0.CaclulateDOTDuration(slot0._tempData, slot0._orb, slot1))

	if slot0._tempData.arg_list.WorldBossDotDamage then
		slot0._igniteDMG = (slot1.Battle.BattleDataProxy.GetInstance().GetInitData(slot6)[slot0._tempData.arg_list.WorldBossDotDamage.useGlobalAttr] or pg.bfConsts.NUM0) * (slot5.paramA or pg.bfConsts.NUM1)
	elseif slot0._orb then
		slot0._igniteAttr = slot0._tempData.arg_list.attr
		slot0._igniteCoefficient = slot0._tempData.arg_list.k
		slot0._igniteDMG = slot0.CalculateIgniteDamage(slot0._orb, slot0._igniteAttr, slot0._igniteCoefficient)
	else
		slot0._igniteDMG = 0
	end

	if slot0._cloakExpose and slot0._cloakExpose > 0 then
		slot1:CloakExpose(slot0._cloakExpose)
	end
end

ys.Battle.BattleBuffDOT.onStack = function (slot0, slot1, slot2)
	return
end

ys.Battle.BattleBuffDOT.onUpdate = function (slot0, slot1, slot2, slot3)
	if slot0._nextEffectTime <= slot3 then
		slot1:UpdateHP(-slot0:CalcNumber(slot1, slot2), slot5)
		slot0.Battle.BattleDataProxy.GetInstance():DamageStatistics(nil, slot1:GetAttrByName("id"), slot0.CalcNumber(slot1, slot2))

		if slot1:IsAlive() then
			slot0._nextEffectTime = slot0._nextEffectTime + slot0._time
		end
	end
end

ys.Battle.BattleBuffDOT.onRemove = function (slot0, slot1, slot2)
	slot1:UpdateHP(-slot0:CalcNumber(slot1, slot2), slot4)
	slot0.Battle.BattleDataProxy.GetInstance():DamageStatistics(nil, slot1:GetAttrByName("id"), slot0.CalcNumber(slot1, slot2))
end

ys.Battle.BattleBuffDOT.CalcNumber = function (slot0, slot1, slot2)
	slot3 = slot0.CaclulateDOTDamageEnhanceRate(slot0._tempData, slot0._orb, slot1)
	slot4, slot5 = slot1:GetHP()
	slot6 = slot4 * slot0._currentHPRatio + slot5 * slot0._maxHPRatio + slot0._number + slot0._igniteDMG

	if slot0._randExtraRange > 0 then
		slot6 = slot6 + math.random(0, slot0._randExtraRange)
	end

	return math.max(0, math.floor(math.min(slot4 - slot5 * slot0._minRestHPRatio, slot6 * (1 + slot3) * slot2._stack * slot1:GetCurrent("repressReduce"))))
end

ys.Battle.BattleBuffDOT.SetOrb = function (slot0, slot1, slot2, slot3)
	slot0._orb = slot2
	slot0._level = slot3

	slot1:SetOrbLevel(slot0._level)
end

ys.Battle.BattleBuffDOT.UpdateCloakLock = function (slot0)
	slot2 = 0
	slot3 = {}

	for slot7, slot8 in pairs(slot1) do
		for slot12, slot13 in ipairs(slot8._effectList) do
			if slot13:GetEffectType() == slot0.FX_TYPE then
				if slot13._cloakExpose > (slot3[slot13._exposeGroup] or 0) then
					slot2 = (slot2 + slot14) - slot16
					slot16 = slot14
				end

				slot3[slot15] = slot16
			end
		end
	end

	slot0:CloakOnFire(slot2)
end

return
