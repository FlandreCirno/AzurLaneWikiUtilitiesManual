ys = ys or {}
ys.Battle.BattleBuffLockHealth = class("BattleBuffLockHealth", ys.Battle.BattleBuffEffect)
ys.Battle.BattleBuffLockHealth.__name = "BattleBuffLockHealth"

ys.Battle.BattleBuffLockHealth.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)
end

ys.Battle.BattleBuffLockHealth.SetArgs = function (slot0, slot1, slot2)
	slot0._rate = slot0._tempData.arg_list.rate
	slot0._threshold = slot0._tempData.arg_list.value
end

ys.Battle.BattleBuffLockHealth.onAttach = function (slot0, slot1, slot2)
	if slot0._rate then
		slot0._threshold = math.floor(slot1:GetMaxHP() * slot0._rate)
	end
end

ys.Battle.BattleBuffLockHealth.onTrigger = function (slot0, slot1, slot2, slot3)
	if slot1:GetCurrentHP() <= slot0._threshold then
		slot3.damage = 0
	elseif slot4 - slot3.damage < slot0._threshold then
		slot3.damage = slot4 - slot0._threshold
	end
end

return
