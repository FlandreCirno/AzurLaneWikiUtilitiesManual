class("WorldUpdateFormationCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot4 = nowWorld.GetActiveMap(slot3)

	pg.ConnectionMgr.GetInstance().Send(slot6, 33405, {
		fleet_list = _.map(slot1:getBody().list, function (slot0)
			return {
				group_id = slot0.fleetId,
				ship_id = _.map(slot0.ships, function (slot0)
					return slot0.id
				end)
			}
		end)
	}, 33406, function (slot0)
		if slot0.result == 0 then
			slot1 = nowWorld

			_.each(slot0.list, function (slot0)
				slot1 = slot0:GetFleet(slot0.fleetId)
				slot3 = slot0:GetPortFleets()
				slot4 = {}

				_.each(slot2, function (slot0)
					slot0[slot0.id] = true
				end)
				_.each(slot1.GetShips(slot1, true), function (slot0)
					if not slot0[slot0.id] then
						slot1:AddPortShip(slot0)
					end
				end)
				_.each(slot1.GetShips(slot6), function (slot0)
					if slot0[slot0.id] then
						slot0[slot0.id] = slot1:RemovePortShip(slot0.id)
					end
				end)
				_.each(slot3, function (slot0)
					if slot0.id ~= slot0.id then
						_.each(slot0:GetShips(true), function (slot0)
							if slot0[slot0.id] then
								slot0[slot0.id] = slot1:RemoveShip(slot0.id)
							end
						end)
					end
				end)

				slot5 = _.map(slot2, function (slot0)
					return slot0:GetShip(slot0.id) or slot1[slot0.id]
				end)

				slot1:UpdateShips(slot5)
				slot1:VerifyFormation()
			end)
		else
			pg.TipsMgr.GetInstance().ShowTips(slot1, errorTip("world_update_formation_err", slot0.result))
		end

		if slot0.callback then
			slot0.callback()
		end
	end)
end

return class("WorldUpdateFormationCommand", pm.SimpleCommand)
