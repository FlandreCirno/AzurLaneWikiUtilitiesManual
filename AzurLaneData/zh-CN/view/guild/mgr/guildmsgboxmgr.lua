pg = pg or {}
pg.GuildMsgBoxMgr = singletonClass("GuildMsgBoxMgr")

pg.GuildMsgBoxMgr.Ctor = function (slot0)
	slot0.ignores = {}
	slot0.refreshTime = pg.TimeMgr.GetInstance():GetServerTime()
end

pg.GuildMsgBoxMgr.Init = function (slot0, slot1)
	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetUI("GuildMsgBoxUI", true, function (slot0)
		pg.DelegateInfo.New(slot0)

		slot0._go = slot0

		slot0._go:SetActive(false)

		slot0._tf = slot0._go.transform
		slot0.UIOverlay = GameObject.Find("Overlay/UIOverlay")

		slot0._go.transform:SetParent(slot0.UIOverlay.transform, false)

		slot0.confirmBtn = findTF(slot0._go, "frame/confirm_btn")
		slot0.cancelBtn = findTF(slot0._go, "frame/cancel_btn")

		setText(slot0.cancelBtn:Find("Text"), i18n("text_iknow"))
		setText(slot0.confirmBtn:Find("Text"), i18n("text_forward"))

		slot0.contextTxt = findTF(slot0._go, "frame/content/Text"):GetComponent(typeof(Text))

		onButton(slot0, slot0.cancelBtn, function ()
			slot0:Hide()
		end, SFX_PANEL)
		onButton(slot0, slot0._tf, function ()
			slot0:Hide()
		end, SFX_PANEL)
		onButton(slot0, findTF(slot0._go, "frame/close"), function ()
			slot0:Hide()
		end, SFX_PANEL)
		pg.UIMgr.GetInstance().LoadingOff(slot1)

		slot0.isInited = true

		if slot0 then
			slot1()
		end
	end)
end

pg.GuildMsgBoxMgr.Notification = function (slot0, slot1)
	if slot1.condition() then
		if not slot0.isInited then
			slot0:Init(function ()
				slot0:RefreshView(slot0)
			end)
		else
			slot0.RefreshView(slot0, slot1)
		end
	end
end

pg.GuildMsgBoxMgr.RefreshView = function (slot0, slot1)
	slot0.settings = slot1

	setActive(slot0._tf, true)

	slot0.contextTxt.text = slot1.content or ""

	onButton(slot0, slot0.confirmBtn, function ()
		if slot0.OnYes then
			slot0.OnYes()
		end

		slot1:Close()
	end, SFX_PANEL)
	pg.UIMgr.GetInstance(slot2):BlurPanel(slot0._tf, false, {
		weight = LayerWeightConst.TOP_LAYER,
		blurCamList = slot1.blurCamList
	})
	slot0._tf:SetAsLastSibling()
end

pg.GuildMsgBoxMgr.Close = function (slot0)
	if slot0._tf and isActive(slot0._tf) then
		slot0.settings = nil

		pg.UIMgr:GetInstance():UnblurPanel(slot0._tf, slot0.UIOverlay)
		setActive(slot0._tf, false)
	end
end

pg.GuildMsgBoxMgr.Hide = function (slot0)
	if slot0._tf and isActive(slot0._tf) and slot0.settings.OnHide then
		slot0.settings.OnHide()
	end

	slot0:Close()
end

pg.GuildMsgBoxMgr.Destroy = function (slot0)
	if slot0.isInited then
		pg.DelegateInfo.Dispose(slot0)

		slot0.isInited = nil

		Destroy(slot0._go)
	end
end

pg.GuildMsgBoxMgr.NotificationForGuildEvent = function (slot0, slot1)
	if getProxy(GuildProxy):getRawData() then
		if slot2:GetActiveWeeklyTask() and slot1.id == slot3:GetPresonTaskId() then
			slot0:Notification({
				condition = function ()
					return slot0:SamePrivateTaskType(GuildTask.PRIVATE_TASK_TYPE_EVENT) and slot0:PrivateBeFinished()
				end,
				content = i18n("guild_mission_complate", slot3.GetPrivateTaskName(slot3)),
				OnYes = function ()
					pg.m02:sendNotification(GuildMainMediator.SWITCH_TO_OFFICE)
				end
			})
		end
	end
