ys = ys or {}
ys.Battle.BattleWeaponRangeSector = class("BattleWeaponRangeSector")
ys.Battle.BattleWeaponRangeSector.__name = "BattleWeaponRangeSector"

ys.Battle.BattleWeaponRangeSector.Ctor = function (slot0, slot1)
	slot0._tf = slot1

	setActive(slot0._tf, true)
	slot0:initSector()
end

ys.Battle.BattleWeaponRangeSector.ConfigHost = function (slot0, slot1, slot2)
	slot0._host = slot1
	slot0._weapon = slot2

	slot0:updateSector(slot0._weapon)
end

ys.Battle.BattleWeaponRangeSector.initSector = function (slot0)
	slot0._minRange = slot0._tf:Find("minSector")
	slot0._minSector = slot0._minRange:Find("sector"):GetComponent(typeof(Renderer)).material
	slot0._maxRange = slot0._tf:Find("maxSector")
	slot0._maxSector = slot0._maxRange:Find("sector"):GetComponent(typeof(Renderer)).material
end

ys.Battle.BattleWeaponRangeSector.updateSector = function (slot0, slot1)
	slot0._maxRange.localScale = Vector3(slot3, 1, slot3)
	slot0._minRange.localScale = Vector3(slot4, 1, slot1._minRangeSqr * 2)

	slot0._maxSector:SetInt("_Angle", slot2)
	slot0._minSector:SetInt("_Angle", slot1:GetAttackAngle())
end

ys.Battle.BattleWeaponRangeSector.Dispose = function (slot0)
	print("ttt")
	Destroy(slot0._tf)

	slot0._host = nil
	slot0._weapon = nil
end

return
