slot0 = class("MetaCharacterEnergyLayer", import("...base.BaseUI"))
slot1 = pg.ship_meta_breakout

slot0.getUIName = function (slot0)
	return "MetaCharacterEnergyUI"
end

slot0.init = function (slot0)
	slot0:initUITipText()
	slot0:initData()
	slot0:initUI()
	slot0:addListener()
end

slot0.didEnter = function (slot0)
	slot0:updateShipImg()
	slot0:updateNamePanel()
	slot0:updateChar()
	slot0:updateAttrPanel()
	slot0:updateMaterialPanel()
	slot0:initPreviewPanel()
	slot0:enablePartialBlur()

	if slot0.contextData.isMainOpen then
		slot0.contextData.isMainOpen = nil

		slot0:moveShipImg(true)
	end

	slot0:moveRightPanel()
	slot0:TryPlayGuide()
end

slot0.willExit = function (slot0)
	slot0:moveShipImg(false)
	slot0:recycleChar()

	if slot0.previewer then
		slot0.previewer:clear()

		slot0.previewer = nil
	end

	slot0:disablePartialBlur()
end

slot0.onBackPressed = function (slot0)
	if isActive(slot0.previewTF) then
		slot0:closePreviewPanel()

		return
	else
		slot0:emit(slot0.ON_BACK_PRESSED)
	end
end

slot0.initUITipText = function (slot0)
	setText(slot1, i18n("meta_energy_preview_title"))
	setText(slot2, i18n("meta_energy_preview_tip"))
	setText(slot3, i18n("word_level_upperLimit"))
	setText(slot0:findTF("RightPanel/MaterialPanel/TipText"), i18n("meta_break"))
end

slot0.initData = function (slot0)
	slot0.shipPrefab = nil
	slot0.shipModel = nil
	slot0.metaCharacterProxy = getProxy(MetaCharacterProxy)
	slot0.bayProxy = getProxy(BayProxy)
	slot0.curMetaShipID = slot0.contextData.shipID
	slot0.curShipVO = nil
	slot0.curMetaCharacterVO = nil

	slot0:updateData()
end

