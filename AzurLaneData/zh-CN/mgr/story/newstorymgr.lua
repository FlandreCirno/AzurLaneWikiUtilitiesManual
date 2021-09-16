pg = pg or {}
pg.NewStoryMgr = singletonClass("NewStoryMgr")
slot1 = 1
slot2 = 2
slot3 = 3
slot4 = 4
slot5 = 5
slot6 = 6
slot7 = 7

require("Mgr/Story/Include")

slot8 = true

function slot9(...)
	if slot0 and Application.isEditor then
		print(...)
	end
end

slot10 = {
	"",
	"JP",
	"KR",
	"US"
}

function LoadStory(slot0)
	slot1 = slot0[PLATFORM_CODE]

	if slot0 == "index" then
		slot0 = slot0 .. slot1
	end

	slot2 = nil
	slot2 = (PLATFORM_CODE == PLATFORM_JP and "GameCfg.story" .. slot1 .. "." .. slot0) or "GameCfg.story" .. "." .. slot0
	slot3, slot4 = pcall(function ()
		return require(require)
	end)

	if not slot3 then
		errorMsg("不存在剧情ID对应的Lua:" .. slot0)
	end

	return slot3 and slot4
end

pg.NewStoryMgr.SetData = function (slot0, slot1)
	slot0.playedList = {}

	for slot5, slot6 in ipairs(slot1) do
		slot7 = slot6

		if slot6 == 20008 then
			slot7 = 1131
		end

		if slot6 == 20009 then
			slot7 = 1132
		end

		if slot6 == 20010 then
			slot7 = 1133
		end

		if slot6 == 20011 then
			slot7 = 1134
		end

		if slot6 == 20012 then
			slot7 = 1135
		end

		if slot6 == 20013 then
			slot7 = 1136
		end

		if slot6 == 20014 then
			slot7 = 1137
		end

		slot0.playedList[slot7] = true
	end
end

pg.NewStoryMgr.SetPlayedFlag = function (slot0, slot1)
	slot0("Update story id", slot1)

	slot0.playedList[slot1] = true
end

pg.NewStoryMgr.GetPlayedFlag = function (slot0, slot1)
	return slot0.playedList[slot1]
end

pg.NewStoryMgr.IsPlayed = function (slot0, slot1, slot2)
	slot7, slot4 = slot0:StoryName2StoryId(slot1)
	slot5 = slot0:GetPlayedFlag(slot3)
	slot6 = true

	if slot4 and not slot2 then
		slot6 = slot0:GetPlayedFlag(slot4)
	end

	return slot5 and slot6
end

function slot11(slot0)
	slot1 = {}

	for slot5, slot6 in pairs(slot0) do
		slot1[slot6] = slot5
	end

	return slot1
end

pg.NewStoryMgr.StoryName2StoryId = function (slot0, slot1)
	if not slot0.indexs then
		slot0.indexs = slot1(LoadStory("index"))
	end

	if not slot0.againIndexs then
		slot0.againIndexs = slot1(LoadStory("index_again"))
	end

	return slot0.indexs[slot1], slot0.againIndexs[slot1]
end

pg.NewStoryMgr.StoryId2StoryName = function (slot0, slot1)
	if not slot0.indexIds then
		slot0.indexIds = LoadStory("index")
	end

	if not slot0.againIndexIds then
		slot0.againIndexIds = LoadStory("index_again")
	end

	return slot0.indexIds[slot1], slot0.againIndexIds[slot1]
end

pg.NewStoryMgr.StoryLinkNames = function (slot0, slot1)
	if not slot0.linkNames then
		slot0.linkNames = LoadStory("index_link")
	end

	return slot0.linkNames[slot1]
end

