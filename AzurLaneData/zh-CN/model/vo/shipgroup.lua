slot0 = class("ShipGroup", import(".BaseVO"))
slot0.REQ_INTERVAL = 60

slot0.GetGroupConfig = function (slot0)
	for slot4, slot5 in pairs(pg.ship_data_group) do
		if slot5.group_type == slot0 then
			return slot5
		end
	end
end

slot0.getDefaultShipConfig = function (slot0)
	slot1 = nil

	for slot5 = 4, 1, -1 do
		if pg.ship_data_statistics[tonumber(slot0 .. slot5)] then
			break
		end
	end

	return slot1
end

slot0.getDefaultShipNameByGroupID = function (slot0)
	return slot0:getDefaultShipConfig().name
end

slot0.IsBluePrintGroup = function (slot0)
	return tobool(pg.ship_data_blueprint[slot0])
end

slot0.IsMetaGroup = function (slot0)
	return tobool(pg.ship_strengthen_meta[slot0])
end

slot0.STATE_LOCK = 0
slot0.STATE_NOTGET = 1
slot0.STATE_UNLOCK = 2
slot0.ENABLE_SKIP_TO_CHAPTER = true
slot1 = pg.ship_data_group

slot0.getState = function (slot0, slot1, slot2)
	function slot3()
		if slot0.ENABLE_SKIP_TO_CHAPTER then
			if slot1 and not slot2 then
				return slot0.STATE_NOTGET
			end

			if slot3[slot4] then
				if not slot3[slot4].hide then
					return slot0.STATE_LOCK
				end

				if slot0.hide == 1 then
					return slot0.STATE_LOCK
				elseif slot0.hide ~= 0 then
					return slot0.STATE_LOCK
				end
			end

			if slot2 then
				return slot0.STATE_UNLOCK
			else
				if not slot3[slot4] then
					return slot0.STATE_LOCK
				end

				slot2 = getProxy(ChapterProxy)
				slot3 = nil

				if slot0.redirect_id ~= 0 then
					slot3 = slot2:getChapterById(slot1)
				end

				if slot1 == 0 or (slot3 and slot3:isClear()) then
					return slot0.STATE_NOTGET
				else
					return slot0.STATE_LOCK
				end
			end
		else
			return (slot2 and slot0.STATE_UNLOCK) or slot0.STATE_LOCK
		end
	end

	slot4 = slot3()

	if HXSet.isHx() and slot4 == slot0.STATE_NOTGET then
		return slot0.STATE_LOCK
	else
		return slot4
	end
end

slot0.Ctor = function (slot0, slot1)
	slot0.id = slot1.id
	slot0.star = slot1.star
	slot0.hearts = slot1.heart_count
	slot0.iheart = (slot1.heart_flag or 0) > 0
	slot0.married = slot1.marry_flag
	slot0.maxIntimacy = slot1.intimacy_max
	slot0.maxLV = slot1.lv_max
	slot0.evaluation = nil
	slot0.lastReqStamp = 0
	slot0.trans = false
	slot0.remoulded = slot1.remoulded
	slot2 = slot0.getDefaultShipConfig(slot0.id)
	slot0.shipConfig = setmetatable({}, {
		__index = function (slot0, slot1)
			return slot0[slot1]
		end
	})
	slot3 = slot0.GetGroupConfig(slot0.id)
	slot0.groupConfig = setmetatable({}, {
		__index = function (slot0, slot1)
			return slot0[slot1]
		end
	})
end

slot0.getName = function (slot0, slot1)
	slot2 = slot0.shipConfig.name

	if slot1 and slot0.trans then
		slot2 = HXSet.hxLan(pg.ship_skin_template[slot0.groupConfig.trans_skin].name)
	end

	return slot2
end

slot0.getNation = function (slot0)
	return slot0.shipConfig.nationality
end

slot0.getRarity = function (slot0, slot1)
	slot2 = slot0.shipConfig.rarity

	if slot1 and slot0.trans then
		slot2 = slot2 + 1
	end

	return slot2
end

slot0.getTeamType = function (slot0)
	return pg.ship_data_by_type[slot0:getShipType()].team_type
end

slot0.getPainting = function (slot0, slot1)
	slot2 = slot0.shipConfig.skin_id

	if slot1 and slot0.trans then
		slot2 = slot0.groupConfig.trans_skin
	end

	return pg.ship_skin_template[slot2].painting
end

slot0.getShipType = function (slot0, slot1)
	slot2 = slot0.shipConfig.type

	if slot1 and slot0.trans and Ship.getTransformShipId(slot0.shipConfig.id) then
		slot2 = pg.ship_data_statistics[slot3].type
	end

	return slot2
end

slot0.getShipConfigId = function (slot0, slot1)
	slot2 = slot0.shipConfig.id

	if slot1 and slot0.trans and Ship.getTransformShipId(slot0.shipConfig.id) then
		slot2 = pg.ship_data_statistics[slot3].id
	end

	return slot2
end

slot0.getSkinList = function (slot0)
	return ShipSkin.GetAllSkinByGroup(slot0)
end