end

pg.GuildMsgBoxMgr.OnBeginBattle = function (slot0)
	if not getProxy(GuildProxy) then
		return
	end

	if getProxy(GuildProxy):getRawData() then
		slot0.taskFinished = slot1:GetActiveWeeklyTask() and slot2:PrivateBeFinished() and slot2:SamePrivateTaskType(GuildTask.PRIVATE_TASK_TYPE_BATTLE)

		print("taskFinished : ", slot0.taskFinished)
	end
end

pg.GuildMsgBoxMgr.OnFinishBattle = function (slot0, slot1)
	if not getProxy(GuildProxy) then
		return
	end

	if getProxy(GuildProxy):getRawData() and slot1 and SYSTEM_SCENARIO <= slot1.system and slot1.system <= SYSTEM_WORLD then
		slot4 = slot2:GetActiveWeeklyTask() and slot3:PrivateBeFinished() and slot3:SamePrivateTaskType(GuildTask.PRIVATE_TASK_TYPE_BATTLE)

		if not slot0.taskFinished and slot4 then
			slot0.shouldShowBattleTip = true
		end
	end

	slot0.taskFinished = nil
end

pg.GuildMsgBoxMgr.NotificationForBattle = function (slot0, slot1)
	if slot0.shouldShowBattleTip then
		if getProxy(GuildProxy):getRawData() and slot2:GetActiveWeeklyTask() then
			slot4 = false

			seriesAsync({
				function (slot0)
					slot0:SubmitTask(function (slot0, slot1, slot2)
						slot0 = slot0

						slot1()
					end)
				end,
				function (slot0)
					slot1 = (slot0 and "\n" .. i18n("guild_task_autoaccept_2", slot1:GetPrivateTaskName())) or ""
					slot3 = {
						pg.UIMgr.CameraLevel
					}

					if getProxy(ChapterProxy):getActiveChapter() and slot2:CheckChapterWin() then
						slot3 = nil
					end

					slot2:Notification({
						condition = function ()
							return true
						end,
						content = i18n("guild_mission_complate", slot1.GetPrivateTaskName(slot9)) .. slot1,
						OnYes = function ()
							pg.m02:sendNotification(GAME.GO_SCENE, SCENE.GUILD, {
								page = "office"
							})
						end,
						blurCamList = slot3,
						OnHide = slot3
					})
				end
			})
		elseif slot1 then
			slot1()
		end
	elseif slot1 then
		slot1()
	end

	slot0.shouldShowBattleTip = nil
end

pg.GuildMsgBoxMgr.NotificationForDailyBattle = function (slot0)
	if slot0.shouldShowBattleTip then
		if getProxy(GuildProxy):getRawData() and slot1:GetActiveWeeklyTask() then
			slot3 = false

			seriesAsync({
				function (slot0)
					slot0:SubmitTask(function (slot0, slot1, slot2)
						slot0 = slot0

						slot1()
					end)
				end,
				function ()
					slot2:Notification({
						condition = function ()
							return true
						end,
						content = i18n("guild_mission_complate", slot1.GetPrivateTaskName(slot6)) .. ((slot0 and "\n" .. i18n("guild_task_autoaccept_2", slot1:GetPrivateTaskName())) or ""),
						OnYes = function ()
							pg.m02:sendNotification(GAME.GO_SCENE, SCENE.GUILD, {
								page = "office"
							})
						end
					})
				end
			})
		end
	end

	slot0.shouldShowBattleTip = nil
end

pg.GuildMsgBoxMgr.NotificationForWorld = function (slot0, slot1)
	if slot0.shouldShowBattleTip then
		if getProxy(GuildProxy):getRawData() and slot2:GetActiveWeeklyTask() then
			slot4 = false

			seriesAsync({
				function (slot0)
					slot0:SubmitTask(function (slot0, slot1, slot2)
						slot0 = slot0

						slot1()
					end)
				end,
				function ()
					slot2:Notification({
						condition = function ()
							return true
						end,
						content = i18n("guild_mission_complate", slot1.GetPrivateTaskName(slot6)) .. ((slot0 and "\n" .. i18n("guild_task_autoaccept_2", slot1:GetPrivateTaskName())) or ""),
						OnYes = function ()
							pg.m02:sendNotification(GAME.GO_SCENE, SCENE.GUILD, {
								page = "office"
							})
						end,
						OnHide = 
					})
				end
			})
		elseif slot1 then
			slot1()
		end
	elseif slot1 then
		slot1()
	end

	slot0.shouldShowBattleTip = nil
