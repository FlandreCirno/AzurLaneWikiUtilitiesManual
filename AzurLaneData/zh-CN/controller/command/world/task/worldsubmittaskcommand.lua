class("WorldSubmitTaskCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot5 = nowWorld.GetInventoryProxy(slot4)

	if not nowWorld.GetTaskProxy(slot4):getTaskById(slot1:getBody().taskId) then
		return
	end

	table.insert(slot8, function (slot0)
		slot1, slot2 = slot0:canSubmit()

		if slot1 then
			slot0()
		else
			pg.TipsMgr.GetInstance():ShowTips(slot2)
		end
	end)

	slot9 = slot7.config.complete_condition == WorldConst.TaskTypeSubmitItem and slot7.config.item_retrieve == 1

	if not slot7.IsAutoSubmit(slot7) and slot9 then
		table.insert(slot8, function (slot0)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_ITEM_BOX,
				content = i18n("sub_item_warning"),
				items = {
					{
						type = DROP_TYPE_WORLD_ITEM,
						id = slot0.config.complete_parameter[1],
						count = slot0:getMaxProgress()
					}
				},
				onYes = slot0
			})
		end)
	end

	seriesAsync(slot8, function ()
		pg.ConnectionMgr.GetInstance():Send(33207, {
			taskId = slot0
		}, 33208, function (slot0)
			if slot0.result == 0 then
				function slot1(slot0, slot1, slot2)
					slot3 = getProxy(BayProxy)
					slot4 = {}
					slot5 = {}

					for slot10, slot11 in ipairs(slot6) do
						table.insert(slot4, slot11)

						slot12 = slot3:getShipById(slot11.id)

						slot12:setIntimacy(slot12:getIntimacy() + slot2)
						slot12:addExp(slot1)
						slot3:updateShip(slot12)
						table.insert(slot5, WorldConst.FetchShipVO(slot11.id))
					end

					return {
						oldships = slot4,
						newships = slot5
					}
				end

				slot2 = {}
				slot3 = slot0.exp
				slot4 = slot0.intimacy

				for slot9, slot10 in pairs(slot5) do
					slot11 = slot1(slot10, slot3, slot4)

					if slot3 > 0 then
						table.insert(slot2, slot11)
					end
				end

				slot6 = PlayerConst.addTranDrop(slot0.drops)

				slot1:commited()
				slot2:updateTask(slot1)
				slot2:riseTaskFinishCount()
				slot0:UpdateProgress(slot1.config.complete_stage)

				if slot3 then
					slot4:RemoveItem(slot1.config.complete_parameter[1], slot1:getMaxProgress())
				end

				slot5:sendNotification(GAME.WORLD_SUMBMIT_TASK_DONE, {
					task = slot1,
					drops = slot6,
					expfleets = slot2
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("task_submitTask", slot0.result))
			end
		end)
	end)
end

return class("WorldSubmitTaskCommand", pm.SimpleCommand)
