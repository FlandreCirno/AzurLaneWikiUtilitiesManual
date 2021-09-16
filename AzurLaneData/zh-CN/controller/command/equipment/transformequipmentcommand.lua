slot0 = class("TransformEquipmentCommand", pm.SimpleCommand)

slot0.execute = function (slot0, slot1)
	slot3 = slot1:getBody().candicate

	seriesAsync({
		function (slot0)
			if slot0.type == DROP_TYPE_ITEM then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("equipment_upgrade_feedback_compose_tip"),
					onYes = slot0
				})

				return
			elseif slot0.type == DROP_TYPE_EQUIP and slot0.template.shipId ~= nil then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("equipment_upgrade_feedback_equipment_consume", getProxy(BayProxy):getShipById(slot1).getName(slot2), slot0.template:getConfig("name")),
					onYes = slot0
				})

				return
			end

			slot0()
		end,
		function (slot0)
			if slot0.type == DROP_TYPE_EQUIP then
				return slot0({
					shipId = slot0.template.shipId,
					pos = slot0.template.shipPos,
					equipmentId = slot0.template.id,
					formulaIds = slot1.formulaIds
				})
			end

			slot3 = getProxy(BagProxy)
			slot7 = pg.equip_data_statistics[pg.compose_data_template[slot0.composeCfg.id].equip_id]

			if getProxy(PlayerProxy).getData(slot4).getMaxEquipmentBag(slot5) < getProxy(EquipmentProxy).getCapacity(slot8) + 1 then
				NoPosMsgBox(i18n("switch_to_shop_tip_noPos"), openDestroyEquip, gotoChargeScene)

				return
			end

			if slot5.gold < slot6.gold_num * slot2 then
				GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
					{
						59001,
						slot6.gold_num * slot2 - slot5.gold,
						slot6.gold_num * slot2
					}
				})

				return
			end

			if not slot3:getItemById(slot6.material_id) or slot10.count < slot6.material_num * slot2 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_materal_no_enough"))

				return
			end

			pg.ConnectionMgr.GetInstance():Send(14006, {
				id = slot1,
				num = slot2
			}, 14007, function (slot0)
				if slot0.result == 0 then
					slot0:addEquipmentById(slot1.equip_id, slot0)
					slot3:consume({
						gold = slot1.gold_num * slot3
					})
					slot4:updatePlayer()
					slot5:removeItemById(slot1.material_id, slot1.material_num * slot5)
					slot6:sendNotification(GAME.COMPOSITE_EQUIPMENT_DONE, {
						equipment = Equipment.New({
							id = slot1.equip_id
						}),
						count = slot2,
						composeId = slot1.equip_id
					})
					slot8({
						equipmentId = slot1.equip_id,
						formulaIds = slot9.formulaIds
					})
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("equipment_compositeEquipment", slot0.result))
				end
			end)
		end,
		function (slot0, slot1)
			slot0:ExecuteEquipTransform(slot1)
		end
	})
end

