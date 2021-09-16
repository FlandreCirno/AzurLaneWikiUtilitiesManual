ys = ys or {}
slot1 = ys.Battle.BattleDataFunction
slot2 = class("BattleSkillFire", ys.Battle.BattleSkillEffect)
ys.Battle.BattleSkillFire = slot2
slot2.__name = "BattleSkillFire"

slot2.Ctor = function (slot0, slot1, slot2)
	slot0.super.Ctor(slot0, slot1, slot2)

	slot0._weaponID = slot0._tempData.arg_list.weapon_id
	slot0._emitter = slot0._tempData.arg_list.emitter
	slot0._useSkin = slot0._tempData.arg_list.useSkin
end

slot2.SetWeaponSkin = function (slot0, slot1)
	slot0._modelID = slot1
end

slot2.DoDataEffect = function (slot0, slot1, slot2)
	if slot0._weapon == nil then
		slot0._weapon = slot0.Battle.BattleDataFunction.CreateWeaponUnit(slot0._weaponID, slot1)

		if BATTLE_DEBUG and slot0._weapon:GetType() == slot0.Battle.BattleConst.EquipmentType.SCOUT then
			slot0._weapon:GetATKAircraftList()
		end

		if slot0._modelID then
			slot0._weapon:SetModelID(slot0._modelID)
		elseif slot0._useSkin and slot1:GetPriorityWeaponSkin() then
			slot0._weapon:SetModelID(slot1.GetEquipSkin(slot3))
		end

		slot1:DispatchEvent(slot0.Event.New(slot0.Battle.BattleUnitEvent.CREATE_TEMPORARY_WEAPON, slot3))
	end

	slot0._weapon.updateMovementInfo(slot4)
	slot0._weapon:SingleFire(slot2, slot0._emitter, function ()
		slot0._weapon:Clear()
	end)
end

slot2.DoDataEffectWithoutTarget = function (slot0, slot1)
	slot0:DoDataEffect(slot1)
end

slot2.Clear = function (slot0)
	slot0.super.Clear(slot0)

	if slot0._weapon and not slot0._weapon:GetHost():IsAlive() then
		slot0._weapon:Clear()
	end
end

slot2.Interrupt = function (slot0)
	slot0.super.Interrupt(slot0)

	if slot0._weapon then
		slot0._weapon:Cease()
		slot0._weapon:Clear()
	end
end

slot2.GetDamageSum = function (slot0)
	slot1 = 0

	if not slot0._weapon then
		slot1 = 0
	elseif slot0._weapon:GetType() == slot0.Battle.BattleConst.EquipmentType.SCOUT then
		for slot5, slot6 in ipairs(slot0._weapon:GetATKAircraftList()) do
			for slot11, slot12 in ipairs(slot7) do
				slot1 = slot1 + slot12:GetDamageSUM()
			end
		end
	else
		slot1 = slot0._weapon:GetDamageSUM()
	end

	return slot1
end

return
