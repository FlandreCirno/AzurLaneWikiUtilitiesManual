ys = ys or {}
slot1 = ys.Battle.BattleConst
slot2 = class("BattleTriggerAOEData", ys.Battle.BattleAOEData)
ys.Battle.BattleTriggerAOEData = slot2
slot2.__name = "BattleTriggerAOEData"

slot2.Ctor = function (slot0, slot1, slot2, slot3)
	slot0.super.Ctor(slot0, slot1, slot2, slot3)
end

slot2.Settle = function (slot0)
	if #slot0._cldObjList > 0 then
		slot0.SortCldObjList(slot0._cldObjList)
		slot0._cldComponent:GetCldData().func(slot0._cldObjList)

		slot0._flag = false
	end
end

return
