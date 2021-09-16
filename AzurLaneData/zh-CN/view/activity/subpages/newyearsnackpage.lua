slot0 = class("NewYearSnackPage", import("...base.BaseActivityPage"))

slot0.OnInit = function (slot0)
	slot0.progressTpl = slot0:findTF("ProgressTpl")
	slot0.progressTplContainer = slot0:findTF("ProgressList")
	slot0.progressUIItemList = UIItemList.New(slot0.progressTplContainer, slot0.progressTpl)
	slot0.helpBtn = slot0:findTF("HelpBtn")
	slot0.goBtn = slot0:findTF("GoBtn")
end

slot0.OnDataSetting = function (slot0)
	slot4 = getProxy(MiniGameProxy):GetHubByHubId(slot3)
	slot0.needCount = slot4:getConfig("reward_need")
	slot0.leftCount = slot4.count
	slot0.playedCount = slot4.usedtime
	slot0.isGotAward = slot4.ultimate > 0
	slot0.curDay = slot0.leftCount + slot0.playedCount
end

slot0.OnFirstFlush = function (slot0)
	slot0.progressUIItemList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot4 = slot0:findTF("Unlocked", slot2)
			slot5 = slot0:findTF("Finished", slot2)
			slot6 = slot0:findTF("FinalFinished", slot2)

			setActive(slot0:findTF("Locked", slot2), slot0.curDay < slot1 + 1)

			if slot1 <= slot0.curDay then
				setActive(slot4, slot0.playedCount < slot1)
				setActive(slot5, slot1 <= slot0.playedCount and slot1 ~= slot0.needCount)
				setActive(slot6, slot1 <= slot0.playedCount and slot1 == slot0.needCount)
			else
				setActive(slot4, false)
				setActive(slot5, false)
				setActive(slot6, false)
			end
		end
	end)
	slot0.progressUIItemList.align(slot1, slot0.needCount)
	onButton(slot0, slot0.goBtn, function ()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 19, {
			callback = function ()
				SCENE.SetSceneInfo(slot0, SCENE.NEWYEAR_BACKHILL)
				getProxy(ContextProxy):PushContext2Prev(Context.New())
			end
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("help_xinnian2021__meishiyemian")
		})
	end, SFX_PANEL)
	slot0.tryGetFinalAward(slot0)
end

slot0.OnUpdateFlush = function (slot0)
	return
end

slot0.OnDestroy = function (slot0)
	return
end

slot0.tryGetFinalAward = function (slot0)
	slot4 = getProxy(MiniGameProxy):GetHubByHubId(slot3)
	slot5 = slot4.usedtime
	slot6 = slot4:getConfig("reward_need")
	slot7 = slot4.ultimate > 0

	if slot6 <= slot5 and not slot7 then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = slot4.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

slot0.IsTip = function ()
	if getProxy(ActivityProxy):getActivityById(pg.activity_const.NEWYEAR_SNACK_PAGE_ID.act_id) and not slot0:isEnd() then
		slot4 = getProxy(MiniGameProxy):GetHubByHubId(slot3)
		slot5 = slot4.usedtime
		slot6 = slot4:getConfig("reward_need")
		slot7 = slot4.ultimate > 0

		if slot6 <= slot5 and not slot7 then
			return true
		elseif slot4.count > 0 then
			return true
		else
			return false
		end
	end
end

return slot0
