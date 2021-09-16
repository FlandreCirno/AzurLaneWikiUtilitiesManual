MetaCharacterConst = {
	Meta_Type_Act_PT = 1,
	Meta_Type_Build = 2,
	REPAIR_ATTRS = {
		AttributeType.Cannon,
		AttributeType.Torpedo,
		AttributeType.Air,
		AttributeType.Reload
	},
	ENERGY_ATTRS = {
		AttributeType.Durability,
		AttributeType.Cannon,
		AttributeType.Torpedo,
		AttributeType.AntiAircraft,
		AttributeType.Air,
		AttributeType.AntiSub,
		AttributeType.Expend
	},
	UIConfig = {
		[970701] = {
			29,
			-4,
			1.35,
			1.35,
			-250,
			0,
			-250,
			0,
			-250,
			0
		},
		[970702] = {
			29,
			-73.3,
			1.4,
			1.4,
			-300,
			-58,
			-300,
			-58,
			-300,
			-58
		},
		[970201] = {
			41.6,
			-102.3,
			1,
			1,
			-300,
			-58,
			-300,
			-58,
			-300,
			-58
		},
		[970703] = {
			-13.9,
			-11.3,
			1,
			1,
			-441.2,
			-58,
			-441.2,
			-58,
			-441.2,
			-58
		}
	},
	META_ART_RESOURCE_PERFIX = "metaship/",
	META_ACTIVE_LASTFIX = "_active",
	META_DISACTIVE_LASTFIX = "_disactive",
	META_BANNER_PERFIX = "banner_",
	META_NAME_PERFIX = "name_",
	META_TOAST_PERFIX = "toast_",
	GetMetaCharacterPaintPath = function (slot0, slot1)
		if slot1 == true then
			return slot0.META_ART_RESOURCE_PERFIX .. slot2, slot0 .. slot0.META_ACTIVE_LASTFIX
		else
			return slot0.META_ART_RESOURCE_PERFIX .. slot2, slot0 .. slot0.META_DISACTIVE_LASTFIX
		end
	end,
	GetMetaCharacterBannerPath = function (slot0)
		return slot0.META_ART_RESOURCE_PERFIX .. slot1, slot0.META_BANNER_PERFIX .. slot0
	end,
	GetMetaCharacterNamePath = function (slot0)
		return slot0.META_ART_RESOURCE_PERFIX .. slot1, slot0.META_NAME_PERFIX .. slot0
	end,
	GetMetaCharacterToastPath = function (slot0)
		return slot0.META_ART_RESOURCE_PERFIX .. slot1, slot0.META_TOAST_PERFIX .. slot0
	end,
	GetMetaShipGroupIDByConfigID = function (slot0)
		return math.floor(slot0 / 10)
	end
}

MetaCharacterConst.isMetaRepairRedTag = function (slot0)
	if not slot0 then
		return false
	end

	if not getProxy(BayProxy):getMetaShipByGroupId(slot0) then
		return false
	end

	if not slot1:getMetaCharacter() then
		return false
	end

	slot3 = false

	for slot7, slot8 in ipairs(MetaCharacterConst.REPAIR_ATTRS) do
		if slot2:getAttrVO(slot8):isCanRepair() == true then
			break
		end
	end

	return slot3
end

MetaCharacterConst.isMetaEnergyRedTag = function (slot0)
	if not slot0 then
		return false
	end

	if not getProxy(BayProxy):getMetaShipByGroupId(slot0) then
		return false
	end

	if not slot1:getMetaCharacter() then
		return false
	end

	slot3 = true

	if not slot2:getBreakOutInfo():hasNextInfo() then
		slot3 = false
	end

	slot5, slot6 = slot4:getLimited()

	if slot1.level < slot5 or slot2:getCurRepairExp() < slot6 then
		slot3 = false
	end

	slot7, slot8 = slot4:getConsume()
	slot9, slot10, slot11 = nil

	if getProxy(BagProxy):getItemCountById(slot8[1].itemId) < slot8[1].count then
		slot3 = false
	end

	if getProxy(PlayerProxy):getData().gold < slot7 then
		slot3 = false
	end

	return slot3
