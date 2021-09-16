ys = ys or {}
slot1 = ys.Battle.BattleConst.UnitType
ys.Battle.BattleAAMissileFactory = singletonClass("BattleAAMissileFactory", ys.Battle.BattleBulletFactory)
ys.Battle.BattleAAMissileFactory.__name = "BattleAAMissileFactory"

ys.Battle.BattleAAMissileFactory.MakeBullet = function (slot0)
	return slot0.Battle.BattleTorpedoBullet.New()
end

ys.Battle.BattleAAMissileFactory.onBulletHitFunc = function (slot0, slot1, slot2)
	slot4 = slot0:GetBulletData().GetTemplate(slot3)
	slot5 = slot0.GetDataProxy()
	slot6 = nil

	if slot2 == slot1.AIRCRAFT_UNIT or slot2 == slot1.AIRFIGHTER_UNIT then
		slot6 = slot0.GetSceneMediator():GetAircraft(slot1):GetUnitData()
	elseif slot2 == slot1.PLAYER_UNIT then
		slot6 = slot0.GetSceneMediator():GetCharacter(slot1):GetUnitData()
	elseif slot2 == slot1.ENEMY_UNIT then
		slot6 = slot0.GetSceneMediator():GetCharacter(slot1):GetUnitData()
	end

	slot7 = slot3:getTrackingTarget()

	if not slot6 or not slot7 or slot7 == -1 or slot6:GetUniqueID() ~= slot7:GetUniqueID() then
		return
	end

	slot2.Battle.PlayBattleSFX(slot4.hit_sfx)

	slot8, slot9 = slot5:HandleDamage(slot3, slot6)
	slot15, slot17 = slot0.GetFXPool():GetFX(slot0:GetFXID())

	pg.EffectMgr.GetInstance():PlayBattleEffect(slot10, slot11:Add(slot0:GetTf().localPosition), true)

	if slot3:GetPierceCount() <= 0 then
		slot3:CleanAimMark()
		slot5:RemoveBulletUnit(slot3:GetUniqueID())
	end
end

ys.Battle.BattleAAMissileFactory.onBulletMissFunc = function (slot0)
	slot0:onBulletHitFunc()
end

ys.Battle.BattleAAMissileFactory.MakeModel = function (slot0, slot1, slot2)
	slot4 = slot1:GetBulletData().GetTemplate(slot3)
	slot5 = slot0:GetDataProxy()

	if not slot0:GetBulletPool():InstBullet(slot1:GetModleID(), function (slot0)
		slot0:AddModel(slot0)
	end) then
		slot1.AddTempModel(slot1, slot0:GetTempGOPool():GetObject())
	end

	slot1:SetSpawn(slot2)
	slot1:SetFXFunc(slot0.onBulletHitFunc, slot0.onBulletMissFunc)
	slot0:GetSceneMediator():AddBullet(slot1)

	if slot3:GetIFF() ~= slot5:GetFriendlyCode() and slot4.alert_fx ~= "" then
		slot1:MakeAlert(slot0:GetFXPool():GetFX(slot4.alert_fx))
	end
end

return
