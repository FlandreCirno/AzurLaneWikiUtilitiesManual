ys = ys or {}
ys.Battle.BattleTriggerBulletFactory = singletonClass("BattleTriggerBulletFactory", ys.Battle.BattleBombBulletFactory)
ys.Battle.BattleTriggerBulletFactory.__name = "BattleTriggerBulletFactory"

ys.Battle.BattleTriggerBulletFactory.Ctor = function (slot0)
	slot0.super.Ctor(slot0)
end

ys.Battle.BattleTriggerBulletFactory.OutRangeFunc = function (slot0)
	slot3 = slot0:GetTemplate().extra_param.multy or 1
	slot4 = slot0.GetDataProxy()

	slot4.SpawnTriggerColumnArea(slot4, slot0:GetEffectField(), slot0:GetIFF(), slot0:GetExplodePostion(), slot0.GetTemplate().hit_type.range, slot0.GetTemplate().hit_type.time, false, slot1.miss_fx, function (slot0)
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

				slot9 = slot2.GetSceneMediator():GetCharacter(slot7):GetUnitData()
				slot10 = 0

				while slot9:IsAlive() and slot10 < slot3 do
					slot4:HandleDamage(slot5, slot9, slot8)

					slot10 = slot10 + 1
				end
			end
		end

		slot6.Battle.PlayBattleSFX(slot7.hit_sfx)
		slot4:SpawnEffect(slot7.hit_fx, slot5:GetExplodePostion())
	end).SetDiveFilter(nil, slot5)
	slot4:RemoveBulletUnit(slot0:GetUniqueID())
end

ys.Battle.BattleTriggerBulletFactory.onBulletHitFunc = function (slot0, slot1, slot2)
	return
end

ys.Battle.BattleTriggerBulletFactory.CreateBulletAlert = function (slot0)
	return
end

return
