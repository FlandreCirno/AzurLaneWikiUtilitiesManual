slot0 = class("Mail", import(".BaseVO"))
slot0.ATTACHMENT_NONE = 0
slot0.ATTACHMENT_EXIST = 1
slot0.ATTACHMENT_TAKEN = 2

slot0.Ctor = function (slot0, slot1)
	slot0.id = slot1.id
	slot0.date = slot1.date
	slot0.title = string.split(HXSet.hxLan(slot1.title), "||")[1]
	slot0.sender = (#string.split(HXSet.hxLan(slot1.title), "||") > 1 and slot2[2]) or i18n("mail_sender_default")
	slot0.readFlag = slot1.read_flag
	slot0.attachFlag = slot1.attach_flag
	slot0.importantFlag = slot1.imp_flag
	slot0.attachments = {}

	for slot6, slot7 in ipairs(slot1.attachment_list) do
		table.insert(slot0.attachments, MailAttachment.New(slot7))
	end

	slot0.openned = false
end

slot0.extend = function (slot0, slot1)
	slot0.content = string.gsub(HXSet.hxLan(slot1.content), "\\n", "\n")
	slot0.openned = true
end

slot0.hasAttachmentsType = function (slot0, slot1)
	for slot5, slot6 in pairs(slot0.attachments) do
		if slot1 == slot6.type then
			return true, slot6.id
		end
	end
end

slot0.getAttatchmentsCount = function (slot0, slot1, slot2)
	slot3 = 0

	for slot7, slot8 in pairs(slot0.attachments) do
		if slot1 == slot8.type and slot2 == slot8.id then
			slot3 = slot3 + slot8.count
		end
	end

	return slot3
end

slot0.IsFudaiAndFullCapcity = function (slot0)
	slot1 = {}

	for slot5, slot6 in pairs(slot0.attachments) do
		if slot6.type == DROP_TYPE_ITEM and table.contains(ITEM_ID_FUDAIS, slot6.id) then
			table.insert(slot1, slot6)
		end
	end

	slot2 = 0
	slot3 = 0
	slot4 = 0
	slot5 = 0

	if #slot1 then
		for slot9, slot10 in ipairs(slot1) do
			for slot15, slot16 in ipairs(pg.item_data_statistics[slot10.id].display_icon) do
				if slot16[1] == DROP_TYPE_RESOURCE then
					if slot16[2] == 1 then
						slot2 = slot2 + slot16[3]
					elseif slot16[2] == 2 then
						slot3 = slot3 + slot16[3]
					end
				elseif slot16[1] == DROP_TYPE_EQUIP then
					slot4 = slot4 + slot16[3]
				elseif slot16[1] == DROP_TYPE_SHIP then
					slot5 = slot5 + slot16[3]
				end
			end
		end
	end

	slot6 = getProxy(PlayerProxy):getRawData()

	if slot3 > 0 and slot6:OilMax(slot3) then
		return false, i18n("oil_max_tip_title")
	end

	if slot2 > 0 and slot6:GoldMax(slot2) then
		return false, i18n("gold_max_tip_title")
	end

	slot7 = getProxy(EquipmentProxy):getCapacity()

	if slot4 > 0 and slot6:getMaxEquipmentBag() < slot4 + slot7 then
		return false, i18n("mail_takeAttachment_error_magazine_full")
	end

	slot8 = getProxy(BayProxy):getShipCount()

	if slot5 > 0 and slot6:getMaxShipBag() < slot5 + slot8 then
		return false, i18n("mail_takeAttachment_error_dockYrad_full")
	end

	return true
end

slot0.sortByTime = function (slot0, slot1)
	if slot0.readFlag == slot1.readFlag then
		if ((slot0.attachFlag == slot0.ATTACHMENT_EXIST and 1) or 0) == ((slot1.attachFlag == slot0.ATTACHMENT_EXIST and 1) or 0) then
			if slot0.date == slot1.date then
				return slot1.id < slot0.id
			else
				return slot1.date < slot0.date
			end
		else
			return slot3 < slot2
		end
	else
		return slot0.readFlag < slot1.readFlag
	end
end

slot0.setReadFlag = function (slot0, slot1)
	slot0.readFlag = slot1
end

slot0.setImportantFlag = function (slot0, slot1)
	slot0.importantFlag = slot1
end

return slot0
