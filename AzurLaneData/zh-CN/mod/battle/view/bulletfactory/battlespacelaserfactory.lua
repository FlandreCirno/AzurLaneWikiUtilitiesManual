ys = ys or {}
slot1 = singletonClass("BattleSpaceLaserFactory", ys.Battle.BattleBulletFactory)
slot1.__name = "BattleSpaceLaserFactory"
ys.Battle.BattleSpaceLaserFactory = slot1

slot1.MakeBullet = function (slot0)
	return slot0.Battle.BattleLaserArea.New()
end

slot1.MakeModel = function (slot0, slot1, slot2)
	slot4 = slot1:GetBulletData().GetTemplate(slot3)
	slot5 = slot0:GetDataProxy()

	if slot0:GetBulletPool():InstFX(slot1:GetModleID()) then
		slot1:AddModel(slot6)
	else
		slot1:AddTempModel(slot0:GetTempGOPool():GetObject())
	end

	slot0.Battle.PlayBattleSFX(slot4.hit_sfx)
	slot1.SetSpawn(slot1, slot2)
	slot1:SetFXFunc(slot7, function (slot0)
		return
	end)
	slot0:GetSceneMediator():AddBullet(slot1)
end

return
