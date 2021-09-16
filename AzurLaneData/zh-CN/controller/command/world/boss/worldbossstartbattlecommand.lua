class("WorldBossStartBattleCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot3 = slot1:getBody().bossId
	slot6 = nowWorld.GetBossProxy(slot5)
	slot8 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLD_WORLDBOSS)

	if slot1.getBody().isOther and slot6:GetPt() <= 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_count_no_enough"))

		return
	end

	if not slot6:GetBossById(slot3) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_joint_boss_not_found"))

		return
	end

	slot0.sendNotification(slot0, GAME.CHECK_WORLD_BOSS_STATE, {
		bossId = slot3,
		time = slot9.lastTime,
		callback = function ()
			slot1 = getProxy(ContextProxy)
			slot3 = pg.m02:retrieveMediator(slot1:getCurrentContext().mediator.__cname)

			slot3:addSubLayers(Context.New({
				mediator = WorldBossFormationMediator,
				viewComponent = WorldBossFormationLayer,
				data = {
					stageId = slot0:GetStageID(),
					bossId = slot1,
					actID = slot2.id,
					system = SYSTEM_WORLD_BOSS,
					isOther = slot3
				}
			}))
		end,
		failedCallback = function ()
			slot0:RemoveCacheBoss(slot1.id)
		end
	})
end

return class("WorldBossStartBattleCommand", pm.SimpleCommand)
