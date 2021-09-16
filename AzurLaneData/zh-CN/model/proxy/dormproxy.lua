slot0 = class("DormProxy", import(".NetProxy"))
slot0.DORM_UPDATEED = "DormProxy updated"
slot0.LEVEL_UP = "DormProxy level up"
slot0.FURNITURE_ADDED = "DormProxy FURNITURE ADDED"
slot0.FURNITURE_UPDATED = "DormProxy FURNITURE UPDATED"
slot0.SHIP_ADDED = "DormProxy ship added"
slot0.SHIP_EXIT = "DormProxy ship exit"
slot0.INIMACY_AND_MONEY_ADD = "DormProxy inimacy and money added"
slot0.SHIPS_EXP_ADDED = "DormProxy SHIPS_EXP_ADDED"
slot0.THEME_ADDED = "DormProxy THEME_ADDED"
slot0.THEME_DELETED = "DormProxy THEME_DELETED"
slot0.THEME_TEMPLATE_UPDATED = "DormProxy THEME_TEMPLATE_UPDATED"
slot0.THEME_TEMPLATE_DELTETED = "DormProxy THEME_TEMPLATE_DELTETED"
slot0.COLLECTION_THEME_TEMPLATE_ADDED = "DormProxy COLLECTION_THEME_TEMPLATE_ADDED"
slot0.COLLECTION_THEME_TEMPLATE_DELETED = "DormProxy COLLECTION_THEME_TEMPLATE_DELETED"
slot0.THEME_TEMPLATE_ADDED = "DormProxy THEME_TEMPLATE_ADDED"
slot0.SHOP_THEME_TEMPLATE_DELETED = "DormProxy SHOP_THEME_TEMPLATE_DELETED"

slot0.register = function (slot0)
	slot0.TYPE = 2
	slot0.PAGE = 1
	slot0.MAX_PAGE = 10
	slot0.lastPages = {
		[2] = math.huge,
		[3] = math.huge,
		[5] = math.huge
	}
	slot0.friendData = nil
	slot0.systemThemes = {}

	slot0:on(19001, function (slot0)
		slot0:sendNotification(GAME.GET_BACKYARD_DATA, {
			isMine = true,
			data = slot0
		})
	end)

	slot0.isLoadExp = nil

	slot0.on(slot0, 19009, function (slot0)
		slot0.isLoadExp = true
		slot0.data.load_exp = slot0.data.load_exp + slot0.exp
		slot0.data.load_food = slot0.data.load_food + slot0.food_consume

		slot0:updateFood(slot0.food_consume)
		slot0:sendNotification(GAME.BACKYARD_ADD_EXP, slot0.exp)
	end)
	slot0.on(slot0, 19010, function (slot0)
		for slot4, slot5 in ipairs(slot0.pop_list) do
			slot0:addInimacyAndMoney(slot0.pop_list[slot4].id, slot0.pop_list[slot4].intimacy, slot0.pop_list[slot4].dorm_icon)
		end
	end)
end

slot0.GetVisitorShip = function (slot0)
	return slot0.visitorShip
end

slot0.SetVisitorShip = function (slot0, slot1)
	slot0.visitorShip = slot1
end

slot0.getBackYardShips = function (slot0)
	slot1 = {}
	slot2 = getProxy(BayProxy)

	for slot6, slot7 in ipairs(slot0.data.shipIds) do
		if slot2:getShipById(slot7) then
			slot1[slot8.id] = slot8
		else
			print("not found ship >>>", slot7)
		end
	end

	return slot1
end

slot0.GetShipIdsByType = function (slot0, slot1)
	slot2 = slot0:getTrainShipIds()
	slot3 = slot0:getRestShipIds()
	slot4 = {}
	slot5 = {}

	if slot1 == BackYardShipInfoLayer.SHIP_TRAIN_TYPE then
		slot4 = slot2
		slot5 = slot3
	elseif slot1 == BackYardShipInfoLayer.SHIP_REST_TYPE then
		slot4 = slot3
		slot5 = slot2
	end

	return slot4, slot5
end

