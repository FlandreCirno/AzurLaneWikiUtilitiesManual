ys = ys or {}
ys.Battle.BattleGuideWave = class("BattleGuideWave", ys.Battle.BattleWaveInfo)
ys.Battle.BattleGuideWave.__name = "BattleGuideWave"

ys.Battle.BattleGuideWave.Ctor = function (slot0)
	slot0.super.Ctor(slot0)
end

ys.Battle.BattleGuideWave.SetWaveData = function (slot0, slot1)
	slot0.super.SetWaveData(slot0, slot1)

	slot0._guideType = slot0._param.type or 0
	slot0._guideStep = slot0._param.id
	slot0._event = slot0._param.event
end

ys.Battle.BattleGuideWave.DoWave = function (slot0)
	slot0.super.DoWave(slot0)

	if not pg.GuideMgr.ENABLE_GUIDE then
		slot0:doPass()
	elseif slot0._guideType == 1 and pg.SeriesGuideMgr.GetInstance():isEnd() then
		slot0:doFail()
	else
		pg.GuideMgr.GetInstance():play(slot0._guideStep, {
			slot0._event
		}, function ()
			slot0:doPass()
		end)
	end
end

return
