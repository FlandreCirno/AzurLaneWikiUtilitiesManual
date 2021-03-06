pg = pg or {}
pg.TimeMgr = singletonClass("TimeMgr")
pg.TimeMgr._Timer = nil
pg.TimeMgr._BattleTimer = nil
pg.TimeMgr._sAnchorTime = 0
pg.TimeMgr._AnchorDelta = 0
pg.TimeMgr._serverUnitydelta = 0
pg.TimeMgr._isdstClient = false
slot2 = 3600
slot3 = 86400
slot4 = 604800

pg.TimeMgr.Ctor = function (slot0)
	slot0._battleTimerList = {}
end

pg.TimeMgr.Init = function (slot0)
	print("initializing time manager...")

	slot0._Timer = TimeUtil.NewUnityTimer()

	UpdateBeat:Add(slot0.Update, slot0)
	UpdateBeat:Add(slot0.BattleUpdate, slot0)
end

pg.TimeMgr.Update = function (slot0)
	slot0._Timer:Schedule()
end

pg.TimeMgr.BattleUpdate = function (slot0)
	if slot0._stopCombatTime > 0 then
		slot0._cobTime = slot0._stopCombatTime - slot0._waitTime
	else
		slot0._cobTime = Time.time - slot0._waitTime
	end
end

pg.TimeMgr.AddTimer = function (slot0, slot1, slot2, slot3, slot4)
	return slot0._Timer:SetTimer(slot1, slot2 * 1000, slot3 * 1000, slot4)
end

pg.TimeMgr.RemoveTimer = function (slot0, slot1)
	if slot1 == nil or slot1 == 0 then
		return
	end

	slot0._Timer:DeleteTimer(slot1)
end

pg.TimeMgr._waitTime = 0
pg.TimeMgr._stopCombatTime = 0
pg.TimeMgr._cobTime = 0

pg.TimeMgr.GetCombatTime = function (slot0)
	return slot0._cobTime
end

pg.TimeMgr.ResetCombatTime = function (slot0)
	slot0._waitTime = 0
	slot0._cobTime = Time.time
end

pg.TimeMgr.GetCombatDeltaTime = function ()
	return Time.fixedDeltaTime
end

pg.TimeMgr.PauseBattleTimer = function (slot0)
	slot0._stopCombatTime = Time.time

	for slot4, slot5 in pairs(slot0._battleTimerList) do
		slot4:Pause()
	end
end

pg.TimeMgr.ResumeBattleTimer = function (slot0)
	slot0._waitTime = (slot0._waitTime + Time.time) - slot0._stopCombatTime
	slot0._stopCombatTime = 0

	for slot4, slot5 in pairs(slot0._battleTimerList) do
		slot4:Resume()
	end
end

pg.TimeMgr.AddBattleTimer = function (slot0, slot1, slot2, slot3, slot4, slot5, slot6)
	slot0._battleTimerList[Timer.New(slot4, slot3, slot2 or -1, slot5 or false)] = true

	if not (slot6 or false) then
		slot7:Start()
	end

	if slot0._stopCombatTime ~= 0 then
		slot7:Pause()
	end

	return slot7
end

pg.TimeMgr.ScaleBattleTimer = function (slot0, slot1)
	Time.timeScale = slot1
end

pg.TimeMgr.RemoveBattleTimer = function (slot0, slot1)
	if slot1 then
		slot0._battleTimerList[slot1] = nil

		slot1:Stop()
	end
end

pg.TimeMgr.RemoveAllBattleTimer = function (slot0)
	for slot4, slot5 in pairs(slot0._battleTimerList) do
		slot4:Stop()
	end

	slot0._battleTimerList = {}
end

pg.TimeMgr.RealtimeSinceStartup = function (slot0)
	return math.ceil(Time.realtimeSinceStartup)
end

pg.TimeMgr.SetServerTime = function (slot0, slot1, slot2)
	if PLATFORM_CODE == PLATFORM_US then
		SERVER_SERVER_DAYLIGHT_SAVEING_TIME = true
	end

	slot0._isdstClient = os.date("*t").isdst
	slot0._serverUnitydelta = slot1 - slot0:RealtimeSinceStartup()
	slot0._sAnchorTime = slot2 - ((SERVER_DAYLIGHT_SAVEING_TIME and 3600) or 0)
	slot0._AnchorDelta = slot2 - os.time({
		year = 2020,
		month = 11,
		hour = 0,
		min = 0,
		sec = 0,
		day = 23,
		isdst = false
	})
