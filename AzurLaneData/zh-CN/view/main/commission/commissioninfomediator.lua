slot0 = class("CommissionInfoMediator", import("...base.ContextMediator"))
slot0.FINISH_EVENT = "CommissionInfoMediator:FINISH_EVENT"
slot0.FINISH_CLASS = "CommissionInfoMediator:FINISH_CLASS"
slot0.GET_OIL_RES = "CommissionInfoMediator:GET_OIL_RES"
slot0.GET_GOLD_RES = "CommissionInfoMediator:GET_GOLD_RES"
slot0.ON_ACTIVE_EVENT = "CommissionInfoMediator:ON_ACTIVE_EVENT"
slot0.ON_ACTIVE_CLASS = "CommissionInfoMediator:ON_ACTIVE_CLASS"
slot0.ON_ACTIVE_TECH = "CommissionInfoMediator:ON_ACTIVE_TECH"
slot0.ON_TECH_TIME_OVER = "CommissionInfoMediator:ON_TECH_TIME_OVER"
slot0.ON_TECH_FINISHED = "CommissionInfoMediator:ON_TECH_FINISHED"
slot0.ON_INS = "CommissionInfoMediator:ON_INS"
slot0.ON_UR_ACTIVITY = "CommanderInfoMediator:ON_UR_ACTIVITY"

slot0.register = function (slot0)
	slot0.viewComponent:setProxies(slot1, slot2, slot3)
	slot0.viewComponent:setPlayer(getProxy(PlayerProxy).getData(slot4))
	slot0:bind(slot0.ON_UR_ACTIVITY, function (slot0)
		slot0:sendNotification(GAME.GO_SCENE, SCENE.ACTIVITY, {
			id = ActivityConst.UR_ITEM_ACT_ID
		})
	end)
	slot0.bind(slot0, slot0.ON_TECH_TIME_OVER, function (slot0, slot1, slot2)
		if getProxy(TechnologyProxy).getTechnologyById(slot3, slot1):canFinish() then
			slot4:finish()
			slot3:updateTechnology(slot4)
		end

		if slot2 then
			slot2()
		end
	end)
	slot0.bind(slot0, slot0.ON_TECH_FINISHED, function (slot0, slot1)
		slot0:sendNotification(GAME.FINISH_TECHNOLOGY, {
			id = slot1.id,
			pool_id = slot1.pool_id
		})
	end)
	slot0.bind(slot0, slot0.FINISH_EVENT, function (slot0, slot1, slot2)
		slot0.contextData.inFinished = true

		slot0:sendNotification(GAME.EVENT_FINISH, {
			id = slot1.id,
			callback = function ()
				slot0.contextData.inFinished = nil
			end,
			onConfirm = function ()
				if slot0 then
					slot0()
				end

				if slot1.contextData.oneStepFinishEventCount then
					slot1.contextData.oneStepFinishEventCount = slot1.contextData.oneStepFinishEventCount - 1

					if slot1.contextData.oneStepFinishEventCount <= 0 then
						slot1:sendNotification(GAME.TACTICS_META_LEVELMAX_SHOW_BOX)
					end
				else
					slot1:sendNotification(GAME.TACTICS_META_LEVELMAX_SHOW_BOX)
				end
			end
		})
	end)
	slot0.bind(slot0, slot0.FINISH_CLASS, function (slot0, slot1, slot2, slot3)
		slot0:sendNotification(GAME.CANCEL_LEARN_TACTICS, {
			shipId = slot1,
			type = slot2,
			onConfirm = slot3
		})
	end)
	slot0.bind(slot0, slot0.ON_ACTIVE_EVENT, function (slot0)
		slot0:sendNotification(GAME.GO_SCENE, SCENE.EVENT)
	end)
	slot0.bind(slot0, slot0.ON_ACTIVE_CLASS, function (slot0)
		slot0:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS)
	end)
	slot0.bind(slot0, slot0.ON_ACTIVE_TECH, function (slot0)
		slot0:sendNotification(GAME.GO_SCENE, SCENE.TECHNOLOGY)
	end)
	slot0.bind(slot0, slot0.GET_OIL_RES, function (slot0)
		slot0:sendNotification(GAME.HARVEST_RES, ResourceField.TYPE_OIL)
	end)
	slot0.bind(slot0, slot0.GET_GOLD_RES, function (slot0)
		slot0:sendNotification(GAME.HARVEST_RES, ResourceField.TYPE_GOLD)
	end)
	slot0.bind(slot0, slot0.ON_INS, function (slot0)
		slot0:sendNotification(GAME.ON_OPEN_INS_LAYER)
		slot0.viewComponent:emit(BaseUI.ON_CLOSE)
	end)
	slot0.Notify(slot0)
end