end

pg.GuildMsgBoxMgr.NotificationForMain = function (slot0)
	if not getProxy(GuildProxy):getRawData() then
		return
	end

	if not slot1:GetActiveEvent() or not slot2:IsParticipant() then
		return
	end

	function slot3()
		slot0:Notification({
			condition = function ()
				slot2, slot3 = getProxy(GuildProxy):getRawData().GetActiveEvent(slot0).AnyMissionFirstFleetCanFroamtion(slot1)

				if slot2 and not table.contains(slot0.ignores, slot3.id) then
					table.insert(slot0.ignores, slot3.id)

					return true
				end

				return false
			end,
			content = i18n("guild_operation_event_occurrence"),
			OnYes = function ()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.GUILD, {
					page = "battle"
				})
			end
		})
	end

	function slot4(slot0, slot1)
		pg.m02:sendNotification(GAME.GUILD_REFRESH_MISSION, {
			force = true,
			id = slot0,
			callback = slot1
		})

		slot0.refreshTime = pg.TimeMgr.GetInstance():GetServerTime()
	end

	slot5 = pg.TimeMgr.GetInstance().GetServerTime(slot5) - slot0.refreshTime > 900
	slot6, slot7 = slot2:AnyMissionFirstFleetCanFroamtion()

	if slot6 and slot7 and table.contains(slot0.ignores, slot7.id) then
		return
	end

	if slot6 then
		slot3()
	elseif slot5 then
		if slot2:GetUnlockMission() then
			slot4(slot8.id, function ()
				if slot0:GetUnlockMission() and slot0.id ~=  then
					slot2(slot0.id, slot3)
				else
					slot3()
				end
			end)

			return
		end

		slot3()
	else
		slot3()
	end
end

pg.GuildMsgBoxMgr.GetShouldShowBattleTip = function (slot0)
	return slot0.shouldShowBattleTip
end

pg.GuildMsgBoxMgr.CancelShouldShowBattleTip = function (slot0)
	slot0.shouldShowBattleTip = nil
end

pg.GuildMsgBoxMgr.SubmitTask = function (slot0, slot1)
	slot1 = slot1 or function ()
		return
	end

	if not getProxy(GuildProxy).getRawData(slot2) then
		slot1()

		return
	end

	if not (slot2 and slot2:GetActiveWeeklyTask()) then
		slot1()

		return
	end

	if slot3 and slot3:isFinished() then
		slot1()

		return
	end

	if (getProxy(TaskProxy):getTaskById(slot3:GetPresonTaskId()) or slot5:getFinishTaskById(slot4)) and not slot6:isFinish() then
		slot1()

		return
	end

	if not slot2:hasWeeklyTaskFlag() then
		slot1(false, false, slot4)

		return
	end

	slot8 = false
	slot9 = {}

	if slot6 and slot6:isFinish() and not slot6:isReceive() then
		table.insert(slot9, function (slot0)
			pg.m02:sendNotification(GAME.SUBMIT_TASK, slot0, function (slot0)
				slot0 = slot0

				slot1()
			end)
		end)
	end

	table.insert(slot9, function (slot0)
		slot1 = slot0:getTaskById(slot0.getTaskById) or slot0:getFinishTaskById(slot0.getFinishTaskById)

		if slot2 and not slot2:isFinished() and (not slot1 or (slot1 and slot1:isFinish() and slot1:isReceive())) then
			pg.m02:sendNotification(GAME.TRIGGER_TASK, slot1, slot0)
		else
			slot0()
		end
	end)
	seriesAsync(slot9, function ()
		slot0(slot0:getTaskById(slot0) ~= nil, slot3, slot0)
	end)
end

return
