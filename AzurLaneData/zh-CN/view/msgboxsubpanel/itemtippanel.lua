class("ItemTipPanel", import(".MsgboxSubPanel")).DetailConfig = {}

for slot4, slot5 in ipairs(pg.item_lack.all) do
	for slot10, slot11 in ipairs(pg.item_lack[slot5].itemids) do
		slot0.DetailConfig[slot11] = slot6
	end
end

slot0.ShowItemTip = function (slot0, slot1, slot2)
	if slot0 == DROP_TYPE_RESOURCE then
		slot1 = (pg.player_resource[slot1] and pg.player_resource[slot1].itemid) or nil
	elseif slot0 == DROP_TYPE_ITEM then
	else
		return
	end

	if not slot0.DetailConfig[slot1] then
		return
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		type = MSGBOX_TYPE_ITEMTIP,
		itemId = slot1,
		descriptions = slot0.DetailConfig[slot1].description,
		msgTitle = slot2,
		weight = LayerWeightConst.SECOND_LAYER
	})

	return true
end

slot0.ShowItemTipbyID = function (...)
	return slot0.ShowItemTip(DROP_TYPE_ITEM, ...)
end

slot0.CanShowTip = function (slot0)
	return tobool(slot0.DetailConfig[slot0])
end

slot0.ShowRingBuyTip = function ()
	GoShoppingMsgBox(i18n("switch_to_shop_tip_2", string.format("<color=#92FC63FF>%s</color>", pg.item_data_statistics[15006].name)), ChargeScene.TYPE_ITEM)
end

slot0.ShowGoldBuyTip = function (slot0)
	GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
		{
			59001,
			slot0 - getProxy(PlayerProxy):getRawData()[id2res(1)],
			slot0
		}
	})
end

slot0.ShowOilBuyTip = function (slot0)
	if not ShoppingStreet.getRiseShopId(ShopArgs.BuyOil, getProxy(PlayerProxy):getRawData().buyOilCount) then
		return
	end

	slot4 = pg.shop_template[slot2].num

	if pg.shop_template[slot2].num == -1 and slot3.genre == ShopArgs.BuyOil then
		slot4 = ShopArgs.getOilByLevel(slot1.level)
	end

	if pg.gameset.buy_oil_limit.key_value <= slot1.buyOilCount then
		return
	end

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		yseBtnLetf = true,
		type = MSGBOX_TYPE_SINGLE_ITEM,
		windowSize = {
			y = 570
		},
		content = i18n("oil_buy_tip_2", slot3.resource_num, slot4, slot1.buyOilCount, slot0 - slot1[id2res(2)]),
		drop = {
			id = 2,
			type = DROP_TYPE_RESOURCE,
			count = slot4
		},
		onYes = function ()
			pg.m02:sendNotification(GAME.SHOPPING, {
				count = 1,
				id = pg.m02.sendNotification
			})
		end,
		weight = LayerWeightConst.TOP_LAYER
	})

	return true
end

slot0.GetUIName = function (slot0)
	return "Msgbox4ItemGo"
end

slot0.OnInit = function (slot0)
	slot0.list = slot0:findTF("skipable_list")
	slot0.tpl = slot0:findTF("tpl", slot0.list)
	slot0.title = slot0:findTF("name")
end

