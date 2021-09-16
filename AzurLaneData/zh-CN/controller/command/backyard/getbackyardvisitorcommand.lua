class("GetBackYardVisitorCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot3 = slot1:getBody().callback

	pg.ConnectionMgr.GetInstance():Send(19024, {
		type = 0
	}, 19025, function (slot0)
		if slot0.visitor and slot0.visitor.ship_template ~= 0 then
			getProxy(DormProxy):SetVisitorShip(Ship.New({
				id = 99999999,
				template_id = slot0.visitor.ship_template,
				name = slot0.visitor.name,
				skin_id = slot0.visitor.ship_skin
			}))
		end

		if slot0 then
			slot0()
		end

		slot1:sendNotification(GAME.BACKYARD_GET_VISITOR_SHIP_DONE)
	end)
end

return class("GetBackYardVisitorCommand", pm.SimpleCommand)