slot0.ExecuteEquipTransform = function (slot0, slot1)
	slot3 = slot1.shipId
	slot4 = slot1.pos
	slot5 = slot1.equipmentId
	slot6 = slot1.formulaIds
	slot7 = nil

	if slot1.shipId then
		slot5 = getProxy(BayProxy).getShipById(slot8, slot2):getEquip(slot4).id
	elseif slot5 ~= 0 then
		slot5 = getProxy(EquipmentProxy):getEquipmentById(slot5).id
	end

	slot8, slot9 = EquipmentTransformUtil.CheckEquipmentFormulasSucceed(slot6, slot5)

	if not slot8 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_x", slot9))

		return
	end

	slot10 = {}
	slot11 = {}

	function slot12()
		slot1 = getProxy(PlayerProxy)

		for slot5, slot6 in pairs(slot0) do
			if slot5 == "gold" then
				slot7 = slot1:getData()
				slot8 = {
					gold = math.abs(slot6)
				}

				if slot6 > 0 then
					slot7:consume(slot8)
					slot1:updatePlayer(slot7)
				elseif slot6 < 0 then
					slot7:addResources(slot8)
					slot1:updatePlayer(slot7)
				end
			elseif slot6 > 0 then
				slot0:removeItemById(slot5, slot6)
			elseif slot6 < 0 then
				slot0:addItemById(slot5, -slot6)
			end
		end

		table.clear(slot0)
	end

	slot13 = slot5

	function slot14()
		slot0()

		slot0 = getProxy(BayProxy)
		slot4 = (not getProxy(EquipmentProxy) or slot0:getShipById(slot1):getEquip(slot0.getShipById(slot1))) and slot1:getEquipmentById(nil):MigrateTo((not getProxy(EquipmentProxy) or slot0.getShipById(slot1):getEquip()) and slot1.getEquipmentById(nil).MigrateTo)

		if slot2 then
			if not slot2:isForbiddenAtPos(slot4, slot2) then
				slot2:updateEquip(slot2, slot4)
				slot0:updateShip(slot2)
			else
				slot2:updateEquip(slot2, nil)
				slot0:updateShip(slot2)
				nil:addEquipment(slot4)
			end
		else
			slot1:removeEquipmentById(slot3.id, 1)
			slot1:addEquipmentById(slot4.id, 1)
		end

		return slot2, slot3, slot4
	end

	slot15 = slot7
	slot16, slot17, slot18 = nil

	table.eachAsync(slot6, function (slot0, slot1, slot2)
		seriesAsync({
			function (slot0)
				slot1 = (slot0 and 14013) or 14015
				slot2 = (slot0 and 14014) or 14016

				if not slot0 or not {
					ship_id = slot0,
					pos = slot1,
					upgrade_id = slot2
				} then
				end

				pg.ConnectionMgr.GetInstance():Send(slot1, slot3, slot2, slot0)
			end,
			function (slot0, slot1)
				if slot1.result == 0 then
					for slot7, slot8 in ipairs(slot3) do
						slot1[slot9] = (slot1[slot8[1]] or 0) + slot8[2]
					end

					slot1.gold = (slot1.gold or 0) + slot2.coin_consume

					for slot8, slot9 in pairs(slot4) do
						if slot8 ~= "gold" then
							slot1[slot8] = (slot1[slot8] or 0) - slot9
							slot3[slot8] = (slot3[slot8] or 0) + slot9
						end
					end

					if pg.equip_data_template[slot2] then
						slot1.gold = (slot1.gold or 0) - (slot5.destory_gold or 0)
						slot3.gold = (slot3.gold or 0) + (slot5.destory_gold or 0)
					end

					slot4 = slot2
					slot2 = slot2.target_id
					slot6, slot7, slot7 = slot8()
					slot5 = slot7

					slot9()
				else
					pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot1.result] .. slot1.result)
					slot10:sendNotification(GAME.TRANSFORM_EQUIPMENT_FAIL)
				end
			end
		})
	end, function ()
		if not slot0 and slot1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_upgrade_equipped_unavailable", getProxy(BayProxy):getShipById(getProxy(BayProxy)).getName(slot0), slot2.config.name))
		end

		slot5:sendNotification(GAME.TRANSFORM_EQUIPMENT_DONE, slot0)
		slot5.LoadLayer(Context.New({
			mediator = EquipmentTransformInfoMediator,
			viewComponent = EquipmentTransformInfoLayer,
			data = {
				equipVO = slot6
			},
			onRemoved = function ()
				if getProxy(ContextProxy).getCurrentContext(slot0):getContextByMediator(EquipmentInfoMediator) then
					pg.m02:retrieveMediator(slot2.mediator.__cname).getViewComponent(slot3):closeView()
				end

				slot4 = pg.m02:retrieveMediator(slot1.mediator.__cname).getViewComponent(slot3)

				seriesAsync({
					function (slot0)
						slot1(slot0, BaseUI.ON_ACHIEVE, {
							{
								count = 1,
								id = (slot0.emit and slot1.id) or 0,
								type = DROP_TYPE_EQUIP
							}
						}, slot0)
					end,
					function (slot0)
						onNextTick(slot0)
					end,
					function (slot0)
						if not next(slot0) then
							slot0()

							return
						end

						slot1 = {}

						for slot5, slot6 in pairs(slot0) do
							if slot5 == "gold" then
								table.insert(slot1, {
									type = DROP_TYPE_RESOURCE,
									id = res2id(slot5),
									count = slot6
								})
							else
								table.insert(slot1, {
									type = DROP_TYPE_ITEM,
									id = slot5,
									count = slot6
								})
							end
						end

						slot1:emit(BaseUI.ON_AWARD, {
							items = slot1,
							title = AwardInfoLayer.TITLE.REVERT,
							removeFunc = slot0
						})
					end,
					function (slot0)
						slot0:sendNotification(GAME.TRANSFORM_EQUIPMENT_AWARD_FINISHED, slot0.sendNotification)
					end
				})
			end
		}), true)
	end)
end

slot0.LoadLayer = function (slot0)
	pg.m02:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = getProxy(ContextProxy).getCurrentContext(slot1),
		context = slot0
	})
end

return slot0
