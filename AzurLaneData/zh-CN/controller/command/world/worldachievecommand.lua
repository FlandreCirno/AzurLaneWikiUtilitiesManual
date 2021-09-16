class("WorldAchieveCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	pg.ConnectionMgr.GetInstance():Send(33602, slot1:getBody(), 33603, function (slot0)
		if slot0.result == 0 then
			slot1 = PlayerConst.addTranDrop(slot0.drops)

			for slot5, slot6 in ipairs(slot0.list) do
				slot7 = nowWorld:GetMap(slot6.id)

				for slot11, slot12 in ipairs(slot6.star_list) do
					nowWorld:SetAchieveSuccess(slot6.id, slot12)
				end
			end

			slot1:sendNotification(GAME.WORLD_ACHIEVE_DONE, {
				list = slot0.list,
				drops = slot1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("world_achieve_error_", slot0.result))
		end
	end)
end

return class("WorldAchieveCommand", pm.SimpleCommand)
