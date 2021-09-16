ys = ys or {}
ys.Battle.BattleSpawnWave = class("BattleSpawnWave", ys.Battle.BattleWaveInfo)
ys.Battle.BattleSpawnWave.__name = "BattleSpawnWave"

ys.Battle.BattleSpawnWave.Ctor = function (slot0)
	slot0.super.Ctor(slot0)

	slot0._spawnUnitList = {}
	slot0._monsterList = {}
	slot0._reinforceKillCount = 0
	slot0._reinforceTotalKillCount = 0
	slot0._airStrikeTimerList = {}
	slot0._spawnTimerList = {}
	slot0._reinforceSpawnTimerList = {}
end

ys.Battle.BattleSpawnWave.SetWaveData = function (slot0, slot1)
	slot0.super.SetWaveData(slot0, slot1)

	slot0._sapwnData = slot1.spawn or {}
	slot0._airStrike = slot1.airFighter or {}
	slot0._reinforce = slot1.reinforcement or {}
	slot0._reinforceCount = #slot0._reinforce
	slot0._spawnCount = #slot0._sapwnData
	slot0._reinforceDuration = slot0._reinforce.reinforceDuration or 0
	slot0._reinforeceExpire = false
	slot0._round = slot0._param.round
end

ys.Battle.BattleSpawnWave.IsBossWave = function (slot0)
	slot1 = false

	for slot6, slot7 in ipairs(slot2) do
		if slot7.bossData then
			slot1 = true
		end
	end

	return slot1
end

ys.Battle.BattleSpawnWave.DoWave = function (slot0)
	slot0.super.DoWave(slot0)

	if slot0._round then
		if slot1.Battle.BattleDataProxy.GetInstance():GetInitData().ChallengeInfo then
			slot3 = slot2:GetInitData().ChallengeInfo:getRound()

			if slot0._round.less and slot3 < slot0._round.less then
				slot1 = true
			end

			if slot0._round.more and slot0._round.more < slot3 then
				slot1 = true
			end

			if slot0._round.equal and table.contains(slot0._round.equal, slot3) then
				slot1 = true
			end
		end

		if not slot1 then
			slot0:doPass()

			return
		end
	end

	slot1 = 0

	if PLATFORM_CODE == PLATFORM_CH then
		slot1 = 0.03
	end

	for slot5, slot6 in ipairs(slot0._airStrike) do
		if slot6.delay + slot5 * slot1 <= 0 then
			slot0:doAirStrike(slot6)
		else
			slot0:airStrikeTimer(slot6, slot7)
		end
	end

	slot2 = 0

	for slot6, slot7 in ipairs(slot0._sapwnData) do
		if slot7.bossData then
			slot2 = slot2 + 1
		end
	end

	slot3 = 0

	for slot7, slot8 in ipairs(slot0._sapwnData) do
		if math.random() <= (slot8.chance or 1) then
			if slot8.bossData and slot2 > 1 then
				slot8.bossData.bossCount = slot3 + 1
			end

			if slot8.delay + slot7 * slot1 <= 0 then
				slot0:doSpawn(slot8)
			else
				slot0:spawnTimer(slot8, slot10, slot0._spawnTimerList)
			end
		else
			slot0._spawnCount = slot0._spawnCount - 1
		end
	end

	if slot0._reinforce then
		slot0:doReinforce()
	end

	if slot0._spawnCount == 0 and slot0._reinforceDuration == 0 then
		slot0:doPass()
	end

	if slot0._reinforceDuration ~= 0 then
		slot0:reinforceDurationTimer(slot0._reinforceDuration)
	end

	slot1.Battle.BattleState.GenerateVertifyData(1)

	slot4, slot5 = slot1.Battle.BattleState.Vertify()

	if not slot4 then
		slot1.Battle.BattleState.GetInstance():GetCommandByName(slot1.Battle.BattleSingleDungeonCommand.__name):SetVertifyFail(100 + slot5)
	end
end

ys.Battle.BattleSpawnWave.AddMonster = function (slot0, slot1)
	if slot1:GetWaveIndex() ~= slot0._index then
		return
	end

	slot0._monsterList[slot1:GetUniqueID()] = slot1
end

ys.Battle.BattleSpawnWave.RemoveMonster = function (slot0, slot1)
	slot0:onWaveUnitDie(slot1)
end

ys.Battle.BattleSpawnWave.doSpawn = function (slot0, slot1)
	slot2 = slot0.Battle.BattleConst.UnitType.ENEMY_UNIT

	if slot1.bossData then
		slot2 = slot0.Battle.BattleConst.UnitType.BOSS_UNIT
	end

	slot0._spawnFunc(slot1, slot0._index, slot2)
end

ys.Battle.BattleSpawnWave.spawnTimer = function (slot0, slot1, slot2, slot3)
	slot4 = nil
	slot3[pg.TimeMgr.GetInstance().AddBattleTimer(slot6, "", 1, slot2, function ()
		slot0[slot1] = nil

		slot2:doSpawn(slot3)
		pg.TimeMgr.GetInstance():RemoveBattleTimer(pg.TimeMgr.GetInstance())
	end, true)] = true
end

ys.Battle.BattleSpawnWave.doAirStrike = function (slot0, slot1)
	slot0._airFunc(slot1)
end

