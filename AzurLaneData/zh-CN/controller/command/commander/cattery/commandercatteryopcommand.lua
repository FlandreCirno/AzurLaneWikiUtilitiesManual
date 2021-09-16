slot0 = class("CommanderCatteryOPCommand", pm.SimpleCommand)

slot0.execute = function (slot0, slot1)
	slot4 = getProxy(CommanderProxy):GetCommanderHome()

	pg.ConnectionMgr.GetInstance():Send(25028, {
		type = slot1:getBody().op
	}, 25029, function (slot0)
		if slot0.result == 0 then
			slot1 = {}

			for slot5, slot6 in ipairs(slot0.awards) do
				table.insert(slot1, slot7)
				slot0:sendNotification(GAME.ADD_ITEM, Item.New({
					type = slot6.type,
					id = slot6.id,
					count = slot6.number
				}))
			end

			slot2 = 0
			slot3 = 0
			slot4 = {}

			if slot1 == 1 then
				slot2:IncCleanValue()
			elseif slot1 == 2 then
				slot4 = slot0:AddCommanderExpByFeed()
			elseif slot1 == 3 then
			end

			slot6 = {}

			for slot10, slot11 in pairs(slot5) do
				if slot11:ExistOP(slot1) and slot11:CommanderCanOP(slot1) then
					slot12 = slot11:GetCommander()

					slot11:ClearOP(slot1)
					slot12:UpdateHomeOpTime(slot1, slot0.op_time)
					getProxy(CommanderProxy):updateCommander(slot12)
					table.insert(slot6, slot11.id)
				end
			end

			slot2:UpdateExpAndLevel(slot0.level, slot0.exp)
			slot0:sendNotification(GAME.COMMANDER_CATTERY_OP_DONE, {
				awards = slot1,
				cmd = slot1,
				opCatteries = slot6,
				commanderExps = slot4,
				homeExp = (Clone(slot2).level < slot2.level and slot7:GetNextLevelExp() - slot7.exp + slot2.exp) or slot2.exp - slot7.exp
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

slot0.AddCommanderExpByFeed = function (slot0)
	slot1 = {}

	function slot2(slot0, slot1)
		if getProxy(CommanderProxy).getCommanderById(slot3, slot2):isMaxLevel() then
			slot1 = 0
		end

		slot4:addExp(slot1)

		if not slot5 and slot4:isMaxLevel() then
			slot1 = slot1 - slot4.exp
		end

		table.insert(slot0, {
			id = slot0.id,
			value = slot1
		})
		slot3:updateCommander(slot4)
	end

	slot3 = getProxy(CommanderProxy).GetCommanderHome(slot3)
	slot5 = slot3:getConfig("feed_level")[2]

	for slot9, slot10 in pairs(slot4) do
		if slot10:ExistCommander() and slot10:ExiseFeedOP() then
			slot2(slot10, slot5)
		end
	end

	return slot1
end

return slot0
