slot0 = class("BackYardSystemTheme", import(".BackYardSelfThemeTemplate"))

slot0.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)

	slot0.level = 1
	slot0.order = slot0:getConfig("order")
end

slot0.GetRawPutList = function (slot0)
	slot0:CheckLevel()

	slot1 = getProxy(DormProxy):getData().level

	if not slot0.putInfo then
		pcall(function ()
			slot0 = require("GameCfg.backyardTheme.theme_" .. slot1.id)
		end)

		if not nil then
			slot3 = require("GameCfg.backyardTheme.theme_empty")
			slot2 = slot3
		end

		slot0.putInfo = _.select(slot2["furnitures_" .. slot1] or {}, function (slot0)
			return pg.furniture_data_template[slot0.id]
		end)
	end

	return slot0.putInfo
end

slot0.CheckLevel = function (slot0)
	if slot0.level ~= getProxy(DormProxy):getData().level then
		slot0.furnitruesByIds = nil
		slot0.furnitures = nil
		slot0.putInfo = nil
		slot0.level = slot1
	end
end

slot0.GetAllFurniture = function (slot0)
	slot0:CheckLevel()
	slot0.super.GetAllFurniture(slot0)

	if not slot0.furnitruesByIds and slot0:HasSameConfigId() then
		slot0:CheckData()
	end

	return slot0.furnitruesByIds
end

slot0.GetWarpFurnitures = function (slot0)
	slot0:CheckLevel()

	return slot0.super.GetWarpFurnitures(slot0)
end

slot0.HasSameConfigId = function (slot0)
	for slot5, slot6 in ipairs(slot1) do
		for slot10, slot11 in ipairs(slot1) do
			if slot5 ~= slot10 and slot6.id == slot11.id then
				return true
			end
		end
	end

	return false
end

slot0.CheckData = function (slot0)
	slot1 = getProxy(DormProxy)
	slot2 = {}
	slot3 = {}

	for slot7, slot8 in pairs(slot0.furnitruesByIds) do
		if not slot1:getFurniById(slot7) then
			if slot8.parent ~= 0 then
				table.insert(slot3, {
					pid = slot8.parent,
					id = slot7
				})
			elseif table.getCount(slot8.child) > 0 then
				for slot12, slot13 in pairs(slot8.child) do
					table.insert(slot2, slot12)
				end
			end

			table.insert(slot2, slot7)
		end
	end

	for slot7, slot8 in ipairs(slot2) do
		slot0.furnitruesByIds[slot8] = nil
	end

	for slot7, slot8 in pairs(slot3) do
		if slot0.furnitruesByIds[slot8.pid] then
			for slot13, slot14 in pairs(slot9.child) do
				if slot13 == slot8.id then
					slot9.child[slot8.id] = nil

					break
				end
			end
		end
	end
end

slot0.bindConfigTable = function (slot0)
	return pg.backyard_theme_template
end

slot0.IsOverTime = function (slot0)
	return _.all(slot0:getConfig("ids"), function (slot0)
		return not Furniture.New({
			id = slot0
		}):IsShopType() or not slot1:inTime()
	end)
end

slot0.GetFurnitures = function (slot0)
	return slot0:getConfig("ids")
end

slot0.HasDiscount = function (slot0)
	return _.any(slot0:GetFurnitures(), function (slot0)
		slot1 = Furniture.New({
			id = slot0
		})

		return slot1:getPrice(PlayerConst.ResDormMoney) < slot1:getConfig("dorm_icon_price")
	end)
end

slot0.GetDiscount = function (slot0)
	slot2 = _.map(slot1, function (slot0)
		return Furniture.New({
			id = slot0
		})
	end)

	return (_.reduce(slot2, 0, function (slot0, slot1)
		return slot0 + slot1:getConfig("dorm_icon_price")
	end) - _.reduce(slot2, 0, function (slot0, slot1)
		return slot0 + slot1:getPrice(PlayerConst.ResDormMoney)
	end)) / _.reduce(slot2, 0, function (slot0, slot1)
		return slot0 + slot1.getConfig("dorm_icon_price")
	end) * 100
end

slot0.IsPurchased = function (slot0, slot1)
	for slot5, slot6 in ipairs(slot0:getConfig("ids")) do
		if not slot1[slot6] then
			return false
		end
	end

	return true
end

slot0.GetName = function (slot0)
	return slot0:getConfig("name")
end

slot0.GetDesc = function (slot0)
	return slot0:getConfig("desc")
end

slot0.IsSystem = function (slot0)
	return true
end

slot0.getName = function (slot0)
	return slot0:GetName()
end

slot0.getIcon = function (slot0)
	return slot0:getConfig("icon")
end

slot0.isUnLock = function (slot0, slot1)
	return slot0:getConfig("deblocking") <= slot1.level
end

return slot0
