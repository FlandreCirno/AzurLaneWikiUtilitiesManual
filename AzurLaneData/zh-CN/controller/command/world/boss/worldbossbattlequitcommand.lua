class("WorldBossBattleQuitCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	if not slot1:getBody().id then
		return
	end

	if nowWorld.GetBossProxy(slot4):GetBossById(slot3) and not slot5:IsSelfBoss(slot6) then
		slot5:RemoveCacheBoss(slot3)

		for slot12, slot13 in ipairs(slot8) do
			slot13.args.isDeath = true

			slot7:UpdateMsg(slot13)
		end

		for slot14, slot15 in ipairs(slot10) do
			slot15.args.isDeath = true

			slot9:UpdateMsg(slot15)
		end
	end
end

return class("WorldBossBattleQuitCommand", pm.SimpleCommand)
