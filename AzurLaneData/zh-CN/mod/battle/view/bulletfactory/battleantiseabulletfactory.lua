ys = ys or {}
ys.Battle.BattleAntiSeaBulletFactory = singletonClass("BattleAntiSeaBulletFactory", ys.Battle.BattleBulletFactory)
ys.Battle.BattleAntiSeaBulletFactory.__name = "BattleAntiSeaBulletFactory"

ys.Battle.BattleAntiSeaBulletFactory.Ctor = function (slot0)
	slot0.super.Ctor(slot0)

	slot0._tmpTimerList = {}
end

ys.Battle.BattleAntiSeaBulletFactory.NeutralizeBullet = function (slot0)
	for slot4, slot5 in pairs(slot0._tmpTimerList) do
		pg.TimeMgr.GetInstance():RemoveBattleTimer(slot5)

		slot0._tmpTimerList[slot5] = nil
	end
end

ys.Battle.BattleAntiSeaBulletFactory.CreateBullet = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot7 = slot2:GetTemplate().hit_type
	slot8 = slot0:GetDataProxy()

	if not slot2:GetDirectHitUnit() then
		slot8:RemoveBulletUnit(slot2:GetUniqueID())

		return
	end

	if not slot0:GetSceneMediator():GetCharacter(slot9:GetUniqueID()) then
		slot8:RemoveBulletUnit(slot2:GetUniqueID())

		return
	end

	slot12 = slot7.range
	slot13, slot14, slot15 = nil

	function slot16()
		if slot0 then
			slot0 = nil
			slot1 = slot1:GetPosition():Clone()
			slot6, slot8 = slot4:GetFXPool():GetFX(slot5:GetTemplate().hit_fx)

			pg.EffectMgr.GetInstance():PlayBattleEffect(slot2, slot3:Add((not slot1.GetPosition():IsAlive() or not slot1 or slot1:Add(Vector3(math.random(slot3) - slot3 * 0.5, 0, math.random(slot3) - slot3 * 0.5))) and slot1), true)
		end
	end

	slot0._tmpTimerList[pg.TimeMgr.GetInstance().AddBattleTimer(slot18, "antiAirTimer", 0, 0.5, function ()
		if slot0:IsAlive() then
			slot1:HandleDamage(slot2, slot1.HandleDamage)
			slot1:RemoveBulletUnit(slot2:GetUniqueID())
		end

		pg.TimeMgr.GetInstance():RemoveBattleTimer(slot3)

		slot4._tmpTimerList[slot3] = nil
		slot3 = nil
	end, true)] = pg.TimeMgr.GetInstance().AddBattleTimer(slot18, "antiAirTimer", 0, 0.5, function ()
		if slot0.IsAlive() then
			slot1.HandleDamage(slot2, slot1.HandleDamage)
			slot1.RemoveBulletUnit(slot2.GetUniqueID())
		end

		pg.TimeMgr.GetInstance().RemoveBattleTimer(slot3)

		slot4._tmpTimerList[slot3] = nil
		slot3 = nil
	end, true)

	if slot4 ~= nil then
		slot0:PlayFireFX(slot1, slot2, slot3, slot4, slot5, nil)

		slot0._tmpTimerList[pg.TimeMgr.GetInstance():AddBattleTimer("showHitFXTimer", -1, 0.1, slot16, true)] = pg.TimeMgr.GetInstance().AddBattleTimer("showHitFXTimer", -1, 0.1, slot16, true)

		slot16()
	else
		slot8:HandleDamage(slot2, slot9)
		slot8:RemoveBulletUnit(slot2:GetUniqueID())
	end
end

return
