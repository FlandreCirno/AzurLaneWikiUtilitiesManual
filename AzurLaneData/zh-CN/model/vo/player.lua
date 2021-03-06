slot0 = class("Player", import(".PlayerAttire"))
slot2 = pg.player_resource.get_id_list_by_name
slot3, slot4 = nil
slot0.MAX_SHIP_BAG = 4000
slot0.MAX_EQUIP_BAG = 2000
slot0.MAX_COMMANDER_BAG = 200
slot0.ASSISTS_TYPE_SHAM = 0
slot0.ASSISTS_TYPE_GUILD = 1
slot0.CHANGE_NAME_KEY = 1

function id2res(slot0)
	return slot0[slot0].name
end

function res2id(slot0)
	return slot0.get_id_list_by_name[slot0][1]
end

function id2ItemId(slot0)
	return slot0[slot0].itemid
end

function itemId2Id(slot0)
	return
end

slot0.skin2Res = function (slot0, slot1)
	slot3 = 1
	slot4 = 0

	for slot8, slot9 in pairs(pg.drop_data_restore.all) do
		if slot0 == slot2[slot9].target_id and slot1 == slot10.drop_id then
			slot3 = slot10.resource_type
			slot4 = slot10.resource_num

			break
		end
	end

	return slot3, slot4
end

slot0.headFrame2Res = function (slot0, slot1)
	slot3 = 1
	slot4 = 0

	for slot8, slot9 in pairs(pg.drop_data_restore.all) do
		if slot0 == slot2[slot9].target_id and slot1 == slot10.drop_id then
			slot3 = slot10.resource_type
			slot4 = slot10.resource_num

			break
		end
	end

	return slot3, slot4
end

slot0.isMetaShipNeedToTrans = function (slot0)
	return (getProxy(BayProxy):getMetaShipByGroupId(MetaCharacterConst.GetMetaShipGroupIDByConfigID(slot0)) and true) or false
end

slot0.metaShip2Res = function (slot0)
	slot9 = nil
	slot9 = (not (getProxy(BayProxy):getMetaShipByGroupId(slot1).getMetaCharacter(slot2).getSpecialMaterialInfoToMaxStar(slot3).count <= getProxy(BagProxy):getItemCountById(getProxy(BayProxy).getMetaShipByGroupId(slot1).getMetaCharacter(slot2).getSpecialMaterialInfoToMaxStar(slot3).itemID)) or pg.ship_transform[slot1].common_item) and pg.ship_transform[slot1].exclusive_item
	slot10 = {}

	for slot14, slot15 in ipairs(slot9) do
		table.insert(slot10, {
			type = slot15[1],
			id = slot15[2],
			count = slot15[3]
		})
	end

	return slot10
end

slot0.getSkinTicket = function (slot0)
	return (pg.gameset.skin_ticket.key_value ~= 0 or 0) and slot0:getResource(slot1)
end

