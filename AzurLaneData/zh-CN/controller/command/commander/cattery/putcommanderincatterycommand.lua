slot0 = class("PutCommanderInCatteryCommand", pm.SimpleCommand)

slot0.execute = function (slot0, slot1)
	slot3 = slot1:getBody().id
	slot5 = slot1:getBody().commanderId == 0
	slot6 = getProxy(CommanderProxy)

	if not slot5 and not slot6:getCommanderById(slot4) then
		return
	end

	if not slot6:GetCommanderHome() then
		return
	end

	if not slot7:GetCatteryById(slot3) or not slot8:CanUse() then
		return
	end

	if not slot5 and slot8:ExistCommander() and slot8:GetCommanderId() == slot4 then
		return
	end

	if slot5 and not slot8:ExistCommander() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(25030, {
		slotidx = slot3,
		commander_id = slot4
	}, 25031, function (slot0)
		if slot0.result == 0 then
			if slot0 then
				slot1:UpdateCommanderLevelAndExp(slot1, slot0)
				slot1:RemoveCommander()
				pg.TipsMgr.GetInstance():ShowTips(i18n("cattery_remove_commander_success"))
			else
				if slot1:ExistCommander() then
					slot1:UpdateCommanderLevelAndExp(slot1:GetCommanderId(), slot0)
				end

				slot1:AddCommander(slot3, slot0.time)

				slot1 = slot4:getCommanderById(slot3)
				slot3 = slot1:ExitFeedFlag()
				slot4 = slot1:ExitPlayFlag()

				if slot1:ExistCleanFlag() and slot1:ExistCleanOP() then
					slot1:ResetCleanOP()
				end

				if slot3 and slot1:ExiseFeedOP() then
					slot1:ResetFeedOP()
				end

				if slot4 and slot1:ExistPlayOP() then
					slot1:ResetPlayOP()
				end

				slot5 = {}

				if not slot2 then
					table.insert(slot5, i18n("common_clean"))
				end

				if not slot3 then
					table.insert(slot5, i18n("common_feed"))
				end

				if not slot4 then
					table.insert(slot5, i18n("common_play"))
				end

				if #slot5 > 0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("cat_home_interaction", table.concat(slot5, ", ")))
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("cattery_add_commander_success"))
				end
			end

			slot2:sendNotification(GAME.PUT_COMMANDER_IN_CATTERY_DONE, {
				id = slot1.id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

slot0.UpdateCommanderLevelAndExp = function (slot0, slot1, slot2)
	slot4 = slot2.commander_exp

	if slot2.commander_level > 0 then
		slot5 = getProxy(CommanderProxy)
		slot6 = slot5:getCommanderById(slot1)

		slot6:UpdateLevelAndExp(slot3, slot4)
		slot5:updateCommander(slot6)
	end
end

return slot0
