class("FinishTechnologyCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot4 = slot1:getBody().pool_id

	if not getProxy(TechnologyProxy):getTechnologyById(slot1.getBody().id) then
		return
	end

	if not slot6:isFinished() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(63003, {
		tech_id = slot3,
		refresh_id = slot4
	}, 63004, function (slot0)
		if slot0.result == 0 then
			slot0:reset()
			slot0.reset:updateTechnology(slot0)

			slot1 = PlayerConst.addTranDrop(slot0.drop_list)

			underscore.each(slot2, function (slot0)
				getProxy(TechnologyProxy):addCatupPrintsNum(slot0.count)
			end)

			slot3 = PlayerConst.addTranDrop(slot0.catchupact_list)

			if getProxy(ActivityProxy).getActivityByType(slot4, ActivityConst.ACTIVITY_TYPE_BLUEPRINT_CATCHUP) and not slot4:isEnd() then
				underscore.each(slot3, function (slot0)
					slot0.data1 = slot0.data1 + slot0.count
				end)
			end

			slot5 = PlayerConst.addTranDrop(slot0.common_list)

			if slot0.hasCondition(slot6) and slot0:getTaskId() then
				getProxy(TaskProxy):removeTaskById(slot6)
			end

			slot1:updateTechnologys(slot0)
			slot2:sendNotification(GAME.FINISH_TECHNOLOGY_DONE, {
				technologyId = slot0.id,
				items = slot1,
				commons = slot5,
				catchupItems = slot2,
				catchupActItems = slot3
			})

			return
		end

		pg.TipsMgr.GetInstance():ShowTips(i18n("technology_finish_erro") .. slot0.result)
	end)
end

return class("FinishTechnologyCommand", pm.SimpleCommand)
