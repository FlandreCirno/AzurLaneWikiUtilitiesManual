class("RefundChargeCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	if (PLATFORM_CODE == PLATFORM_US or PLATFORM_CODE == PLATFORM_JP) and not pg.SdkMgr.GetInstance():CheckAiriCanBuy() then
		print("wait for a second, Do not click quickly~")

		return
	end

	slot3 = slot1:getBody().shopId
	slot5 = getProxy(ShopsProxy):getFirstChargeList() or {}

	if not slot3 then
		return
	end

	slot6 = not table.contains(slot5, slot3)
	slot7 = Goods.Create({
		shop_id = slot3
	}, Goods.TYPE_CHARGE)

	pg.TrackerMgr.GetInstance():Tracking(TRACKING_PURCHASE_CLICK, slot3)
	pg.ConnectionMgr.GetInstance():Send(11513, {
		shop_id = slot3,
		device = PLATFORM
	}, 11514, function (slot0)
		if slot0.result == 0 then
			if slot0.tradeNoPrev ~= slot0.pay_id then
				if (PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US) and pg.SdkMgr.GetInstance():GetIsPlatform() then
					if pg.SdkMgr.GetInstance():CheckAudit() then
						print("serverTag:audit 请求购买物品")
						pg.SdkMgr.GetInstance():AiriBuy(slot1:getConfig("airijp_id"), "audit", slot0.pay_id)
					elseif pg.SdkMgr.GetInstance():CheckPreAudit() then
						print("serverTag:preAudit 请求购买物品")
						pg.SdkMgr.GetInstance():AiriBuy(slot1:getConfig("airijp_id"), "preAudit", slot0.pay_id)
					elseif pg.SdkMgr.GetInstance():CheckPretest() then
						print("serverTag:preTest 请求购买物品")
						pg.SdkMgr.GetInstance():AiriBuy(slot1:getConfig("airijp_id"), "preAudit", slot0.pay_id)
					else
						print("serverTag:production 请求购买物品")
						pg.SdkMgr.GetInstance():AiriBuy(slot1:getConfig("airijp_id"), "production", slot0.pay_id)
					end

					print("请求购买的airijp_id为：" .. slot1:getConfig("airijp_id"))
					print("请求购买的id为：" .. slot0.pay_id)
				else
					slot7 = 0

					pg.SdkMgr.GetInstance():SdkPay(slot1:firstPayDouble() and slot2:getConfig("id_str"), slot1.firstPayDouble() and slot2:getConfig("money") * 100, slot1.firstPayDouble() and slot2:getConfig("name"), (slot1.firstPayDouble() and slot2 and slot1.firstPayDouble() and slot2:getConfig("gem") * 2) or slot1.firstPayDouble() and slot2:getConfig("gem") + slot1.firstPayDouble() and slot2:getConfig("extra_gem"), slot8, slot1.firstPayDouble() and slot2:getConfig("subject"), "-" .. getProxy(PlayerProxy).getData(slot2).id .. "-" .. slot0.pay_id, getProxy(PlayerProxy).getData(slot2).name, slot0.url or "", slot0.order_sign or "")
				end

				slot0.tradeNoPrev = slot0.pay_id

				pg.TrackerMgr.GetInstance():Tracking(TRACKING_PURCHASE, )
				getProxy(ShopsProxy):addWaitTimer()
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("charge_trade_no_error"))
			end
		elseif slot0.result == 6 then
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("charge", slot0.result))
		end
	end)
end

return class("RefundChargeCommand", pm.SimpleCommand)