slot0.initUI = function (slot0)
	slot0.shipImg = slot0:findTF("ShipImg")
	slot0.nameTF = slot0:findTF("NamePanel")
	slot0.nameScrollText = slot0:findTF("NameMask/NameText", slot0.nameTF)
	slot0.shipTypeImg = slot0:findTF("TypeImg", slot0.nameTF)
	slot0.enNameText = slot0:findTF("NameENText", slot0.nameTF)
	slot0.nameTFStarUIList = UIItemList.New(slot2, slot1)
	slot0.previewBtn = slot0:findTF("PreviewBtn")
	slot0.rightPanel = slot0:findTF("RightPanel")
	slot0.qCharContain = slot0:findTF("DetailPanel/QChar", slot0.rightPanel)
	slot0.starTpl = slot0:findTF("DetailPanel/RarePanel/StarTpl", slot0.rightPanel)

	setActive(slot0.starTpl, false)

	slot0.starsFrom = slot0:findTF("DetailPanel/RarePanel/StarsFrom", slot0.rightPanel)
	slot0.starsTo = slot0:findTF("DetailPanel/RarePanel/StarsTo", slot0.rightPanel)
	slot0.starOpera = slot0:findTF("DetailPanel/RarePanel/OpImg", slot0.rightPanel)
	slot0.starFromList = UIItemList.New(slot0.starsFrom, slot0.starTpl)
	slot0.starToList = UIItemList.New(slot0.starsTo, slot0.starTpl)
	slot0.attrTpl = slot0:findTF("DetailPanel/AttrTpl", slot0.rightPanel)

	setActive(slot0.attrTpl, false)

	slot0.attrsContainer = slot0:findTF("DetailPanel/AttrsContainer", slot0.rightPanel)
	slot0.attrsList = UIItemList.New(slot0.attrsContainer, slot0.attrTpl)
	slot0.materialPanel = slot0:findTF("MaterialPanel", slot0.rightPanel)
	slot0.levelNumText = slot0:findTF("Info/LevelTipText", slot0.materialPanel)
	slot0.infoTF = slot0:findTF("Info", slot0.materialPanel)
	slot0.repairRateText = slot0:findTF("Info/ProgressTipText", slot0.materialPanel)
	slot0.materialTF = slot0:findTF("Info/Material", slot0.materialPanel)
	slot0.breakOutTipImg = slot0:findTF("TipText", slot0.materialPanel)
	slot0.goldTF = slot0:findTF("Gold", slot0.materialPanel)
	slot0.goldNumText = slot0:findTF("NumText", slot0.goldTF)
	slot0.starMaxTF = slot0:findTF("StarMax", slot0.materialPanel)
	slot0.activeBtn = slot0:findTF("ActiveBtn", slot0.materialPanel)
	slot0.activeBtnDisable = slot0:findTF("ActiveBtnDisable", slot0.materialPanel)
	slot0.previewTF = slot0:findTF("Preview")
	slot0.previewBG = slot0:findTF("BG", slot0.previewTF)
	slot0.previewPanel = slot0:findTF("PreviewPanel", slot0.previewTF)
	slot0.stages = slot0:findTF("StageScrollRect/Stages", slot0.previewPanel)
	slot0.stagesSnap = slot0:findTF("StageScrollRect", slot0.previewPanel):GetComponent("HorizontalScrollSnap")
	slot0.breakView = slot0:findTF("Content/Text", slot0.previewPanel)
	slot0.sea = slot0:findTF("Sea", slot0.previewPanel)
	slot0.rawImage = slot0.sea:GetComponent("RawImage")

	setActive(slot0.rawImage, false)

	slot0.healTF = slot0:findTF("Resources/Heal")
	slot0.healTF.transform.localPosition = Vector3(-360, 50, 40)

	setActive(slot0.healTF, false)

	slot0.seaLoading = slot0:findTF("BG/Loading", slot0.previewPanel)
	slot0.previewAttrTpl = slot0:findTF("FinalAttrPanel/AttrTpl", slot0.previewTF)
	slot0.previewAttrContainer = slot0:findTF("FinalAttrPanel/AttrsContainer", slot0.previewTF)
	slot0.previewAttrUIItemList = UIItemList.New(slot0.previewAttrContainer, slot0.previewAttrTpl)
end

slot0.addListener = function (slot0)
	onButton(slot0, slot0.previewBtn, function ()
		slot0:openPreviewPanel()
	end, SFX_PANEL)
	onButton(slot0, slot0.previewBG, function ()
		slot0:closePreviewPanel()
	end, SFX_CANCEL)
	onButton(slot0, slot0.activeBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("meta_energy_active_box_tip"),
			onYes = function ()
				pg.m02:sendNotification(GAME.ENERGY_META_ACTIVATION, {
					shipId = slot0.curMetaShipID
				})
			end,
			weight = LayerWeightConst.TOP_LAYER
		})
	end, SFX_PANEL)
end

slot0.updateData = function (slot0)
	slot0.curShipVO = slot0.bayProxy:getShipById(slot0.curMetaShipID)
	slot0.curMetaCharacterVO = slot0.curShipVO:getMetaCharacter()
end

slot0.TryPlayGuide = function (slot0)
	pg.SystemGuideMgr.GetInstance():PlayByGuideId("NG0026")
end

slot0.updateShipImg = function (slot0)
	slot6, slot7 = MetaCharacterConst.GetMetaCharacterPaintPath(slot0.curMetaCharacterVO.id, true)

	setImageSprite(slot0.shipImg, LoadSprite(slot1, slot2), true)
	setLocalPosition(slot0.shipImg, {
		x = MetaCharacterConst.UIConfig[slot0.curMetaCharacterVO.id][5],
		y = MetaCharacterConst.UIConfig[slot0.curMetaCharacterVO.id][6]
	})
	setLocalScale(slot0.shipImg, {
		x = MetaCharacterConst.UIConfig[slot0.curMetaCharacterVO.id][3],
		y = MetaCharacterConst.UIConfig[slot0.curMetaCharacterVO.id][4]
	})
