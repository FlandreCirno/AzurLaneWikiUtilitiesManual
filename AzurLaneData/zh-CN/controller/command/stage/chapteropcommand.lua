slot0 = class("ChapterOpCommand", import(".ChapterOpRoutine"))

slot0.execute = function (slot0, slot1)
	if slot1:getBody().type == ChapterConst.OpSwitch then
		for slot8, slot9 in ipairs(getProxy(ChapterProxy).getActiveChapter(slot3).fleets) do
			if slot9.id == slot2.id then
				slot4.findex = slot8

				break
			end
		end

		slot3:updateChapter(slot4, bit.bor(ChapterConst.DirtyStrategy, ChapterConst.DirtyFleet))
		slot0:sendNotification(GAME.CHAPTER_OP_DONE, {
			type = slot2.type
		})
		pg.TipsMgr.GetInstance():ShowTips(i18n("formation_switch_success", slot4.fleet.name))

		return
	elseif slot2.type == ChapterConst.OpSkipBattle then
		slot3 = getProxy(ChapterProxy)
		slot4 = slot3:getActiveChapter()

		slot4:UpdateProgressAfterSkipBattle()
		slot3:updateChapter(slot4)
	end

	pg.ConnectionMgr.GetInstance():Send(13103, {
		act = slot2.type,
		group_id = defaultValue(slot2.id, 0),
		act_arg_1 = slot2.arg1,
		act_arg_2 = slot2.arg2
	}, 13104, function (slot0)
		if slot0.result == 0 then
			slot0:initData(false, slot0, getProxy(ChapterProxy).getActiveChapter(slot2))
			slot0:doDropUpdate()

			if slot0.chapter then
				slot0:doMapUpdate()
				slot0:doAIUpdate()
				slot0:doShipUpdate()
				slot0:doBuffUpdate()
				slot0:doCellFlagUpdate()
				slot0:doExtraFlagUpdate()

				if slot1.type == ChapterConst.OpRetreat then
					if not slot1.id then
						slot1.win = slot0.chapter:CheckChapterWillWin()

						if slot1.win then
							slot0.chapter:UpdateProgressOnRetreat()
						end

						slot4 = pg.TimeMgr.GetInstance()
						slot5 = slot2:getMapById(slot3:getConfig("map"))

						if slot1.win and slot5:getMapType() == Map.ELITE and slot4:IsSameDay(slot3:getStartTime(), slot4:GetServerTime()) then
							getProxy(DailyLevelProxy):EliteCountPlus()
						end

						if slot3:getPlayType() == ChapterConst.TypeMainSub and (slot1.win or not slot3:isValid()) then
							slot3:retreat(slot1.win)
							slot3:clearSubChapter()
							slot2:updateChapter(slot3, ChapterConst.DirtyMapItems)
							slot0:sendNotification(GAME.CHAPTER_OP_DONE, {
								type = slot1.type,
								win = slot1.win
							})

							return
						end
					end

					slot0:doRetreat()
				elseif slot1.type == ChapterConst.OpMove then
					slot0:doCollectAI()
					slot0:doMove()
					slot0:doTeleportByPortal()
				elseif slot1.type == ChapterConst.OpBox then
					slot0:doCollectAI()
					slot0:doOpenBox()
				elseif slot1.type == ChapterConst.OpStory then
					slot0:doCollectAI()
					slot0:doPlayStory()
				elseif slot1.type == ChapterConst.OpAmbush then
					slot0:doAmbush()
				elseif slot1.type == ChapterConst.OpStrategy then
					slot0:doCollectAI()
					slot0:doStrategy()
				elseif slot1.type == ChapterConst.OpRepair then
					slot0:doRepair()
				elseif slot1.type == ChapterConst.OpSupply then
					slot0:doSupply()
				elseif slot1.type == ChapterConst.OpEnemyRound then
					slot0:doCollectAI()
					slot0:doEnemyRound()
				elseif slot1.type == ChapterConst.OpSubState then
					slot0:doSubState()
				elseif slot1.type == ChapterConst.OpBarrier then
					slot0:doBarrier()
				elseif slot1.type == ChapterConst.OpRequest then
					slot0:doRequest()
				elseif slot1.type == ChapterConst.OpSkipBattle then
					slot0:doSkipBattle()
				elseif slot1.type == ChapterConst.OpSubTeleport then
					slot0:doTeleportSub()
					slot0:doTeleportByPortal()
				end

				if slot1.type ~= ChapterConst.OpEnemyRound and slot1.type ~= ChapterConst.OpMove then
					slot0.flag = bit.bor(slot0.flag, slot0.extraFlag)
				end

				slot2:updateChapter(slot0.chapter, slot0.flag)
				slot0:sendNotification(GAME.CHAPTER_OP_DONE, {
					type = slot1.type,
					id = slot1.id,
					arg1 = slot1.arg1,
					arg2 = slot1.arg2,
					path = slot0.move_path,
					fullpath = slot0.fullpath,
					items = slot0.items,
					exittype = slot1.exittype or 0,
					aiActs = slot0.aiActs,
					extraFlag = slot0.extraFlag or 0,
					oldLine = slot1.ordLine,
					extraFlagRemoveList = slot0.del_flag_list,
					extraFlagAddList = slot0.add_flag_list,
					win = slot1.win,
					teleportPaths = slot0.teleportPaths,
					chapterVO = slot0.chapter
				})
			end
		else
			warning(string.format("SLG操作%d 请求失效，重新拉取信息", slot1.type))
			pg.TipsMgr.GetInstance():ShowTips(errorTip("levelScene_operation", slot0.result))

			if pg.TipsMgr.GetInstance().ShowTips.type ~= ChapterConst.OpRequest and slot1.type ~= ChapterConst.OpRetreat and slot1.type ~= ChapterConst.OpSubTeleport then
				slot0:sendNotification(GAME.CHAPTER_OP, {
					type = ChapterConst.OpRequest,
					id = slot1.id
				})
			end
		end
	end)
