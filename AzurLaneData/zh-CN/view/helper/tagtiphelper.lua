slot0 = class("TagTipHelper")

slot0.FuDaiTagTip = function (slot0)
	triggerToggle(slot0, false)

	slot1 = {}

	for slot6, slot7 in ipairs(pg.pay_data_display.all) do
		if slot2[slot7].type == 1 and pg.TimeMgr.GetInstance():inTime(slot2[slot7].time) and type(slot2[slot7].time) == "table" then
			table.insert(slot1, slot2[slot7])
		end
	end

	if #slot1 > 0 then
		function slot3(slot0)
			table.sort(slot0, function (slot0, slot1)
				return pg.TimeMgr.GetInstance():parseTimeFromConfig(slot1.time[1]) < pg.TimeMgr.GetInstance():parseTimeFromConfig(slot0.time[1])
			end)

			slot3 = pg.TimeMgr.GetInstance().parseTimeFromConfig(slot3, slot1.time[1])
			slot4 = PlayerPrefs.GetInt("Ever_Enter_Mall_", 0)

			if not (slot0[slot0[1].id] ~= nil) and slot4 < slot3 then
				slot1.FudaiTime = slot3

				triggerToggle(slot2, true)
			end
		end

		if not getProxy(ShopsProxy).getChargedList(slot4) then
			pg.m02:sendNotification(GAME.GET_CHARGE_LIST, {
				callback = function ()
					slot0 = slot1:getChargedList()

					slot2(slot2)
				end
			})
		else
			slot3(slot5)
		end
	end
end

slot0.SetFuDaiTagMark = function ()
	if slot0.FudaiTime then
		PlayerPrefs.SetInt("Ever_Enter_Mall_", slot0.FudaiTime)
		PlayerPrefs.Save()

		PlayerPrefs.Save.FudaiTime = nil
	end
end

slot0.SkinTagTip = function (slot0)
	triggerToggle(slot0, false)

	if #_.select(slot1, function (slot0)
		slot1 = slot0:getConfig("time")

		if slot0.type ~= Goods.TYPE_SKIN or type(slot1) ~= "table" or slot0.genre == ShopArgs.SkinShopTimeLimit then
			slot2 = false
		else
			slot2 = true
		end

		return slot2
	end) > 0 then
		table.sort(slot2, function (slot0, slot1)
			return pg.TimeMgr.GetInstance():parseTimeFromConfig(slot1:getConfig("time")[1]) < pg.TimeMgr.GetInstance():parseTimeFromConfig(slot0:getConfig("time")[1])
		end)

		if PlayerPrefs.GetInt("Ever_Enter_Skin_Shop_", 0) < pg.TimeMgr.GetInstance().parseTimeFromConfig(slot5, slot2[1].getConfig(slot4, "time")[1]) then
			slot0.SkinTime = slot5

			triggerToggle(slot0, true)
		end
	end
end

slot0.SetSkinTagMark = function ()
	if slot0.SkinTime then
		PlayerPrefs.SetInt("Ever_Enter_Skin_Shop_", slot0.SkinTime)
		PlayerPrefs.Save()

		PlayerPrefs.Save.SkinTime = nil
	end
end

slot0.MonthCardTagTip = function (slot0)
	triggerToggle(slot0, MonthCardOutDateTipPanel.GetShowMonthCardTag())
end

return slot0
