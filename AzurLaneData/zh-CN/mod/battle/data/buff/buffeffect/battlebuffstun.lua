ys = ys or {}
ys.Battle.BattleBuffStun = class("BattleBuffStun", ys.Battle.BattleBuffEffect)
ys.Battle.BattleBuffStun.__name = "BattleBuffStun"

ys.Battle.BattleBuffStun.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)
end

ys.Battle.BattleBuffStun.SetArgs = function (slot0, slot1, slot2)
	slot3 = slot0._tempData.arg_list
end

ys.Battle.BattleBuffStun.onAttach = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffStun.onUpdate = function (slot0, slot1, slot2)
	slot0:onTrigger(slot1, slot2)
end

ys.Battle.BattleBuffStun.onTrigger = function (slot0, slot1, slot2)
	slot0.super.onTrigger(slot0, slot1, slot2)
	slot1.Battle.BattleAttr.Stun(slot1)
	slot1:UpdateMoveLimit()
end

ys.Battle.BattleBuffStun.onRemove = function (slot0, slot1, slot2)
	slot0.Battle.BattleAttr.CancelStun(slot1)
	slot1:UpdateMoveLimit()
end

return
