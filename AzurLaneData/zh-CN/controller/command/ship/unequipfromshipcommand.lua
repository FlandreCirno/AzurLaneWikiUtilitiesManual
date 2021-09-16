class("UnequipFromShipCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot2 = slot1:getBody()
	slot4 = slot2.pos
	slot5 = slot2.callback
	slot7 = getProxy(BayProxy).getShipById(slot6, slot3)

	if getProxy(PlayerProxy):getData():getMaxEquipmentBag() <= getProxy(EquipmentProxy):getCapacity() then
		NoPosMsgBox(i18n("switch_to_shop_tip_noPos"), openDestroyEquip, gotoChargeScene)

		if slot5 then
			slot5()
		end

		return
	end

	if slot7 == nil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", slot3))

		if slot5 then
			slot5()
		end

		return
	end

	if not slot7:getEquip(slot4) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_unequipFromShip_error_noEquip"))

		if slot5 then
			slot5()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(12006, {
		equip_id = 0,
		type = 0,
		ship_id = slot3,
		pos = slot4
	}, 12007, function (slot0)
		if slot0.result == 0 then
			slot1 = getProxy(EquipmentProxy)

			slot0:updateEquip(slot1, nil)
			slot0.updateEquip:updateShip(slot0)
			slot0.updateEquip:setSkinId(0)
			slot1:addEquipment(slot1)
			slot4:sendNotification(GAME.UNEQUIP_FROM_SHIP_DONE, slot0)
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_unequipFromShip_ok", slot3.config.name), "red")

			if slot0:getEquipSkin(slot1) > 0 and not slot0:checkCanEquipSkin(slot1, slot0:getEquipSkin(slot1)) then
				slot4:sendNotification(GAME.EQUIP_EQUIPMENTSKIN_TO_SHIP, {
					equipmentSkinId = 0,
					shipId = slot5,
					pos = slot1
				})
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_unequipFromShip", slot0.result))
		end

		if slot6 then
			slot6()
		end
	end)
end

return class("UnequipFromShipCommand", pm.SimpleCommand)
