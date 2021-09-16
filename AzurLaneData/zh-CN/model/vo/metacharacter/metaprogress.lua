slot0 = class("MetaProgress", import("..BaseVO"))
slot0.STATE_LESS_PT = 1
slot0.STATE_LESS_STORY = 2
slot0.STATE_CAN_AWARD = 3
slot0.STATE_CAN_FINISH = 4
slot0.STATE_GOT_SHIP = 5

slot0.bindConfigTable = function (slot0)
	return pg.ship_strengthen_meta
end

slot0.Ctor = function (slot0, slot1)
	slot0.id = slot1.id
	slot0.configId = slot0.id
	slot0.metaType = slot0:getConfig("type")
	slot0.actID = slot0:getConfig("activity_id")
	slot0.metaAct = nil
	slot0.metaShipVO = nil

	if slot0:isPtType() then
		slot0.unlockPTNum = slot0:getConfig("synchronize")
		slot0.unlockPTLevel = nil
		slot0.metaPtData = nil
	end
end

slot0.updateMetaPtData = function (slot0, slot1)
	if slot0.metaPtData then
		slot0.metaPtData:Update(slot0.metaAct)
	else
		slot0.metaPtData = ActivityPtData.New(slot0.metaAct)
	end
end

slot0.getSynRate = function (slot0)
	slot1, slot2, slot3 = slot0.metaPtData:GetResProgress()

	return slot1 / slot0.unlockPTNum
end

slot0.getStoryIndexList = function (slot0)
	return slot0.metaAct:getDataConfig("unlock_story")
end

slot0.getCurLevelStoryIndex = function (slot0)
	slot1, slot2, slot3 = slot0.metaPtData:GetLevelProgress()

	return slot0:getStoryIndexList()[slot1]
end

slot0.isFinishCurLevelStory = function (slot0)
	slot2 = false

	if slot0:getCurLevelStoryIndex() == 0 then
		slot2 = true
	else
		slot3 = pg.NewStoryMgr.GetInstance()

		if slot3:IsPlayed(slot3:StoryName2StoryId(slot1)) then
			slot2 = true
		end
	end

	return slot2
end

slot0.getCurLevelStoryName = function (slot0)
	return pg.memory_template[slot0:getCurLevelStoryIndex()].title
end

slot0.isCanGetAward = function (slot0)
	slot1 = slot0.metaPtData:CanGetAward()
	slot3 = false

	if slot0:getCurLevelStoryIndex() == 0 then
		slot3 = true
	else
		slot4 = pg.NewStoryMgr.GetInstance()
		slot6 = slot4:GetStoryByName("index")[slot2]

		if slot4:IsPlayed(slot2) then
			slot3 = true
		end
	end

	return slot1 and slot3
end

slot0.getMetaProgressPTState = function (slot0)
	slot1 = slot0.metaPtData:CanGetAward()
	slot2 = slot0:isFinishCurLevelStory()
	slot3 = slot0:isUnlocked()

	if slot0.metaPtData.level + 1 < slot0.unlockPTLevel then
		if not slot1 then
			return slot0.STATE_LESS_PT
		elseif slot2 == false then
			return slot0.STATE_LESS_STORY
		elseif slot2 == true then
			return slot0.STATE_CAN_AWARD
		end
	elseif slot4 == slot0.unlockPTLevel then
		if not slot1 then
			return slot0.STATE_LESS_PT
		elseif slot2 == false then
			return slot0.STATE_LESS_STORY
		elseif slot2 == true then
			return slot0.STATE_CAN_FINISH
		end
	elseif slot0.unlockPTLevel < slot4 then
		return slot0.STATE_GOT_SHIP
	end
end

slot0.getRepairRateFromMetaCharacter = function (slot0)
	return slot0.metaShipVO.metaCharacter:getRepairRate()
end

slot0.isPtType = function (slot0)
	return slot0.metaType == MetaCharacterConst.Meta_Type_Act_PT
end

slot0.isBuildType = function (slot0)
	return slot0.metaType == MetaCharacterConst.Meta_Type_Build
end

slot0.isInAct = function (slot0)
	if slot0.metaAct and not slot0.metaAct:isEnd() then
		return true
	else
		return false
	end
end

slot0.isUnlocked = function (slot0)
	return slot0.metaShipVO ~= nil
end

slot0.isShow = function (slot0)
	slot1 = slot0:isInAct()
	slot3 = true

	if slot0:isUnlocked() then
		return true
	elseif slot1 then
		if slot0:isPtType() and slot3 then
			return true
		elseif slot0:isBuildType() then
			return true
		else
			return false
		end
	else
		return false
	end
end

slot0.getMetaActivityFromActProxy = function (slot0, slot1)
	if getProxy(ActivityProxy):getActivityById(slot0.actID) and not slot2:isEnd() then
		return slot2
	end
end

slot0.getMetaShipFromBayProxy = function (slot0)
	slot0.metaShipVO = getProxy(BayProxy):getMetaShipByGroupId(slot0.configId)

	return getProxy(BayProxy).getMetaShipByGroupId(slot0.configId)
end

slot0.getShip = function (slot0)
	return slot0.metaShipVO
end

slot0.updateShip = function (slot0, slot1)
	slot0.metaShipVO = slot1
end

slot0.setDataBeforeGet = function (slot0)
	slot0.metaAct = slot0:getMetaActivityFromActProxy()
	slot0.metaShipVO = slot0:getMetaShipFromBayProxy()

	if slot0:isPtType() and slot0.metaAct then
		slot0:updateMetaPtData()
	end

	if slot0:isPtType() and slot0.metaAct and not slot0.unlockPTLevel then
		for slot5, slot6 in ipairs(slot1) do
			if slot6 == slot0.unlockPTNum then
				slot0.unlockPTLevel = slot5

				break
			end
		end
	end
end

slot0.updateDataAfterActOP = function (slot0)
	slot0.metaAct = slot0:getMetaActivityFromActProxy()

	if slot0:isPtType() and slot0.metaAct then
		slot0:updateMetaPtData()
	end
end

slot0.updateDataAfterAddShip = function (slot0)
	slot0.metaShipVO = slot0:getMetaShipFromBayProxy()
end

slot0.getPaintPathAndName = function (slot0)
	slot4, slot5 = MetaCharacterConst.GetMetaCharacterPaintPath(slot0.configId, slot1)

	return slot2, slot3
end

slot0.getBannerPathAndName = function (slot0)
	slot3, slot4 = MetaCharacterConst.GetMetaCharacterBannerPath(slot0.configId)

	return slot1, slot2
end

slot0.getBGNamePathAndName = function (slot0)
	slot3, slot4 = MetaCharacterConst.GetMetaCharacterNamePath(slot0.configId)

	return slot1, slot2
end

slot0.getPtIconPath = function (slot0)
	return pg.item_data_statistics[id2ItemId(slot0.metaPtData.resId)].icon
end

return slot0