end

slot0.updateNamePanel = function (slot0)
	slot2 = slot0.curMetaCharacterVO

	setScrollText(slot0.nameScrollText, slot3)
	setImageSprite(slot0.shipTypeImg, LoadSprite("shiptype", slot4))
	setText(slot0.enNameText, slot5)

	slot7 = slot0.curShipVO.getStar(slot1)

	slot0.nameTFStarUIList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot3 = slot0:findTF("empty", slot2)

			setActive(slot0:findTF("on", slot2), slot1 + 1 <= )
		end
	end)
	slot0.nameTFStarUIList.align(slot8, slot0.curShipVO.getMaxStar(slot1))
end

slot0.updateChar = function (slot0)
	return
end

slot0.recycleChar = function (slot0)
	if slot0.shipPrefab and slot0.shipModel then
		PoolMgr.GetInstance():ReturnSpineChar(slot0.shipPrefab, slot0.shipModel)

		slot0.shipPrefab = nil
		slot0.shipModel = nil
	end
end

slot0.updateAttrPanel = function (slot0)
	slot1 = slot0.curShipVO
	slot3 = slot0.curMetaCharacterVO.getBreakOutInfo(slot2)

	function slot4(slot0, slot1)
		Clone(slot1).configId = slot0:getNextInfo().id
		slot5 = 0
		slot6 = 0

		if AttributeType.Expend ~= MetaCharacterConst.ENERGY_ATTRS[slot0 + 1] then
			slot5 = math.floor(slot1:getShipProperties()[slot4])
			slot6 = math.floor(slot3:getShipProperties()[slot4])
		else
			slot5 = math.floor(slot1:getBattleTotalExpend())
			slot6 = math.floor(slot3:getBattleTotalExpend())
		end

		setText(slot1:Find("NameText"), AttributeType.Type2Name(slot4))
		setText(slot1:Find("CurValueText"), slot5)
		setActive(slot1:Find("AddValueText"), true)
		setText(slot1:Find("AddValueText"), "+" .. slot6 - slot5)
		setText(slot1:Find("NextValueText"), slot6)
		slot2.starFromList:align(slot1:getStar())
		slot2.starToList:align(slot3:getStar())
	end

	function slot5(slot0, slot1)
		slot2 = slot0:getShipProperties()
		slot4 = 0

		setText(slot1:Find("NameText"), AttributeType.Type2Name(slot3))
		setText(slot1:Find("CurValueText"), (AttributeType.Expend == MetaCharacterConst.ENERGY_ATTRS[slot0 + 1] or math.floor(slot0:getShipProperties()[slot3])) and math.floor(slot0:getBattleTotalExpend()))
		setText(slot1:Find("NextValueText"), setColorStr((AttributeType.Expend == MetaCharacterConst.ENERGY_ATTRS[slot0 + 1] or math.floor(slot0.getShipProperties()[slot3])) and math.floor(slot0.getBattleTotalExpend()), COLOR_GREEN))
		setText(slot1:Find("AddValueText"), "+0")
		setActive(slot1:Find("AddValueText"), false)
		slot1.starFromList:align(slot0:getStar())
		slot1.starToList:align(0)
	end

	slot0.attrsList.make(slot6, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			if slot0:hasNextInfo() then
				slot1(slot1, slot2)
				setActive(slot2.starOpera, true)
			else
				slot3(slot1, slot2)
				setActive(slot2.starOpera, false)
			end
		end
	end)
	slot0.attrsList.align(slot6, #MetaCharacterConst.ENERGY_ATTRS)
end

slot0.updateMaterialPanel = function (slot0, slot1)
	slot2 = slot0.curShipVO
	slot5 = getProxy(BagProxy)

	if not slot0.curMetaCharacterVO.getBreakOutInfo(slot3):hasNextInfo() then
		setActive(slot0.infoTF, false)
		setActive(slot0.breakOutTipImg, false)
		setActive(slot0.goldTF, false)
		setActive(slot0.starMaxTF, true)
		setActive(slot0.activeBtn, false)
		setActive(slot0.activeBtnDisable, true)

		return
	else
		setActive(slot0.infoTF, true)
		setActive(slot0.breakOutTipImg, true)
		setActive(slot0.goldTF, true)
		setActive(slot0.starMaxTF, false)
		setActive(slot0.activeBtn, true)
		setActive(slot0.activeBtnDisable, false)
	end

	slot6 = true
	slot7, slot8 = nil
	slot7, slot8 = slot4:getConsume()
	slot12 = slot0:findTF("Item", slot0.materialTF)
	slot13 = slot0:findTF("icon_bg/count", slot12)

	updateDrop(slot12, slot14, {
		hideName = true
	})
	onButton(slot0, slot12, function ()
		slot0:emit(BaseUI.ON_DROP, slot0)
	end, SFX_PANEL)
	setText(slot13, setColorStr(slot5:getItemCountById(nil), (slot5.getItemCountById(nil) < nil[1].count and COLOR_RED) or COLOR_GREEN) .. "/" .. nil)

	if slot10 < slot11 then
		slot6 = false
	end

	setText(slot0.goldNumText, slot7)

	if getProxy(PlayerProxy):getData().gold < slot7 then
		slot6 = false
	end

	slot18, slot19 = nil
	slot18, slot19 = slot4:getLimited()

	setText(slot0.levelNumText, i18n("meta_energy_ship_level_need", (slot2.level < slot2.level and setColorStr(slot2.level, COLOR_RED)) or setColorStr(slot2.level, COLOR_GREEN), slot18))
	setText(slot0.repairRateText, i18n("meta_energy_ship_repairrate_need", (slot3:getRepairRate() < slot19 / 100 and setColorStr(slot3:getRepairRate() * 100 .. "%%", COLOR_RED)) or setColorStr(slot3.getRepairRate() * 100 .. "%%", COLOR_GREEN), slot19 .. "%%"))

	if slot2.level < slot18 then
		slot6 = false
	end

	if slot3:getRepairRate() < slot19 / 100 then
		slot6 = false
	end

	setActive(slot0.activeBtn, slot6)
	setActive(slot0.activeBtnDisable, not slot6)
end

slot0.moveShipImg = function (slot0, slot1)
	slot0:managedTween(LeanTween.moveX, nil, rtf(slot0.shipImg), (slot1 and MetaCharacterConst.UIConfig[slot0.curMetaCharacterVO.id][5]) or -2000, 0.2):setFrom((slot1 and -2000) or MetaCharacterConst.UIConfig[slot0.curMetaCharacterVO.id][5])
end

slot0.moveRightPanel = function (slot0)
	slot0:managedTween(LeanTween.moveX, nil, rtf(slot0.rightPanel), 577.64, 0.2):setFrom(2000)
end

slot0.updatePreviewAttrListPanel = function (slot0)
	slot2 = slot0.curMetaCharacterVO
	slot4 = Clone(slot1)
	slot4.level = 120
	slot6 = intProperties(slot4:getMetaCharacter().getFinalAddition(slot5, slot4))

	slot0.previewAttrUIItemList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot5 = slot0:findTF("AddValueText", slot2)

			setImageSprite(slot3, LoadSprite("attricon", slot1[slot1 + 1]))
			setText(slot0:findTF("NameText", slot2), AttributeType.Type2Name(slot1[slot1 + 1]))

			if slot1[slot1 + 1] == AttributeType.ArmorType then
				setText(slot5, slot2:getShipArmorName())
			else
				setText(slot5, slot3[slot6] or 0)
			end
		end
	end)
	slot0.previewAttrUIItemList.align(slot7, #{
		AttributeType.Durability,
		AttributeType.Cannon,
		AttributeType.Torpedo,
		AttributeType.AntiAircraft,
		AttributeType.Air,
		AttributeType.Reload,
		AttributeType.ArmorType,
		AttributeType.Dodge
	})
