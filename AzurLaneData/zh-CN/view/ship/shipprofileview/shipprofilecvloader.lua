slot0 = class("ShipProfileCVLoader")
slot1 = pg.ship_skin_words

slot0.Ctor = function (slot0)
	slot0.loadedCVBankName = nil
	slot0.loadedCVBattleBankName = nil
	slot0.playbackInfo = nil
	slot0.timers = {}
end

slot0.Load = function (slot0, slot1)
	slot0:Unload()

	if ShipWordHelper.ExistVoiceKey(slot1) then
		slot0:SetUp(ShipWordHelper.RawGetCVKey(slot1))
	end
end

slot0.SetUp = function (slot0, slot1)
	function slot2()
		if slot1.exited then
			pg.CriMgr.UnloadCVBank(slot0)
			pg.CriMgr.UnloadCVBank(slot1)
		else
			slot1.loadedCVBankName = slot0
			slot1.loadedCVBattleBankName = slot1
		end
	end

	seriesAsync({
		function (slot0)
			pg.CriMgr:LoadCV(slot0, slot0)
		end,
		function (slot0)
			pg.CriMgr:LoadBattleCV(slot0, slot0)
		end
	}, slot2)
end

slot0.PlaySound = function (slot0, slot1)
	if not slot0.playbackInfo or slot1 ~= slot0.prevCvPath or slot0.playbackInfo.cueData == nil then
		slot0:StopSound()
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot1, function (slot0)
			if slot0 then
				slot0.playbackInfo = slot0
			end
		end)

		slot0.prevCvPath = slot1

		if slot0.playbackInfo == nil then
			return nil
		end

		return slot0.playbackInfo.cueInfo
	elseif slot0.playbackInfo then
		slot0.playbackInfo.PlaybackStop(slot2)
		slot0.playbackInfo:SetStartTimeAndPlay()

		return slot0.playbackInfo.cueInfo
	end

	return nil
end

slot0.DelayPlaySound = function (slot0, slot1, slot2, slot3)
	slot0:RemoveTimer(slot1)

	if slot2 > 0 then
		slot0.timers[slot1] = Timer.New(function ()
			slot0 = slot0:PlaySound(slot0)

			if slot0 then
				slot2(slot0)
			end
		end, slot2, 1)

		slot0.timers[slot1]:Start()
	else
		slot4 = slot0:PlaySound(slot1)

		if slot3 then
			slot3(slot4)
		end
	end
end

slot0.RawPlaySound = function (slot0, slot1, slot2)
	slot0:RemoveTimer(slot1)

	if slot2 > 0 then
		slot0.timers[slot1] = Timer.New(function ()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(pg.CriMgr.GetInstance().PlaySoundEffect_V3)
		end, slot2, 1)

		slot0.timers[slot1]:Start()
	else
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(slot1)
	end
end

slot0.RemoveTimer = function (slot0, slot1)
	if slot0.timers[slot1] then
		slot0.timers[slot1]:Stop()

		slot0.timers[slot1] = nil
	end
end

slot0.StopSound = function (slot0)
	if slot0.playbackInfo then
		slot0.playbackInfo:PlaybackStop()
	end
end

slot0.Unload = function (slot0)
	if slot0.loadedCVBankName then
		pg.CriMgr.UnloadCVBank(slot0.loadedCVBankName)

		slot0.loadedCVBankName = nil
	end

	if slot0.loadedCVBattleBankName then
		pg.CriMgr.UnloadCVBank(slot0.loadedCVBattleBankName)

		slot0.loadedCVBattleBankName = nil
	end
end

slot0.Dispose = function (slot0)
	slot0:StopSound()
	slot0:Unload()

	if slot0.playbackInfo then
		slot0.playbackInfo:Dispose()

		slot0.playbackInfo = nil
	end

	slot0.exited = true

	for slot4, slot5 in pairs(slot0.timers) do
		slot5:Stop()
	end

	slot0.timers = nil
end

return slot0