end

pg.TimeMgr.GetServerTime = function (slot0)
	return slot0:RealtimeSinceStartup() + slot0._serverUnitydelta
end

pg.TimeMgr.GetServerWeek = function (slot0)
	return slot0:GetServerTimestampWeek(slot0:GetServerTime())
end

pg.TimeMgr.GetServerTimestampWeek = function (slot0, slot1)
	return math.ceil(((slot1 - slot0._sAnchorTime) % slot0 + 1) / slot1)
end

pg.TimeMgr.GetServerHour = function (slot0)
	return math.floor((slot0:GetServerTime() - slot0._sAnchorTime) % slot0 / slot0.GetServerTime())
end

pg.TimeMgr.Table2ServerTime = function (slot0, slot1)
	if slot0._isdstClient ~= SERVER_DAYLIGHT_SAVEING_TIME then
		if SERVER_DAYLIGHT_SAVEING_TIME then
			return (slot0._AnchorDelta + os.time(slot1)) - slot0
		else
			return slot0._AnchorDelta + os.time(slot1) + slot0
		end
	else
		return slot0._AnchorDelta + os.time(slot1)
	end
end

pg.TimeMgr.CTimeDescC = function (slot0, slot1, slot2)
	return os.date(slot2 or "%Y%m%d%H%M%S", slot1)
end

pg.TimeMgr.STimeDescC = function (slot0, slot1, slot2, slot3)
	slot2 = slot2 or "%Y/%m/%d %H:%M:%S"

	if slot3 then
		return os.date(slot2, (slot1 + os.time()) - slot0:GetServerTime())
	else
		return os.date(slot2, slot1)
	end
end

pg.TimeMgr.STimeDescS = function (slot0, slot1, slot2)
	slot2 = slot2 or "%Y/%m/%d %H:%M:%S"
	slot3 = 0

	if slot0._isdstClient ~= SERVER_DAYLIGHT_SAVEING_TIME then
		return os.date(slot2, slot1 - slot0._AnchorDelta + ((SERVER_DAYLIGHT_SAVEING_TIME and 3600) or -3600))
	end
end

pg.TimeMgr.CurrentSTimeDesc = function (slot0, slot1, slot2)
	if slot2 then
		return slot0:STimeDescS(slot0:GetServerTime(), slot1)
	else
		return slot0:STimeDescC(slot0:GetServerTime(), slot1)
	end
end

pg.TimeMgr.ChieseDescTime = function (slot0, slot1, slot2)
	slot4 = nil
	slot5 = split((not slot2 or os.date("%Y/%m/%d", slot1)) and os.date("%Y/%m/%d", (slot1 + os.time()) - slot0:GetServerTime()), "/")

	return NumberToChinese(slot5[1], false) .. "???" .. NumberToChinese(slot5[2], true) .. "???" .. NumberToChinese(slot5[3], true) .. "???"
end

pg.TimeMgr.GetNextTime = function (slot0, slot1, slot2, slot3, slot4)
	return math.floor((slot0:GetServerTime() - (slot0._sAnchorTime + slot1 * slot1 + slot2 * 60 + slot3)) / (slot4 or slot0) + 1) * (slot4 or slot0) + slot0._sAnchorTime + slot1 * slot1 + slot2 * 60 + slot3
end

pg.TimeMgr.GetNextTimeByTimeStamp = function (slot0, slot1)
	return math.floor((slot1 - slot0._sAnchorTime) / slot0) * slot0 + slot0._sAnchorTime
end

pg.TimeMgr.GetNextWeekTime = function (slot0, slot1, slot2, slot3, slot4)
	return slot0:GetNextTime((slot1 - 1) * 24 + slot2, slot3, slot4, slot0)
end

pg.TimeMgr.ParseTime = function (slot0, slot1)
	return slot0:Table2ServerTime({
		year = tonumber(slot1) / 100 / 100 / 100 / 100 / 100,
		month = (tonumber(slot1) / 100 / 100 / 100 / 100) % 100,
		day = (tonumber(slot1) / 100 / 100 / 100) % 100,
		hour = (tonumber(slot1) / 100 / 100) % 100,
		min = (tonumber(slot1) / 100) % 100,
		sec = tonumber(slot1) % 100
	})
end