ys.Battle.BattleSpawnWave.airStrikeTimer = function (slot0, slot1, slot2)
	slot3 = nil
	slot0._airStrikeTimerList[pg.TimeMgr.GetInstance().AddBattleTimer(slot5, "", 1, slot2, function ()
		slot0._airStrikeTimerList[slot1] = nil

		slot0._airStrikeTimerList:doAirStrike(nil)
		pg.TimeMgr.GetInstance():RemoveBattleTimer(pg.TimeMgr.GetInstance())
	end, true)] = true
end

ys.Battle.BattleSpawnWave.doReinforce = function (slot0)
	slot0._reinforceKillCount = 0

	if slot0._reinforeceExpire then
		return
	end

	for slot4, slot5 in ipairs(slot0._reinforce) do
		slot5.reinforce = true

		if slot5.delay <= 0 then
			slot0:doSpawn(slot5)
		else
			slot0:spawnTimer(slot5, slot5.delay, slot0._reinforceSpawnTimerList)
		end
	end
end

ys.Battle.BattleSpawnWave.reinforceTimer = function (slot0, slot1)
	slot0:clearReinforceTimer()

	slot0._reinforceTimer = pg.TimeMgr.GetInstance().AddBattleTimer(slot3, "", 1, slot1, function ()
		slot0:doReinforce()
		slot0.doReinforce:clearReinforceTimer()
	end, true)
end

ys.Battle.BattleSpawnWave.clearReinforceTimer = function (slot0)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(slot0._reinforceTimer)

	slot0._reinforceTimer = nil
end

ys.Battle.BattleSpawnWave.reinforceDurationTimer = function (slot0, slot1)
	slot0._reinforceDurationTimer = pg.TimeMgr.GetInstance().AddBattleTimer(slot3, "", 1, slot1, function ()
		pg.TimeMgr.GetInstance():RemoveBattleTimer(slot0._reinforceDurationTimer)

		pg.TimeMgr.GetInstance().RemoveBattleTimer._reinforeceExpire = true
		pg.TimeMgr.GetInstance().RemoveBattleTimer._reinforceDuration = nil

		pg.TimeMgr.GetInstance().RemoveBattleTimer:clearReinforceTimer()
		pg.TimeMgr.GetInstance().RemoveBattleTimer.clearReinforceTimer.clearTimerList(slot0._reinforceSpawnTimerList)

		if pg.TimeMgr.GetInstance().RemoveBattleTimer.clearReinforceTimer.clearTimerList._spawnCount == 0 then
			slot0:doPass()
		end
	end, true)
end

ys.Battle.BattleSpawnWave.clearReinforceDurationTimer = function (slot0)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(slot0._reinforceDurationTimer)

	slot0._reinforceDurationTimer = nil
end

ys.Battle.BattleSpawnWave.onWaveUnitDie = function (slot0, slot1)
	if slot0._monsterList[slot1] == nil then
		return
	end

	slot3 = nil

	if slot2:IsReinforcement() then
		slot0._reinforceKillCount = slot0._reinforceKillCount + 1
		slot0._reinforceTotalKillCount = slot0._reinforceTotalKillCount + 1

		if slot0._reinforceCount ~= 0 and slot0._reinforceCount == slot0._reinforceKillCount then
			slot3 = true
		end
	end

	function slot4(slot0)
		if slot0 and slot0 then
			if slot0 == 0 then
				slot1:doReinforce()
			else
				slot1:reinforceTimer(slot0)
			end

			slot0 = false
		end
	end

	slot5 = 0
	slot6 = 0

	for slot10, slot11 in pairs(slot0._monsterList) do
		if slot11.IsAlive(slot11) == false then
			if not slot11:IsReinforcement() then
				slot5 = slot5 + 1
			end
		else
			slot6 = slot6 + 1

			slot4(slot11:GetReinforceCastTime())
		end
	end

	if slot0._reinforceDuration ~= 0 and not slot0._reinforeceExpire then
		slot4(0)
	end

	if slot6 == 0 and slot0._spawnCount <= slot5 and slot0._reinforceCount <= slot0._reinforceTotalKillCount and (slot0._reinforceDuration == 0 or slot0._reinforeceExpire) then
		slot0:doPass()
	end
end

ys.Battle.BattleSpawnWave.doPass = function (slot0)
	slot0.clearTimerList(slot0._spawnTimerList)
	slot0.clearTimerList(slot0._reinforceSpawnTimerList)
	slot0:clearReinforceTimer()
	slot0:clearReinforceDurationTimer()
	slot0.Battle.BattleDataProxy.GetInstance():KillWaveSummonMonster(slot0._index)
	slot0.Battle.BattleDataProxy.GetInstance().KillWaveSummonMonster.super.doPass(slot0)
end

ys.Battle.BattleSpawnWave.clearTimerList = function (slot0)
	for slot4, slot5 in pairs(slot0) do
		pg.TimeMgr.GetInstance():RemoveBattleTimer(slot4)
	end
end

ys.Battle.BattleSpawnWave.Dispose = function (slot0)
	slot0.clearTimerList(slot0._airStrikeTimerList)

	slot0._airStrikeTimerList = nil

	slot0.clearTimerList(slot0._spawnTimerList)

	slot0._spawnTimerList = nil

	slot0.clearTimerList(slot0._reinforceSpawnTimerList)

	slot0._reinforceSpawnTimerList = nil

	slot0:clearReinforceTimer()
	slot0:clearReinforceDurationTimer()
	slot0.super.Dispose(slot0)
end

return
