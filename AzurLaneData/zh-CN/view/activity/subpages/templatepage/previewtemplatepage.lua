slot0 = class("PreviewTemplatePage", import("view.base.BaseActivityPage"))

slot0.OnInit = function (slot0)
	slot0.bg = slot0:findTF("AD")
	slot0.btnList = slot0:findTF("btn_list", slot0.bg)
end

slot0.OnFirstFlush = function (slot0)
	slot0:initBtn()
end

slot0.initBtn = function (slot0)
	function slot1(slot0)
		if not getProxy(ActivityProxy):getActivityById(slot0) or (slot1 and slot1:isEnd()) then
			return true
		else
			return false
		end
	end

	slot2 = slot0.activity.getConfig(slot2, "config_client")
	slot3 = {
		task = function (slot0)
			onButton(slot0, slot0, function ()
				if slot0.taskLinkActID and slot1(slot0.taskLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				slot2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.TASK, {
					page = "activity"
				})
			end)
		end,
		shop = function (slot0)
			slot1 = _.detect(getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP), function (slot0)
				return slot0:getConfig("config_client").pt_id == pg.gameset.activity_res_id.key_value
			end)

			onButton(slot0, slot0, function ()
				if slot0.shopLinkActID and slot1(slot0.shopLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				slot3.actId = {
					warp = NewShopsScene.TYPE_ACTIVITY
				} and slot3.id

				slot2:emit(ActivityMediator.GO_SHOPS_LAYER, slot3)
			end)
		end,
		build = function (slot0)
			onButton(slot0, slot0, function ()
				if slot0.buildLinkActID and slot1(slot0.buildLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				slot2:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
					projectName = BuildShipScene.PROJECTS.ACTIVITY
				})
			end)
		end,
		fight = function (slot0)
			onButton(slot0, slot0, function ()
				if slot0.fightLinkActID and slot1(slot0.fightLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				slot2:emit(ActivityMediator.BATTLE_OPERA)
			end)
		end,
		lottery = function (slot0)
			onButton(slot0, slot0, function ()
				if slot0.lotteryLinkActID and slot1(slot0.lotteryLinkActID) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

					return
				end

				slot2:emit(ActivityMediator.GO_LOTTERY)
			end)
		end,
		memory = function (slot0)
			onButton(slot0, slot0, function ()
				return
			end)
		end,
		activity = function (slot0)
			onButton(slot0, slot0, function ()
				return
			end)
		end,
		mountain = function (slot0)
			onButton(slot0, slot0, function ()
				return
			end)
		end,
		skinshop = function (slot0)
			onButton(slot0, slot0, function ()
				pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP)
			end)
		end
	}

	eachChild(slot0.btnList, function (slot0)
		slot0[slot0.name](slot0)
	end)
end

return slot0
