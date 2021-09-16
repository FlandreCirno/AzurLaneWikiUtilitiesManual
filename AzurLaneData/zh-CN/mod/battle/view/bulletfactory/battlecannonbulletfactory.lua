ys = ys or {}
slot1 = ys.Battle.BattleConst.UnitType
ys.Battle.BattleCannonBulletFactory = singletonClass("BattleCannonBulletFactory", ys.Battle.BattleBulletFactory)
ys.Battle.BattleCannonBulletFactory.__name = "BattleCannonBulletFactory"

ys.Battle.BattleCannonBulletFactory.Ctor = function (slot0)
	slot0.super.Ctor(slot0)
end

ys.Battle.BattleCannonBulletFactory.MakeBullet = function (slot0)
	return slot0.Battle.BattleCannonBullet.New()
end

slot3 = Quaternion.Euler(-90, 0, 0)

ys.Battle.BattleCannonBulletFactory.onBulletHitFunc = function (slot0, slot1, slot2)
	slot3 = slot0.GetDataProxy()
	slot5 = slot0:GetBulletData().GetTemplate(slot4)
	slot6 = nil

	if slot2 == slot1.AIRCRAFT_UNIT or slot2 == slot1.AIRFIGHTER_UNIT then
		slot6 = slot0.GetSceneMediator():GetAircraft(slot1)
	elseif slot2 == slot1.PLAYER_UNIT then
		slot6 = slot0.GetSceneMediator():GetCharacter(slot1)
	elseif slot2 == slot1.ENEMY_UNIT then
		slot6 = slot0.GetSceneMediator():GetCharacter(slot1)
	end

	if not slot6 then
		return
	end

	slot8, slot9 = slot3:HandleDamage(slot4, slot7)
	slot10 = nil

	if slot6:GetGO() then
		if slot8 then
			slot11, slot12 = slot0.GetFXPool():GetFX(slot0:GetMissFXID())
			slot13 = slot6:GetUnitData():GetBoxSize()

			if math.random(0, 1) == 0 then
				slot14 = -1
			end

			pg.EffectMgr.GetInstance():PlayBattleEffect(slot11, Vector3(slot15, 0, slot13.z * slot14):Add(slot6:GetPosition()).Add(slot16, slot12), true)
			slot2.Battle.PlayBattleSFX(slot5.miss_sfx)
		else
			slot2.Battle.PlayBattleSFX(slot5.hit_sfx)

			slot0:GetPosition() - slot6:GetPosition().x = slot0.GetPosition() - slot6.GetPosition().x * slot7:GetDirection()
			slot0.GetPosition() - slot6.GetPosition().y = math.cos(math.deg2Rad * slot3 * slot6:GetTf().localRotation.eulerAngles.x) * slot0.GetPosition() - slot6.GetPosition().z
			slot0.GetPosition() - slot6.GetPosition().z = 0

			slot6:AddFX(slot0:GetFXID()).transform.localPosition:Add((slot0.GetPosition() - slot6.GetPosition()) / slot6:GetInitScale())

			slot6.AddFX(slot0.GetFXID()).transform.localPosition = slot6.AddFX(slot0.GetFXID()).transform.localPosition
		end
	end

	if slot10 and slot7:GetIFF() == slot3:GetFoeCode() then
		slot10.transform.localRotation = Vector3(slot10.transform.localRotation.x, 180, slot10.transform.localRotation.z)
	end

	if slot4:GetPierceCount() <= 0 then
		slot3:RemoveBulletUnit(slot4:GetUniqueID())
	end
end

ys.Battle.BattleCannonBulletFactory.onBulletMissFunc = function (slot0)
	slot1 = slot0:GetBulletData()
	slot7, slot9 = slot0.GetFXPool():GetFX(slot0:GetMissFXID())

	pg.EffectMgr.GetInstance():PlayBattleEffect(slot3, slot4:Add(slot0:GetPosition()), true)
	slot1.Battle.PlayBattleSFX(slot1:GetTemplate().miss_sfx)
end

ys.Battle.BattleCannonBulletFactory.MakeModel = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = slot0:GetDataProxy()
	slot6 = slot1:GetBulletData()

	if not slot0:GetBulletPool():InstBullet(slot1:GetModleID(), function (slot0)
		slot0:AddModel(slot0)
	end) then
		slot1.AddTempModel(slot1, slot0:GetTempGOPool():GetObject())
	end

	slot1:SetSpawn(slot2)
	slot1:SetFXFunc(slot0.onBulletHitFunc, slot0.onBulletMissFunc)
	slot0:GetSceneMediator():AddBullet(slot1)
end

return