end

slot0.PrepareChapterRetreat = function (slot0)
	seriesAsync({
		function (slot0)
			if getProxy(ChapterProxy):getActiveChapter():CheckChapterWillWin() then
				slot1:UpdateProgressOnRetreat()

				slot3 = slot1:getConfig("defeat_story")
				slot4 = false

				table.eachAsync(slot1:getConfig("defeat_story_count"), function (slot0, slot1, slot2)
					if slot0.defeatCount < slot1 then
						slot2()

						return
					end

					if not slot1[slot0] or pg.NewStoryMgr.GetInstance():IsPlayed(tostring(slot3)) then
						slot2()

						return
					end

					if type(slot3) == "number" then
						pg.m02:sendNotification(GAME.BEGIN_STAGE, {
							system = SYSTEM_PERFORM,
							stageId = slot3,
							exitCallback = slot2
						})
					elseif type(slot3) == "string" then
						if ChapterOpCommand.PlayChapterStory(slot3, slot2, not slot2 and slot0:IsAutoFight()) then
							slot2 = true
						end
					else
						slot2()
					end
				end, slot0)

				return
			end

			slot0()
		end,
		function (slot0)
			pg.m02:sendNotification(GAME.CHAPTER_OP, {
				type = ChapterConst.OpRetreat
			})
			slot0()
		end,
		slot0
	})
end

slot0.PlayChapterStory = function (slot0, slot1, slot2)
	pg.NewStoryMgr.GetInstance().Play(slot3, slot0, slot1)

	if not getProxy(SettingsProxy):GetStoryAutoPlayFlag() and slot2 and slot3:IsRunning() then
		slot3:Puase()
		pg.MsgboxMgr.GetInstance(slot5):ShowMsgBox({
			hideYes = true,
			parent = rtf(slot3._tf),
			type = MSGBOX_TYPE_STORY_CANCEL_TIP,
			onYes = function ()
				slot0()
				slot1:TriggerAutoBtn()
			end,
			onNo = function ()
				slot0:Resume()
			end,
			weight = LayerWeightConst.TOP_LAYER
		})

		return true
	end
end

return slot0
