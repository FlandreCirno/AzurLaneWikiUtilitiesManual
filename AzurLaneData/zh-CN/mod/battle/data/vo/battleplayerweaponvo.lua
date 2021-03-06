ys = ys or {}
slot1 = ys.Battle.BattleConfig
slot2 = ys.Battle.BattleVariable
ys.Battle.BattlePlayerWeaponVO = class("BattlePlayerWeaponVO")
ys.Battle.BattlePlayerWeaponVO.__name = "BattlePlayerWeaponVO"

ys.Battle.BattlePlayerWeaponVO.Ctor = function (slot0, slot1)
	slot0.EventDispatcher.AttachEventDispatcher(slot0)

	slot0._GCD = slot1

	slot0:Reset()
end

ys.Battle.BattlePlayerWeaponVO.Reset = function (slot0)
	slot0._isOverLoad = false
	slot0._current = slot0._GCD
	slot0._max = slot0._GCD
	slot0._count = 0
	slot0._total = 0
	slot0._weaponList = {}
	slot0._overHeatList = {}
	slot0._readyList = {}
	slot0._chargingList = {}
end

ys.Battle.BattlePlayerWeaponVO.Update = function (slot0, slot1)
	if slot0._current < slot0._max then
		if slot0._max <= slot1 - slot0._reloadStartTime then
			slot0._current = slot0._max
			slot0._reloadStartTime = nil

			for slot6, slot7 in ipairs(slot0._chargingList) do
				slot7:UpdateReload()
			end

			slot0:DispatchOverLoadChange()
		else
			slot0._current = slot2
		end
	end
end

ys.Battle.BattlePlayerWeaponVO.PlayFocus = function (slot0, slot1, slot2)
	slot0.Battle.BattleCameraUtil.GetInstance():FocusCharacter(slot1, slot1.CAST_CAM_ZOOM_IN_DURATION)
	slot0.Battle.BattleCameraUtil.GetInstance():ZoomCamara(nil, slot1.CAST_CAM_ZOOM_SIZE, slot1.CAST_CAM_ZOOM_IN_DURATION, true)
	slot0.Battle.BattleCameraUtil.GetInstance():BulletTime(slot1.SPEED_FACTOR_FOCUS_CHARACTER, slot1.FOCUS_MAP_RATE, slot1)

	slot0._focus = true

	if slot0._focusTimer then
		pg.TimeMgr.GetInstance():RemoveBattleTimer(slot0._focusTimer)
	end

	slot0._focusTimer = pg.TimeMgr.GetInstance().AddBattleTimer(slot4, "", -1, slot1.CAST_CAM_ZOOM_IN_DURATION, function ()
		pg.TimeMgr.GetInstance():RemoveBattleTimer(slot0._focusTimer)

		pg.TimeMgr.GetInstance().RemoveBattleTimer._focusTimer = nil

		nil()
	end, true)
end

ys.Battle.BattlePlayerWeaponVO.PlayCutIn = function (slot0, slot1, slot2)
	slot0.Battle.BattleCameraUtil.GetInstance():CutInPainting(slot1, slot2)
end

ys.Battle.BattlePlayerWeaponVO.ResetFocus = function (slot0)
	return
end

ys.Battle.BattlePlayerWeaponVO.CancelFocus = function (slot0)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(slot0._focusTimer)

	slot0._focusTimer = nil
end

ys.Battle.BattlePlayerWeaponVO.GetWeaponList = function (slot0)
	return slot0._weaponList
end

