pg = pg or {}
pg.SystemGuideMgr = singletonClass("SystemGuideMgr")
slot1 = nil

pg.SystemGuideMgr.Init = function (slot0, slot1)
	slot0 = require("GameCfg.guide.newguide.SSG001")

	slot1()
end

function slot2(slot0)
	if getProxy(PlayerProxy) then
		return pg.NewStoryMgr.GetInstance():IsPlayed(slot0, noAgain)
	end

	return false
end

function slot3(slot0)
	if slot0 then
		slot0()
	end
end

function slot4(slot0, slot1, slot2)
	if pg.SeriesGuideMgr.GetInstance():isRunning() then
		slot0(slot2)

		return
	end

	if slot1(slot0) then
		slot0(slot2)

		return
	end

	if not pg.GuideMgr.GetInstance():canPlay() then
		slot0(slot2)

		return
	end

	if slot0 == "SYG001" then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_TUTORIAL_COMPLETE_2)
	elseif slot0 == "SYG003" then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_TUTORIAL_COMPLETE_3)
	elseif slot0 == "SYG006" then
		pg.TrackerMgr.GetInstance():Tracking(TRACKING_TUTORIAL_COMPLETE_4)
	end

	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = slot0
	})
	pg.GuideMgr.GetInstance():play(slot0, slot1, slot2)
end

pg.SystemGuideMgr.Play = function (slot0, slot1, slot2)
	if Application.isEditor and not ENABLE_GUIDE then
		if slot2 then
			slot2()
		end

		return
	end

	if slot1.exited then
		return
	end

	if not slot0[slot1.__cname] then
		slot1(slot2)

		return
	end

	if not _.detect(slot3, function (slot0)
		return not slot0(slot0.id) and slot0.condition(slot1)
	end) then
		slot1(slot2)

		return
	end

	slot3(slot4.id, slot6(slot1), slot2)
end

pg.SystemGuideMgr.PlayChapter = function (slot0, slot1, slot2)
	if slot1:getPlayType() == ChapterConst.TypeMainSub then
		slot0:PlayByGuideId("NG003", nil, slot2)
	elseif slot1.id == 1160002 then
		slot0:PlayByGuideId("NG0011", nil, slot2)
	elseif slot1:isTypeDefence() then
		slot0:PlayByGuideId("NG0016", nil, slot2)
	else
		existCall(slot2)
	end
end

pg.SystemGuideMgr.PlayByGuideId = function (slot0, slot1, slot2, slot3)
	slot0(slot1, slot2, slot3)
end

pg.SystemGuideMgr.FixGuide = function (slot0, slot1)
	if not slot0("FixGuide") then
		slot1("FixGuide")
		slot1()
	end
end

pg.SystemGuideMgr.PlayDailyLevel = function (slot0, slot1)
	if not slot0("NG0015") then
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = "NG0015"
		})
		slot1()
	end
end

pg.SystemGuideMgr.PlayBackYardThemeTemplate = function (slot0)
	if not slot0("NG0020") and getProxy(DormProxy):getData():IsMaxLevel() then
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			modal = true,
			hideNo = true,
			hideClose = true,
			content = i18n("open_backyard_theme_template_tip"),
			weight = LayerWeightConst.TOP_LAYER
		})
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = "NG0020"
		})
	end
end

pg.SystemGuideMgr.PlayCommander = function (slot0)
	slot1 = {
		"ZHIHUIMIAO2",
		"NG006",
		"NG007",
		"ZHIHUIMIAO3",
		"NG008",
		"ZHIHUIMIAO4",
		"NG009"
	}

	if not LOCK_CATTERY then
		table.insert(slot1, "NG0029")
	end

	slot2 = _.select(slot1, function (slot0)
		return not slot0(slot0)
	end)
	slot3 = {}
	slot4 = nil

	for slot8, slot9 in ipairs(slot2) do
		table.insert(slot3, function (slot0)
			if (slot0 == "NG006" and table.getCount(getProxy(CommanderProxy):getData()) >= 1) or (slot0 == "NG007" and getProxy(BagProxy):getItemCountById(20012) ~= 1) or (slot0 == "NG008" and getProxy(CommanderProxy):getBoxes()[1]:getState() ~= CommanderBox.STATE_FINISHED) or (slot0 == "NG009" and table.getCount(getProxy(CommanderProxy):getData()) ~= 1) then
				pg.m02:sendNotification(GAME.STORY_UPDATE, {
					storyId = slot0
				})
				slot0()
			elseif slot0 == "ZHIHUIMIAO2" or slot0 == "ZHIHUIMIAO3" or slot0 == "ZHIHUIMIAO4" then
				pg.NewStoryMgr.GetInstance():Play(slot0, slot0, true)
			elseif slot0 == "NG0029" then
				if slot1 == "NG009" then
					slot2(slot0, {
						1
					}, slot0)
				else
					slot2(slot0, {
						2
					}, slot0)
				end
			else
				slot1 = slot0

				slot2(slot0, {}, slot0)
			end
		end)
	end

	seriesAsync(slot3)
end

pg.SystemGuideMgr.PlayGuildAssaultFleet = function (slot0, slot1)
	slot0:PlayByGuideId("GNG001", {}, callback)
end

return
