slot0 = singletonClass("WorldGuider", import("....Mod.Experiment.BaseEntity"))
slot0.Fields = {
	tempGridPos = "table",
	tStamina = "number"
}

slot0.Init = function (slot0)
	slot0.tempGridPos = {}
end

slot0.SetTempGridPos = function (slot0, slot1, slot2)
	slot0.tempGridPos[slot2 or 1] = pg.GuideMgr.GetInstance():transformPos(slot1)
end

slot0.SetTempGridPos2 = function (slot0, slot1, slot2)
	slot0:SetTempGridPos(GameObject.Find("OverlayCamera"):GetComponent(typeof(Camera)).ScreenToWorldPoint(slot5, slot4), slot2)
end

slot0.GetTempGridPos = function (slot0, slot1)
	return slot0.tempGridPos[slot1 or 1]
end

slot0.CheckPlayChooseCamp = function (slot0)
	if nowWorld:GetRealm() == nil or slot1 < 1 then
		slot0:PlayGuide("WorldG001")
	end
end

slot0.CheckIntruduce = function (slot0)
	if nowWorld:GetRealm() and slot1 > 0 then
		if slot1 == 1 then
			slot0:PlayGuide("WorldG002_1")
		elseif slot1 == 2 then
			slot0:PlayGuide("WorldG002_2")
		end
	end
end

slot0.CheckUseStaminaItem = function (slot0)
	slot2 = nowWorld:GetInventoryProxy()
	slot3 = 0

	for slot7, slot8 in ipairs(slot1) do
		slot3 = slot3 + slot2:GetItemCount(slot8)
	end

	if slot3 > 0 then
		slot0:PlayGuide("WorldG020")
	end
end

slot0.CheckMapLimit = function (slot0)
	pg.GuideMgr.GetInstance():play("WorldG012")
end

slot0.SpecialCheck = function (slot0, slot1)
	if slot1 == "WorldG008" and nowWorld:GetActiveMap() ~= nil and slot2.findex == 2 then
		return "WorldG008_2"
	end

	return slot1
end

slot0.interruptReplayList = {
	"WorldG007",
	"WorldG021",
	"WorldG100",
	"WorldG121",
	"WorldG141",
	"WorldG151"
}

slot0.PlayGuide = function (slot0, slot1, slot2, slot3)
	slot4 = pg.GuideMgr.GetInstance()

	if not GUIDE_WROLD or (not slot2 and slot4:isPlayed(slot1)) or not slot4:canPlay() then
		existCall(slot3)

		return false
	end

	if not _.any(slot0.interruptReplayList, function (slot0)
		return slot0 == slot0
	end) then
		pg.m02.sendNotification(slot5, GAME.STORY_UPDATE, {
			storyId = slot1
		})
	end

	slot4:play(slot1, nil, function ()
		return existCall(existCall)
	end)

	return true
end

slot0.PlayGuideAndUpdateOnEnd = function (slot0, slot1)
	slot2 = pg.GuideMgr.GetInstance()

	if not GUIDE_WROLD or (not canRepeat and slot2:isPlayed(slot1)) or not slot2:canPlay() then
		return
	end

	slot2:play(slot1, nil, function ()
		pg.m02:sendNotification(GAME.STORY_UPDATE, {
			storyId = pg.m02.sendNotification
		})
	end)
end

slot0.WORLD_HIDE_UI = "world hide ui"
slot0.WORLD_OPEN_MAP_OVERVIEW = "world open map overview"
slot0.WORLD_SHOW_MARGIN = "world show margin"
slot0.WORLD_SCANNER_DISPLAY = "world scanner display"
slot0.WORLD_GET_COMPASS_POS = "world get compass pos"
slot0.WORLD_GET_COMPASS_MAP_POS = "world get compass map pos"
slot0.WORLD_GET_SLG_TILE_POS = "world get slg tile pos"
slot0.WORLD_GET_SCANNER_POS = "world get scanner pos"
slot0.WORLD_OPEN_TRANSPORT_POS = "world open transport pos"
slot0.WORLD_SELECT_MODEL_MAP = "world select model map"
slot0.WORLD_FOCUS_EDGE = "world focus edge"
slot0.WORLD_FOCUS_EVENT = "world focus event"
slot0.WORLD_SCANNER_EVENT = "world scanner event"
slot0.WORLD_HELP_EVENT = "world help event"

