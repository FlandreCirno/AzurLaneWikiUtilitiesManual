slot0 = class("GetCommanderHomeCommand", pm.SimpleCommand)

slot0.execute = function (slot0, slot1)
	slot2 = slot1:getBody()

	if getProxy(CommanderProxy):GetCommanderHome() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(25026, {
		type = 0
	}, 25027, function (slot0)
		slot0:AddCommanderHome(slot1)

		for slot5, slot6 in ipairs(slot0.slots) do
			if slot6.commander_id ~= 0 and slot6.commander_level and slot6.commander_level ~= 0 and slot6.commander_exp then
				slot1:UpdateCommanderLevelAndExp(slot6.commander_id, slot6.commander_level, slot6.commander_exp)
			end
		end
	end)
end

slot0.UpdateCommanderLevelAndExp = function (slot0, slot1, slot2, slot3)
	if getProxy(CommanderProxy):getCommanderById(slot1) then
		slot5:UpdateLevelAndExp(slot2, slot3)
		slot4:updateCommander(slot5)
	end
end

return slot0
