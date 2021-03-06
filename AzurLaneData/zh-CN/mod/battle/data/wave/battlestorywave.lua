ys = ys or {}
ys.Battle.BattleStoryWave = class("BattleStoryWave", ys.Battle.BattleWaveInfo)
ys.Battle.BattleStoryWave.__name = "BattleStoryWave"

ys.Battle.BattleStoryWave.Ctor = function (slot0)
	slot0.super.Ctor(slot0)
end

ys.Battle.BattleStoryWave.SetWaveData = function (slot0, slot1)
	slot0.super.SetWaveData(slot0, slot1)

	slot0._storyID = slot0._param.id
end

ys.Battle.BattleStoryWave.DoWave = function (slot0)
	slot0.super.DoWave(slot0)

	slot1 = true

	if slot0._param.progress then
		if not getProxy(ChapterProxy):getActiveChapter() then
			slot1 = false
		elseif math.min(slot2.progress + slot2:getConfig("progress_boss"), 100) < slot0._param.progress then
			slot1 = false
		end
	end

	if slot1 then
		pg.MsgboxMgr.GetInstance():hide()
		ChapterOpCommand.PlayChapterStory(slot0._storyID, function (slot0, slot1)
			if slot0 then
				slot0:doFail(slot1)
			else
				slot0:doPass(slot1)
			end
		end, getProxy(ChapterProxy) and slot3.getActiveChapter(slot3) and getProxy(ChapterProxy) and slot3.getActiveChapter(slot3):IsAutoFight())
		gcAll()
	else
		slot0:doPass()
	end
end

ys.Battle.BattleStoryWave.doPass = function (slot0, slot1)
	slot0.Battle.BattleDataProxy.GetInstance().AddWaveFlag(slot2, slot1)
	slot1.super.doPass(slot0)
end

ys.Battle.BattleStoryWave.doFail = function (slot0, slot1)
	slot0.Battle.BattleDataProxy.GetInstance().AddWaveFlag(slot2, slot1)
	slot1.super.doFail(slot0)
end

return
