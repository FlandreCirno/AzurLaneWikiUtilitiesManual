ys = ys or {}
ys.Battle.BattleFleetBuffJam = class("BattleFleetBuffJam", ys.Battle.BattleFleetBuffEffect)
ys.Battle.BattleFleetBuffJam.__name = "BattleFleetBuffJam"

ys.Battle.BattleFleetBuffJam.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)
end

ys.Battle.BattleFleetBuffJam.onAttach = function (slot0, slot1, slot2)
	slot0.Battle.BattleDataProxy.GetInstance().JamManualCast(slot3, true)
	slot1:Jamming(true)
	slot1:SetWeaponBlock(1)
end

ys.Battle.BattleFleetBuffJam.onRemove = function (slot0, slot1, slot2)
	slot0.Battle.BattleDataProxy.GetInstance().JamManualCast(slot3, false)
	slot1:Jamming(false)
	slot1:SetWeaponBlock(-1)
end

return