ys.Battle.BattlePlayerWeaponVO.AppendWeapon = function (slot0, slot1)
	slot0._weaponList[#slot0._weaponList + 1] = slot1

	if slot1:GetCurrentState() == slot1.STATE_READY then
		slot0._count = slot0._count + 1
	end

	slot0._total = slot0._total + 1

	slot0:DispatchTotalChange()

	slot0._current = slot0._max

	slot0:DispatchOverLoadChange()

	slot0._readyList[#slot0._readyList + 1] = slot1
end

ys.Battle.BattlePlayerWeaponVO.RemoveWeapon = function (slot0, slot1)
	slot2 = slot0.deleteElementFromArray(slot1, slot0._weaponList)
	slot0._total = slot0._total - 1

	if slot1:GetCurrentState() ~= slot1.STATE_OVER_HEAT then
		slot0._count = slot0._count - 1

		if slot0._count < 0 then
			slot0._count = 0
		end

		slot0:DispatchOverLoadChange()
		slot0:DispatchTotalChange(slot0.deleteElementFromArray(slot1, slot0._readyList))
	else
		if slot0.deleteElementFromArray(slot1, slot0._chargingList) == -1 then
			slot0.deleteElementFromArray(slot1, slot0._overHeatList)
		end

		slot0:DispatchOverLoadChange()
		slot0:DispatchTotalChange()
	end

	slot0:refreshCD()

	return slot2
end

ys.Battle.BattlePlayerWeaponVO.refreshCD = function (slot0)
	slot2 = #slot0._chargingList

	if #slot0._readyList ~= 0 then
		slot0._current = 1
		slot0._max = 1
	elseif slot1 + slot2 == 0 then
		slot0._current = 1
		slot0._max = 1
	else
		slot4 = slot0:GetNextTimeStamp() - pg.TimeMgr.GetInstance():GetCombatTime()

		if slot0._GCD <= slot0._current then
			slot0._max = slot4
		else
			slot0._max = math.max(math.max(slot0._max, slot0._GCD) - slot0._current, slot4)
		end

		slot0:resetCurrent()
	end
end

ys.Battle.BattlePlayerWeaponVO.RefreshReloadingBar = function (slot0)
	if not slot0._reloadStartTime or #slot0._readyList ~= 0 then
		return
	end

	slot0._max = slot0:GetNextTimeStamp() - slot0._reloadStartTime
	slot0._current = slot0._current / slot0._max * slot0._max
end

ys.Battle.BattlePlayerWeaponVO.resetCurrent = function (slot0)
	slot0._current = 0
	slot0._reloadStartTime = slot0._jammingStarTime or pg.TimeMgr.GetInstance():GetCombatTime()
end

ys.Battle.BattlePlayerWeaponVO.SetMax = function (slot0, slot1)
	slot0._max = slot1
end

ys.Battle.BattlePlayerWeaponVO.GetMax = function (slot0)
	return slot0._max
end

ys.Battle.BattlePlayerWeaponVO.GetCurrent = function (slot0)
	return slot0._current
end

ys.Battle.BattlePlayerWeaponVO.IsOverLoad = function (slot0)
	return slot0._current < slot0._max or slot0._count < 1
end

ys.Battle.BattlePlayerWeaponVO.SetTotal = function (slot0, slot1)
	slot0._total = slot1
end

ys.Battle.BattlePlayerWeaponVO.GetTotal = function (slot0)
	return slot0._total
end

ys.Battle.BattlePlayerWeaponVO.SetCount = function (slot0, slot1)
	slot0._count = slot1
end

ys.Battle.BattlePlayerWeaponVO.GetCount = function (slot0)
	return slot0._count
end

ys.Battle.BattlePlayerWeaponVO.GetNextTimeStamp = function (slot0)
	slot1 = nil

	if #slot0._chargingList > 0 then
		tiemStampB = slot0._chargingList[1].GetReloadFinishTimeStamp(slot1)

		for slot5, slot6 in ipairs(slot0._chargingList) do
			tiemStampB = slot1:GetReloadFinishTimeStamp()

			if slot6:GetReloadFinishTimeStamp() < tiemStampB then
				slot1 = slot6
				tiemStampB = slot7
			end
		end
	end

	return tiemStampB, slot1
end

ys.Battle.BattlePlayerWeaponVO.GetCurrentWeapon = function (slot0)
	return slot0._readyList[1]
end

ys.Battle.BattlePlayerWeaponVO.Plus = function (slot0, slot1)
	slot0._count = slot0._count + 1

	slot0:DispatchCountChange()
	slot0.deleteElementFromArray(slot1, slot0._chargingList)

	slot0._readyList[#slot0._readyList + 1] = slot1

	slot0:DispatchEvent(slot0.Event.New(slot0.Battle.BattleEvent.WEAPON_COUNT_PLUS))
	slot0:DispatchOverLoadChange()
end

ys.Battle.BattlePlayerWeaponVO.Deduct = function (slot0, slot1)
	slot0.deleteElementFromArray(slot1, slot0._readyList)

	slot0._overHeatList[#slot0._overHeatList + 1] = slot1
	slot0._count = slot0._count - 1

	if slot0._count < 0 then
		slot0._count = 0
	end

	slot0:DispatchCountChange()

	if #slot0._readyList ~= 0 then
		slot0._max = slot0._GCD

		slot0:resetCurrent()
	elseif #slot0._chargingList ~= 0 then
		slot0._max = math.max(slot0._GCD, slot0:GetNextTimeStamp() - pg.TimeMgr.GetInstance():GetCombatTime())

		slot0:resetCurrent()
	elseif slot1:GetType() == slot0.Battle.BattleConst.EquipmentType.DISPOSABLE_TORPEDO then
	else
		slot0._current = 0
	end

	slot0:DispatchOverLoadChange()
end

ys.Battle.BattlePlayerWeaponVO.Charge = function (slot0, slot1)
	slot0.deleteElementFromArray(slot1, slot0._overHeatList)

	slot0._chargingList[#slot0._chargingList + 1] = slot1

	if #slot0._readyList == 0 then
		slot0._max = math.max(slot0._GCD, slot0:GetNextTimeStamp() - pg.TimeMgr.GetInstance():GetCombatTime())

		slot0:resetCurrent()
	end
end

ys.Battle.BattlePlayerWeaponVO.ReloadBoost = function (slot0, slot1, slot2)
	slot3, slot4 = slot0:GetNextTimeStamp()

	slot1:ReloadBoost(slot2)

	slot5, slot6 = slot0:GetNextTimeStamp()

	if slot4 ~= slot1 and slot6 ~= slot1 then
	elseif slot4 == slot1 and slot6 == slot1 then
		slot0:RefreshReloadingBar()
	elseif slot4 ~= slot6 then
		slot0:RefreshReloadingBar()
	end
end

ys.Battle.BattlePlayerWeaponVO.InstantCoolDown = function (slot0, slot1)
	slot0.deleteElementFromArray(slot1, slot0._overHeatList)

	if slot0._GCD <= slot0._current then
		slot0._current = slot0._max
		slot0._reloadStartTime = nil
	else
		slot0._max = slot0._GCD - slot0._current

		slot0:resetCurrent()
	end

	slot0:Plus(slot1)
end

ys.Battle.BattlePlayerWeaponVO.DispatchBlink = function (slot0, slot1)
	slot0:DispatchEvent(slot0.Event.New(slot0.Battle.BattleEvent.WEAPON_BUTTON_BLINK, slot2))
end

ys.Battle.BattlePlayerWeaponVO.DispatchTotalChange = function (slot0, slot1)
	slot0:DispatchEvent(slot0.Event.New(slot0.Battle.BattleEvent.WEAPON_TOTAL_CHANGE, {
		index = slot1
	}))
end

ys.Battle.BattlePlayerWeaponVO.DispatchOverLoadChange = function (slot0)
	slot0:DispatchEvent(slot0.Event.New(slot0.Battle.BattleEvent.OVER_LOAD_CHANGE))
end

ys.Battle.BattlePlayerWeaponVO.DispatchCountChange = function (slot0)
	slot0:DispatchEvent(slot0.Event.New(slot0.Battle.BattleEvent.COUNT_CHANGE))
end

ys.Battle.BattlePlayerWeaponVO.StartJamming = function (slot0)
	slot0._jammingStarTime = pg.TimeMgr.GetInstance():GetCombatTime()

	for slot4, slot5 in ipairs(slot0._chargingList) do
		slot5:StartJamming()
	end
end

ys.Battle.BattlePlayerWeaponVO.JammingEliminate = function (slot0)
	for slot4, slot5 in ipairs(slot0._chargingList) do
		slot5:JammingEliminate()
	end

	if slot0._reloadStartTime then
		slot1 = pg.TimeMgr.GetInstance():GetCombatTime()

		if #slot0._readyList ~= 0 then
			slot0._max = slot0._GCD
		else
			slot0._max = slot0:GetNextTimeStamp() - slot1 + slot0._current
		end

		slot0._reloadStartTime = slot0._reloadStartTime + slot1 - slot0._jammingStarTime
	end

	slot0._jammingStarTime = nil
end

ys.Battle.BattlePlayerWeaponVO.Dispose = function (slot0)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(slot0._focusTimer)

	slot0._focusTimer = nil

	slot0.EventDispatcher.DetachEventDispatcher(slot0)
end

ys.Battle.BattlePlayerWeaponVO.deleteElementFromArray = function (slot0, slot1)
	slot2 = nil

	for slot6, slot7 in ipairs(slot1) do
		if slot0 == slot7 then
			slot2 = slot6

			break
		end
	end

	if slot2 == nil then
		return -1
	end

	for slot6 = slot2, #slot1, 1 do
		if slot1[slot6 + 1] ~= nil then
			slot1[slot6] = slot1[slot6 + 1]
		else
			slot1[slot6] = nil
		end
	end

	return slot2
end

return
