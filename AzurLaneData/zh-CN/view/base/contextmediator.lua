slot0 = class("ContextMediator", pm.Mediator)

slot0.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, nil, slot1)
end

slot0.onRegister = function (slot0)
	slot0.event = {}

	slot0:bind(BaseUI.ON_BACK_PRESSED, function (slot0, slot1)
		slot0:onBackPressed(slot1)
	end)
	slot0.bind(slot0, BaseUI.AVALIBLE, function (slot0, slot1)
		slot0:onUIAvalible()
	end)
	slot0.bind(slot0, BaseUI.ON_BACK, function (slot0, slot1, slot2)
		if slot2 and slot2 > 0 then
			pg.UIMgr.GetInstance():LoadingOn(false)
			LeanTween.delayedCall(slot2, System.Action(function ()
				pg.UIMgr.GetInstance():LoadingOff()
				pg.UIMgr.GetInstance().LoadingOff:sendNotification(GAME.GO_BACK, nil, pg.UIMgr.GetInstance().LoadingOff)
			end))
		else
			slot0.sendNotification(slot3, GAME.GO_BACK, nil, slot1)
		end
	end)
	slot0.bind(slot0, BaseUI.ON_HOME, function (slot0)
		if getProxy(ContextProxy).getCurrentContext(slot1):retriveLastChild() and slot3 ~= slot2 then
			slot0:sendNotification(GAME.REMOVE_LAYERS, {
				onHome = true,
				context = slot3
			})
		end

		slot0:sendNotification(GAME.GO_SCENE, SCENE.MAINUI)
	end)
	slot0.bind(slot0, BaseUI.ON_CLOSE, function (slot0)
		if getProxy(ContextProxy).getCurrentContext(slot1):getContextByMediator(slot0.class) then
			slot0:sendNotification(GAME.REMOVE_LAYERS, {
				context = slot3
			})
		end
	end)
	slot0.bind(slot0, BaseUI.ON_DROP, function (slot0, slot1, slot2)
		if slot1.type == DROP_TYPE_EQUIP then
			slot0:addSubLayers(Context.New({
				mediator = EquipmentInfoMediator,
				viewComponent = EquipmentInfoLayer,
				data = {
					equipmentId = slot1.cfg.id,
					type = EquipmentInfoMediator.TYPE_DISPLAY,
					onRemoved = slot2,
					LayerWeightMgr_weight = LayerWeightConst.TOP_LAYER
				}
			}))
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_SINGLE_ITEM,
				drop = slot1,
				onNo = slot2,
				onYes = slot2,
				weight = LayerWeightConst.TOP_LAYER
			})
		end
	end)
	slot0.bind(slot0, BaseUI.ON_DROP_LIST, function (slot0, slot1)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_ITEM_BOX,
			items = slot1.itemList,
			content = slot1.content,
			item2Row = slot1.item2Row,
			itemFunc = function (slot0)
				slot0.viewComponent:emit(BaseUI.ON_DROP, slot0, function ()
					slot0.viewComponent:emit(BaseUI.ON_DROP_LIST, slot0.viewComponent)
				end)
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	end)
	slot0.bind(slot0, BaseUI.ON_ITEM, function (slot0, slot1)
		slot0:addSubLayers(Context.New({
			mediator = ItemInfoMediator,
			viewComponent = ItemInfoLayer,
			data = {
				mine = true,
				info = {
					type = DROP_TYPE_ITEM,
					id = slot1
				}
			}
		}))
	end)
	slot0.bind(slot0, BaseUI.ON_SHIP, function (slot0, slot1)
		slot0:addSubLayers(Context.New({
			mediator = ItemInfoMediator,
			viewComponent = ItemInfoLayer,
			data = {
				mine = true,
				info = {
					type = DROP_TYPE_SHIP,
					id = slot1
				}
			}
		}))
	end)
	slot0.bind(slot0, BaseUI.ON_AWARD, function (slot0, slot1)
		slot2 = {}

		if _.all(slot1.items, function (slot0)
			return slot0.type == DROP_TYPE_ICON_FRAME or slot0.type == DROP_TYPE_CHAT_FRAME
		end) then
			table.insert(slot2, function (slot0)
				onNextTick(slot0)
			end)
		else
			table.insert(slot2, function (slot0)
				slot0:addSubLayers(Context.New({
					mediator = AwardInfoMediator,
					viewComponent = AwardInfoLayer,
					data = setmetatable({
						removeFunc = slot0
					}, {
						__index = slot0.addSubLayers
					})
				}))
			end)
		end

		seriesAsync(slot2, slot1.removeFunc)
	end)

	function slot1(slot0, slot1)
		underscore.each(slot0, function (slot0)
			if slot0.type == DROP_TYPE_NPC_SHIP then
				table.insert(slot0, slot1:getShipById(slot0.id))
			elseif slot0.type == DROP_TYPE_SHIP then
				slot2 = slot2 - 1
			end
		end)

		if ((pg.gameset.award_ship_limit and pg.gameset.award_ship_limit.key_value) or 20) >= #underscore.rest(slot3, #getProxy(BayProxy).getNewShip(slot2, true) + 1) then
			for slot9, slot10 in ipairs(slot3) do
				table.insert(slot1, function (slot0)
					slot0:addSubLayers(Context.New({
						mediator = NewShipMediator,
						viewComponent = NewShipLayer,
						data = {
							ship = slot0.addSubLayers
						},
						onRemoved = slot0
					}))
				end)
			end
		end
	end

	function slot2(slot0, slot1)
		for slot5, slot6 in pairs(slot0) do
			if slot6.type == DROP_TYPE_SKIN and pg.ship_skin_template[slot6.id].skin_type ~= ShipSkin.SKIN_TYPE_REMAKE and not getProxy(ShipSkinProxy):hasOldNonLimitSkin(slot6.id) then
				table.insert(slot1, function (slot0)
					slot0:addSubLayers(Context.New({
						mediator = NewSkinMediator,
						viewComponent = NewSkinLayer,
						data = {
							skinId = slot1.id
						},
						onRemoved = slot0
					}))
				end)
			end
		end
	end

	slot0.bind(slot0, BaseUI.ON_ACHIEVE, function (slot0, slot1, slot2)
		slot3 = {}

		if #slot1 > 0 then
			table.insert(slot3, function (slot0)
				slot0.viewComponent:emit(BaseUI.ON_AWARD, {
					items = slot0.viewComponent.emit,
					removeFunc = slot0
				})
			end)
			table.insert(slot3, function (slot0)
				slot0(slot0, )
				slot0(slot0, )
				slot0()
			end)
		end

		seriesAsyncExtend(slot3, slot2)
	end)
	slot0.bind(slot0, BaseUI.ON_WORLD_ACHIEVE, function (slot0, slot1)
		slot2 = {}

		if #slot1.items > 0 then
			table.insert(slot2, function (slot0)
				slot0.viewComponent:emit(BaseUI.ON_AWARD, setmetatable({
					removeFunc = slot0
				}, {
					__index = slot0.viewComponent.emit
				}))
			end)
			table.insert(slot2, function (slot0)
				slot0(slot0, )
				slot0(slot0, )
				slot0()
			end)
		end

		seriesAsyncExtend(slot2, slot1.removeFunc)
	end)
	slot0.bind(slot0, BaseUI.ON_EQUIPMENT, function (slot0, slot1)
		slot1.type = defaultValue(slot1.type, EquipmentInfoMediator.TYPE_DEFAULT)

		slot0:addSubLayers(Context.New({
			mediator = EquipmentInfoMediator,
			viewComponent = EquipmentInfoLayer,
			data = slot1
		}))
	end)
	slot0.bind(slot0, BaseUI.ON_SHIP_EXP, function (slot0, slot1, slot2)
		slot0:addSubLayers(Context.New({
			mediator = ShipExpMediator,
			viewComponent = ShipExpLayer,
			data = slot1,
			onRemoved = slot2
		}))
	end)
	slot0.register(slot0)
