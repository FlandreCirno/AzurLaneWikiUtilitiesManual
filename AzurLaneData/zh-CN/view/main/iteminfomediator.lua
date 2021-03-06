slot0 = class("ItemInfoMediator", import("..base.ContextMediator"))
slot0.USE_ITEM = "ItemInfoMediator:USE_ITEM"
slot0.COMPOSE_ITEM = "ItemInfoMediator:COMPOSE_ITEM"
slot0.ON_BLUEPRINT_SCENE = "ItemInfoMediator:ON_BLUEPRINT_SCENE"
slot0.SELL_BLUEPRINT = "sell blueprint"

slot0.register = function (slot0)
	slot0:bind(slot0.ON_BLUEPRINT_SCENE, function ()
		slot0:sendNotification(GAME.GO_SCENE, SCENE.SHIPBLUEPRINT)
	end)
	slot0.bind(slot0, slot0.SELL_BLUEPRINT, function (slot0, slot1, slot2, slot3)
		slot0:sendNotification(GAME.FRAG_SELL, {
			{
				id = slot2,
				count = slot3,
				type = slot1
			}
		})
	end)

	slot2 = slot0.contextData.mine

	if slot0.contextData.info.type == DROP_TYPE_SHIP then
		slot0.viewComponent.setShipId(slot3, slot1.id)
	elseif slot1.type == DROP_TYPE_ITEM then
		slot0:updateItem()

		if slot2 then
			slot0:bind(slot0.USE_ITEM, function (slot0, slot1, slot2)
				if not UseItemCommand.Check(getProxy(BagProxy):getItemById(slot1), slot2) then
					slot0.viewComponent:emit(BaseUI.ON_CLOSE)

					return
				end

				slot0.viewComponent:PlayOpenBox(slot3:getTempConfig("display_effect"), function ()
					if table.contains(ITEM_ID_FUDAIS, table.contains) then
						slot1:sendNotification(GAME.OPEN_MAIL_ATTACHMENT, {
							items = {
								{
									id = slot0,
									type = DROP_TYPE_ITEM,
									count = GAME.OPEN_MAIL_ATTACHMENT
								}
							}
						})
					else
						slot1:sendNotification(GAME.USE_ITEM, {
							id = slot0,
							count = GAME.USE_ITEM
						})
					end
				end)
			end)
			slot0.bind(slot0, slot0.COMPOSE_ITEM, function (slot0, slot1, slot2)
				slot0:sendNotification(GAME.COMPOSE_ITEM, {
					id = slot1,
					count = slot2
				})
			end)
		end
	end
end

slot0.listNotificationInterests = function (slot0)
	return {
		BagProxy.ITEM_UPDATED,
		GAME.USE_ITEM_DONE,
		GAME.OPEN_MAIL_ATTACHMENT_DONE,
		GAME.FRAG_SELL_DONE
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == BagProxy.ITEM_UPDATED then
		if slot0.contextData.mine and slot0:updateItem().count <= 0 then
			slot0.viewComponent:doClose()
		end
	elseif slot2 == GAME.USE_ITEM_DONE then
		slot0.viewComponent:SetOperateCount(1)
	elseif slot2 == GAME.FRAG_SELL_DONE then
		slot0.viewComponent:SetOperateCount(1)
	elseif slot2 == GAME.OPEN_MAIL_ATTACHMENT_DONE and slot3.items and #slot4 > 0 then
		slot0.viewComponent:emit(BaseUI.ON_ACHIEVE, slot4, function ()
			if slot0.callback then
				slot0.callback()
			end
		end)
	end
end

slot0.updateItem = function (slot0)
	slot1 = slot0.contextData.info
	slot3 = getProxy(BagProxy)
	slot4 = nil

	if slot0.contextData.mine then
		slot4 = slot3:getItemById(slot1.id) or Item.New({
			count = 0,
			id = slot1.id
		})
	else
		slot4 = Item.New({
			id = slot1.id,
			count = defaultValue(slot1.count, 0)
		})
	end

	slot0.viewComponent:setItem(slot4)

	return slot4
end

return slot0