slot0.addShip = function (slot0, slot1)
	slot0.data:addShip(slot1)
	slot0:sendNotification(slot0.SHIP_ADDED, slot0:getShipById(slot1):clone())
	slot0:updateDrom(slot0.data)
end

slot0.exitYardById = function (slot0, slot1)
	slot0.data:deleteShip(slot1)
	slot0:sendNotification(slot0.SHIP_EXIT, slot0:getShipById(slot1))
	slot0:updateDrom(slot0.data)
end

slot0.getShipById = function (slot0, slot1)
	if slot0:getBackYardShips()[slot1] then
		return slot2[slot1]
	end
end

slot0.getShipsByState = function (slot0, slot1)
	slot3 = {}

	for slot7, slot8 in pairs(slot2) do
		if slot8.state == slot1 then
			slot3[slot8.id] = slot8
		end
	end

	return slot3
end

slot0.getTrainShipIds = function (slot0)
	return _.keys(slot0:getShipsByState(Ship.STATE_TRAIN) or {})
end

slot0.getRestShipIds = function (slot0)
	return _.keys(slot0:getShipsByState(Ship.STATE_REST) or {})
end

slot0.getTrainShipCount = function (slot0)
	return #slot0:getTrainShipIds()
end

slot0.addInimacyAndMoney = function (slot0, slot1, slot2, slot3)
	if not getProxy(BayProxy):getShipById(slot1) then
		return
	end

	slot5:updateStateInfo34(slot2, slot3)
	slot4:updateShip(slot5)
	slot0:sendNotification(slot0.INIMACY_AND_MONEY_ADD)

	if pg.backyard then
		pg.backyard:sendNotification(BACKYARD.COMMAND_BACKYARD_BOAT, {
			name = BACKYARD.BOAT_HARVEST,
			ship = slot5:clone()
		})
	end
end

slot0.isLackOfFood = function (slot0)
	if slot0:getTrainShipCount() == 0 then
		return false
	end

	slot2 = slot0:getRestFood()

	if not slot0.isLoadExp then
		slot2 = slot2 - slot0.data.load_food
	end

	return slot2 <= 0
end

slot0.havePopEvent = function (slot0)
	for slot5, slot6 in pairs(slot1) do
		if slot6:hasStateInfo3Or4() then
			return true
		end
	end

	return false
end

slot0.getFurnitrues = function (slot0)
	return Clone(slot0.data.furnitures)
end

slot0.getFurnitrueCount = function (slot0, slot1)
	slot3 = 0

	for slot7, slot8 in pairs(slot2) do
		if slot8.configId == slot1 then
			slot3 = slot3 + 1
		end
	end

	return slot3
end

slot0.getTempFurnitrues = function (slot0)
	slot1 = {}

	for slot5, slot6 in pairs(slot0.data.furnitures) do
		if pg.furniture_data_template[slot6.id] then
			slot1[slot6.id] = slot6:clone()
		end
	end

	return slot1
end

slot0.getFurnitureCountByType = function (slot0, slot1)
	slot2 = 0

	for slot6, slot7 in pairs(slot0:getFurnitrues()) do
		if slot7:getConfig("type") == slot1 then
			slot2 = slot2 + 1
		end
	end

	return slot2
end

function slot1(slot0, slot1)
	slot3 = slot1.count

	if not slot0:getFurniById(slot1.id) then
		slot2 = slot1

		slot0.data:addFurniture(slot1)
	else
		slot2:addFurnitrueCount(slot1.count)
		slot0:updateFurniture(slot2)

		slot3 = slot3 + 1
	end

	for slot7 = 1, slot3 - 1, 1 do
		for slot11 = 1, slot2.count - 1, 1 do
			if not slot0:getFurniById(slot2:getCloneId(slot11)) then
				slot0.data:addFurniture(Furniture.New({
					count = 1,
					id = slot12,
					configId = slot2.id,
					get_time = slot2.date
				}))

				break
			end
		end
	end
end

slot0.addFurniture = function (slot0, slot1)
	slot0(slot0, slot1)
	slot0:updateDrom(slot0.data)
