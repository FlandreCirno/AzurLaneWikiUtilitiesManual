ys = ys or {}
ys.Battle.BattleBombBulletFactory = singletonClass("BattleBombBulletFactory", ys.Battle.BattleBulletFactory)
ys.Battle.BattleBombBulletFactory.__name = "BattleBombBulletFactory"

ys.Battle.BattleBombBulletFactory.Ctor = function (slot0)
	slot0.super.Ctor(slot0)
end

ys.Battle.BattleBombBulletFactory.OutRangeFunc = function (slot0)
	slot1 = slot0:GetTemplate()

	slot0:BuffTrigger(slot1.Battle.BattleConst.BuffEffectType.ON_BOMB_BULLET_BANG, slot5)

	slot6 = nil

	slot0.GetDataProxy().SpawnColumnArea(slot3, slot0:GetEffectField(), slot0:GetIFF(), slot0:GetExplodePostion(), slot1.hit_type.range, slot1.hit_type.time, function (slot0)
		if slot0.decay then
			slot1:UpdateDistanceInfo()
		end

		for slot5, slot6 in ipairs(slot0) do
			if slot6.Active then
				slot7 = slot6.UID
				slot8 = 0

				if slot1 then
					slot8 = slot1:GetDistance(slot7) / (slot0.range * 0.5) * slot1
				end

				slot3:HandleDamage(slot4, slot2.GetSceneMediator():GetCharacter(slot7):GetUnitData(), slot8)
			end
		end
	end):SetDiveFilter(slot0:GetDiveFilter())

	if slot1.extra_param.friendlyFire then
		slot3:SpawnColumnArea(slot0:GetEffectField(), slot3.GetOppoSideCode(slot0:GetIFF()), slot0:GetExplodePostion(), slot2.range, slot2.time, slot7):SetDiveFilter(slot4)
	end

	slot3:RemoveBulletUnit(slot0:GetUniqueID())
end

ys.Battle.BattleBombBulletFactory.MakeBullet = function (slot0)
	return slot0.Battle.BattleBombBullet.New()
end

ys.Battle.BattleBombBulletFactory.onBulletHitFunc = function (slot0, slot1, slot2)
	slot3 = slot0:GetBulletData()

	slot0.Battle.PlayBattleSFX(slot3:GetTemplate().hit_sfx)

	slot10, slot13 = slot1.GetFXPool():GetFX(slot0:GetFXID())

	pg.EffectMgr.GetInstance():PlayBattleEffect(slot5, pg.Tool.FilterY(slot3:GetPosition()).Add(slot7, slot6), true)
end

ys.Battle.BattleBombBulletFactory.onBulletMissFunc = function ()
	return
end

ys.Battle.BattleBombBulletFactory.MakeModel = function (slot0, slot1, slot2)
	slot5, slot6, slot7, slot8 = slot0:GetDataProxy():GetTotalBounds()

	if slot1:GetBulletData().GetExplodePostion(slot3).z > slot5 + 3 then
		slot0:GetDataProxy():RemoveBulletUnit(slot3:GetUniqueID())

		return
	end

	slot9 = slot3:GetTemplate()

	if not slot0:GetBulletPool():InstBullet(slot1:GetModleID(), function (slot0)
		slot0:AddModel(slot0)
	end) then
		slot1.AddTempModel(slot1, slot0:GetTempGOPool():GetObject())
	end

	slot1:SetSpawn(slot2)

	if slot3:GetIFF() ~= slot0:GetDataProxy():GetFriendlyCode() and slot3:GetExist() and slot9.alert_fx ~= "" then
		slot0.CreateBulletAlert(slot3)
	end

	slot3:SetExist(true)
	slot1:SetFXFunc(slot0.onBulletHitFunc, slot0.onBulletMissFunc)
	slot0:GetSceneMediator():AddBullet(slot1)
end

ys.Battle.BattleBombBulletFactory.CreateBulletAlert = function (slot0)
	slot1 = slot0:GetTemplate().hit_type.range
	slot4 = slot0.Battle.BattleFXPool.GetInstance():GetFX(slot2).transform
	slot5 = 0

	if pg.effect_offset[slot0:GetTemplate().alert_fx] and slot6[slot2].y_scale == true then
		slot5 = slot1
	end

	slot4.localScale = Vector3(slot1, slot5, slot1)

	pg.EffectMgr.GetInstance():PlayBattleEffect(slot3, slot0:GetExplodePostion())
end

return