pg.NewStoryMgr.Init = function (slot0, slot1)
	slot0.state = slot0
	slot0.playedList = {}
	slot0.playQueue = {}

	PoolMgr.GetInstance():GetUI("NewStoryUI", true, function (slot0)
		slot0._go = slot0
		slot0._tf = tf(slot0._go)
		slot0.UIOverlay = GameObject.Find("Overlay/UIOverlay")

		slot0._go.transform:SetParent(slot0.UIOverlay.transform, false)

		slot0.skipBtn = findTF(slot0._tf, "btns/skip_button")
		slot0.autoBtn = findTF(slot0._tf, "btns/auto_button")
		slot0.players = {
			AsideStoryPlayer.New(slot0),
			DialogueStoryPlayer.New(slot0),
			BgStoryPlayer.New(slot0),
			CarouselPlayer.New(slot0)
		}

		setActive(slot0._go, false)

		slot0.state = slot0

		if slot0 then
			slot2()
		end
	end)
end

pg.NewStoryMgr.Play = function (slot0, slot1, slot2, slot3, slot4)
	table.insert(slot0.playQueue, {
		slot1,
		slot2
	})

	if #slot0.playQueue == 1 then
		slot5 = nil

		function slot5()
			if #slot0.playQueue == 0 then
				return
			end

			slot1 = slot0.playQueue[1][2]

			slot0:SoloPlay(slot0.playQueue[1][1], function (slot0, slot1)
				if slot0 then
					slot0(slot0, slot1)
				end

				table.remove(slot1.playQueue, 1)
				table.remove()
			end, slot0.SoloPlay, slot0)
		end

		slot5()
	end
end

pg.NewStoryMgr.Puase = function (slot0)
	if slot0.state ~= slot0 then
		slot1("state is not 'running'")

		return
	end

	slot0.state = slot2

	for slot4, slot5 in ipairs(slot0.players) do
		slot5:Pause()
	end
end

pg.NewStoryMgr.Resume = function (slot0)
	if slot0.state ~= slot0 then
		slot1("state is not 'pause'")

		return
	end

	slot0.state = slot2

	for slot4, slot5 in ipairs(slot0.players) do
		slot5:Resume()
	end
end

pg.NewStoryMgr.Stop = function (slot0)
	if slot0.state ~= slot0 then
		slot1("state is not 'running'")

		return
	end

	slot0.state = slot2

	for slot4, slot5 in ipairs(slot0.players) do
		slot5:Stop()
	end
end

pg.NewStoryMgr.AutoPlay = function (slot0, slot1, slot2, slot3, slot4, slot5)
	slot0.optionSelCodes = slot2 or {}
	slot0.autoPlayFlag = true

	slot0:Play(slot1, slot3, slot4, slot5)
end

pg.NewStoryMgr.SeriesPlay = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = {}

	for slot9, slot10 in ipairs(slot1) do
		table.insert(slot5, function (slot0)
			slot0:SoloPlay(slot0.SoloPlay, slot0, slot0, )
		end)
	end

	seriesAsync(slot5, slot2)
end

pg.NewStoryMgr.SoloPlay = function (slot0, slot1, slot2, slot3, slot4)
	slot0("Play Story:", slot1)

	slot5 = 1

	function slot6(slot0, slot1)
		slot0 = slot0 - 1

		if slot1 and slot0 == 0 then
			onNextTick(function ()
				slot0(slot1, slot2)
			end)
		end
	end

	if not LoadStory(slot1) then
		slot6(false)
		slot0("not exist story file")

		return nil
	end

	if slot0:IsReView() then
		slot3 = true
	end

	slot0.storyScript = Story.New(slot7, slot3, slot0.optionSelCodes)

	if not slot0:CheckState() then
		slot0("story state error")
		slot6(false)

		return nil
	end

	if not slot0.storyScript:CanPlay() then
		slot0("story cant be played")
		slot6(false)

		return nil
	end

	slot0:OnStart()

	slot8 = {}
	slot0.currPlayer = nil

	for slot12, slot13 in ipairs(slot0.storyScript.steps) do
		table.insert(slot8, function (slot0)
			slot0.currPlayer = slot0.players[slot1:GetMode()]

			slot0.players[slot1.GetMode()]:Play(slot0.storyScript, slot0.players[slot1.GetMode()].Play, slot0)
		end)
	end

	seriesAsync(slot8, function ()
		slot0:OnEnd(slot0)
	end)