slot0.getDisplayableSkinList = function (slot0)
	slot1 = {}

	function slot2(slot0)
		return slot0.skin_type == ShipSkin.SKIN_TYPE_OLD or (slot0.skin_type == ShipSkin.SKIN_TYPE_NOT_HAVE_HIDE and not getProxy(ShipSkinProxy):hasSkin(slot0.id))
	end

	function slot3(slot0)
		return getProxy(ShipSkinProxy):InShowTime(slot0)
	end

	for slot7, slot8 in ipairs(pg.ship_skin_template.all) do
		if pg.ship_skin_template[slot8].ship_group == slot0.id and slot9.no_showing ~= "1" and not slot2(slot9) and slot3(slot9.id) then
			table.insert(slot1, slot9)
		end
	end

	return slot1
end

slot0.getDefaultSkin = function (slot0)
	return ShipSkin.GetSkinByType(slot0, ShipSkin.SKIN_TYPE_DEFAULT)
end

slot0.getProposeSkin = function (slot0)
	return ShipSkin.GetSkinByType(slot0, ShipSkin.SKIN_TYPE_PROPOSE)
end

slot0.getModSkin = function (slot0)
	if pg.ship_data_trans[slot0] then
		return pg.ship_skin_template[slot1.skin_id]
	end

	return nil
end

slot0.GetSkin = function (slot0, slot1)
	if not slot1 then
		return slot0.getDefaultSkin(slot0.id)
	else
		return slot0.getModSkin(slot0.id)
	end
end

slot0.updateMaxIntimacy = function (slot0, slot1)
	slot0.maxIntimacy = math.max(slot1, slot0.maxIntimacy)
end

slot0.updateMarriedFlag = function (slot0)
	slot0.married = 1
end

slot0.isBluePrintGroup = function (slot0)
	return slot0.IsBluePrintGroup(slot0.id)
end

slot0.getBluePrintChangeSkillList = function (slot0)
	return pg.ship_data_blueprint[slot0.id].change_skill
end

slot0.GetSkin = function (slot0, slot1)
	if not slot1 then
		return slot0.getDefaultSkin(slot0.id)
	else
		return slot0.getModSkin(slot0.id)
	end
end

slot0.GetNationTxt = function (slot0)
	return Nation.Nation2facionName(slot1) .. "-" .. Nation.Nation2Name(slot0.shipConfig.nationality)
end

slot0.CONDITION_FORBIDDEN = -1
slot0.CONDITION_CLEAR = 0
slot0.CONDITION_INTIMACY = 1
slot0.CONDITION_MARRIED = 2

slot0.VoiceReplayCodition = function (slot0, slot1)
	slot2 = true
	slot3 = ""

	if slot0:isBluePrintGroup() and not table.contains(getProxy(TechnologyProxy):getBluePrintById(slot0.id).getUnlockVoices(slot4), slot1.key) and slot4:getUnlockLevel(slot1.key) > 0 then
		return false, i18n("ship_profile_voice_locked_design", slot6)
	end

	if slot0:isMetaGroup() and not table.contains(getProxy(BayProxy):getMetaShipByGroupId(slot0.id).getMetaCharacter(slot4).getUnlockedVoiceList(slot5), slot1.key) and slot5:getUnlockVoiceRepairPercent(slot1.key) > 0 then
		return false, i18n("ship_profile_voice_locked_meta", slot7)
	end

	if slot1.unlock_condition[1] == slot0.CONDITION_INTIMACY then
		if slot0.maxIntimacy < slot1.unlock_condition[2] then
			slot2 = false
			slot3 = i18n("ship_profile_voice_locked_intimacy", math.floor(slot1.unlock_condition[2] / 100))
		end
	elseif slot1.unlock_condition[1] == slot0.CONDITION_MARRIED and slot0.married == 0 then
		return false, (not slot0:IsXIdol() or i18n("ship_profile_voice_locked_propose_imas")) and i18n("ship_profile_voice_locked_propose")
	end
end

slot0.GetMaxIntimacy = function (slot0)
	return slot0.maxIntimacy / 100 + ((slot0.married and slot0.married * 1000) or 0)
end

slot0.isSpecialFilter = function (slot0)
	for slot4, slot5 in ipairs(slot0.shipConfig.tag_list) do
		if slot5 == "special" then
			return true
		end
	end

	return false
end

slot0.getGroupId = function (slot0)
	return slot0.id
end

slot0.isRemoulded = function (slot0)
	return slot0.remoulded
end

slot0.isMetaGroup = function (slot0)
	return slot0.IsMetaGroup(slot0.id)
end

slot2 = {
	feeling2 = true,
	feeling3 = true,
	feeling5 = true,
	feeling4 = true,
	propose = true,
	feeling1 = true
}

slot0.getIntimacyName = function (slot0, slot1)
	if not slot0[slot1] then
		return
	end

	if slot0:isMetaGroup() then
		return i18n("meta_voice_name_" .. slot1)
	elseif slot0:IsXIdol() then
		return i18n("idolmaster_voice_name_" .. slot1)
	end
end

slot0.getProposeType = function (slot0)
	if slot0:isMetaGroup() then
		return "meta"
	elseif slot0:IsXIdol() then
		return "imas"
	else
		return "default"
	end
end

slot0.IsXIdol = function (slot0)
	return slot0:getNation() == Nation.IDOL_LINK
end

return slot0
