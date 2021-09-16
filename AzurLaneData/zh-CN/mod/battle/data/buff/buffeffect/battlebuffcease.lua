ys = ys or {}
slot1 = class("BattleBuffCease", ys.Battle.BattleBuffEffect)
ys.Battle.BattleBuffCease = slot1
slot1.__name = "BattleBuffCease"

slot1.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)
end

slot1.onAttach = function (slot0, slot1, slot2)
	slot1:CeaseAllWeapon(true)
end

slot1.onRemove = function (slot0, slot1, slot2)
	slot1:CeaseAllWeapon(false)
end

return
