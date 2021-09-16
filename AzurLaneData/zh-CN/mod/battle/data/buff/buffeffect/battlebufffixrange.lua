ys = ys or {}
ys.Battle.BattleBuffFixRange = class("BattleBuffFixRange", ys.Battle.BattleBuffEffect)
ys.Battle.BattleBuffFixRange.__name = "BattleBuffFixRange"

ys.Battle.BattleBuffFixRange.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)
end

ys.Battle.BattleBuffFixRange.SetArgs = function (slot0, slot1, slot2)
	slot0._weaponRange = slot0._tempData.arg_list.weaponRange
	slot0._bulletRange = slot0._tempData.arg_list.bulletRange
	slot0._minRange = slot0._tempData.arg_list.minRange
	slot0._bulletRangeOffset = slot0._tempData.arg_list.bulletRangeOffset
end

ys.Battle.BattleBuffFixRange.onAttach = function (slot0, slot1)
	if slot0._weaponRange or slot0._bulletRange or slot0._bulletRangeOffset then
		slot0:updateBulletRange(slot1, slot0._weaponRange, slot0._bulletRange, slot0._minRange, slot0._bulletRangeOffset)
	end
end

ys.Battle.BattleBuffFixRange.onRemove = function (slot0, slot1)
	slot0:updateBulletRange(slot1)
end

ys.Battle.BattleBuffFixRange.updateBulletRange = function (slot0, slot1, slot2, slot3, slot4, slot5)
	for slot10, slot11 in ipairs(slot6) do
		slot12 = slot11:GetEquipmentIndex()

		if slot0._indexRequire == nil or table.contains(slot0._indexRequire, slot12) then
			slot11:FixWeaponRange(slot2, slot3, slot4, slot5)
		end
	end
end

return
