slot0 = class("ChallengeShareLayer", import("..base.BaseUI"))

slot0.getUIName = function (slot0)
	return "ChallengeShareUI"
end

slot0.init = function (slot0)
	slot0.painting = slot0:findTF("main/Painting")
	slot0.shipList = slot0:findTF("main/ship_list")
	slot0.cardTF = slot0:findTF("ship_card", slot0.shipList)
	slot0.itemList = UIItemList.New(slot0.shipList, slot0.cardTF)
	slot0.wordTF = slot0:findTF("main/word")
	slot0.touchBtn = slot0:findTF("touch_btn")

	pg.UIMgr.GetInstance():OverlayPanel(slot0._tf)
end

slot0.setLevel = function (slot0, slot1)
	slot0.level = slot1
end

slot0.setShipPaintList = function (slot0, slot1)
	slot0.shipPaintList = slot1
end

slot0.setFlagShipPaint = function (slot0, slot1)
	slot0.flagShipPaint = slot1
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0.touchBtn, function ()
		if slot0.isLoading then
			return
		end

		slot0:closeView()
	end, SFX_PANEL)
	slot0.itemList.make(slot1, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			table.insert(slot0.funcs, function (slot0)
				LoadSpriteAsync("shipYardIcon/" .. slot0.shipPaintList[slot1 + 1], function (slot0)
					if not IsNil(slot0) then
						setImageSprite(slot0:Find("back/Image"), slot0)
					end

					slot1()
				end)
			end)
		end
	end)
	slot0.flush(slot0)
end

slot0.flush = function (slot0)
	slot0.funcs = {}

	slot0.itemList:align(#slot0.shipPaintList)
	table.insert(slot0.funcs, function (slot0)
		setPaintingPrefabAsync(slot0.painting, slot0.flagShipPaint, "chuanwu", slot0)
	end)

	slot0.isLoading = true

	parallelAsync(slot0.funcs, function ()
		slot0.isLoading = false

		pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypeChallenge)
	end)
	setText(slot0.wordTF.Find(slot2, "Text"), i18n("challenge_share_progress"))
	setText(slot0.wordTF:Find("number/Text"), slot0.level)
	setText(slot0.wordTF:Find("Text2"), i18n("challenge_share"))
end

slot0.willExit = function (slot0)
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0._tf)
end

return slot0