end

MetaCharacterConst.isMetaTacticsRedTag = function (slot0)
	return getProxy(MetaCharacterProxy):getRedTag(slot0)
end

MetaCharacterConst.isMetaSynRedTag = function (slot0)
	if not slot0 then
		return false
	end

	if not getProxy(BayProxy):getMetaShipByGroupId(slot0) then
		return false
	end

	if not slot1:getMetaCharacter() then
		return false
	end

	slot3 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(slot0)

	slot3:setDataBeforeGet()

	if slot3:isBuildType() then
		return false
	end

	if not slot3:isShow() then
		return false
	end

	slot4 = false

	if slot3.metaPtData then
		slot4 = slot3.metaPtData:CanGetAward()
	end

	return slot4
end

MetaCharacterConst.isMetaMainSceneRedTag = function (slot0)
	if not slot0 then
		return false
	end

	if getProxy(BayProxy):getMetaShipByGroupId(slot0) then
		return false
	end

	slot2 = getProxy(MetaCharacterProxy):getMetaProgressVOByID(slot0)

	slot2:setDataBeforeGet()

	if slot2:isBuildType() then
		return false
	end

	if not slot2:isShow() then
		return false
	end

	if slot2:getMetaProgressPTState() == MetaProgress.STATE_CAN_FINISH or slot3 == MetaProgress.STATE_CAN_AWARD then
		return true
	end
end

MetaCharacterConst.isAnyMetaRedPoint = function ()
	for slot4, slot5 in ipairs(slot0) do
		if (slot0.isMetaMainSceneRedTag(slot5.id) or slot0.isMetaRepairRedTag(slot5.id) or slot0.isMetaEnergyRedTag(slot5.id) or slot0.isMetaTacticsRedTag(slot5.id) or slot0.isMetaSynRedTag(slot5.id)) == true then
			return true
		end
	end

	return false
end

MetaCharacterConst.getFinalSkillIDListByMetaGroupID = function (slot0)
	slot1 = nil

	for slot5 = 1, 4, 1 do
		if pg.ship_data_template[slot0 * 10 + slot5] then
			slot1 = slot6
		end

		break
	end

	slot2 = {}

	for slot6, slot7 in ipairs(pg.ship_data_template[slot1].buff_list_display) do
		table.insert(slot2, slot7)
	end

	return slot2
end

MetaCharacterConst.getTacticsSkillIDListByShipConfigID = function (slot0)
	slot1 = {}

	for slot7, slot8 in ipairs(slot3) do
		if MetaCharacterConst.isMetaTaskSkillID(slot8) then
			table.insert(slot1, slot8)
		end
	end

	return slot1
end

MetaCharacterConst.getMetaSkillTacticsConfig = function (slot0, slot1)
	for slot5, slot6 in ipairs(pg.ship_meta_skilltask) do
		if slot6.skill_ID == slot0 and slot6.level == slot1 then
			return slot6
		end
	end
end

MetaCharacterConst.addReMetaTransItem = function (slot0, slot1)
	if not slot0.virgin and slot0:isMetaShip() and Player.isMetaShipNeedToTrans(slot0.configId) then
		slot2 = Player.metaShip2Res(slot0.configId)

		if not slot1 then
			for slot6, slot7 in ipairs(slot2) do
				pg.m02:sendNotification(GAME.ADD_ITEM, Item.New({
					type = slot7.type,
					id = slot7.id,
					count = slot7.count
				}))
			end
		end

		return Item.New({
			type = slot2[1].type,
			id = slot2[1].id,
			count = slot2[1].count
		})
	end
end

MetaCharacterConst.isMetaTaskSkillID = function (slot0)
	for slot4, slot5 in ipairs(pg.ship_meta_skilltask) do
		if slot5.skill_ID == slot0 then
			return true
		end
	end

	return false
end

return MetaCharacterConst
