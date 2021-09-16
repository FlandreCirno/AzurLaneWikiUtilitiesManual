ys = ys or {}
ys.Battle.BattleBuffShiftBarrage = class("BattleBuffShiftBarrage", ys.Battle.BattleBuffEffect)
ys.Battle.BattleBuffShiftBarrage.__name = "BattleBuffShiftBarrage"

ys.Battle.BattleBuffShiftBarrage.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)
end

ys.Battle.BattleBuffShiftBarrage.SetArgs = function (slot0, slot1, slot2)
	slot0._barrageID = slot0._tempData.arg_list.barrage_id
end

ys.Battle.BattleBuffShiftBarrage.onAttach = function (slot0, slot1, slot2)
	slot0:shiftBarrage(slot1, slot0._barrageID)
end

ys.Battle.BattleBuffShiftBarrage.onRemove = function (slot0, slot1, slot2)
	slot0:shiftBarrage(slot1)
end

ys.Battle.BattleBuffShiftBarrage.shiftBarrage = function (slot0, slot1, slot2)
	slot3 = slot1:GetAllWeapon()

	for slot7, slot8 in ipairs(slot0._indexRequire) do
		for slot12, slot13 in ipairs(slot3) do
			if slot13:GetEquipmentIndex() == slot8 then
				if slot2 then
					slot13:ShiftBarrage(slot2)
				else
					slot13:RevertBarrage()
				end
			end
		end
	end
end

return