end

pg.NewStoryMgr.CheckState = function (slot0)
	if slot0.state == slot0 or slot0.state ==  or slot0.state == slot2 then
		return false
	end

	return true
end

pg.NewStoryMgr.RegistSkipBtn = function (slot0)
	function slot1()
		slot0.storyScript:SkipAll()
		slot0.storyScript.SkipAll.currPlayer:NextOneImmediately()
	end

	onButton(slot0, slot0.skipBtn, function ()
		if slot0:IsStopping() or slot0:IsPausing() then
			return
		end

		if not slot0.currPlayer:CanSkip() then
			return
		end

		if slot0.storyScript:GetAutoPlayFlag() then
			slot0.storyScript:StopAutoPlay()
			slot0.storyScript.StopAutoPlay:UpdateAutoBtn()
		end

		if slot0:IsReView() or slot0.storyScript:IsPlayed() or not slot0.storyScript:ShowSkipTip() then
			slot1()

			return
		end

		slot0:Puase()
		pg.MsgboxMgr:GetInstance():ShowMsgBox({
			parent = rtf(slot0._tf),
			content = i18n("story_skip_confirm"),
			onYes = function ()
				slot0:Resume()
				slot0()
			end,
			onNo = function ()
				slot0:Resume()
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	end, SFX_PANEL)
end

pg.NewStoryMgr.RegistAutoBtn = function (slot0)
	onButton(slot0, slot0.autoBtn, function ()
		if slot0:IsStopping() or slot0:IsPausing() then
			return
		end

		if slot0.storyScript:GetAutoPlayFlag() then
			slot0.storyScript:StopAutoPlay()
		else
			slot0.storyScript:SetAutoPlay()
			slot0.storyScript.SetAutoPlay.currPlayer:NextOne()
		end

		if slot0.storyScript then
			slot0:UpdateAutoBtn()
		end
	end, SFX_PANEL)

	if slot0.IsAutoPlay(slot0) then
		slot0.storyScript:SetAutoPlay()
		slot0:UpdateAutoBtn()

		slot0.autoPlayFlag = false
	end
end

pg.NewStoryMgr.TriggerAutoBtn = function (slot0)
	if not slot0:IsRunning() then
		return
	end

	triggerButton(slot0.autoBtn)
end

pg.NewStoryMgr.OnStart = function (slot0)
	removeOnButton(slot0._go)
	removeOnButton(slot0.skipBtn)
	removeOnButton(slot0.autoBtn)

	slot0.state = slot0

	pg.m02:sendNotification(GAME.STORY_BEGIN, slot0.storyScript:GetName())
	pg.m02:sendNotification(GAME.STORY_UPDATE, {
		storyId = slot0.storyScript:GetName()
	})
	pg.DelegateInfo.New(slot0)

	for slot4, slot5 in ipairs(slot0.players) do
		slot5:StoryStart(slot0.storyScript)
	end

	setActive(slot0._go, true)
	slot0._tf:SetAsLastSibling()
	setActive(slot0.skipBtn, not slot0.storyScript:ShouldHideSkip())
	setActive(slot0.autoBtn:Find("sel"), false)
	setActive(slot0.autoBtn:Find("unsel"), true)
	setActive(slot0.autoBtn, true)
	slot0:RegistSkipBtn()
	slot0:RegistAutoBtn()
end

pg.NewStoryMgr.UpdateAutoBtn = function (slot0)
	setActive(slot0.autoBtn:Find("sel"), slot1)
	setActive(slot0.autoBtn:Find("unsel"), not slot0.storyScript:GetAutoPlayFlag())
end

pg.NewStoryMgr.Clear = function (slot0)
	slot0.autoPlayFlag = false

	removeOnButton(slot0._go)
	removeOnButton(slot0.skipBtn)

	if isActive(slot0._go) then
		pg.DelegateInfo.Dispose(slot0)
	end

	setActive(slot0.skipBtn, false)
	setActive(slot0._go, false)

	for slot4, slot5 in ipairs(slot0.players) do
		slot5:StoryEnd(slot0.storyScript)
	end

	slot0.optionSelCodes = nil

	pg.CriMgr.GetInstance():ResumeLastNormalBGM()
	pg.m02:sendNotification(GAME.STORY_END)
end

pg.NewStoryMgr.OnEnd = function (slot0, slot1)
	slot0:Clear()

	if slot0.state == slot0 or slot0.state == slot1 then
		slot0.state = slot2

		if slot0.storyScript:GetNextScriptName() and not slot0:IsReView() then
			slot0.storyScript = nil

			slot0:Play(slot2, slot1)
		else
			slot3 = slot0.storyScript:GetBranchCode()
			slot0.storyScript = nil

			if slot1 then
				slot1(true, slot3)
			end
		end
	else
		slot0.state = slot2

		if slot1 then
			slot1(true, code)
		end
	end
end

pg.NewStoryMgr.OnSceneEnter = function (slot0, slot1)
	if not slot0.scenes then
		slot0.scenes = {}
	end

	slot0.scenes[slot1.view] = true
end

pg.NewStoryMgr.OnSceneExit = function (slot0, slot1)
	if not slot0.scenes then
		return
	end

	slot0.scenes[slot1.view] = nil
end

pg.NewStoryMgr.IsReView = function (slot0)
	return slot0.scenes[WorldMediaCollectionScene.__cname] == true or (getProxy(ContextProxy):GetPrevContext(1) and getProxy(ContextProxy).GetPrevContext(1).mediator == WorldMediaCollectionMediator)
end

pg.NewStoryMgr.IsRunning = function (slot0)
	return slot0.state == slot0
end

pg.NewStoryMgr.IsStopping = function (slot0)
	return slot0.state == slot0
end

pg.NewStoryMgr.IsPausing = function (slot0)
	return slot0.state == slot0
end

pg.NewStoryMgr.IsAutoPlay = function (slot0)
	return getProxy(SettingsProxy):GetStoryAutoPlayFlag() or slot0.autoPlayFlag == true
end

pg.NewStoryMgr.Quit = function (slot0)
	slot0.state = slot0
	slot0.storyScript = nil
	slot0.playQueue = {}
	slot0.playedList = {}
	slot0.scenes = {}
end

pg.NewStoryMgr.Fix = function (slot0)
	slot4 = {
		10020,
		10021,
		10022,
		10023,
		10024,
		10025,
		10026,
		10027
	}

	if getProxy(PlayerProxy):getRawData().GetRegisterTime(slot1) <= pg.TimeMgr.GetInstance():parseTimeFromConfig({
		{
			2021,
			4,
			8
		},
		{
			9,
			0,
			0
		}
	}) then
		_.each(slot4, function (slot0)
			slot0.playedList[slot0] = true
		end)
	end

	slot5 = 5001
	slot7 = getProxy(TaskProxy)
	slot8 = 0

	for slot12 = slot5, 5020, -1 do
		if slot7:getFinishTaskById(slot12) or slot7:getTaskById(slot12) then
			slot8 = slot12

			break
		end
	end

	for slot12 = slot8, slot6, -1 do
		if pg.task_data_template[slot12] and slot13.story_id and #slot14 > 0 and not slot0:IsPlayed(slot14) then
			slot0.playedList[slot14] = true
		end
	end

	if getProxy(ActivityProxy):getActivityById(ActivityConst.JYHZ_ACTIVITY_ID) and not slot9:isEnd() then
		slot11 = nil

		for slot15 = #_.flatten(slot9:getConfig("config_data")), 1, -1 do
			if pg.task_data_template[slot10[slot15]].story_id and #slot16 > 0 then
				slot17 = slot0:IsPlayed(slot16)

				if slot11 then
					if not slot17 then
						slot0.playedList[slot16] = true
					end
				elseif slot17 then
					slot11 = slot15
				end
			end
		end
	end
end

return
