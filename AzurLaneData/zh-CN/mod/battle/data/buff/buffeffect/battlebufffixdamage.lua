ys = ys or {}
ys.Battle.BattleBuffFixDamage = class("BattleBuffFixDamage", ys.Battle.BattleBuffEffect)
ys.Battle.BattleBuffFixDamage.__name = "BattleBuffFixDamage"

ys.Battle.BattleBuffFixDamage.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)
end

ys.Battle.BattleBuffFixDamage.SetArgs = function (slot0, slot1, slot2)
	slot0._rant = slot0._tempData.arg_list.rant or 10000
	slot0._value = slot0._tempData.arg_list.value
	slot0._rate = slot0._tempData.arg_list.rate
end

ys.Battle.BattleBuffFixDamage.onTrigger = function (slot0, slot1, slot2, slot3)
	if not slot0.Battle.BattleFormulas.IsHappen(slot0._rant) then
		return "chance"
	end

	slot4 = slot3.damage

	if slot0._rate then
		slot3.damage = math.max(1, slot4 * slot0._rate)
	elseif slot0._value < slot4 then
		slot3.damage = slot0._value
	end
end

return
