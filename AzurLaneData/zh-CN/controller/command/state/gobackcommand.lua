class("GoBackCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()
	slot3 = slot1:getType() or 1

	if getProxy(ContextProxy).getContextCount(slot4) > 1 then
		slot5 = slot4:popContext()
		slot6 = nil

		for slot10 = 1, slot3, 1 do
			if slot4:getContextCount() > 0 then
				slot6 = slot4:popContext()
			else
				print("could not pop more context")

				break
			end
		end

		slot6:extendData(slot2)
		slot0:sendNotification(GAME.LOAD_SCENE, {
			prevContext = slot5,
			context = slot6
		})
	else
		print("no more context in the stack")
	end
end

return class("GoBackCommand", pm.SimpleCommand)
