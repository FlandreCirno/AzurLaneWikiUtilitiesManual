class("OpenOrCloseCatteryCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	pg.ConnectionMgr.GetInstance():Send(25036, {
		is_open = (not slot1:getBody().open or 0) and 1
	})
	getProxy(CommanderProxy):UpdateOpenCommanderScene(slot3)

	if slot3 and slot5:GetCommanderHome() then
		for slot11, slot12 in pairs(slot7) do
			slot12:ClearCacheExp()
		end
	end
end

return class("OpenOrCloseCatteryCommand", pm.SimpleCommand)