slot0.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)

	if slot0.character then
		if type(slot2) == "number" then
			slot0.character = slot2
			slot0.characters = {
				slot2
			}
		else
			slot0.character = slot2[1]
			slot0.characters = slot2
		end
	end

	slot0.id = slot1.id
	slot0.name = slot1.name
	slot0.level = slot1.level or slot1.lv
	slot0.configId = slot0.level
	slot0.exp = slot1.exp or 0
	slot0.attackCount = slot1.attack_count or 0
	slot0.winCount = slot1.win_count or 0
	slot0.manifesto = slot1.adv or slot1.manifesto
	slot0.shipBagMax = slot1.ship_bag_max
	slot0.equipBagMax = slot1.equip_bag_max
	slot0.buff_list = slot1.buffList or {}
	slot0.rank = slot1.rank or slot1.title or 0
	slot0.pvp_attack_count = slot1.pvp_attack_count or 0
	slot0.pvp_win_count = slot1.pvp_win_count or 0
	slot0.collect_attack_count = slot1.collect_attack_count or 0
	slot0.guideIndex = slot1.guide_index
	slot0.buyOilCount = slot1.buy_oil_count
	slot0.chatRoomId = slot1.chat_room_id or 1
	slot0.score = slot1.score or 0
	slot0.guildWaitTime = slot1.guild_wait_time or 0
	slot0.commanderBagMax = slot1.commander_bag_max
	slot0.displayTrophyList = slot1.medal_id or {}
	slot0.banBackyardUploadTime = slot1.theme_upload_not_allowed_time or 0
	slot0.identityFlag = slot1.gm_flag
	slot3 = getProxy(AppreciateProxy)

	if slot1.appreciation then
		slot4 = ipairs
		slot5 = slot1.appreciation.gallerys or {}

		for slot7, slot8 in slot4(slot5) do
			slot3:addPicIDToUnlockList(slot8)
		end

		slot4 = ipairs
		slot5 = slot1.appreciation.musics or {}

		for slot7, slot8 in slot4(slot5) do
			slot3:addMusicIDToUnlockList(slot8)
		end

		slot4 = ipairs
		slot5 = slot1.appreciation.favor_gallerys or {}

		for slot7, slot8 in slot4(slot5) do
			slot3:addPicIDToLikeList(slot8)
		end

		slot4 = ipairs
		slot5 = slot1.appreciation.favor_musics or {}

		for slot7, slot8 in slot4(slot5) do
			slot3:addMusicIDToLikeList(slot8)
		end

		if getProxy(AppreciateProxy):getResultForVer() then
			pg.ConnectionMgr.GetInstance():Send(15300, {
				type = 0,
				ver_str = slot5
			})
			slot4:clearVer()
		end
	end

	if slot1.cartoon_read_mark then
		slot3:initMangaReadIDList(slot1.cartoon_read_mark)
	end

	if slot1.cartoon_collect_mark then
		slot3:initMangaLikeIDList(slot1.cartoon_collect_mark)
	end

	slot0.cdList = {}
	slot4 = ipairs
	slot5 = slot1.cd_list or {}

	for slot7, slot8 in slot4(slot5) do
		slot0.cdList[slot8.key] = slot8.timestamp
	end

	slot0.commonFlagList = {}
	slot4 = ipairs
	slot5 = slot1.flag_list or {}

	for slot7, slot8 in slot4(slot5) do
		slot0.commonFlagList[slot8] = true
	end

	slot0.registerTime = slot1.register_time
	slot0.vipCards = {}
	slot4 = ipairs
	slot5 = slot1.card_list or {}

	for slot7, slot8 in slot4(slot5) do
		slot0.vipCards[VipCard.New(slot8).id] = VipCard.New(slot8)
	end

	slot0:updateResources(slot1.resource_list)

	slot0.maxRank = slot1.max_rank or 0
	slot0.shipCount = slot1.ship_count or 0
	slot0.chargeExp = slot1.acc_pay_lv or 0
	slot0.mingshiflag = 0
	slot0.mingshiCount = 0
	slot0.chatMsgBanTime = slot1.chat_msg_ban_time or 0
	slot0.displayInfo = slot1.display or {}
	slot0.attireInfo = {
		[AttireConst.TYPE_ICON_FRAME] = slot0.iconFrame,
		[AttireConst.TYPE_CHAT_FRAME] = slot0.chatFrame
	}
end

slot0.updateAttireFrame = function (slot0, slot1, slot2)
	slot0.attireInfo[slot1] = slot2
end

slot0.getAttireByType = function (slot0, slot1)
	return slot0.attireInfo[slot1]
end

