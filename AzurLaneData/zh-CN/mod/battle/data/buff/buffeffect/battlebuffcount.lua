ys = ys or {}
slot1 = ys.Battle.BattleDataFunction
slot2 = ys.Battle.BattleAttr
slot3 = class("BattleBuffCount", ys.Battle.BattleBuffEffect)
ys.Battle.BattleBuffCount = slot3
slot3.__name = "BattleBuffCount"

slot3.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)
end

slot3.SetArgs = function (slot0, slot1, slot2)
	slot0._countTarget = slot0._tempData.arg_list.countTarget or 1
	slot0._countType = slot0._tempData.arg_list.countType
	slot0._weaponType = slot0._tempData.arg_list.weaponType
	slot0._index = slot0._tempData.arg_list.index
	slot0._gunnerBonus = slot0._tempData.arg_list.gunnerBonus

	slot0:ResetCount()
end

slot3.onTrigger = function (slot0, slot1, slot2)
	slot0.super.onTrigger(slot0, slot1, slot2)

	slot0._count = slot0._count + 1

	if slot0:getCount(slot1) <= slot0._count then
		slot1:TriggerBuff(slot1.Battle.BattleConst.BuffEffectType.ON_BATTLE_BUFF_COUNT, {
			buffFX = slot0
		})
	end
end

slot3.onTakeDamage = function (slot0, slot1, slot2, slot3)
	if slot0:damageAttrRequire(slot3.damageAttr) then
		slot0._count = slot0._count + slot3.damage

		if slot0._countTarget <= slot0._count then
			slot1:TriggerBuff(slot0.Battle.BattleConst.BuffEffectType.ON_BATTLE_BUFF_COUNT, {
				buffFX = slot0
			})
		end
	end
end

slot3.onTakeHealing = function (slot0, slot1, slot2, slot3)
	slot0._count = slot0._count + slot3.damage

	if slot0:getCount(slot1) <= slot0._count then
		slot1:TriggerBuff(slot0.Battle.BattleConst.BuffEffectType.ON_BATTLE_BUFF_COUNT, {
			buffFX = slot0
		})
	end
end

slot3.onStack = function (slot0, slot1, slot2, slot3)
	slot0._count = slot2:GetStack()

	if slot0:getCount(slot1) <= slot0._count then
		slot1:TriggerBuff(slot0.Battle.BattleConst.BuffEffectType.ON_BATTLE_BUFF_COUNT, {
			buffFX = slot0
		})
	end
end

slot3.onBulletHit = function (slot0, slot1, slot2, slot3)
	if not slot0:equipIndexRequire(slot3.equipIndex) then
		return
	end

	slot0._count = slot0._count + slot3.damage

	if slot0:getCount(slot1) <= slot0._count then
		slot1:TriggerBuff(slot0.Battle.BattleConst.BuffEffectType.ON_BATTLE_BUFF_COUNT, {
			buffFX = slot0
		})
	end
end

slot3.getCount = function (slot0, slot1)
	slot2 = slot0._countTarget
	slot3 = slot0.GetCurrent(slot1, "barrageCounterMod")

	if slot0._gunnerBonus then
		slot2 = math.ceil(slot2 / slot3)
	end

	return slot2
end

slot3.GetCountType = function (slot0)
	return slot0._countType
end

slot3.ResetCount = function (slot0)
	slot0._count = 0
end

return