end

slot0.register = function (slot0)
	return
end

slot0.onUIAvalible = function (slot0)
	return
end

slot0.setContextData = function (slot0, slot1)
	slot0.contextData = slot1
end

slot0.bind = function (slot0, slot1, slot2)
	slot0.viewComponent.event:connect(slot1, slot2)
	table.insert(slot0.event, {
		event = slot1,
		callback = slot2
	})
end

slot0.onRemove = function (slot0)
	slot0:remove()

	for slot4, slot5 in ipairs(slot0.event) do
		slot0.viewComponent.event:disconnect(slot5.event, slot5.callback)
	end

	slot0.event = {}
end

slot0.remove = function (slot0)
	return
end

slot0.addSubLayers = function (slot0, slot1, slot2, slot3)
	slot6 = getProxy(ContextProxy).getCurrentContext(slot4):getContextByMediator(slot0.class)

	if slot2 then
		while slot6.parent do
			slot6 = slot6.parent
		end
	end

	slot0:sendNotification(GAME.LOAD_LAYERS, {
		parentContext = slot6,
		context = slot1,
		callback = function ()
			if slot0 then
				slot0()
			end
		end
	})
end

slot0.blockEvents = function (slot0)
	if slot0.event then
		for slot4, slot5 in ipairs(slot0.event) do
			slot0.viewComponent.event:block(slot5.event, slot5.callback)
		end
	end
end

slot0.unblockEvents = function (slot0)
	if slot0.event then
		for slot4, slot5 in ipairs(slot0.event) do
			slot0.viewComponent.event:unblock(slot5.event, slot5.callback)
		end
	end
end

slot0.onBackPressed = function (slot0, slot1)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_CANCEL)

	slot2 = getProxy(ContextProxy)

	if slot1 then
		if slot2:getContextByMediator(slot0.class).parent and pg.m02:retrieveMediator(slot3.mediator.__cname) and slot4.viewComponent then
			slot4.viewComponent:onBackPressed()
		end
	else
		slot0.viewComponent:closeView()
	end
end

slot0.removeSubLayers = function (slot0, slot1, slot2)
	if not getProxy(ContextProxy):getContextByMediator(slot0.class or slot0) then
		return
	end

	if not slot4:getContextByMediator(slot1) then
		return
	end

	slot0:sendNotification(GAME.REMOVE_LAYERS, {
		context = slot5,
		callback = slot2
	})
end

return slot0