slot0.getRandomSecretary = function (slot0)
	return slot0.characters[math.random(#slot0.characters)]
end

slot0.canModifyName = function (slot0)
	slot1 = pg.TimeMgr.GetInstance():GetServerTime()

	if slot0.level < pg.gameset.player_name_change_lv_limit.key_value then
		return false, i18n("player_name_change_time_lv_tip", slot2)
	end

	if slot1 < slot0:getModifyNameTimestamp() then
		slot4, slot5, slot6, slot7 = pg.TimeMgr.GetInstance():parseTimeFrom(slot3 - slot1)
		slot8 = nil

		return false, i18n("player_name_change_time_limit_tip", (slot4 == 0 and ((slot5 == 0 and math.max(slot6, 1) .. i18n("word_minute")) or slot5 .. i18n("word_hour"))) or slot4 .. i18n("word_date"))
	end

	return true
end

slot0.getModifyNameComsume = function (slot0)
	return pg.gameset.player_name_change_cost.description
end

slot0.getModifyNameTimestamp = function (slot0)
	return slot0.cdList[slot0.CHANGE_NAME_KEY] or 0
end

slot0.updateModifyNameColdTime = function (slot0, slot1)
	slot0.cdList[slot0.CHANGE_NAME_KEY] = slot1
end

slot0.getMaxGold = function (slot0)
	return pg.gameset.max_gold.key_value
end

slot0.getMaxOil = function (slot0)
	return pg.gameset.max_oil.key_value
end

slot0.getLevelMaxGold = function (slot0)
	return (getProxy(GuildProxy):GetAdditionGuild() and slot0:getConfig("max_gold") + slot2:getMaxGoldAddition()) or slot0.getConfig("max_gold")
end

slot0.getLevelMaxOil = function (slot0)
	return (getProxy(GuildProxy):GetAdditionGuild() and slot0:getConfig("max_oil") + slot2:getMaxOilAddition()) or slot0.getConfig("max_oil")
end

slot0.getResource = function (slot0, slot1)
	return slot0[id2res(slot1)] or 0
end

slot0.updateResources = function (slot0, slot1)
	for slot5, slot6 in pairs(slot0) do
		slot7 = slot6[1]

		if slot5 == "gem" then
			slot0.chargeGem = 0
		elseif slot5 == "freeGem" then
			slot0.awardGem = 0
		else
			slot0[slot5] = 0
		end
	end

	slot2 = ipairs
	slot3 = slot1 or {}

	for slot5, slot6 in slot2(slot3) do
		if id2res(slot6.type) == "gem" then
			slot0.chargeGem = slot6.num
		elseif slot7 == "freeGem" then
			slot0.awardGem = slot6.num
		else
			slot0[slot7] = slot6.num
		end
	end
end

slot0.getPainting = function (slot0)
	return (pg.ship_skin_template[slot0.skinId] and slot1.painting) or "unknown"
end

slot0.inGuildCDTime = function (slot0)
	return slot0.guildWaitTime > 0 and pg.TimeMgr.GetInstance():GetServerTime() < slot0.guildWaitTime
end

slot0.setGuildWaitTime = function (slot0, slot1)
	slot0.guildWaitTime = slot1
end

slot0.getChargeLevel = function (slot0)
	slot2 = pg.pay_level_award.all[1]
	slot3 = pg.pay_level_award.all[#pg.pay_level_award.all]

	for slot7, slot8 in ipairs(pg.pay_level_award.all) do
		if slot1[slot8].exp <= slot0.chargeExp then
			slot2 = math.min(slot8 + 1, slot3)
		end
	end

	return slot2
end

slot0.getCardById = function (slot0, slot1)
	return Clone(slot0.vipCards[slot1])
end

slot0.addVipCard = function (slot0, slot1)
	slot0.vipCards[slot1.id] = slot1
end

slot0.addShipBagCount = function (slot0, slot1)
	slot0.shipBagMax = slot0.shipBagMax + slot1
end

slot0.addEquipmentBagCount = function (slot0, slot1)
	slot0.equipBagMax = slot0.equipBagMax + slot1
end

slot0.bindConfigTable = function (slot0)
	return pg.user_level
end

slot0.updateScoreAndRank = function (slot0, slot1, slot2)
	slot0.score = slot1
	slot0.rank = slot2
end

slot0.increasePvpCount = function (slot0)
	slot0.pvp_attack_count = slot0.pvp_attack_count + 1
end

slot0.increasePvpWinCount = function (slot0)
	slot0.pvp_win_count = slot0.pvp_win_count + 1
end

slot0.isEnough = function (slot0, slot1)
	for slot5, slot6 in pairs(slot1) do
		if slot0[slot5] == nil or slot0[slot5] < slot6 then
			return false, slot5
		end
	end

	return true
end

slot0.increaseBuyOilCount = function (slot0)
	slot0.buyOilCount = slot0.buyOilCount + 1
end

slot0.changeChatRoom = function (slot0, slot1)
	slot0.chatRoomId = slot1
end

slot0.increaseAttackCount = function (slot0)
	slot0.attackCount = slot0.attackCount + 1
end

slot0.increaseAttackWinCount = function (slot0)
	slot0.winCount = slot0.winCount + 1
end

slot0.increaseShipCount = function (slot0, slot1)
	slot0.shipCount = slot0.shipCount + ((slot1 and slot1) or 1)
end

slot0.isFull = function (slot0)
	for slot4, slot5 in pairs(slot0) do
		if pg.user_level["max_" .. slot4] and slot0[slot4] < slot6 then
			return false
		end
	end

	return true
end

slot0.getMaxEquipmentBag = function (slot0)
	slot1 = slot0.equipBagMax
	slot2 = 0

	if getProxy(GuildProxy):GetAdditionGuild() then
		slot2 = slot3:getEquipmentBagAddition()
	end

	return slot2 + slot1
end

slot0.getMaxShipBag = function (slot0)
	slot1 = slot0.shipBagMax
	slot2 = 0

	if getProxy(GuildProxy):GetAdditionGuild() then
		slot2 = slot3:getShipBagAddition()
	end

	return slot2 + slot1
end

slot0.getMaxEquipmentBagExcludeGuild = function (slot0)
	return slot0.equipBagMax
end

slot0.getMaxShipBagExcludeGuild = function (slot0)
	return slot0.shipBagMax
end

slot0.__index = function (slot0, slot1)
	if slot1 == "gem" then
		return slot0:getChargeGem()
	elseif slot1 == "freeGem" then
		return slot0:getTotalGem()
	elseif slot1 == "equipBagMax" then
		return slot0:getMaxEquipmentBag()
	elseif slot1 == "shipBagMax" then
		return slot0:getMaxShipBag()
	end

	return rawget(slot0, slot1) or slot0[slot1] or slot0.super[slot1]
end

slot0.__newindex = function (slot0, slot1, slot2)
	rawset(slot0, slot1, slot2)
end

slot0.getFreeGem = function (slot0)
	return slot0.awardGem
end

slot0.getChargeGem = function (slot0)
	return slot0.chargeGem
end

slot0.getTotalGem = function (slot0)
	return slot0:getFreeGem() + slot0:getChargeGem()
end

slot0.getResById = function (slot0, slot1)
	if slot1 == 4 then
		return slot0:getTotalGem()
	else
		return slot0[id2res(slot1)]
	end
end

slot0.consume = function (slot0, slot1)
	slot1.freeGem = nil
	slot1.gem = nil

	if (slot1.freeGem or 0) + (slot1.gem or 0) > 0 then
		slot0.awardGem = slot0:getFreeGem() - math.min(slot2, slot3)
		slot0.chargeGem = slot0.chargeGem - (slot2 - math.min(slot2, slot3))
	end

	for slot6, slot7 in pairs(slot1) do
		slot0[slot6] = slot0[slot6] - slot7
	end
end

slot0.addResources = function (slot0, slot1)
	for slot5, slot6 in pairs(slot1) do
		if slot5 == "gold" then
			slot0[slot5] = math.min(slot0[slot5] + slot6, slot0:getMaxGold())
		elseif slot5 == "oil" then
			slot0[slot5] = math.min(slot0[slot5] + slot6, slot0:getMaxOil())
		elseif slot5 == "chargeGem" then
			slot0.chargeGem = slot0:getChargeGem() + slot6
		elseif slot5 == "gem" or slot5 == "freeGem" then
			slot0.awardGem = slot0:getFreeGem() + slot6
		elseif slot5 == id2res(WorldConst.ResourceID) then
			slot0[slot5] = math.min(slot0[slot5] + slot6, pg.gameset.world_resource_max.key_value)
		else
			slot0[slot5] = slot0[slot5] + slot6
		end
	end
end

slot0.resetBuyOilCount = function (slot0)
	slot0.buyOilCount = 0
end

slot0.addExp = function (slot0, slot1)
	slot0.exp = slot0.exp + slot1

	while slot0:canLevelUp() do
		slot0.exp = slot0.exp - slot0:getLevelExpConfig().exp_interval
		slot0.level = slot0.level + 1

		pg.TrackerMgr.GetInstance():Tracking(TRACKING_USER_LEVELUP, slot0.level)

		if slot0.level == 30 then
			pg.TrackerMgr.GetInstance():Tracking(TRACKING_USER_LEVEL_THIRTY)

			if slot0.level == 40 then
				pg.TrackerMgr.GetInstance():Tracking(TRACKING_USER_LEVEL_FORTY)
			end
		end
	end
end

slot0.GetBuffs = function (slot0)
	return slot0.buff_list
end

slot0.getLevelExpConfig = function (slot0)
	return getConfigFromLevel1(pg.user_level, slot0.level)
end

slot0.getMaxLevel = function (slot0)
	return pg.user_level.all[#pg.user_level.all]
end

slot0.getTotalExp = function (slot0)
	return slot0:getLevelExpConfig().exp_start + slot0.exp
end

slot0.canLevelUp = function (slot0)
	return getConfigFromLevel1(pg.user_level, slot0.level + 1) and getConfigFromLevel1(pg.user_level, slot0.level) ~= slot1 and slot0:getLevelExpConfig().exp_interval <= slot0.exp
end

slot0.isSelf = function (slot0)
	return getProxy(PlayerProxy):isSelf(slot0.id)
end

slot0.isFriend = function (slot0)
	return getProxy(FriendProxy):isFriend(slot0.id)
end

slot0.OilMax = function (slot0, slot1)
	if (slot1 or 0) < 0 then
		slot1 = 0
	end

	return pg.gameset.max_oil.key_value < slot0.oil + slot1
end

slot0.GoldMax = function (slot0, slot1)
	return pg.gameset.max_gold.key_value < slot0.gold + (slot1 or 0)
end

slot0.UpdateCommonFlag = function (slot0, slot1)
	slot0.commonFlagList[slot1] = true
end

slot0.GetCommonFlag = function (slot0, slot1)
	return slot0.commonFlagList[slot1]
end

slot0.CancelCommonFlag = function (slot0, slot1)
	slot0.commonFlagList[slot1] = false
end

slot0.updateCommanderBagMax = function (slot0, slot1)
	slot0.commanderBagMax = slot0.commanderBagMax + slot1
end

slot0.GetDaysFromRegister = function (slot0)
	slot1 = pg.TimeMgr.GetInstance():GetServerTime()

	return math.floor((os.time({
		minute = 0,
		second = 0,
		hour = 0,
		year = os.date("%Y", slot1),
		month = os.date("%m", slot1),
		day = os.date("%d", slot1)
	}) - os.time({
		minute = 0,
		second = 0,
		hour = 0,
		year = os.date("%Y", slot0.registerTime),
		month = os.date("%m", slot0.registerTime),
		day = os.date("%d", slot0.registerTime)
	})) / 86400)
end

slot0.CanUploadBackYardThemeTemplate = function (slot0)
	return slot0.banBackyardUploadTime <= pg.TimeMgr.GetInstance():GetServerTime()
end

slot0.GetBanUploadBackYardThemeTemplateTime = function (slot0)
	return pg.TimeMgr.GetInstance():STimeDescC(slot0.banBackyardUploadTime or 0)
end

slot0.CheckIdentityFlag = function (slot0)
	return slot0.identityFlag == 1
end

slot0.GetRegisterTime = function (slot0)
	return slot0.registerTime
end

return slot0
