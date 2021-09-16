ys = ys or {}
slot1 = ys.Battle.BattleUnitEvent
slot2 = ys.Battle.BattleEvent
slot3 = class("BattleAirFightCommand", ys.Battle.BattleSingleDungeonCommand)
ys.Battle.BattleAirFightCommand = slot3
slot3.__name = "BattleAirFightCommand"

slot3.Ctor = function (slot0)
	slot0.super.Ctor(slot0)
end

slot3.AddEvent = function (slot0, ...)
	slot0.super.AddEvent(slot0, ...)
	slot0._dataProxy:RegisterEventListener(slot0, slot1.COMMON_DATA_INIT_FINISH, slot0.onBattleDataInitFinished)
end

slot3.RemoveEvent = function (slot0, ...)
	slot0._dataProxy:UnregisterEventListener(slot0, slot0.COMMON_DATA_INIT_FINISH)
	slot0._dataProxy.UnregisterEventListener.super.RemoveEvent(slot0, ...)
end

slot3.DoPrologue = function (slot0)
	pg.UIMgr.GetInstance():Marching()
	slot0._uiMediator.SeaSurfaceShift(slot2, 1, 15, nil, function ()
		slot0._uiMediator:OpeningEffect(function ()
			slot0._dataProxy:SetupCalculateDamage(slot1.Battle.BattleFormulas.FriendInvincibleDamage)
			slot0._dataProxy.SetupCalculateDamage._dataProxy:SetupDamageKamikazeShip(slot1.Battle.BattleFormulas.CalcDamageLockS2M)
			slot0._dataProxy.SetupCalculateDamage._dataProxy.SetupDamageKamikazeShip._dataProxy:SetupDamageCrush(slot1.Battle.BattleFormulas.FriendInvincibleCrashDamage)
			slot0._dataProxy.SetupCalculateDamage._dataProxy.SetupDamageKamikazeShip._dataProxy.SetupDamageCrush._uiMediator:ShowTimer()
			slot0._dataProxy.SetupCalculateDamage._dataProxy.SetupDamageKamikazeShip._dataProxy.SetupDamageCrush._uiMediator.ShowTimer._state:ChangeState(slot1.Battle.BattleState.BATTLE_STATE_FIGHT)
			slot0._dataProxy.SetupCalculateDamage._dataProxy.SetupDamageKamikazeShip._dataProxy.SetupDamageCrush._uiMediator.ShowTimer._state.ChangeState._waveUpdater:Start()
		end, SYSTEM_AIRFIGHT)
		slot0._uiMediator.OpeningEffect._dataProxy.InitAllFleetUnitsWeaponCD(slot0)
	end)

	slot2 = slot0._state:GetSceneMediator()

	slot2:InitPopScorePool()
	slot2:EnablePopContainer(slot0.Battle.BattlePopNumManager.CONTAINER_HP, false)
	slot2:EnablePopContainer(slot0.Battle.BattlePopNumManager.CONTAINER_SCORE, false)
	slot2:EnablePopContainer(slot0.Battle.BattleHPBarManager.ROOT_NAME, false)
	slot0._uiMediator:ShowAirFightScoreBar()
end

slot3.initWaveModule = function (slot0)
	function slot1(slot0, slot1, slot2)
		slot0._dataProxy:SpawnMonster(slot0, slot1, slot2, slot1.Battle.BattleConfig.FOE_CODE)
	end

	slot0._waveUpdater = slot0.Battle.BattleWaveUpdater.New(slot1, nil, function ()
		if slot0._vertifyFail then
			pg.m02:sendNotification(GAME.CHEATER_MARK, {
				reason = slot0._vertifyFail
			})

			return
		end

		slot0._dataProxy:CalcAirFightScore()
		slot0._dataProxy.CalcAirFightScore._state:BattleEnd()
	end, nil)
end

slot3.onBattleDataInitFinished = function (slot0)
	slot0._dataProxy:AirFightInit()

	for slot5, slot6 in ipairs(slot1) do
		slot6:HideWaveFx()
	end
end

slot3.RegisterUnitEvent = function (slot0, slot1, ...)
	slot0.super.RegisterUnitEvent(slot0, slot1, ...)

	if slot1:GetUnitType() == slot1.Battle.BattleConst.UnitType.PLAYER_UNIT then
		slot1:RegisterEventListener(slot0, slot2.UPDATE_HP, slot0.onPlayerHPUpdate)
	end
end

slot3.UnregisterUnitEvent = function (slot0, slot1, ...)
	if slot1:GetUnitType() == slot0.Battle.BattleConst.UnitType.PLAYER_UNIT then
		slot1:UnregisterEventListener(slot0, slot1.UPDATE_HP)
	end

	slot2.super.UnregisterUnitEvent(slot0, slot1, ...)
end

slot3.ShipType2Point = {
	[ShipType.YuLeiTing] = 200,
	[ShipType.JinBi] = 300,
	[ShipType.ZiBao] = 3000
}
slot3.BeenHitDecreasePoint = 10

slot3.onWillDie = function (slot0, slot1)
	slot4 = slot1.Dispatcher.GetTemplate(slot2).type

	if (slot1.Dispatcher.GetDeathReason(slot2) == slot0.Battle.BattleConst.UnitDeathReason.CRUSH or slot3 == slot0.Battle.BattleConst.UnitDeathReason.KILLED) and slot1.ShipType2Point[slot4] and slot5 > 0 then
		slot0._dataProxy:AddAirFightScore(slot5)
	end
end

slot3.onPlayerHPUpdate = function (slot0, slot1)
	if slot1.Data.dHP <= 0 then
		slot0._dataProxy:DecreaseAirFightScore(slot0.BeenHitDecreasePoint * -slot1.Data.dHP)
	end
end

return
