class("WorldBossGetOtherFormationCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	pg.ConnectionMgr.GetInstance():Send(34519, {
		boss_id = slot1:getBody().bossId,
		userId = slot1.getBody().userId
	}, 34520, function (slot0)
		if slot0.result == 0 then
			slot1 = {}

			for slot5, slot6 in ipairs(slot0.ship_list) do
				table.insert(slot1, Ship.New(slot6))
			end

			slot0:sendNotification(GAME.WORLD_BOSS_GET_FORMATION_DONE, {
				ships = slot1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[slot0.result] .. slot0.result)
		end
	end)
end

return class("WorldBossGetOtherFormationCommand", pm.SimpleCommand)
