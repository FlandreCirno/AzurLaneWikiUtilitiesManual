class("ColoringAchieveCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	pg.ConnectionMgr.GetInstance():Send(26002, {
		act_id = slot1:getBody().activityId,
		id = slot1.getBody().id
	}, 26003, function (slot0)
		if slot0.result == 0 then
			slot1 = PlayerConst.addTranDrop(slot0.drop_list)
			slot2 = getProxy(ColoringProxy)
			slot3 = slot2:getColorGroups()
			slot4 = slot2:getColorGroup(slot0)

			slot4:setDrops(slot1)
			slot4:setState(ColorGroup.StateAchieved)
			slot2:checkState()
			slot1:sendNotification(GAME.COLORING_ACHIEVE_DONE, {
				drops = slot1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("coloring_achieve", slot0.result))
		end
	end)
end

return class("ColoringAchieveCommand", pm.SimpleCommand)
