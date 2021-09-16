slot0 = class("WorldResource", import("..base.BaseUI"))
slot0.Listeners = {
	onUpdateInventory = "OnUpdateInventory",
	onUpdateActivate = "OnUpdateActivate",
	onUpdateStamina = "OnUpdateStamina",
	onBossProgressUpdate = "OnBossProgressUpdate"
}

slot0.Ctor = function (slot0)
	slot0.super.Ctor(slot0)
	PoolMgr.GetInstance():GetUI("WorldResPanel", false, function (slot0)
		slot0.transform:SetParent(pg.UIMgr.GetInstance().UIMain.transform, false)
		slot0:onUILoaded(slot0)
	end)
end

slot0.init = function (slot0)
	for slot4, slot5 in pairs(slot0.Listeners) do
		slot0[slot4] = function (...)
			slot0[slot1](slot2, ...)
		end
	end

	slot0.stamina = slot0.findTF(slot0, "res/stamina")

	onButton(slot0, slot0.stamina, function ()
		slot0.staminaMgr:Show()
	end, SFX_PANEL)

	slot0.oil = slot0.findTF(slot0, "res/oil")

	onButton(slot0, slot0.oil, function ()
		if not ShoppingStreet.getRiseShopId(ShopArgs.BuyOil, slot0.player.buyOilCount) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_today_buy_limit"))

			return
		end

		slot2 = pg.shop_template[slot0].num

		if pg.shop_template[slot0].num == -1 and slot1.genre == ShopArgs.BuyOil then
			slot2 = ShopArgs.getOilByLevel(slot0.player.level)
		end

		if slot0.player.buyOilCount < pg.gameset.buy_oil_limit.key_value then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				type = MSGBOX_TYPE_SINGLE_ITEM,
				content = i18n("oil_buy_tip", slot1.resource_num, slot2, slot0.player.buyOilCount),
				drop = {
					id = 2,
					type = DROP_TYPE_RESOURCE,
					count = slot2
				},
				onYes = function ()
					pg.m02:sendNotification(GAME.SHOPPING, {
						count = 1,
						id = pg.m02.sendNotification
					})
				end
			})
		else
			pg.MsgboxMgr.GetInstance().ShowMsgBox(slot4, {
				type = MSGBOX_TYPE_HELP,
				helps = i18n("help_oil_buy_limit"),
				custom = {
					{
						text = "text_iknow",
						sound = SFX_CANCEL
					}
				}
			})
		end
	end, SFX_PANEL)

	slot0.Whuobi = slot0.findTF(slot0, "res/Whuobi")

	onButton(slot0, slot0.Whuobi, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				type = DROP_TYPE_WORLD_ITEM,
				id = WorldItem.MoneyId
			}
		})
	end, SFX_PANEL)

	slot0.bossProgress = slot0.findTF(slot0, "res/boss_progress")

	onButton(slot0, slot0.bossProgress, function ()
		slot5, slot7, slot3, slot4 = slot0:GetBossProxy().GetUnlockProgress(slot0)
		slot5 = slot1 .. "/" .. slot2
		slot6 = slot2 == WorldBossProxy.INFINITY

		if slot6 then
			slot5 = i18n("world_boss_daily_limit")
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				type = DROP_TYPE_VITEM,
				id = WorldBossProxy.VIRTUAL_ITEM_ID
			},
			content = i18n("world_boss_progress_item_desc", slot3 - 1, slot4, slot5),
			yesText = (slot6 and i18n("world_boss_daily_limit")) or (slot2 <= slot1 and i18n("common_go_to_analyze")) or i18n("world_boss_not_reach_target"),
			yesSize = not (slot2 <= slot1) and Vector2(318, 118),
			yesGray = not (slot2 <= slot1) or slot6,
			onYes = function ()
				if slot0 then
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.WORLDBOSS)
				else
					pg.MsgboxMgr.GetInstance():hide()
				end
			end
		})
	end, SFX_PANEL)

	if nowWorld.GetActiveMap(slot1) then
		slot0:setStaminaMgr(slot1.staminaMgr)
	else
		slot0.atlas = slot1:GetAtlas()

		slot0.atlas:AddListener(WorldAtlas.EventUpdateActiveMap, slot0.onUpdateActivate)
		setActive(slot0.stamina, false)
	end

	slot0:setWorldInventory(slot1:GetInventoryProxy())
	slot0:SetWorldBossRes(slot1:GetBossProxy())
