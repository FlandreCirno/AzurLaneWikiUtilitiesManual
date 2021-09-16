ys = ys or {}
slot1 = ys.Battle.BattleConst
ys.Battle.BattleShrapnelBulletFactory = singletonClass("BattleShrapnelBulletFactory", ys.Battle.BattleBulletFactory)
ys.Battle.BattleShrapnelBulletFactory.__name = "BattleShrapnelBulletFactory"
ys.Battle.BattleShrapnelBulletFactory.INHERIT_NONE = 0
ys.Battle.BattleShrapnelBulletFactory.INHERIT_ANGLE = 1
ys.Battle.BattleShrapnelBulletFactory.INHERIT_SPEED_NORMALIZE = 2

ys.Battle.BattleShrapnelBulletFactory.Ctor = function (slot0)
	slot0.super.Ctor(slot0)
end

ys.Battle.BattleShrapnelBulletFactory.MakeBullet = function (slot0)
	return slot0.Battle.BattleShrapnelBullet.New()
end

ys.Battle.BattleShrapnelBulletFactory.CreateBullet = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot2:SetOutRangeCallback(slot0.OutRangeFunc)

	slot6 = slot0:MakeBullet()

	slot6:SetFactory(slot0)
	slot6:SetBulletData(slot2)
	slot0:MakeModel(slot6, slot3, slot4, slot5)

	if slot4 and slot4 ~= "" then
		slot0:PlayFireFX(slot1, slot2, slot3, slot4, slot5, nil)
	end

	slot0.bulletSplit(slot6)

	return slot6
end

ys.Battle.BattleShrapnelBulletFactory.onBulletHitFunc = function (slot0, slot1, slot2)
	slot3 = slot0.GetDataProxy()
	slot4 = slot0:GetBulletData()
	slot5 = slot4:GetCurrentState()
	slot7 = slot4:GetTemplate().extra_param.shrapnel

	if slot4.GetTemplate().extra_param.fragile and slot1 then
		slot1.Battle.BattleCannonBulletFactory.onBulletHitFunc(slot0, slot1, slot2)

		return
	end

	if slot5 ~= slot4.STATE_SPLIT then
		if slot5 == slot4.STATE_SPIN then
		elseif slot5 == slot4.STATE_FINAL_SPLIT then
			return
		elseif slot4:GetPierceCount() > 0 then
			slot1.Battle.BattleCannonBulletFactory.onBulletHitFunc(slot0, slot1, slot2)

			return
		end
	end

	if slot1 ~= nil and slot2 ~= nil then
		slot9 = nil

		if slot2 == slot1.Battle.BattleConst.UnitType.AIRCRAFT_UNIT then
			slot9 = slot0.GetSceneMediator():GetAircraft(slot1)
		elseif slot2 == slot1.Battle.BattleConst.UnitType.PLAYER_UNIT then
			slot9 = slot0.GetSceneMediator():GetCharacter(slot1)
		elseif slot2 == slot1.Battle.BattleConst.UnitType.ENEMY_UNIT then
			slot9 = slot0.GetSceneMediator():GetCharacter(slot1)
		end

		slot11 = slot9:AddFX(slot0:GetFXID())

		if slot9:GetUnitData().GetIFF(slot10) == slot3:GetFoeCode() then
			slot11.transform.localRotation = Vector3(slot11.transform.localRotation.x, 180, slot11.transform.localRotation.z)
		end
	end

	slot1.Battle.PlayBattleSFX(slot6.hit_sfx)
	slot0:bulletSplit(true)
end

ys.Battle.BattleShrapnelBulletFactory.bulletSplit = function (slot0, slot1)
	slot2 = slot0:GetBulletData()
	slot3 = slot0.GetDataProxy()
	slot5 = slot2:GetTemplate().extra_param.shrapnel
	slot6 = slot2:GetSrcHost()
	slot7 = slot2:GetWeapon()

	if slot2.GetTemplate().extra_param.FXID ~= nil then
		slot12, slot14 = slot0.GetFXPool():GetFX(slot4.extra_param.FXID)

		pg.EffectMgr.GetInstance():PlayBattleEffect(slot8, slot9:Add(slot0:GetPosition()), true)
	end

	slot8 = nil
	slot8 = (slot2:GetSpeed().x <= 0 or 0) and 180

	for slot12, slot13 in ipairs(slot5) do
		if slot1 ~= slot13.initialSplit then
			slot15 = slot13.bullet_ID
			slot17 = slot13.inheritAngle
			slot18 = slot13.reaim

			function slot19(slot0, slot1, slot2, slot3)
				slot4 = slot0:CreateBulletUnit(slot1, slot2, slot3, Vector3.zero)

				slot4:OverrideCorrectedDMG(slot4.damage)
				slot4:SetOffsetPriority(slot3)
				slot4:SetShiftInfo(slot0, slot1)

				slot5 = slot4.SetShiftInfo

				if slot4 == slot0.INHERIT_ANGLE then
					slot5 = slot8:GetYAngle()
				elseif slot6 == slot7.INHERIT_SPEED_NORMALIZE then
					slot5 = slot8:GetCurrentYAngle()
				end

				if slot9 then
					if slot10.Battle.BattleTargetChoise.TargetHarmNearest(slot8)[1] == nil then
						slot4:SetRotateInfo(nil, slot5, slot2)
					else
						slot4:SetRotateInfo(slot6:GetBeenAimedPosition(), slot5, slot2)
					end
				else
					slot4:SetRotateInfo(nil, slot5, slot2)
				end

				slot7.GetFactoryList()[slot4:GetTemplate().type]:CreateBullet(slot11:GetTf(), slot4, slot11:GetPosition())
			end

			slot2:CacheChildEimtter(nil)
			slot1.Battle[slot13.emitterType or slot1.Battle.BattleWeaponUnit.EMITTER_SHOTGUN].New(slot19, slot21, slot13.barrage_ID).Ready(nil)
			slot1.Battle[slot13.emitterType or slot1.Battle.BattleWeaponUnit.EMITTER_SHOTGUN].New(slot19, slot21, slot13.barrage_ID):Fire(nil, slot7:GetDirection(), slot1.Battle.BattleDataFunction.GetBarrageTmpDataFromID(slot13.barrage_ID).angle)
		end
	end

	if slot1 then
		slot2:ChangeShrapnelState(slot1.Battle.BattleShrapnelBulletUnit.STATE_FINAL_SPLIT)
	end
end

ys.Battle.BattleShrapnelBulletFactory.onBulletMissFunc = function (slot0)
	return
end

ys.Battle.BattleShrapnelBulletFactory.MakeModel = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = slot1:GetBulletData()

	if not slot0:GetBulletPool():InstBullet(slot1:GetModleID(), function (slot0)
		slot0:AddModel(slot0)
	end) then
		slot1.AddTempModel(slot1, slot0:GetTempGOPool():GetObject())
	end

	slot1:SetSpawn(slot2)
	slot1:SetFXFunc(slot0.onBulletHitFunc, slot0.onBulletMissFunc)
	slot0:GetSceneMediator():AddBullet(slot1)
end

ys.Battle.BattleShrapnelBulletFactory.OutRangeFunc = function (slot0)
	if slot0:IsOutRange() then
		slot0:ChangeShrapnelState(slot0.Battle.BattleShrapnelBulletUnit.STATE_SPIN)
	else
		slot0:ChangeShrapnelState(slot0.Battle.BattleShrapnelBulletUnit.STATE_SPLIT)
	end
end

return
