ys = ys or {}
slot1 = ys.Battle.BattleDataFunction
slot2 = ys.Battle.BattleConst
slot3 = ys.Battle.BattleFormulas
slot4 = ys.Battle.BattleAttr
slot5 = ys.Battle.BattleConfig
slot6 = ys.Battle.BattleUnitEvent
slot7 = class("BattleBossUnit", ys.Battle.BattleEnemyUnit)
ys.Battle.BattleBossUnit = slot7
slot7.__name = "BattleBossUnit"

slot7.Ctor = function (slot0, slot1, slot2)
	slot0.super.Ctor(slot0, slot1, slot2)

	slot0._isBoss = true
end

slot7.IsBoss = function (slot0)
	return true
end

slot7.BarrierStateChange = function (slot0, slot1, slot2)
	slot0:DispatchEvent(slot0.Event.New(slot1.BARRIER_STATE_CHANGE, {
		barrierDurability = slot1,
		barrierDuration = slot2
	}))
end

slot7.UpdateHP = function (slot0, slot1, slot2, slot3, slot4)
	slot0.super.UpdateHP(slot0, slot1, slot2, slot3, slot4)

	if slot1 < 0 then
		for slot8, slot9 in ipairs(slot0._autoWeaponList) do
			slot9:UpdatePrecastArmor(slot1)
		end
	end
end

return