end

slot0.initPreviewPanel = function (slot0, slot1)
	slot2 = slot0.curShipVO
	slot0.breakIds = slot0:getAllBreakIDs(slot0.curMetaCharacterVO.id)

	for slot7 = 1, 3, 1 do
		slot9 = slot0[slot0.breakIds[slot7]]

		onToggle(slot0, slot0:findTF("Stage" .. slot7, slot0.stages), function (slot0)
			if slot0 then
				setText(slot0.breakView, slot1[slot0.breakView].breakout_view)
				slot0:switchStage(slot0)
			end
		end, SFX_PANEL)

		if slot7 == 1 then
			triggerToggle(slot10, true)
		end
	end

	onButton(slot0, slot0.seaLoading, function ()
		if not slot0.previewer then
			slot0:showBarrage()
		end
	end)
	slot0.updatePreviewAttrListPanel(slot0)
end

slot0.closePreviewPanel = function (slot0)
	if slot0.previewer then
		slot0.previewer:clear()

		slot0.previewer = nil
	end

	setActive(slot0.previewTF, false)
	setActive(slot0.rawImage, false)
	pg.UIMgr.GetInstance():UnblurPanel(slot0.previewTF, slot0._tf)
end

slot0.openPreviewPanel = function (slot0)
	setActive(slot0.previewTF, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0.previewTF, false, {
		weight = LayerWeightConst.TOP_LAYER
	})
	slot0:playLoadingAni()
