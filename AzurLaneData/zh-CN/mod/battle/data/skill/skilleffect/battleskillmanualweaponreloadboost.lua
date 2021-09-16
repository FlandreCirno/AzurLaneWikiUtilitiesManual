ys = ys or {}
slot1 = class("BattleSkillManualWeaponReloadBoost", ys.Battle.BattleSkillEffect)
ys.Battle.BattleSkillManualWeaponReloadBoost = slot1
slot1.__name = "BattleSkillManualWeaponReloadBoost"

slot1.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1, lv)

	slot0._weaponType = slot0._tempData.arg_list.weaponType
	slot0._boostValue = slot0._tempData.arg_list.value * -1
end

slot1.DoDataEffect = function (slot0, slot1, slot2)
	for slot7, slot8 in ipairs(slot3) do
		slot8:AppendReloadBoost(slot0._boostValue)
	end
end

slot1.DoDataEffectWithoutTarget = function (slot0, slot1)
	slot0:DoDataEffect(slot1, nil)
end

slot1._GetWeapon = function (slot0, slot1)
	slot2 = {}

	if slot0._weaponType == "ChargeWeapon" then
		slot2 = slot1:GetChargeQueue()
	elseif slot0._weaponType == "TorpedoWeapon" then
		slot2 = slot1:GetTorpedoQueue()
	elseif slot0._weaponType == "AirAssist" then
		slot2 = slot1:GetAirAssistQueue()
	end

	return slot2:GetCoolDownList()
end

return
