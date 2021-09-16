ys = ys or {}
ys.Battle.BattleAntiAirBulletFactory = singletonClass("BattleAntiAirBulletFactory", ys.Battle.BattleBulletFactory)
ys.Battle.BattleAntiAirBulletFactory.__name = "BattleAntiAirBulletFactory"

ys.Battle.BattleAntiAirBulletFactory.Ctor = function (slot0)
	slot0.super.Ctor(slot0)

	slot0._tmpTimerList = {}
end

ys.Battle.BattleAntiAirBulletFactory.NeutralizeBullet = function (slot0)
	for slot4, slot5 in pairs(slot0._tmpTimerList) do
		pg.TimeMgr.GetInstance():RemoveBattleTimer(slot5)

		slot0._tmpTimerList[slot5] = nil
	end
end

ys.Battle.BattleAntiAirBulletFactory.CreateBullet = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot7 = slot2:GetTemplate().hit_type
	slot8 = slot0:GetDataProxy()

	if not slot2:GetDirectHitUnit() then
		slot8:RemoveBulletUnit(slot2:GetUniqueID())

		return
	end

	if slot0:GetSceneMediator():GetAircraft(slot9:GetUniqueID()) == nil then
		slot8:RemoveBulletUnit(slot2:GetUniqueID())

		return
	end

	slot12 = slot11:GetPosition():Clone()
	slot13 = slot7.range

	function slot14(slot0)
		slot1 = {}

		for slot5, slot6 in ipairs(slot0) do
			if slot6.Active and slot0:GetSceneMediator():GetAircraft(slot6.UID) and slot7:GetUnitData():IsVisitable() then
				slot1[#slot1 + 1] = slot8
			end
		end

		slot1:HandleMeteoDamage(slot1.HandleMeteoDamage, slot1)
	end

	function slot15()
		slot0:SpawnColumnArea(slot1:GetEffectField(), slot1:GetIFF(), , , slot4.time, )
		slot0.SpawnColumnArea:RemoveBulletUnit(slot1:GetUniqueID())
	end

	function slot16()
		if slot0:IsAlive() and slot1 then
			slot3 = slot1:GetPosition():Clone():Add(Vector3(math.random(slot2) - slot2 * 0.5, 0, math.random(slot2) - slot2 * 0.5))
		else
			slot0 = slot3
		end

		slot5, slot7 = slot4:GetFXPool():GetFX(slot5:GetTemplate().hit_fx)

		pg.EffectMgr.GetInstance():PlayBattleEffect(slot1, slot2:Add(slot0), true)
	end

	slot17, slot18 = nil

	function slot18()
		if slot0._tmpTimerList[slot1] ~= nil then
			slot2()
			slot3()
		else
			slot4()
		end
	end

	slot0._tmpTimerList[pg.TimeMgr.GetInstance().AddBattleTimer(slot21, "antiAirTimer", -1, 0.5, function ()
		pg.TimeMgr.GetInstance():RemoveBattleTimer(pg.TimeMgr.GetInstance().RemoveBattleTimer)

		slot1._tmpTimerList[] = nil
		slot0 = nil
	end, true)] = pg.TimeMgr.GetInstance().AddBattleTimer(slot21, "antiAirTimer", -1, 0.5, function ()
		pg.TimeMgr.GetInstance().RemoveBattleTimer(pg.TimeMgr.GetInstance().RemoveBattleTimer)

		slot1._tmpTimerList[] = nil
		slot0 = nil
	end, true)

	function ()
		if slot0 == nil then
			slot1()
		else
			slot2:PlayFireFX(slot3, slot4, slot5, slot2.PlayFireFX, slot6, slot7)
		end
	end()
end

return
