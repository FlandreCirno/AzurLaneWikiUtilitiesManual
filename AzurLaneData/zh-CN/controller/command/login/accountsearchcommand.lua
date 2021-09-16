class("AccountSearchCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot3 = slot1:getBody().callback
	slot4 = slot1.getBody().update
	slot6 = getProxy(UserProxy).getData(slot5)
	slot8 = {}

	for slot12, slot13 in pairs(slot7) do
		table.insert(slot8, function (slot0)
			slot3 = nil

			pg.SimpleConnectionMgr.GetInstance():Disconnect()
			pg.SimpleConnectionMgr.GetInstance():SetErrorCB(function ()
				if not slot0 then
					slot1({
						id = slot2.id
					})
					slot3()
				end
			end)
			pg.SimpleConnectionMgr.GetInstance().Connect(slot4, slot0:getHost(), slot0:getPort(), function ()
				pg.SimpleConnectionMgr.GetInstance():Send(10026, {
					account_id = slot0.uid
				}, 10027, function (slot0)
					if slot0.user_id and slot0.user_id ~= 0 and slot0.level and slot0.level > 0 then
						slot0({
							id = slot1.id,
							user_id = slot0.user_id,
							level = slot0.level
						})
					else
						slot0({
							id = slot1.id
						})
					end

					slot2 = slot1.id

					slot3()
				end, nil, 0.5)
			end, 0.5)
		end)
	end

	seriesAsync(slot8, function ()
		slot0()
	end)
end

return class("AccountSearchCommand", pm.SimpleCommand)
