ys = ys or {}
slot1 = class("BattleBuffRegisterWaveFlags", ys.Battle.BattleBuffEffect)
slot1.__name = "BattleBuffRegisterWaveFlags"
ys.Battle.BattleBuffRegisterWaveFlags = slot1

slot1.SetArgs = function (slot0, slot1, slot2)
	slot0._flags = slot0._tempData.arg_list.flags
end

slot1.onTrigger = function (slot0, slot1, slot2, slot3)
	slot0.super.onTrigger(slot0, slot1, slot2, slot3)

	slot4 = slot1.Battle.BattleDataProxy.GetInstance()

	for slot8, slot9 in ipairs(slot0._flags) do
		slot4:AddWaveFlag(slot9)
	end
end

return
