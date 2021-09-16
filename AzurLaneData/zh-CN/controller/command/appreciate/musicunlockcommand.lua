class("MusicUnlockCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot4 = slot1:getBody().unlockCBFunc
	slot6 = getProxy(BagProxy)
	slot8 = getProxy(PlayerProxy).getData(slot7)

	for slot13, slot14 in pairs(slot9) do
		if slot14.type == DROP_TYPE_RESOURCE then
			if slot8:getResById(slot14.id) < slot14.count then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

				return
			end
		elseif slot14.type == DROP_TYPE_ITEM and slot6:getItemCountById(slot14.id) < slot14.count then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_item_1"))

			return
		end
	end

	pg.ConnectionMgr.GetInstance():Send(17503, {
		id = slot3
	}, 17504, function (slot0)
		if slot0.result == 0 then
			slot0:addMusicIDToUnlockList(slot0.addMusicIDToUnlockList)

			for slot5, slot6 in pairs(slot1) do
				if slot6.type == DROP_TYPE_RESOURCE then
					slot2:consume({
						[id2res(slot6.id)] = slot6.count
					})
					slot3:updatePlayer(slot2)
				elseif slot6.type == DROP_TYPE_ITEM then
					slot4:removeItemById(slot6.id, slot6.count)
				end
			end

			if slot5 then
				slot5()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips("UnLock Fail, Code:" .. tostring(slot0.result))
		end
	end)
end

return class("MusicUnlockCommand", pm.SimpleCommand)