slot0.GetWorldGuiderNotifies = function (slot0)
	return {
		slot0.WORLD_HIDE_UI,
		slot0.WORLD_GET_COMPASS_POS,
		slot0.WORLD_GET_COMPASS_MAP_POS,
		slot0.WORLD_GET_SLG_TILE_POS,
		slot0.WORLD_GET_SCANNER_POS,
		slot0.WORLD_OPEN_MAP_OVERVIEW,
		slot0.WORLD_SHOW_MARGIN,
		slot0.WORLD_SCANNER_DISPLAY,
		slot0.WORLD_OPEN_TRANSPORT_POS,
		slot0.WORLD_SELECT_MODEL_MAP,
		slot0.WORLD_FOCUS_EDGE,
		slot0.WORLD_FOCUS_EVENT,
		slot0.WORLD_SCANNER_EVENT,
		slot0.WORLD_HELP_EVENT
	}
end

slot0.WorldGuiderNotifyHandler = function (slot0, slot1, slot2, slot3)
	if slot1 == slot0.WORLD_HIDE_UI then
		if slot2.type == 1 then
			slot3:HideMapRightCompass()
		elseif slot2.type == 2 then
			slot3:HideMapRightMemo()
		elseif slot2.type == 3 then
		elseif slot2.type == 4 then
			slot3:HideOverall()
		end
	elseif slot1 == slot0.WORLD_GET_COMPASS_POS then
		slot3:GetCompassGridPos(slot2.row, slot2.column, slot2.cachedIndex)
	elseif slot1 == slot0.WORLD_GET_COMPASS_MAP_POS then
		slot3:GetEntranceTrackMark(slot2.mapId, slot2.cachedIndex)
	elseif slot1 == slot0.WORLD_GET_SLG_TILE_POS then
		slot3:GetSlgTilePos(slot2.row, slot2.column, slot2.cachedIndex)
	elseif slot1 == slot0.WORLD_GET_SCANNER_POS then
		slot3:GetScannerPos((slot2 and slot2.cachedIndex) or 1)
	elseif slot1 == slot0.WORLD_OPEN_MAP_OVERVIEW then
		slot3:Op("OpShowMarkOverall", {
			ids = slot2.mapIds
		})
	elseif slot1 == slot0.WORLD_SHOW_MARGIN then
		slot3:ShowMargin(slot2.tdType)
	elseif slot1 == slot0.WORLD_SCANNER_DISPLAY then
		if slot2.open == 1 then
			slot3:OnLongPressMap(slot2.row, slot2.column)
		else
			slot3:HideScannerPanel()
		end
	elseif slot1 == slot0.WORLD_OPEN_TRANSPORT_POS then
		slot3:EnterTransportWorld()
	elseif slot1 == slot0.WORLD_SELECT_MODEL_MAP then
		slot3:GuideSelectModelMap(slot2.mapId)
	elseif slot1 == slot0.WORLD_FOCUS_EDGE then
		slot3:Op("OpMoveCameraTarget", slot2.line, slot2.stayTime)
	elseif slot1 == slot0.WORLD_FOCUS_EVENT then
		slot3:Op("OpMoveCamera", slot2.eventId, slot2.stayTime)
	elseif slot1 == slot0.WORLD_SCANNER_EVENT then
		slot3:GuideShowScannerEvent(slot2.eventId)
	elseif slot1 == slot0.WORLD_HELP_EVENT then
		slot3:emit(WorldMediator.OnOpenLayer, Context.New({
			mediator = WorldHelpMediator,
			viewComponent = WorldHelpLayer,
			data = {
				titleId = slot2.titleId,
				pageId = slot2.pageId
			}
		}))
	end
end

return slot0