end

slot0.AddFurnitrues = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot1) do
		slot0(slot0, Furniture.New({
			count = 1,
			id = slot6
		}))
	end

	slot0:updateDrom(slot0.data)
end

slot0.updateFurniture = function (slot0, slot1)
	slot0.data:updateFurniture(slot1)
	slot0:sendNotification(slot0.FURNITURE_UPDATED, slot1:clone())
end

slot0.getFurniById = function (slot0, slot1)
	return Clone(slot0.data:getFurnitrueById(slot1))
end

slot0.getPutFurnis = function (slot0)
	return Clone(slot0.data:getPutFurnis())
end

slot0.getWallPaper = function (slot0, slot1)
	for slot5, slot6 in pairs(slot0:getFurnitrues()) do
		slot7 = slot6:getConfig("type")

		if slot6.position and slot1 == slot7 then
			return slot6:clone()
		end
	end
end

slot0.addDorm = function (slot0, slot1)
	slot0.data = slot1

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inBackyard")
end

slot0.updateDrom = function (slot0, slot1)
	slot0.data = slot1

	pg.ShipFlagMgr.GetInstance():UpdateFlagShips("inBackyard")
	slot0.facade:sendNotification(slot0.DORM_UPDATEED, slot1:clone())
end

slot0.getData = function (slot0)
	return slot0.data or Dorm.New({
		id = 1
	}):clone()
end

slot0.updateFood = function (slot0, slot1)
	slot0.data:consumeFood(slot1)
	slot0.data:restNextTime()
	slot0:updateDrom(slot0.data)
end

slot0.getRestFood = function (slot0)
	return slot0.data.food
end

slot0.hasFood = function (slot0)
	return slot0.data:isMaxFood() == false and getProxy(BagProxy):getItemCountById(50001) > 0
end

slot0.GetCustomThemeTemplates = function (slot0)
	return slot0.customThemeTemplates
end

slot0.SetCustomThemeTemplates = function (slot0, slot1)
	slot0.customThemeTemplates = slot1
end

slot0.GetCustomThemeTemplateById = function (slot0, slot1)
	return slot0.customThemeTemplates[slot1]
end

slot0.UpdateCustomThemeTemplate = function (slot0, slot1)
	slot0.customThemeTemplates[slot1.id] = slot1

	slot0:sendNotification(slot0.THEME_TEMPLATE_UPDATED, {
		type = BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM,
		template = slot1
	})
end

slot0.DeleteCustomThemeTemplate = function (slot0, slot1)
	slot0.customThemeTemplates[slot1] = nil

	slot0:sendNotification(slot0.THEME_TEMPLATE_DELTETED, {
		templateId = slot1
	})
end

slot0.AddCustomThemeTemplate = function (slot0, slot1)
	slot0.customThemeTemplates[slot1.id] = slot1

	slot0:sendNotification(slot0.THEME_TEMPLATE_ADDED, {
		template = slot1
	})
end

slot0.GetUploadThemeTemplateCnt = function (slot0)
	slot1 = 0

	for slot5, slot6 in pairs(slot0.customThemeTemplates) do
		if slot6:IsPushed() then
			slot1 = slot1 + 1
		end
	end

	return slot1
end

slot0.GetShopThemeTemplates = function (slot0)
	return slot0.shopThemeTemplates
end

slot0.SetShopThemeTemplates = function (slot0, slot1)
	slot0.shopThemeTemplates = slot1
end

slot0.GetShopThemeTemplateById = function (slot0, slot1)
	return slot0.shopThemeTemplates[slot1]
end

slot0.IsInitShopThemeTemplates = function (slot0)
	return slot0.shopThemeTemplates ~= nil
end

slot0.UpdateShopThemeTemplate = function (slot0, slot1)
	slot0.shopThemeTemplates[slot1.id] = slot1

	slot0:sendNotification(slot0.THEME_TEMPLATE_UPDATED, {
		type = BackYardConst.THEME_TEMPLATE_TYPE_SHOP,
		template = slot1
	})
end

