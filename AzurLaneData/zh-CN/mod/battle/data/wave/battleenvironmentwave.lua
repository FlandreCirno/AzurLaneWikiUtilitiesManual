ys = ys or {}
ys.Battle.BattleEnvironmentWave = class("BattleEnvironmentWave", ys.Battle.BattleWaveInfo)
ys.Battle.BattleEnvironmentWave.__name = "BattleEnvironmentWave"

ys.Battle.BattleEnvironmentWave.Ctor = function (slot0)
	slot0.super.Ctor(slot0)

	slot0._spawnTimerList = {}
end

ys.Battle.BattleEnvironmentWave.SetWaveData = function (slot0, slot1)
	slot0.super.SetWaveData(slot0, slot1)

	slot0._sapwnData = slot1.spawn or {}
	slot0._environWarning = slot1.warning
end

ys.Battle.BattleEnvironmentWave.DoWave = function (slot0)
	slot0.super.DoWave(slot0)

	for slot4, slot5 in ipairs(slot0._sapwnData) do
		if slot5.delay and slot5.delay > 0 then
			slot0:spawnTimer(slot5)
		else
			slot0:doSpawn(slot5)
		end
	end

	if slot0._environWarning then
		slot1.Battle.BattleDataProxy.GetInstance():DispatchWarning(true)
	end
end

ys.Battle.BattleEnvironmentWave.doSpawn = function (slot0, slot1)
	slot0.Battle.BattleDataProxy.GetInstance().SpawnEnvironment(slot2, slot1).ConfigCallback(slot3, function ()
		slot0:doPass()
	end)
end

ys.Battle.BattleEnvironmentWave.doPass = function (slot0)
	if slot0._environWarning then
		slot0.Battle.BattleDataProxy.GetInstance():DispatchWarning(false)
	end
end

ys.Battle.BattleEnvironmentWave.spawnTimer = function (slot0, slot1)
	slot2 = nil
	slot0._spawnTimerList[pg.TimeMgr.GetInstance().AddBattleTimer(slot5, "", 1, slot1.delay, function ()
		slot0:doSpawn(slot0)
		pg.TimeMgr.GetInstance():RemoveBattleTimer(slot0)
	end, true)] = true
end

ys.Battle.BattleEnvironmentWave.Dispose = function (slot0)
	for slot4, slot5 in pairs(slot0._spawnTimerList) do
		pg.TimeMgr.GetInstance():RemoveBattleTimer(slot4)
	end

	slot0._spawnTimerList = nil
end

return
