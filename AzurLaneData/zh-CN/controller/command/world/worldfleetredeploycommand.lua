class("WorldFleetRedeployCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	pg.ConnectionMgr.GetInstance():Send(33409, slot1:getBody(), 33410, function (slot0)
		if slot0.result == 0 then
			nowWorld.SetFleets(slot2, getProxy(WorldProxy).NetBuildMapFleetList(slot1, slot0.group_list))
			nowWorld.SetPortShips(slot2, {})

			slot3 = nowWorld.GetActiveMap(slot2)

			slot3:SetValid(false)
			slot3:UnbindFleets()

			slot3.findex = table.indexof(nowWorld.fleets, nowWorld.GetFleet(slot2, slot4))

			slot3:BindFleets(nowWorld.fleets)
			nowWorld.staminaMgr:ConsumeStamina(slot5)
			nowWorld.SetReqCDTime(slot2, WorldConst.OpReqRedeploy, pg.TimeMgr.GetInstance():GetServerTime())
			pg.TipsMgr.GetInstance():ShowTips(i18n("world_instruction_redeploy_2"))
			nowWorld.GetBossProxy(slot2).GenFleet(slot6)
			slot0:sendNotification(GAME.WORLD_FLEET_REDEPLOY_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_fleet_redeploy_error_", slot0.result))
		end
	end)
end

return class("WorldFleetRedeployCommand", pm.SimpleCommand)
