slot0 = class("MangaView", import("..base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "MangaUI"
end

slot0.OnInit = function (slot0)
	slot0:initData()
	slot0:initUI()
	slot0:addListener()
	slot0:updateBtnList()
	slot0:Show()
	slot0:updatePanel()
	slot0:tryShowTipMsgBox()
end

slot0.OnDestroy = function (slot0)
	slot0.resLoader:Clear()
end

slot0.onBackPressed = function (slot0)
	return true
end

slot0.initData = function (slot0)
	slot0.appreciateProxy = getProxy(AppreciateProxy)
	slot0.resLoader = AutoLoader.New()
	slot0.isShowNotRead = false
	slot0.isShowLike = false
	slot0.isUpOrder = false
	slot0.mangaIDListForShow = slot0:getMangaIDListForShow()
end

slot0.initUI = function (slot0)
	setLocalPosition(slot0._tf, Vector2.zero)

	slot0._tf.anchorMin = Vector2.zero
	slot0._tf.anchorMax = Vector2.one
	slot0._tf.offsetMax = Vector2.zero
	slot0._tf.offsetMin = Vector2.zero
	slot1 = slot0:findTF("BtnList")
	slot0.likeFilteBtn = slot0:findTF("LikeFilterBtn", slot1)
	slot0.readFilteBtn = slot0:findTF("ReadFilteBtn", slot1)
	slot0.orderBtn = slot0:findTF("OrderBtn", slot1)
	slot0.repairBtn = slot0:findTF("RepairBtn", slot1)
	slot0.scrollView = slot0:findTF("ScrollView")
	slot0.emptyPanel = slot0:findTF("EmptyPanel")
	slot0.mangaContainer = slot0:findTF("ScrollView/Content")
	slot0.lScrollRectSC = slot0:findTF("ScrollView/Content"):GetComponent("LScrollRect")
	slot0.mangaTpl = slot0:findTF("MangaTpl")

	slot0.lScrollRectSC:BeginLayout()
	slot0.lScrollRectSC:EndLayout()
	slot0:initUIText()
end

slot0.initUIText = function (slot0)
	setText(slot1, i18n("cartoon_notall"))
	setText(slot2, i18n("cartoon_notall"))
	setText(slot3, i18n("cartoon_notall"))
	setText(slot0:findTF("Text", slot0.emptyPanel), i18n("cartoon_haveno"))
end

slot0.addListener = function (slot0)
	onButton(slot0, slot0.likeFilteBtn, function ()
		slot0.isShowLike = not slot0.isShowLike
		slot0.mangaIDListForShow = slot0:getMangaIDListForShow()

		slot0:updateBtnList()
		slot0.updateBtnList:updatePanel()
	end, SFX_PANEL)
	onButton(slot0, slot0.readFilteBtn, function ()
		slot0.isShowNotRead = not slot0.isShowNotRead
		slot0.mangaIDListForShow = slot0:getMangaIDListForShow()

		slot0:updateBtnList()
		slot0.updateBtnList:updatePanel()
	end, SFX_PANEL)
	onButton(slot0, slot0.orderBtn, function ()
		slot0.isUpOrder = not slot0.isUpOrder
		slot0.mangaIDListForShow = slot0:getMangaIDListForShow()

		slot0:updateBtnList()
		slot0.updateBtnList:updatePanel()
	end, SFX_PANEL)
	onButton(slot0, slot0.repairBtn, function ()
		slot0 = {
			text = i18n("msgbox_repair"),
			onCallback = function ()
				if PathMgr.FileExists(Application.persistentDataPath .. "/hashes.csv") then
					UpdateMgr.Inst:StartVerify()
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
				end
			end
		}

		if Application.isEditor then
			PlayerPrefs.SetInt("mangaVersion", 0)
		end

		pg.MsgboxMgr.GetInstance().ShowMsgBox(slot1, {
			hideYes = true,
			content = i18n("resource_verify_warn"),
			custom = {
				slot0
			}
		})
	end, SFX_PANEL)
end

slot0.updateMangaTpl = function (slot0, slot1, slot2)
	slot3 = tf(slot2)
	slot13 = MangaConst.isMangaEverReadByID(slot4)
	slot14 = MangaConst.isMangaNewByID(slot4)

	setActive(slot6, not slot13)
	setActive(slot7, false)
	setActive(slot8, slot13)
	setActive(slot9, not slot13)
	setText(slot10, "#" .. pg.cartoon[slot0.mangaIDListForShow[slot1]].cartoon_id)
	setText(slot11, "#" .. pg.cartoon[slot0.mangaIDListForShow[slot1]].cartoon_id)
	setText(slot12, "#" .. pg.cartoon[slot0.mangaIDListForShow[slot1]].cartoon_id)
	onButton(slot0, slot3, function ()
		slot0:openMangaViewLayer(slot0)
	end, SFX_PANEL)

	slot15 = pg.cartoon[slot0.mangaIDListForShow[slot1]].resource
	slot16 = MangaConst.MANGA_PATH_PREFIX .. slot15

	if not IsNil(GetComponent(slot5, "Image").sprite) then
		if slot17.name ~= slot15 then
			slot0.resLoader:LoadSprite(slot16, slot15, slot5, false)
		end
	else
		slot0.resLoader:LoadSprite(slot16, slot15, slot5, false)
	end
end

slot0.updateMangaList = function (slot0)
	slot0.resLoader:Clear()

	slot0.lScrollRectSC.onUpdateItem = function (slot0, slot1)
		slot0:updateMangaTpl(slot0 + 1, slot1)
	end

	slot0.lScrollRectSC.SetTotalCount(slot1, #slot0.mangaIDListForShow)
end

slot0.updatePanel = function (slot0)
	setActive(slot0.emptyPanel, #slot0.mangaIDListForShow <= 0)
	setActive(slot0.scrollView, #slot0.mangaIDListForShow > 0)

	if #slot0.mangaIDListForShow > 0 then
		slot0:updateMangaList()
	end
end

slot0.updateBtnList = function (slot0)
	setActive(slot1, slot0.isShowLike)
	setActive(slot2, not slot0.isShowNotRead)
	setActive(slot3, slot0.isShowNotRead)
	setActive(slot4, slot0.isUpOrder)
	setActive(slot0:findTF("Down", slot0.orderBtn), not slot0.isUpOrder)
end

slot0.tryShowTipMsgBox = function (slot0)
	if slot0.appreciateProxy:isMangaHaveNewRes() then
		pg.MsgboxMgr.GetInstance().ShowMsgBox(slot3, {
			hideClose = true,
			hideNo = true,
			content = i18n("res_cartoon_new_tip", MangaConst.NewCount),
			onYes = function ()
				PlayerPrefs.SetInt("mangaVersion", MangaConst.Version)
				PlayerPrefs.SetInt:emit(CollectionScene.UPDATE_RED_POINT)
			end,
			onCancel = function ()
				PlayerPrefs.SetInt("mangaVersion", MangaConst.Version)
				PlayerPrefs.SetInt.emit(CollectionScene.UPDATE_RED_POINT)
			end,
			onClose = function ()
				PlayerPrefs.SetInt("mangaVersion", MangaConst.Version)
				PlayerPrefs.SetInt.emit(CollectionScene.UPDATE_RED_POINT)
			end
		})
	end
end

slot0.openMangaViewLayer = function (slot0, slot1)
	LoadContextCommand.LoadLayerOnTopContext(Context.New({
		mediator = MangaFullScreenMediator,
		viewComponent = MangaFullScreenLayer,
		data = {
			mangaIndex = slot1,
			mangaIDLIst = slot0.mangaIDListForShow,
			mangaContext = slot0,
			isShowingNotRead = isActive(slot0:findTF("ShowingNotRead", slot0.readFilteBtn))
		},
		onRemoved = function ()
			return
		end
	}))
end

slot0.updateLineAfterRead = function (slot0, slot1)
	if slot0:findTF(tostring(slot2), slot0.mangaContainer) then
		slot8 = MangaConst.isMangaEverReadByID(slot1)

		setActive(slot0:findTF("Content/Bottom/BottomNew", slot3), MangaConst.isMangaNewByID(slot1) and not slot8)
		setActive(slot0:findTF("Content/Bottom/BottomNotRead", slot3), not slot9 and not slot8)
		setActive(slot0:findTF("Content/Bottom/BottomNormal", slot3), slot8)
		setActive(slot0:findTF("TopSpecial", slot3), not slot8)
	end
end

slot0.updateToMangaID = function (slot0, slot1)
	slot0.lScrollRectSC:SetTotalCount(#slot0.mangaIDListForShow, defaultValue(slot0.lScrollRectSC:HeadIndexToValue(slot2), -1))
end

slot0.getMangaIDListForShow = function (slot0, slot1)
	slot2 = {}

	for slot6, slot7 in ipairs(pg.cartoon.all) do
		slot8 = MangaConst.isMangaEverReadByID(slot7)
		slot9 = MangaConst.isMangaLikeByID(slot7)

		if slot0.isShowNotRead and slot0.isShowLike then
			if not slot8 and slot9 then
				table.insert(slot2, slot7)
			end
		elseif slot0.isShowNotRead and not slot0.isShowLike then
			if not slot8 then
				table.insert(slot2, slot7)
			end
		elseif not slot0.isShowNotRead and slot0.isShowLike then
			if slot9 then
				table.insert(slot2, slot7)
			end
		else
			table.insert(slot2, slot7)
		end
	end

	table.sort(slot2, function (slot0, slot1)
		if pg.cartoon[slot1].cartoon_id < pg.cartoon[slot0].cartoon_id then
			return not slot0.isUpOrder
		elseif slot4 == slot5 then
			return slot0 < slot1
		elseif slot4 < slot5 then
			return slot0.isUpOrder
		end
	end)

	return slot2
end

return slot0