slot0.DeleteShopThemeTemplate = function (slot0, slot1)
	slot0.shopThemeTemplates[slot1] = nil

	slot0:sendNotification(slot0.SHOP_THEME_TEMPLATE_DELETED, {
		id = slot1
	})
end

slot0.GetCollectionThemeTemplates = function (slot0)
	return slot0.collectionThemeTemplates
end

slot0.SetCollectionThemeTemplates = function (slot0, slot1)
	slot0.collectionThemeTemplates = slot1
end

slot0.GetCollectionThemeTemplateById = function (slot0, slot1)
	return slot0.collectionThemeTemplates[slot1]
end

slot0.AddCollectionThemeTemplate = function (slot0, slot1)
	slot0.collectionThemeTemplates[slot1.id] = slot1

	slot0:sendNotification(slot0.COLLECTION_THEME_TEMPLATE_ADDED, {
		template = slot1
	})
end

slot0.DeleteCollectionThemeTemplate = function (slot0, slot1)
	slot0.collectionThemeTemplates[slot1] = nil

	slot0:sendNotification(slot0.COLLECTION_THEME_TEMPLATE_DELETED, {
		id = slot1
	})
end

slot0.GetThemeTemplateCollectionCnt = function (slot0)
	return table.getCount(slot0.collectionThemeTemplates or {})
end

slot0.UpdateCollectionThemeTemplate = function (slot0, slot1)
	slot0.collectionThemeTemplates[slot1.id] = slot1

	slot0:sendNotification(slot0.THEME_TEMPLATE_UPDATED, {
		type = BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION,
		template = slot1
	})
end

slot0.GetTemplateNewID = function (slot0)
	slot1 = _.map(_.values(slot0.customThemeTemplates or {}), function (slot0)
		return slot0:GetPos()
	end)

	for slot5 = 1, 10, 1 do
		if not table.contains(slot1, slot5) then
			return slot5
		end
	end
end

slot0.GetSystemThemes = function (slot0)
	if not slot0.systemThemes or #slot0.systemThemes == 0 then
		for slot5, slot6 in ipairs(pg.backyard_theme_template.all) do
			if slot1[slot6].is_view == 1 then
				table.insert(slot0.systemThemes, BackYardSystemTheme.New({
					id = slot6
				}))
			end
		end
	end

	return slot0.systemThemes
end

slot0.ResetSystemTheme = function (slot0, slot1)
	if not slot0.systemThemes or #slot0.systemThemes == 0 then
		return
	end

	for slot5, slot6 in ipairs(slot0.systemThemes) do
		if slot6.id == slot1 then
			slot0.systemThemes[slot5] = BackYardSystemTheme.New({
				id = slot1
			})

			break
		end
	end
end

slot0.NeedRefreshThemeTemplateShop = function (slot0)
	if not slot0.refreshThemeTemplateShopTime then
		slot0.refreshThemeTemplateShopTime = 0
	end

	if slot0.refreshThemeTemplateShopTime < pg.TimeMgr.GetInstance():GetServerTime() then
		slot0.refreshThemeTemplateShopTime = slot1 + BackYardConst.AUTO_REFRESH_THEME_TEMPLATE_TIME

		return true
	end

	return false
end

slot0.NeedCollectionTip = function (slot0)
	if slot0:GetThemeTemplateCollectionCnt() ~= PlayerPrefs.GetInt("backyard_template" .. slot1, 0) then
		PlayerPrefs.SetInt("backyard_template" .. slot1, slot3)
		PlayerPrefs.Save()
	end

	if slot3 < slot2 then
		return true
	end

	return false
end

slot0.NeedShopShowHelp = function (slot0)
	if not (PlayerPrefs.GetInt("backyard_template_help" .. slot1, 0) > 0) then
		PlayerPrefs.SetInt("backyard_template_help" .. slot1, 1)
		PlayerPrefs.Save()

		return true
	end

	return false
end

slot0.IsShowRedDot = function (slot0)
	slot1 = getProxy(DormProxy)

	return slot1:isLackOfFood() or slot1:havePopEvent()
end

return slot0
