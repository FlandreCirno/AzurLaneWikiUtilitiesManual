slot0 = class("CustomBackyardScene", import("..base.BaseUI"))
slot1 = require("Mod/BackYard/view/BackYardTool")

slot0.setHouse = function (slot0, slot1)
	slot0.houseVO = slot1
	slot0.furnitureVOs = slot0.houseVO.furnitures
	slot0.boatVOs = slot0.houseVO.ships
	slot0.wallPaperVO = slot0.houseVO.wallPaper
	slot0.floorPaperVO = slot0.houseVO.floorPaper
end

slot0.preload = function (slot0, slot1)
	PoolMgr.GetInstance():GetUI("BackYardUI", true, function (slot0)
		slot0.backyardui = slot0.transform

		slot0.backyardui:SetParent(pg.UIMgr.GetInstance().UIMain.transform, false)
		setActive(slot0.backyardui, false)

		slot0.loading = slot0.backyardui:Find("loading")
		slot0.loadingHelp = slot0.backyardui:Find("loading/help")
		slot0.loadingHelpTx = slot0.backyardui:Find("loading/loading/tipsText")
		slot0.loadingProgress = slot0.backyardui:Find("loading/loading/loading_bar/progress")
		slot0.loadingProgressTx = slot0.backyardui:Find("loading/loading/loading_label/percent")
		slot0.loadingCount = 0

		slot0:initLoading()
		slot0.initLoading()
	end)
end

slot0.getUIName = function (slot0)
	return "backyardmainui"
end

slot0.init = function (slot0)
	slot0.furnitureModals = {}
	slot0.furnItem = {}
	slot0.shipModels = {}
	slot0.furnBottomGrids = {}
	slot0.mainBG = slot0:findTF("bg")
	slot0.floorContain = slot0:findTF("bg/furContain/floor")
	slot0.floorGrid = slot0:findTF("bg/floorGrid")
	slot0.furnitureTpl = slot0:findTF("resources/furnituretpl")
	slot0.furContain = slot0:findTF("bg/furContain")
	slot0.wallContain = slot0:findTF("bg/furContain/wall")
	slot0.carpetContain = slot0:findTF("bg/furContain/carpet")
	slot0.wallBG = slot0:findTF("bg/wall")
	slot0.floorBG = slot0:findTF("bg/floor")
	slot0.decorationBtn = slot0:findTF("decorateBtn")
	slot0.warn = slot0:findTF("bg/warn")
	slot0.backBtn = findTF(slot0._tf, "back")
	slot0.msgBoxPanel = slot0:findTF("msg_box")
	slot0.warnCG = slot0.warn:GetComponent("CanvasGroup")
	slot0.zoom = slot0:findTF("bg"):GetComponent("Zoom")

	setActive(slot0.warn, false)
	setActive(slot0.backBtn, false)
	setActive(slot0.decorationBtn, false)

	slot0.mainBG:GetComponent(typeof(CanvasGroup)).blocksRaycasts = true
	slot0.backyardPoolMgr = BackyardPoolMgr.New()
end

slot0.didEnter = function (slot0)
	slot0:initHouse()
end

slot0.initHouse = function (slot0)
	slot0.maps = {}
	slot0.map = slot0:createMap(slot0.houseVO.endX + 1, slot0.houseVO.endY + 1, true)

	slot0:loadWallPaper(slot0.wallPaperVO, Furniture.TYPE_WALLPAPER)
	slot0:loadWallPaper(slot0.floorPaperVO, Furniture.TYPE_FLOORPAPER)
	slot0:initFurnitures()
	slot0:updateHouseArea(slot0.houseVO.level)
	slot0:setHouseDragEnabled(false)
end

slot0.getProgress = function (slot0)
	if not slot0.loadingCount or not slot0.loadingTotal then
		return 0
	else
		return (slot0.loadingCount == slot0.loadingTotal and 1) or slot0.loadingCount / slot0.loadingTotal
	end
end

