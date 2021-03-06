class("TakeAllAttachmentCommand", pm.SimpleCommand).execute = function (slot0, slot1)
	slot6 = getProxy(BayProxy).getShipCount(slot4)
	slot7 = getProxy(EquipmentProxy).getCapacity(slot5)
	slot8 = getConfigFromLevel1(pg.user_level, getProxy(PlayerProxy).getData(slot2).level)

	if getProxy(MailProxy).getAttatchmentsCount(slot9, DROP_TYPE_RESOURCE, 1) > 0 and slot3:GoldMax(slot10) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_mail"))

		return
	end

	if slot9:getAttatchmentsCount(DROP_TYPE_RESOURCE, 2) > 0 and slot3:OilMax(slot11) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_mail"))

		return
	end

	if #slot9:getAttatchmentMailIds() <= 0 then
		return
	end

	slot14 = _.detect(slot12, function (slot0)
		slot2, slot3 = slot0:getMailById(slot0).IsFudaiAndFullCapcity(slot1)

		if not slot2 then
			slot1 = slot3

			return true
		else
			return false
		end
	end)

	if nil then
		pg.TipsMgr.GetInstance().ShowTips(slot15, slot13)

		return
	end

	slot15 = {}

	if slot9:hasAttachmentsType(DROP_TYPE_WORLD_ITEM) then
		if not nowWorld:IsActivate() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("mail_takeAttachment_error_noWorld"))

			return
		elseif slot16:CheckReset() then
			table.insert(slot15, function (slot0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("mail_takeAttachment_error_reWorld"),
					onYes = slot0
				})
			end)
		end
	end

	seriesAsync(slot15, function (slot0)
		pg.ConnectionMgr.GetInstance():Send(30004, {
			id = slot0
		}, 30005, function (slot0)
			for slot5, slot6 in ipairs(slot1) do
				if slot6.readFlag == 0 then
					slot0:removeMail(slot6)
				elseif slot6.attachFlag == slot6.ATTACHMENT_EXIST then
					slot6.readFlag = 2
					slot6.attachFlag = slot6.ATTACHMENT_TAKEN

					slot0:updateMail(slot6)
				end
			end

			slot0:unpdateExistAttachment(slot3)
			slot1:sendNotification(GAME.OPEN_MAIL_ATTACHMENT, {
				items = PlayerConst.addTranDrop(slot0.attachment_list)
			})
			slot1:sendNotification(GAME.TAKE_ALL_ATTACHMENT_DONE)
		end)
	end)
end

return class("TakeAllAttachmentCommand", pm.SimpleCommand)
