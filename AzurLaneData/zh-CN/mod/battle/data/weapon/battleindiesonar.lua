ys = ys or {}
slot1 = ys.Battle.BattleEvent
slot2 = ys.Battle.BattleFormulas
slot3 = ys.Battle.BattleConst
slot4 = ys.Battle.BattleConfig
slot5 = ys.Battle.BattleDataFunction
slot6 = ys.Battle.BattleAttr
slot7 = ys.Battle.BattleVariable
slot8 = ys.Battle.BattleTargetChoise
slot9 = class("BattleIndieSonar")
ys.Battle.BattleIndieSonar = slot9
slot9.__name = "BattleIndieSonar"

slot9.Ctor = function (slot0, slot1, slot2, slot3)
	slot0._fleetVO = slot1
	slot0._range = 180
	slot0._duration = slot3
end

slot9.SwitchHost = function (slot0, slot1)
	slot0._host = slot1
end

slot9.Detect = function (slot0)
	slot0._snoarStartTime = pg.TimeMgr.GetInstance():GetCombatTime()

	for slot5, slot6 in ipairs(slot1) do
		slot6:Detected(slot0._duration)
	end

	slot0._detectedList = slot1

	slot0._fleetVO:DispatchSonarScan(true)
end

slot9.Update = function (slot0, slot1)
	if slot1 > slot0._snoarStartTime + slot0._duration then
		slot0._detectedList = nil

		slot0._fleetVO:RemoveIndieSonar(slot0)
	end
end

slot9.FilterTarget = function (slot0)
	return slot0.TargetDiveState(slot0._host, {
		diveState = slot1.OXY_STATE.DIVE
	}, slot0.TargetAllFoe(slot0._host))
end

return