end

slot0.setParent = function (slot0, slot1, slot2)
	setParent(slot0._go, slot1, slot2)
end

slot0.setPlayer = function (slot0, slot1)
	slot0.player = slot1

	setText(slot0.oil:Find("max_value"), "MAX:" .. pg.user_level[slot1.level].max_oil)
	setText(slot0.oil:Find("value"), slot1.oil)
end

slot0.OnUpdateActivate = function (slot0)
	slot0:setStaminaMgr(nowWorld.staminaMgr)
	slot0.atlas:RemoveListener(WorldAtlas.EventUpdateActiveMap, slot0.onUpdateActivate)
end

slot0.setStaminaMgr = function (slot0, slot1)
	slot0.staminaMgr = slot1

	setText(slot0.stamina:Find("max_value"), "MAX:" .. slot1:GetMaxStamina())
	slot0.staminaMgr:AddListener(WorldStaminaManager.EventUpdateStamina, slot0.onUpdateStamina)
	slot0:OnUpdateStamina()
	setActive(slot0.stamina, true)
end

slot0.setWorldInventory = function (slot0, slot1)
	slot0.inventoryProxy = slot1

	slot0.inventoryProxy:AddListener(WorldInventoryProxy.EventUpdateItem, slot0.onUpdateInventory)
	slot0:OnUpdateInventory()
end

slot0.OnUpdateStamina = function (slot0)
	setText(slot0.stamina:Find("value"), slot0.staminaMgr:GetDisplayStanima())
end

slot0.OnUpdateInventory = function (slot0, slot1, slot2, slot3)
	if not slot1 or (slot1 == WorldInventoryProxy.EventUpdateItem and slot3.id == WorldItem.MoneyId) then
		setText(slot0.Whuobi:Find("value"), slot0.inventoryProxy:GetItemCount(WorldItem.MoneyId))
	end
end

slot0.SetWorldBossRes = function (slot0, slot1)
	slot0.worldBossProxy = slot1

	slot0.worldBossProxy:AddListener(WorldBossProxy.EventUnlockProgressUpdated, slot0.onBossProgressUpdate)
	slot0:OnBossProgressUpdate()
end

slot0.OnBossProgressUpdate = function (slot0)
	slot1, slot2, slot3, slot4, slot5 = slot0.worldBossProxy:GetUnlockProgress()
	slot6 = slot0.bossProgress:Find("value")
	slot7 = slot0.bossProgress:Find("max_value")
	slot8 = (slot2 == WorldBossProxy.INFINITY and "#5E5E5EFF") or "#FAFAF7FF"
	slot9 = "<color=%s>%d/%d</color>"

	if slot2 == WorldBossProxy.INFINITY then
		setText(slot6, string.format(slot9, slot8, slot5, slot5))
	else
		setText(slot6, string.format(slot9, slot8, slot1, slot2))
	end

	setText(slot7, "<color=" .. slot8 .. ">PHASE:" .. slot3 - 1 .. "/" .. slot4 .. "</color>")
	setActive(slot0.bossProgress, nowWorld:IsSystemOpen(WorldConst.SystemWorldBoss))
end

slot0.willExit = function (slot0)
	if slot0.staminaMgr then
		slot0.staminaMgr:RemoveListener(WorldStaminaManager.EventUpdateStamina, slot0.onUpdateStamina)
	else
		slot0.atlas:RemoveListener(WorldAtlas.EventUpdateActiveMap, slot0.onUpdateActivate)
	end

	slot0.inventoryProxy:RemoveListener(WorldInventoryProxy.EventUpdateItem, slot0.onUpdateInventory)
	slot0.worldBossProxy:RemoveListener(WorldBossProxy.EventUnlockProgressUpdated, slot0.onBossProgressUpdate)
	PoolMgr.GetInstance():ReturnUI("WorldResPanel", slot0._go)
end

return slot0