slot0.OnRefresh = function (slot0, slot1)
	setActive(slot0.viewParent._btnContainer, false)
	setText(slot0.title, slot1.msgTitle or i18n("item_lack_title", pg.item_data_statistics[slot1.itemId].name, ))
	UIItemList.StaticAlign(slot0.list, slot0.tpl, #slot1.descriptions, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot4 = slot0[slot1 + 1][1]
			slot6 = slot0[slot1 + 1][3]
			slot8 = slot0[slot1 + 1][2][3]
			slot9 = slot2:Find("skip_btn")
			slot10 = #slot0[slot1 + 1][2][1] > 0

			if slot6 and slot6 ~= 0 then
				slot11 = getProxy(ActivityProxy):getActivityById(slot6)

				setActive(slot9, slot10 and slot11 and not slot11:isEnd())
			end

			if #slot7 > 0 then
				onButton(slot1, slot9, function ()
					slot0 = Clone(slot0[2]) or {}

					if slot1 == SCENE.SHOP and slot0.warp == "supplies" and not pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getRawData().level, "MilitaryExerciseMediator") then
						pg.TipsMgr.GetInstance():ShowTips(i18n("military_shop_no_open_tip"))

						return
					elseif slot1 == SCENE.LEVEL then
						slot1 = getProxy(ChapterProxy)

						if getProxy(PlayerProxy):getRawData() and slot2.leastChapterId then
							if not slot1:getMapById(slot1:getChapterById(slot3):getConfig("map")) then
								pg.TipsMgr.GetInstance():ShowTips(i18n("target_chapter_is_lock"))

								return
							elseif not slot4:isUnlock() or (slot5:getMapType() == Map.ELITE and not slot5:isEliteEnabled()) or slot2.level < slot4:getConfig("unlocklevel") then
								pg.TipsMgr.GetInstance():ShowTips(i18n("target_chapter_is_lock"))

								return
							end
						end

						if slot0.eliteDefault and not getProxy(DailyLevelProxy):IsEliteEnabled() then
							pg.TipsMgr.GetInstance():ShowTips(i18n("common_elite_no_quota"))

							return
						end

						if slot2 and slot2.lastDigit then
							slot3 = 0
							slot4 = {}

							if slot2.mapType then
								slot4 = slot1:getMapsByType(slot2.mapType)
							else
								for slot8, slot9 in ipairs({
									Map.SCENARIO,
									Map.ELITE
								}) do
									for slot13, slot14 in ipairs(slot1:getMapsByType(slot9)) do
										table.insert(slot4, slot14)
									end
								end
							end

							for slot8, slot9 in ipairs(slot4) do
								if slot9:isUnlock() and (slot2.mapType ~= Map.ELITE or slot9:isEliteEnabled()) and slot3 < slot9.id then
									for slot13, slot14 in pairs(slot9.chapters) do
										if math.fmod(slot13, 10) == slot2.lastDigit and slot14:isUnlock() and slot14:getConfig("unlocklevel") <= slot2.level then
											slot0.chapterId = slot13
											slot3 = slot9.id
											slot0.mapIdx = slot9.id

											break
										end
									end
								end
							end
						end

						if slot0.chapterId then
							if slot1:getMapById(slot1:getChapterById(slot3):getConfig("map")) and slot5:getMapType() == Map.ELITE and not getProxy(DailyLevelProxy):IsEliteEnabled() then
								pg.TipsMgr.GetInstance():ShowTips(i18n("common_elite_no_quota"))

								return
							end

							if slot4:isUnlock() then
								if slot4.active then
									slot0.mapIdx = slot4:getConfig("map")
								elseif slot1:getActiveChapter() then
									pg.MsgboxMgr.GetInstance():ShowMsgBox({
										content = i18n("collect_chapter_is_activation"),
										onYes = function ()
											pg.m02:sendNotification(GAME.CHAPTER_OP, {
												type = ChapterConst.OpRetreat
											})
										end
									})

									return
								else
									slot0.mapIdx = slot4.getConfig(slot4, "map")
									slot0.openChapterId = slot3
								end
							else
								pg.TipsMgr.GetInstance():ShowTips(i18n("target_chapter_is_lock"))
							end
						end
					elseif slot1 == SCENE.TASK and slot2 and slot2.awards then
						slot1 = {}

						for slot5, slot6 in ipairs(slot2.awards) do
							slot1[slot6] = true
						end

						slot2 = nil

						if next(slot1) then
							for slot8, slot9 in pairs(slot4) do
								slot10 = false

								for slot14, slot15 in ipairs(slot9:getConfig("award_display")) do
									if slot1[slot15[2]] then
										slot2 = slot9.id
										slot10 = true

										break
									end
								end

								if slot10 then
									break
								end
							end
						end

						if not slot2 then
							pg.TipsMgr.GetInstance():ShowTips(i18n("task_has_finished"))

							return
						end

						slot0.targetId = slot2
					elseif slot1 == SCENE.COLLECTSHIP then
						slot0.toggle = 2
					elseif slot1 == SCENE.DAILYLEVEL and slot0.dailyLevelId then
						slot1, slot2 = DailyLevelScene.CanOpenDailyLevel(slot0.dailyLevelId)

						if not slot1 then
							pg.TipsMgr.GetInstance():ShowTips(slot2)

							return
						end
					elseif slot1 == SCENE.MILITARYEXERCISE and not getProxy(MilitaryExerciseProxy):getSeasonInfo():canExercise() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("exercise_count_insufficient"))

						return
					end

					slot3.viewParent:hide()
					pg.m02:sendNotification(GAME.GO_SCENE, pg.m02.sendNotification, slot0)
				end, SFX_PANEL)
			end

			slot11 = slot2.Find(slot2, "mask/title"):GetComponent("ScrollText")
			slot11.enabled = false

			Canvas.ForceUpdateCanvases()

			slot11.enabled = true

			slot11:SetText(slot4)
		end
	end)
end

return slot0
