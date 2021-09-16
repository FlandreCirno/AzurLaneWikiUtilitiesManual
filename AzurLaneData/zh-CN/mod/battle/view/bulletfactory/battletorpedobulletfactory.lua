ys = ys or {}
ys.Battle.BattleTorpedoBulletFactory = singletonClass("BattleTorpedoBulletFactory", ys.Battle.BattleBulletFactory)
ys.Battle.BattleTorpedoBulletFactory.__name = "BattleTorpedoBulletFactory"

ys.Battle.BattleTorpedoBulletFactory.Ctor = function (slot0)
	slot0.super.Ctor(slot0)
end

ys.Battle.BattleTorpedoBulletFactory.MakeBullet = function (slot0)
	return slot0.Battle.BattleTorpedoBullet.New()
end

ys.Battle.BattleTorpedoBulletFactory.onBulletHitFunc = function (slot0, slot1, slot2)
	slot6 = slot0.GetDataProxy()
	slot7 = slot0:GetBulletData()

	slot1.Battle.PlayBattleSFX(slot7:GetTemplate().hit_sfx)

	slot10 = nil

	(not slot0:GetBulletData().GetTemplate(slot3).hit_type.range or slot6.SpawnColumnArea(slot6, slot7:GetEffectField(), slot7:GetIFF(), pg.Tool.FilterY(slot0:GetPosition():Clone()), slot5.range, slot5.time, function (slot0)
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

				slot3:HandleDamage(slot4, slot2:GetSceneMediator():GetCharacter(slot7):GetUnitData(), slot8)
			end
		end
	end)) and slot6:SpawnCubeArea(slot7:GetEffectField(), slot7:GetIFF(), pg.Tool.FilterY(slot0:GetPosition():Clone()), slot5.width, slot5.height, slot5.time, function (slot0)
		if slot0.decay then
			slot1.UpdateDistanceInfo()
		end

		for slot5, slot6 in ipairs(slot0) do
			if slot6.Active then
				slot7 = slot6.UID
				slot8 = 0

				if slot1 then
					slot8 = slot1.GetDistance(slot7) / (slot0.range * 0.5) * slot1
				end

				slot3.HandleDamage(slot4, slot2.GetSceneMediator().GetCharacter(slot7).GetUnitData(), slot8)
			end
		end
	end):SetDiveFilter(slot7:GetDiveFilter())

	slot17, slot19 = slot0.GetFXPool():GetFX(slot0:GetFXID())

	pg.EffectMgr.GetInstance():PlayBattleEffect(slot12, slot13:Add(slot0:GetTf().localPosition), true)

	if slot7:GetPierceCount() <= 0 then
		slot6:RemoveBulletUnit(slot7:GetUniqueID())
	end
end

ys.Battle.BattleTorpedoBulletFactory.onBulletMissFunc = function (slot0)
	slot0:onBulletHitFunc()
end

ys.Battle.BattleTorpedoBulletFactory.MakeModel = function (slot0, slot1, slot2)
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
