ys = ys or {}
slot1 = ys.Battle.BattleDataFunction
slot2 = ys.Battle.BattleConst
slot3 = ys.Battle.BattleConfig
slot4 = class("BattleLaserUnit", ys.Battle.BattleWeaponUnit)
ys.Battle.BattleLaserUnit = slot4
slot4.__name = "BattleLaserUnit"
slot4.STATE_ATTACK = "FIB"
slot4.BEAM_STATE_READY = "beamStateReady"
slot4.BEAM_STATE_OVER_HEAT = "beamStateOverHeat"

slot4.Ctor = function (slot0)
	slot0.super.Ctor(slot0)
end

slot4.Clear = function (slot0)
	if slot0._alertTimer then
		pg.TimeMgr.GetInstance():RemoveBattleTimer(slot0._alertTimer)
	end

	slot0._alertTimer = nil

	for slot4, slot5 in ipairs(slot0._beamList) do
		if slot5:GetBeamState() == slot5.BEAM_STATE_ATTACK then
			slot0._dataProxy:RemoveAreaOfEffect(slot5:GetAoeData():GetUniqueID())
		end

		slot5:ClearBeam()
	end

	slot0.super.Clear(slot0)
end

slot4.Update = function (slot0)
	slot0:UpdateReload()

	if slot0._currentState == slot0.STATE_READY then
		slot0:updateMovementInfo()

		if slot0:Tracking() then
			if slot0._preCastInfo.time ~= nil then
				slot0:PreCast(slot1)
			else
				slot0._currentState = slot0.STATE_PRECAST_FINISH
			end
		end
	end

	if slot0._currentState == slot0.STATE_PRECAST then
	elseif slot0._currentState == slot0.STATE_PRECAST_FINISH then
		slot0:updateMovementInfo()
		slot0:Fire(slot0:Tracking())
	end

	if slot0._attackStartTime then
		slot0:updateMovementInfo()
		slot0:updateBeamList()
	end
end

slot4.DoAttack = function (slot0, slot1)
	if slot1 == nil or not slot1:IsAlive() or slot0:outOfFireRange(slot1) then
		slot1 = nil
	end

	slot0._attackStartTime = pg.TimeMgr.GetInstance():GetCombatTime()

	if slot0._tmpData.aim_type == slot0.WeaponAimType.AIM and slot1 ~= nil then
		slot0._aimPos = slot1:GetBeenAimedPosition()
	end

	slot0:cacheBulletID()

	for slot5, slot6 in ipairs(slot0._beamList) do
		slot6:ChangeBeamState(slot6.BEAM_STATE_READY)

		if slot1.GetBarrageTmpDataFromID(slot6:GetBeamInfoID()).first_delay == 0 then
			slot0:createBeam(slot6)
		end
	end

	slot2.Battle.PlayBattleSFX(slot0._tmpData.fire_sfx)
	slot0:TriggerBuffOnFire()
	slot0:CheckAndShake()
end

slot4.SetTemplateData = function (slot0, slot1)
	slot0.super.SetTemplateData(slot0, slot1)
	slot0:initBeamList()
end

slot4.initBeamList = function (slot0)
	slot1 = slot0._tmpData.barrage_ID
	slot0._alertList = {}
	slot0._beamList = {}

	for slot6, slot7 in ipairs(slot2) do
		slot0._beamList[slot6] = slot0.Battle.BattleBeamUnit.New(slot7, slot1[slot6])
	end
end

slot4.updateBeamList = function (slot0)
	slot1 = pg.TimeMgr.GetInstance():GetCombatTime() - slot0._attackStartTime
	slot2 = 0

	for slot6, slot7 in ipairs(slot0._beamList) do
		if slot7:GetBeamState() == slot7.BEAM_STATE_READY then
			if slot0.GetBarrageTmpDataFromID(slot7:GetBeamInfoID()).first_delay < slot1 then
				slot0:createBeam(slot7)
			end
		elseif slot7:GetBeamState() == slot7.BEAM_STATE_ATTACK then
			if not slot7:IsBeamActive() then
				slot7:ClearBeam()

				slot2 = slot2 + 1
			else
				slot7:UpdateBeamPos(slot0._hostPos)
				slot7:UpdateBeamAngle()

				if slot7:CanDealDamage() then
					slot0:doBeamDamage(slot7)
				end
			end
		elseif slot7:GetBeamState() == slot7.BEAM_STATE_FINISH then
			slot2 = slot2 + 1
		end
	end

	if slot2 == #slot0._beamList then
		slot0:EnterCoolDown()
	end
end

slot4.createBeam = function (slot0, slot1)
	slot4 = slot0.GetBarrageTmpDataFromID(slot1.GetBeamInfoID(slot1))
	slot13 = slot0._dataProxy:SpawnLastingCubeArea(slot1.AOEField.SURFACE, slot0._host:GetIFF(), Vector3(slot0._hostPos.x + slot4.offset_x, 0, slot0._hostPos.z + slot4.offset_z), slot4.delta_offset_x, slot4.delta_offset_z, slot4.delay, function (slot0)
		for slot4, slot5 in ipairs(slot0) do
			if slot5.Active then
				slot1:AddCldUnit(slot0._dataProxy:GetUnitList()[slot5.UID])
			end
		end
	end, function (slot0)
		if slot0.Active then
			slot1:RemoveCldUnit(slot0._dataProxy:GetUnitList()[slot0.UID])
		end
	end, false, slot0.GetBulletTmpDataFromID(slot1:GetBulletID()).modle_ID)

	if slot0._aimPos == nil then
		slot1:SetAimAngle(0)
	elseif slot4.offset_prioritise then
		slot1:SetAimPosition(slot0._aimPos, slot12)
	else
		slot1:SetAimAngle(math.rad2Deg * math.atan2(slot0._hostPos.z - slot0._aimPos.z, slot0._hostPos.x - slot0._aimPos.x))
	end

	if slot11 == slot2.FRIENDLY_CODE then
		slot13:SetAnchorPointAlignment(slot13.ALIGNMENT_LEFT)
	elseif slot11 == slot2.FOE_CODE then
		slot13:SetAnchorPointAlignment(slot13.ALIGNMENT_RIGHT)
	end

	slot13:SetFXStatic(true)
	slot1:SetAoeData(slot13)
	slot1:BeginFocus()
	slot1:ChangeBeamState(slot1.BEAM_STATE_ATTACK)
end

slot4.doBeamDamage = function (slot0, slot1)
	slot1:DealDamage()

	slot2 = slot0:Spawn(slot1:GetBulletID())

	for slot7, slot8 in pairs(slot3) do
		if slot8:IsAlive() then
			slot0._dataProxy:HandleDamage(slot2, slot8)

			slot13, slot15 = slot0.Battle.BattleFXPool.GetInstance():GetFX(slot1:GetFXID())

			pg.EffectMgr.GetInstance():PlayBattleEffect(slot9, slot10:Add(slot8:GetPosition()), true)
			slot0.Battle.PlayBattleSFX(slot1:GetSFXID())
		end
	end
end

slot4.EnterCoolDown = function (slot0)
	slot0._attackStartTime = nil

	slot0.super.EnterCoolDown(slot0)
end

return