slot0.Notify = function (slot0)
	slot0.viewComponent:NotifyIns(getProxy(InstagramProxy), getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_INSTAGRAM))
	slot0.viewComponent:UpdateLinkPanel()
end

slot0.continueClass = function (slot0, slot1, slot2, slot3)
	slot5 = getProxy(BayProxy).getShipById(slot4, slot1)
	slot9 = table.getCount
	slot10 = getProxy(BagProxy).getItemsByType(slot7, 10) or {}

	if slot9(slot10) <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("tactics_no_lesson"))

		return
	end

	slot4:setSelectShipId(nil)
	slot0:sendNotification(GAME.GO_SCENE, SCENE.NAVALTACTICS, {
		shipToLesson = {
			shipId = slot1,
			skillIndex = slot5:getSkillIndex(slot2),
			index = slot3
		}
	})
end

slot0.listNotificationInterests = function (slot0)
	return {
		PlayerProxy.UPDATED,
		GAME.HARVEST_RES_DONE,
		GAME.EVENT_LIST_UPDATE,
		GAME.EVENT_SHOW_AWARDS,
		GAME.CANCEL_LEARN_TACTICS_DONE,
		GAME.FINISH_TECHNOLOGY_DONE
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == PlayerProxy.UPDATED then
		slot0.viewComponent:setPlayer(slot3)
	elseif slot2 == GAME.HARVEST_RES_DONE then
		slot4 = nil

		if slot3.type == 2 then
			slot4 = i18n("word_oil")
		elseif slot3.type == 1 then
			slot4 = i18n("word_gold")
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("commission_get_award", slot4, slot3.outPut))
	elseif slot2 == GAME.EVENT_LIST_UPDATE then
		slot4 = getProxy(EventProxy)

		slot0.viewComponent:updateProject(CommissionCard.TYPE_EVENT)
	else
		if slot2 == GAME.EVENT_SHOW_AWARDS then
			slot4 = nil
			slot5 = coroutine.wrap(function ()
				if #slot0.oldShips > 0 then
					slot1.viewComponent:emit(BaseUI.ON_SHIP_EXP, {
						title = pg.collection_template[slot0.eventId].title,
						oldShips = slot0.oldShips,
						newShips = slot0.newShips,
						isCri = slot0.isCri
					}, )
					coroutine.yield()
				end

				slot1.viewComponent:emit(BaseUI.ON_ACHIEVE, slot0.awards, function ()
					if slot0.onConfirm then
						slot0.onConfirm()
					end
				end)
			end)

			slot5()

			return
		end

		if slot2 == GAME.CANCEL_LEARN_TACTICS_DONE then
			slot0.viewComponent:updateProject(CommissionCard.TYPE_CLASS)

			slot7 = getProxy(BayProxy):getShipById(slot3.shipId)
			slot9 = nil
			slot9 = (slot3.oldSkill.level < slot3.newSkill.level and i18n("tactics_end_to_learn", slot7:getName(), getSkillName(slot3.newSkill.id), slot3.totalExp) .. i18n("tactics_skill_level_up", slot5.level, slot6.level)) or i18n("tactics_end_to_learn", slot7:getName(), getSkillName(slot3.newSkill.id), slot3.totalExp)

			if pg.skill_data_template[slot8].max_level <= slot6.level then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					modal = true,
					hideNo = true,
					hideClose = true,
					content = slot9,
					weight = LayerWeightConst.THIRD_LAYER,
					onYes = function ()
						if slot0.onConfirm then
							slot0.onConfirm(slot0.shipId, , slot0.id)
						end
					end
				})
			else
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					modal = true,
					hideNo = false,
					hideClose = true,
					content = slot9 .. i18n("tactics_continue_to_learn"),
					weight = LayerWeightConst.THIRD_LAYER,
					onYes = function ()
						slot0.openMsgBox = false

						slot0:continueClass(slot1.shipId, , slot1.id)
					end,
					onNo = function ()
						slot0.openMsgBox = false
					end
				})
			end
		elseif slot2 == GAME.FINISH_TECHNOLOGY_DONE then
			slot0.viewComponent.updateProject(slot4, CommissionCard.TYPE_TECHNOLOGY)

			slot6 = slot3.catchupItems
			slot7 = slot3.catchupActItems

			_.each(slot4, function (slot0)
				slot0.riraty = true

				table.insert(slot0, slot0)
			end)
			_.each(slot6, function (slot0)
				slot0.catchupTag = true

				table.insert(slot0, slot0)
			end)
			_.each(slot7, function (slot0)
				slot0.catchupActTag = true

				table.insert(slot0, slot0)
			end)

			if #slot3.commons > 0 then
				slot0.viewComponent.emit(slot8, BaseUI.ON_AWARD, {
					animation = true,
					items = slot5
				})
			end
		end
	end
end

return slot0
