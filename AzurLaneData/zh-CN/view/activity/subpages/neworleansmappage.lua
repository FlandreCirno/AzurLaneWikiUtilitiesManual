slot0 = class("NewOrleansMapPage", import("...base.BaseActivityPage"))

slot0.OnInit = function (slot0)
	slot0.bg = slot0:findTF("AD")
	slot0.item = slot0:findTF("item", slot0.bg)
	slot0.itemMask = slot0:findTF("icon_mask", slot0.item)
	slot0.gotaskBtn = slot0:findTF("gotask", slot0.bg)
	slot0.gobattleBtn = slot0:findTF("gobattle", slot0.bg)
end

slot0.OnDataSetting = function (slot0)
	slot0.taskIDList = _.flatten(slot1)
	slot0.taskProxy = getProxy(TaskProxy)
end

slot0.OnFirstFlush = function (slot0)
	onButton(slot0, slot0.gobattleBtn, function ()
		if not getProxy(ActivityProxy):getActivityById(pg.activity_const.NEW_ORLEANS_Map_BATTLE.act_id) or slot0:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

			return
		end

		slot0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
	onButton(slot0, slot0.gotaskBtn, function ()
		if not getProxy(ActivityProxy):getActivityById(pg.activity_const.NEW_ORLEANS_Map_BATTLE.act_id) or slot0:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

			return
		end

		slot0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
			page = "activity"
		})
	end)
end

slot0.OnUpdateFlush = function (slot0)
	slot0.curTaskVO = slot0.taskProxy:getTaskVO(slot2)

	updateDrop(slot0.item, slot5)
	onButton(slot0, slot0.item, function ()
		slot0:emit(BaseUI.ON_DROP, slot0)
	end, SFX_PANEL)
	setActive(slot0.itemMask, slot0.taskProxy.getTaskVO(slot2).getTaskStatus(slot3) == 2)
end

slot0.OnDestroy = function (slot0)
	return
end

slot0.findCurTaskIndex = function (slot0)
	slot1 = nil

	for slot5, slot6 in ipairs(slot0.taskIDList) do
		if slot0.taskProxy:getTaskVO(slot6).getTaskStatus(slot7) <= 1 then
			slot1 = slot5

			break
		elseif slot5 == #slot0.taskIDList then
			slot1 = slot5
		end
	end

	return slot1
end

return slot0
