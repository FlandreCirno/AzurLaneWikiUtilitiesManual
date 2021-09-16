ys = ys or {}
slot1 = ys.Battle.BattleConst
slot2 = ys.Battle.BattleConfig
slot3 = ys.Battle.BattleFormulas
slot4 = ys.Battle.BattleDataFunction
slot5 = class("BattleSpaceLaserWeaponUnit", ys.Battle.BattleWeaponUnit)
ys.Battle.BattleSpaceLaserWeaponUnit = slot5
slot5.__name = "BattleSpaceLaserWeaponUnit"

slot5.createMajorEmitter = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot6, slot7, slot8 = nil
	slot9 = 0

	function slot10(slot0, slot1, slot2, slot3, slot4)
		slot6 = slot0:Spawn(slot5, slot4, slot2.INTERNAL)

		slot6:SetOffsetPriority(slot3 + 1)
		slot6:SetShiftInfo(slot0, slot1)
		slot6:setTrackingTarget((slot0._tmpData.aim_type == slot4.WeaponAimType.AIM and slot4) or nil)
		slot6:SetYAngle(slot5)
		slot6:SetLifeTime(slot6:GetTemplate().extra_param.attack_time)
		slot6:RegisterLifeEndCB(function ()
			if slot0 - 1 > 0 then
				return
			end

			for slot3, slot4 in ipairs(slot1._majorEmitterList) do
				if slot4:GetState() ~= slot4.STATE_STOP then
					return
				end
			end

			slot1:EnterCoolDown()
		end)
		slot6:SetRotateInfo(slot6 or (((slot0._tmpData.aim_type == slot4.WeaponAimType.AIM and slot4) or nil) and pg.Tool.FilterY((slot0._tmpData.aim_type == slot4.WeaponAimType.AIM and slot4) or nil.GetCLDZCenterPosition(slot4))), slot0:GetBaseAngle(), slot2)
		slot0:DispatchBulletEvent(slot6, slot6 or (((slot0._tmpData.aim_type == slot4.WeaponAimType.AIM and slot4) or nil) and pg.Tool.FilterY((slot0._tmpData.aim_type == slot4.WeaponAimType.AIM and slot4) or nil.GetCLDZCenterPosition(slot4))) or )

		return slot6
	end

	return slot0.super.createMajorEmitter(slot0, slot1, slot2, slot3, (slot2.GetBulletTmpDataFromID(slot0._emitBulletIDList[slot2]).extra_param.aim_time and slot12 > 0 and function (slot0, slot1, slot2, slot3, slot4)
		slot6 = slot0:Spawn(slot5, slot4, slot2.INTERNAL)

		slot6:setTrackingTarget((slot0._tmpData.aim_type == slot4.WeaponAimType.AIM and slot4) or nil)
		slot6:SetOffsetPriority(slot3 + 1)
		slot6:SetShiftInfo(slot0, slot1)
		slot6:SetLifeTime(slot6:GetTemplate().extra_param.aim_time)
		slot6:SetAlert(true)
		slot6:RegisterLifeEndCB(function ()
			slot0 = slot0 - 1
			slot2 = Vector3(slot3, 0, slot4)
			slot1 = pg.Tool.FilterY(slot2:GetPosition() - slot2)
			slot5 = slot2:GetYAngle()
			slot6 = slot2:GetRotateInfo()

			slot7(slot3, 0, slot8, slot9, slot10)
		end)

		if slot6.GetTemplate(slot6).alert_fx and #slot7 > 0 then
			slot6:SetModleID(slot7)
		end

		slot6:SetRotateInfo(slot4 and pg.Tool.FilterY(slot4:GetCLDZCenterPosition()), slot0:GetBaseAngle(), slot2)
		slot0:DispatchBulletEvent(slot6, slot4 and pg.Tool.FilterY(slot4.GetCLDZCenterPosition()))

		return slot6
	end) or slot10, function ()
		return
	end)
end

return