slot0.initLoading = function (slot0)
	setActive(slot0.loading, true)
	setParent(slot0.loading, GameObject.Find("OverlayCamera/Overlay/UIOverlay"), false)
	setSlider(slot0.loadingProgress, 0, 1, 0)
	setText(slot0.loadingProgressTx, "0.00%")
	LoadImageSpriteAsync("helpbg/" .. ({
		"battle_maincanon",
		"battle_plane",
		"break",
		"bullet",
		"energy",
		"equip",
		"strength",
		"tactics"
	})[math.clamp(math.random(#) + 1, 1, #)], slot0.loadingHelp)

	slot2 = pg.server_language[math.random(#pg.server_language)]

	while slot2.limitation ~= -1 do
		slot2 = pg.server_language[math.random(#pg.server_language)]
	end

	setText(slot0.loadingHelpTx, slot2.content)

	slot3 = 0
	slot0.loadingTimer = Timer.New(function ()
		slot0 = slot0:getProgress()

		setSlider(slot0.loadingProgress, 0, 1, slot1)
		setText(slot0.loadingProgressTx, string.format("%.2f", math.lerp(math.lerp, slot0, 0.5) * 100) .. "%")

		if slot0 >= 1 then
			onNextTick(function ()
				slot0:hideLoading()
			end)
		end
	end, 0.0334, -1)

	slot0.loadingTimer.Start(slot4)
end

slot0.hideLoading = function (slot0)
	if slot0.loadingTimer then
		slot0.loadingTimer:Stop()

		slot0.loadingTimer = nil
	end

	setActive(slot0.loading, false)
	setParent(slot0.loading, slot0.backyardui, false)
end

slot0.updateHouseArea = function (slot0, slot1)
	slot0:setBaseBG(slot1)
end

slot0.setHouseDragEnabled = function (slot0, slot1)
	slot0.mainBG:GetComponent(typeof(Zoom)).enabled = slot1
	slot0._tf:GetComponent(typeof(ScrollRect)).enabled = slot1
end

slot0.setBaseBG = function (slot0, slot1)
	slot2 = LoadAndInstantiateSync("dormbase", "state" .. slot1)

	if not IsNil(slot0.baseBG) then
		Destroy(slot0.baseBG)
	end

	slot0.baseBG = tf(slot2)

	slot0.baseBG:SetParent(slot0.mainBG, false)
	slot0.baseBG:SetSiblingIndex(1)

	slot0.mainBG.sizeDelta = Vector2(slot0.baseBG.rect.width + 50, slot0.baseBG.rect.height + 60 * slot0.houseVO.level)

	scrollTo(slot0._tf, 0.3, 0.9)
end

slot0.createMap = function (slot0, slot1, slot2, slot3)
	slot4 = pg.IsometricMap.New(slot1, slot2)

	slot4:SetAfterFunc(function (slot0)
		slot1 = 0

		for slot5, slot6 in ipairs(slot0) do
			if not slot6.ob.isBoat then
				slot0.furnitureModals[slot6.ob.id]:SetSiblingIndex(slot1)
			end

			slot1 = slot1 + 1
		end

		if slot1 then
			slot0:sortBoat()
		end
	end)

	return slot4
end

slot0.sortBoat = function (slot0)
	for slot4, slot5 in pairs(slot0.shipModels) do
		if slot0.boatVOs[slot4]:getPosition() and not slot0.boatVOs[slot4]:hasInterActionFurnitrue() then
			slot5:removeItem()
			slot5:createItem(slot6)
		end
	end
end

slot0.getMap = function (slot0, slot1)
	if slot1.parent ~= 0 and slot0.maps[slot1.parent] then
		return slot0.maps[slot1.parent]
	elseif slot1.parent ~= 0 and not slot0.maps[slot1.parent] then
		slot8, slot9 = slot0.furnitureVOs[slot1.parent]:getMapSize()
		slot0.maps[slot1.parent] = slot0:createMap(slot2, slot3)

		return slot0.maps[slot1.parent]
	else
		return slot0.map
	end
end

slot0.createItem = function (slot0, slot1, slot2, slot3)
	if not slot1:isMapItem() then
		return
	end

	slot4 = slot0:getMap(slot1)
	slot9, slot10 = slot1:getSize()

	slot4:PlaceItem(slot2 + 1, slot3 + 1, slot4:CreateItem(slot5, slot6, {
		isBoat = false,
		id = slot1.id
	}))

	slot0.furnItem[slot1.id] = slot4.CreateItem(slot5, slot6, )
end

slot0.removeItem = function (slot0, slot1)
	if not slot1:isMapItem() then
		return
	end

	if not slot0.furnItem[slot1.id] then
		return
	end

	if not slot1:hasParent() then
		slot0.map:RemoveItem(slot2)
	elseif slot0.maps[slot1.parent] then
		slot0.maps[slot1.parent]:RemoveItem(slot2)
	end

	slot0.furnItem[slot1.id] = nil
end

slot0.initFurnitures = function (slot0)
	slot1 = {}

	for slot5, slot6 in pairs(slot0.furnitureVOs) do
		table.insert(slot1, slot6)
	end

	table.sort(slot1, function (slot0, slot1)
		return slot0.parent < slot1.parent
	end)

	slot2 = {}

	for slot6, slot7 in ipairs(slot1) do
		table.insert(slot2, function (slot0)
			slot0.loadingCount = slot0.loadingCount + 1

			slot0:loadFurnitureModel(slot0.loadFurnitureModel, slot0)
		end)
	end

	slot3 = {}

	for slot7, slot8 in pairs(slot0.boatVOs) do
		table.insert(slot3, function (slot0)
			onNextTick(function ()
				slot0.loadingCount = slot0.loadingCount + 1

				slot0:loadboatModal(slot0, )
			end)
		end)
	end

	slot0.loadingTotal = #slot2 + #slot3

	limitedParallelAsync(slot2, 4, function ()
		seriesAsync(seriesAsync, function ()
			slot0.loadingCount = slot0.loadingTotal
		end)
		seriesAsync.sortWallFurns(slot0)
	end)
end

slot0.loadWallPaper = function (slot0, slot1, slot2)
	if not slot1 then
		if slot2 == Furniture.TYPE_WALLPAPER then
			SetActive(slot0.wallBG, false)
		elseif slot2 == Furniture.TYPE_FLOORPAPER then
			SetActive(slot0.floorBG, false)
		end

		return
	elseif slot2 == Furniture.TYPE_WALLPAPER then
		slot3 = slot0.wallBG:GetComponent(typeof(Image))
		slot3.sprite = GetSpriteFromAtlas("furniture/" .. slot1:getConfig("picture") .. slot0.houseVO.level, "")

		slot3:SetNativeSize()
		setActive(slot0.wallBG, true)
	elseif slot2 == Furniture.TYPE_FLOORPAPER then
		slot3 = GetSpriteFromAtlas("furniture/" .. slot1:getConfig("picture"), "")
		slot5 = slot0.houseVO:getFloorScaleByLevel(level)
		slot0.floorBG.localScale = Vector3(slot5, slot5, slot5)
		slot0.floorBG:GetComponent(typeof(Image)).sprite = GetSpriteFromAtlas("furniture/" .. slot1:getConfig("picture"), "")

		setActive(slot0.floorBG, true)
	end
end

slot0.loadFurnitureModel = function (slot0, slot1, slot2)
	if not slot0.backyardPoolMgr then
		if slot2 then
			slot2()
		end

		return
	end

	slot4 = slot0.backyardPoolMgr:Dequeue(slot0.backyardPoolMgr.POOL_NAME.FURNITURE)

	SetParent(slot4, slot0.furContain)

	slot4.gameObject.name = slot1.id

	setActive(slot5, false)
	SetActive(slot0:findTF("rotation", slot4:Find("drag")), slot3)

	slot0.furnitureModals[slot1.id] = slot4
	slot6 = slot1:getPosition()

	function slot7(slot0)
		slot0.sizeDelta = Vector2(slot0.rect.width, slot0.rect.height)

		SetParent(slot1, slot0)

		slot2 = slot2(slot2.dir == 2)
		slot0.localScale = Vector3(slot2, 1, 1)

		slot0:setWallModalDir(slot2, slot0)
		slot0.setWallModalDir:updateFurnitruePos(slot2, true)

		slot2.anchoredPosition3D = Vector3(0, 0, 0)

		if 0 then
			slot6()
		end
	end

	if not slot1.isSpine(slot1) then
		GetSpriteFromAtlasAsync("furniture/" .. slot1:getConfig("picture"), "", function (slot0)
			if not IsNil(slot0._tf) then
				slot1.pivot = getSpritePivot(slot0)
				slot1 = slot2.createImage("icon", true, slot2.createImage, 1)

				slot1:AddComponent(typeof(AlphaCheck))
				setImageSprite(slot1, slot0, true)

				if slot1:hasInterActionMask() then
					ResourceMgr.Inst:getAssetAsync("furniture/" .. slot2, "", typeof(Sprite), UnityEngine.Events.UnityAction_UnityEngine_Object(function (slot0)
						setActive(slot1, false)
						setImageSprite(slot1, slot0, true)
						setImageSprite(slot1)
					end), true, true)
				else
					slot4(slot0)
				end
			elseif slot5 then
				slot5()
			end
		end)
	else
		slot12, slot9 = slot1.getSpineName(slot1)

		LoadAndInstantiateAsync("sfurniture", slot8, function (slot0)
			if not IsNil(slot0._tf) then
				slot1 = rtf(slot0)
				slot1.pivot = slot1.pivot

				slot3(slot1, "icon", 1, slot1.pivot)

				if slot3:hasSpineMask() then
					slot8, slot5 = slot3:getSpineMaskName()

					LoadAndInstantiateAsync("sfurniture", slot4, function (slot0)
						setActive(slot0, false)
						slot0(rtf(slot0), "icon_front", 2)
						slot0(rtf(slot0))
					end, true, true)
				else
					slot4(slot1)
				end

				return
			end

			if slot5 then
				slot5()
			end
		end, true, true)
	end
end

slot0.createbottomGrid = function (slot0, slot1, slot2)
	slot4 = slot0.furnitureModals[slot1.id].Find(slot3, "grids")
	slot5 = {}
	slot6 = slot1:isFloor()

	for slot11, slot12 in ipairs(slot7) do
		slot13 = slot0:getGridTpl(slot6)

		SetParent(slot13, slot0.furContain)

		slot5[slot11] = slot13
		slot13.localPosition = slot0.getLocalPos(slot12)

		if not slot6 and BackyardFurnitureVO.isRightWall(slot2) then
			slot13.localScale = Vector3(1, 1, 1)
		end

		slot13:SetParent(slot4, true)
	end

	slot0.furnBottomGrids[slot1.id] = slot5
end

slot0.updateFurnitruePos = function (slot0, slot1, slot2)
	slot0:setFurnitureParent(slot1)

	slot0.furnitureModals[slot1.id].localPosition = slot0.getLocalPos(slot1:getPosition())

	if slot2 then
		slot0:createbottomGrid(slot1, slot3)
	end

	if slot1.parent ~= 0 then
		slot4.localPosition = Vector2(slot4.localPosition.x + slot0.furnitureVOs[slot1.parent].getConfig(slot6, "offset")[1], slot4.localPosition.y + slot0.furnitureVOs[slot1.parent].getConfig(slot6, "offset")[2])

		slot4:SetParent(slot0.furnitureModals[slot1.parent]:Find("childs"), true)

		if slot0.maps[slot1.parent] then
			slot0.maps[slot5].afterSortFunc(slot0.maps[slot5].sortedItems)
		end
	end

	slot0:createItem(slot1, slot3.x, slot3.y)
end

slot0.removeFurn = function (slot0, slot1)
	slot2 = slot0.furnitureModals[slot1.id]

	if slot1:hasInterActionShipId() then
		for slot7, slot8 in ipairs(slot3) do
			if not IsNil(slot2:Find("char_" .. slot8)) then
				SetParent(slot9, slot0.floorContain)
			end

			slot0.shipModels[slot8].spineAnimUI:SetAction("stand2", 0)
		end
	end

	slot4 = (slot1:isFloor() and slot0.backyardPoolMgr.POOL_NAME.GRID) or slot0.backyardPoolMgr.POOL_NAME.WALL
	slot5 = pairs
	slot6 = slot0.furnBottomGrids[slot1.id] or {}

	for slot8, slot9 in slot5(slot6) do
		slot0.backyardPoolMgr:Enqueue(slot4, slot9)
	end

	slot0.furnBottomGrids[slot1.id] = nil

	slot0.backyardPoolMgr:Enqueue(slot0.backyardPoolMgr.POOL_NAME.FURNITURE, slot2)

	slot0.curFurnModal = nil
	slot0.furnitureModals[slot1.id] = nil
	slot0.furnitureVOs[slot1.id] = nil

	if slot0.maps[slot1.id] then
		slot0.maps[slot1.id] = nil
	end
end

slot0.sortWallFurns = function (slot0)
	slot1, slot4 = slot0.houseVO:sortWallFurns()

	for slot6, slot7 in ipairs(slot2) do
		if not IsNil(slot0.furnitureModals[slot7.id]) then
			slot8:SetAsLastSibling()
		end
	end

	for slot6, slot7 in ipairs(slot1) do
		if not IsNil(slot0.furnitureModals[slot7.id]) then
			slot8:SetAsLastSibling()
		end
	end
end

slot0.setWallModalDir = function (slot0, slot1, slot2)
	if slot1:isFloor() then
		return
	end

	slot3 = slot0.furnitureModals[slot1.id]
	slot4 = slot0.getSign(BackyardFurnitureVO.isRightWall(slot2))

	if not IsNil(slot0.preFurnSelected) then
		slot0:setPreSelectedParent(slot0.furContain)
	end

	slot3.localScale = Vector3(slot4, 1, 1)

	if not IsNil(slot0.preFurnSelected) then
		slot0:setPreSelectedParent(slot3)

		slot0.preFurnSelected.anchoredPosition3D = Vector3(0, 0, 0)
	end
end

slot0.setFurnitureParent = function (slot0, slot1)
	slot0.furnitureModals[slot1.id]:SetParent((slot1:isFloor() and ((slot1:isMat() and slot0.carpetContain) or slot0.floorContain)) or slot0.wallContain, true)
end

slot0.getGridTpl = function (slot0, slot1)
	SetParent(slot0.backyardPoolMgr:Dequeue((slot1 and slot0.backyardPoolMgr.POOL_NAME.GRID) or slot0.backyardPoolMgr.POOL_NAME.WALL), slot0.furContain)

	return slot0.backyardPoolMgr.Dequeue((slot1 and slot0.backyardPoolMgr.POOL_NAME.GRID) or slot0.backyardPoolMgr.POOL_NAME.WALL)
end

slot0.loadboatModal = function (slot0, slot1, slot2)
	PoolMgr.GetInstance():GetSpineChar(slot1:getPrefab(), true, function (slot0)
		if not IsNil(slot0._tf) then
			slot0.name = "char_" .. slot1.id
			slot1 = BackYardShipModel.New(slot0, BackYardShipModel.New)
			slot0.shipModels[slot1.id] = slot1

			slot1:onLoadSlotModel(slot0)

			if not slot1:hasInterActionFurnitrue() then
				slot0:emit(BackyardMainMediator.ADD_BOAT_MOVE, slot1.id)
			end
		end

		if slot2 then
			slot2()
		end
	end)
end

slot0.setInterAction = function (slot0, slot1, slot2, slot3, slot4)
	if slot0.shipModels[slot2] then
		slot6 = slot0.furnitureModals[slot3]
		slot7 = slot0.furnitureVOs[slot3]

		if slot1 then
			slot5:updateSpineInterAction(slot7, slot6)
		else
			slot5:updateInterActionPos(slot7, slot6, slot4)
			slot5:InterActionSortSibling(slot3)
		end
	end
end

slot0.boatMove = function (slot0, slot1, slot2, slot3)
	slot0.shipModels[slot1]:move(slot2, slot3)
end

slot0.cancelShipMove = function (slot0, slot1)
	slot0.shipModels[slot1]:cancelMove()
end

slot0.updateShipPos = function (slot0, slot1)
	slot0.boatVOs[slot1.id]:setPosition(slot1:getPosition())

	if slot0.shipModels[slot1.id] then
		slot3:updateBoatVO(slot0.boatVOs[slot1.id])
		slot3:updatePosition(slot0.getLocalPos(slot2))
	end
end

slot0.acquireEffect = function (slot0, slot1, slot2, slot3)
	if slot0.shipModels[slot1] then
		slot4:acquireEffect(slot2, slot3)
	end
end

slot0.addBoatInimacyAndMoney = function (slot0, slot1)
	if slot0.shipModels[slot1.id] then
		slot2:updateInimacy(slot1:hasInimacy())
		slot2:updateMoney(slot1:hasMoney())
	else
		slot0.boatVOs[slot1.id].setInimacy(slot3, slot1.inimacy)
		slot0.boatVOs[slot1.id]:setMoney(slot1.money)
	end
end

slot0.exitBoat = function (slot0, slot1)
	slot0.shipModels[slot1.id].dispose(slot2)
	PoolMgr.GetInstance():ReturnSpineChar(slot3, slot0.shipModels[slot1.id].go)

	slot0.shipModels[slot1.id] = nil
	slot0.boatVOs[slot1.id] = nil
end

slot0.clearUI = function (slot0)
	for slot4, slot5 in pairs(slot0.shipModels) do
		slot5:dispose()
		PoolMgr.GetInstance():ReturnSpineChar(slot0.boatVOs[slot4]:getPrefab(), slot5.go)
	end

	for slot4, slot5 in pairs(slot0.furnBottomGrids) do
		for slot9, slot10 in pairs(slot5) do
			if not IsNil(slot10) then
				slot0.backyardPoolMgr:Enqueue((slot0.furnitureVOs[slot4]:isFloor() and slot0.backyardPoolMgr.POOL_NAME.GRID) or slot0.backyardPoolMgr.POOL_NAME.WALL, slot10)
			end
		end
	end

	for slot4, slot5 in pairs(slot0.furnitureModals) do
		if not IsNil(slot5) then
			slot0.backyardPoolMgr:Enqueue(slot0.backyardPoolMgr.POOL_NAME.FURNITURE, slot5)
		end
	end

	if not IsNil(slot0.furContain) then
		removeAllChildren(slot0.furContain:Find("shadow"))
		setActive(slot0.furContain:Find("ship_grid"), false)
	end

	if not IsNil(slot0.carpetContain) then
		removeAllChildren(slot0.carpetContain)
	end

	if not IsNil(slot0.wallContain) then
		removeAllChildren(slot0.wallContain)
	end

	if not IsNil(slot0.floorContain) then
		removeAllChildren(slot0.floorContain)
	end

	if not IsNil(slot0.baseBG) then
		Destroy(slot0.baseBG)
	end

	if not IsNil(slot0.wallBG) then
		UIUtil.ClearImageSprite(go(slot0.wallBG))
		setActive(slot0.wallBG, false)
	end

	if not IsNil(slot0.floorBG) then
		UIUtil.ClearImageSprite(go(slot0.floorBG))
		setActive(slot0.floorBG, false)
	end

	if not IsNil(slot0.floorGrid) then
		setActive(slot0.floorGrid, false)
	end
end

slot0.willExit = function (slot0)
	slot0:clearUI()
	PoolMgr.GetInstance():ReturnUI("BackYardUI", slot0.backyardui.gameObject)
	slot0.backyardPoolMgr:clear()

	slot0.backyardPoolMgr = nil
end

return slot0