end

slot0.playLoadingAni = function (slot0)
	setActive(slot0.seaLoading, true)
end

slot0.stopLoadingAni = function (slot0)
	setActive(slot0.seaLoading, false)
end

slot0.getAllBreakIDs = function (slot0, slot1)
	slot2 = {}

	for slot6, slot7 in ipairs(slot0.all) do
		if math.floor(slot7 / 10) == slot1 then
			table.insert(slot2, slot7)
		end
	end

	return slot2
end

slot0.getWaponIdsById = function (slot0, slot1)
	return slot0[slot1].weapon_ids
end

slot0.getAllWeaponIds = function (slot0)
	slot1 = {}

	for slot5, slot6 in ipairs(slot0.breakIds) do
		setmetatable(slot1, {
			__add = function (slot0, slot1)
				for slot5, slot6 in ipairs(slot0) do
					if not table.contains(slot1, slot6) then
						table.insert(slot1, slot6)
					end
				end

				return slot1
			end
		})

		slot1 = slot1 + Clone(slot0[slot6].weapon_ids)
	end

	return slot1
end

slot0.showBarrage = function (slot0)
	slot1 = slot0.bayProxy:getShipById(slot0.curMetaShipID)
	slot2 = slot1:getMetaCharacter()
	slot0.previewer = WeaponPreviewer.New(slot0.rawImage)

	slot0.previewer:configUI(slot0.healTF)
	slot0.previewer:setDisplayWeapon(slot0:getWaponIdsById(slot0.breakOutId))
	slot0.previewer:load(40000, slot1, slot0:getAllWeaponIds(), function ()
		slot0:stopLoadingAni()
	end)
end

slot0.switchStage = function (slot0, slot1)
	if slot0.breakOutId == slot1 then
		return
	end

	slot0.breakOutId = slot1

	if slot0.previewer then
		slot0.previewer:setDisplayWeapon(slot0:getWaponIdsById(slot0.breakOutId))
	end
end

slot0.enablePartialBlur = function (slot0)
	if slot0._tf then
		table.insert(slot1, slot0.previewBtn)
		table.insert(slot1, slot0.rightPanel)
		pg.UIMgr.GetInstance():OverlayPanelPB(slot0._tf, {
			pbList = {},
			groupName = LayerWeightConst.GROUP_META,
			weight = LayerWeightConst.BASE_LAYER - 1
		})
	end
end

slot0.disablePartialBlur = function (slot0)
	if slot0._tf then
		pg.UIMgr.GetInstance():UnOverlayPanel(slot0._tf)
	end
end

return slot0