pg.TimeMgr.ParseTimeEx = function (slot0, slot1, slot2)
	if slot2 == nil then
		slot2 = "(%d+)%-(%d+)%-(%d+)%s(%d+)%:(%d+)%:(%d+)"
	end

	slot11.year, slot11.month, slot11.day, slot11.hour, slot11.min, slot11.sec = slot1:match(slot2)

	return slot0:Table2ServerTime({
		year = slot3,
		month = slot4,
		day = slot5,
		hour = slot6,
		min = slot7,
		sec = slot8
	})
end

pg.TimeMgr.parseTimeFromConfig = function (slot0, slot1)
	return slot0:Table2ServerTime({
		year = slot1[1][1],
		month = slot1[1][2],
		day = slot1[1][3],
		hour = slot1[2][1],
		min = slot1[2][2],
		sec = slot1[2][3]
	})
end

pg.TimeMgr.DescCDTime = function (slot0, slot1)
	return string.format("%02d:%02d:%02d", math.floor(slot1 / 3600), math.floor((slot1 - math.floor(slot1 / 3600) * 3600) / 60), (slot1 - math.floor(slot1 / 3600) * 3600) % 60)
end

pg.TimeMgr.parseTimeFrom = function (slot0, slot1)
	return math.floor(slot1 / slot0), math.fmod(math.floor(slot1 / 3600), 24), math.fmod(math.floor(slot1 / 60), 60), math.fmod(slot1, 60)
end

pg.TimeMgr.DiffDay = function (slot0, slot1, slot2)
	return math.floor((slot2 - slot0._sAnchorTime) / slot0) - math.floor((slot1 - slot0._sAnchorTime) / slot0)
end

pg.TimeMgr.IsSameDay = function (slot0, slot1, slot2)
	return math.floor((slot1 - slot0._sAnchorTime) / slot0) == math.floor((slot2 - slot0._sAnchorTime) / slot0)
end

pg.TimeMgr.IsPassTimeByZero = function (slot0, slot1, slot2)
	return slot2 < math.fmod(slot1 - slot0._sAnchorTime, slot0)
end

pg.TimeMgr.CalcMonthDays = function (slot0, slot1, slot2)
	slot3 = 30

	if slot2 == 2 then
		slot3 = (((slot1 % 4 == 0 and slot1 % 100 ~= 0) or slot1 % 400 == 0) and 29) or 28
	elseif _.include({
		1,
		3,
		5,
		7,
		8,
		10,
		12
	}, slot2) then
		slot3 = 31
	end

	return slot3
end

pg.TimeMgr.inTime = function (slot0, slot1)
	if not slot1 then
		return true
	end

	if type(slot1) == "string" then
		return slot1 == "always"
	end

	if slot1[1] == nil then
		slot1 = {
			slot1[2],
			slot1[3]
		}
	end

	function slot2(slot0)
		return {
			year = slot0[1][1],
			month = slot0[1][2],
			day = slot0[1][3],
			hour = slot0[2][1],
			min = slot0[2][2],
			sec = slot0[2][3]
		}
	end

	slot3 = nil

	if #slot1 > 0 then
		slot3 = slot2(slot1[1] or {
			{
				2000,
				1,
				1
			},
			{
				0,
				0,
				0
			}
		})
	end

	slot4 = nil

	if #slot1 > 1 then
		slot4 = slot2(slot1[2] or {
			{
				2000,
				1,
				1
			},
			{
				0,
				0,
				0
			}
		})
	end

	slot5 = nil

	if slot3 and slot4 then
		slot8 = slot0:Table2ServerTime(slot4)

		if slot0:GetServerTime() < slot0:Table2ServerTime(slot3) then
			return false, slot3
		end

		if slot8 < slot6 then
			return false, nil
		end

		slot5 = slot4
	end

	return true, slot5
end

pg.TimeMgr.passTime = function (slot0, slot1)
	if not slot1 then
		return true
	end

	function slot2(slot0)
		return {
			year = slot0[1][1],
			month = slot0[1][2],
			day = slot0[1][3],
			hour = slot0[2][1],
			min = slot0[2][2],
			sec = slot0[2][3]
		}
	end

	slot3 = slot2
	slot4 = slot1 or {
		{
			2000,
			1,
			1
		},
		{
			0,
			0,
			0
		}
	}

	if slot3(slot4) then
		return slot0:Table2ServerTime(slot3) < slot0:GetServerTime()
	end

	return true
end

return
