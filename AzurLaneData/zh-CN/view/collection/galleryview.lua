slot0 = class("GalleryView", import("..base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "GalleryUI"
end

slot0.OnInit = function (slot0)
	slot0:initData()
	slot0:findUI()
	slot0:addListener()
	slot0:initCardListPanel()
	slot0:initTimeSelectPanel()
	slot0:initPicPanel()
	slot0:Show()
	slot0:recoveryFromRunData()
	slot0:tryShowTipMsgBox()
end

slot0.OnDestroy = function (slot0)
	slot0.resLoader:Clear()

	if slot0.appreciateUnlockMsgBox and slot0.appreciateUnlockMsgBox:CheckState(BaseSubView.STATES.INITED) then
		slot0.appreciateUnlockMsgBox:hideCustomMsgBox()
	end

	if isActive(slot0.picPanel) then
		slot0:closePicPanel(true)
	end

	if slot0.downloadCheckTimer then
		slot0.downloadCheckTimer:Stop()

		slot0.downloadCheckTimer = nil
	end

	if slot0.scrollTimer then
		slot0.scrollTimer:Stop()

		slot0.scrollTimer = nil
	end
end

slot0.onBackPressed = function (slot0)
	if slot0.appreciateUnlockMsgBox and slot0.appreciateUnlockMsgBox:CheckState(BaseSubView.STATES.INITED) then
		slot0.appreciateUnlockMsgBox:hideCustomMsgBox()

		return false
	elseif isActive(slot0.picPanel) then
		slot0:closePicPanel()

		return false
	else
		return true
	end
end

slot0.initData = function (slot0)
	slot0.appreciateProxy = getProxy(AppreciateProxy)

	slot0.appreciateProxy:checkPicFileState()

	slot0.resLoader = AutoLoader.New()
	slot0.manager = BundleWizard.Inst:GetGroupMgr("GALLERY_PIC")
	slot0.picForShowConfigList = {}
	slot0.cardTFList = {}
	slot0.curPicLikeValue = GalleryConst.Filte_Normal_Value
	slot0.curPicSelectDateValue = GalleryConst.Data_All_Value
	slot0.curPicSortValue = GalleryConst.Sort_Order_Up
	slot0.curMiddleDataIndex = 1
	slot0.curFilteLoadingBGValue = GalleryConst.Loading_BG_NO_Filte
	slot0.downloadCheckIDList = {}
	slot0.downloadCheckTimer = nil
	slot0.recoveryDataTag = false
	slot0.recoveryDataLikeTag = false
	slot0.recoveryDataBGFilteTag = false
	slot0.picLikeToggleTag = false
end

slot0.findUI = function (slot0)
	setLocalPosition(slot0._tf, Vector2.zero)

	slot0._tf.anchorMin = Vector2.zero
	slot0._tf.anchorMax = Vector2.one
	slot0._tf.offsetMax = Vector2.zero
	slot0._tf.offsetMin = Vector2.zero
	slot0.topPanel = slot0:findTF("TopPanel")
	slot0.likeFilterToggle = slot0:findTF("List/LikeFilterBtn", slot0.topPanel)
	slot0.likeNumText = slot0:findTF("TextNum", slot0.likeFilterToggle)

	setActive(slot0.likeFilterToggle, true)
	setActive(slot0.likeNumText, false)

	slot0.timeFilterToggle = slot0:findTF("List/TimeFilterBtn", slot0.topPanel)
	slot0.timeTextSelected = slot0:findTF("TextSelected", slot0.timeFilterToggle)
	slot0.timeItemContainer = slot0:findTF("Panel", slot0.timeFilterToggle)
	slot0.timeItemTpl = slot0:findTF("Item", slot0.timeItemContainer)

	setActive(slot0.timeFilterToggle, #GalleryConst.DateIndex >= 2)

	slot0.orderToggle = slot0:findTF("List/OrderBtn", slot0.topPanel)
	slot0.setFilteToggle = slot0:findTF("List/SetFilterBtn", slot0.topPanel)

	setActive(slot0.setFilteToggle, false)

	slot0.resRepaireBtn = slot0:findTF("List/RepaireBtn", slot0.topPanel)
	slot0.progressText = slot0:findTF("TextProgress", slot0.topPanel)
	slot0.scrollPanel = slot0:findTF("Scroll")
	slot0.lScrollPageSC = GetComponent(slot0.scrollPanel, "LScrollPage")
	slot0.picPanel = slot0:findTF("PicPanel")
	slot0.picPanelBG = slot0:findTF("PanelBG", slot0.picPanel)
	slot0.picTopContainer = slot0:findTF("Container", slot0.picPanel)
	slot0.picContainer = slot0:findTF("Container/Picture", slot0.picPanel)
	slot0.picBGImg = slot0:findTF("Container/Picture/PicBG", slot0.picPanel)
	slot0.picImg = slot0:findTF("Container/Picture/Pic", slot0.picPanel)
	slot0.picLikeToggle = slot0:findTF("LikeBtn", slot0.picContainer)
	slot0.picName = slot0:findTF("PicName", slot0.picContainer)
	slot0.picPreBtn = slot0:findTF("PreBtn", slot0.picPanel)
	slot0.picNextBtn = slot0:findTF("NextBtn", slot0.picPanel)

	setActive(slot0.picLikeToggle, true)

	slot0.emptyPanel = slot0:findTF("EmptyPanel")
	slot0.setOpenToggle = slot0:findTF("SetToggle")

	setActive(slot0.setOpenToggle, false)
end

slot0.addListener = function (slot0)
	onToggle(slot0, slot0.orderToggle, function (slot0)
		if slot0.recoveryDataTag == true then
			slot0.recoveryDataTag = false
		else
			slot0.curMiddleDataIndex = 1
		end

		if slot0 == true then
			slot0.curPicSortValue = GalleryConst.Sort_Order_Down
		else
			slot0.curPicSortValue = GalleryConst.Sort_Order_Up
		end

		slot0:saveRunData()
		slot0:sortPicConfigListForShow()
		slot0:updateCardListPanel()
	end, SFX_PANEL)
	onToggle(slot0, slot0.likeFilterToggle, function (slot0)
		if slot0.recoveryDataLikeTag == true then
			slot0.recoveryDataLikeTag = false

			return
		end

		slot0.curMiddleDataIndex = 1

		if slot0 == true then
			slot0.curPicLikeValue = GalleryConst.Filte_Like_Value
		else
			slot0.curPicLikeValue = GalleryConst.Filte_Normal_Value
		end

		slot0:saveRunData()

		slot0.picForShowConfigList = slot0:filtePicForShowByDate(slot0.curPicSelectDateValue)
		slot0.picForShowConfigList = slot0:filtePicForShowByLike(slot0.curPicLikeValue)
		slot0.picForShowConfigList = slot0:filtePicForShowByLoadingBG(slot0.curFilteLoadingBGValue)

		slot0:updateCardListPanel()
	end)
	onButton(slot0, slot0.resRepaireBtn, function ()
		pg.MsgboxMgr.GetInstance().ShowMsgBox(slot1, {
			hideYes = true,
			content = i18n("resource_verify_warn"),
			custom = {
				{
					text = i18n("msgbox_repair"),
					onCallback = function ()
						if PathMgr.FileExists(Application.persistentDataPath .. "/hashes-pic.csv") then
							BundleWizard.Inst:GetGroupMgr("GALLERY_PIC"):StartVerifyForLua()
						else
							pg.TipsMgr.GetInstance():ShowTips(i18n("word_no_cache"))
						end
					end
				}
			}
		})
	end, SFX_PANEL)
end

slot0.initTimeSelectPanel = function (slot0)
	slot0.timeSelectUIItemList = UIItemList.New(slot0.timeItemContainer, slot0.timeItemTpl)

	slot0.timeSelectUIItemList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot3 = GalleryConst.DateIndex[slot1 + 1]

			setText(slot5, slot4)
			onButton(slot0, slot2, function ()
				if slot0 ~= slot1.curPicSelectDateValue then
					slot1.curPicSelectDateValue = slot1
					slot1.curMiddleDataIndex = 1

					1:saveRunData()
					setText(1.timeTextSelected, slot2)

					slot1 = 1.timeTextSelected:filtePicForShowByDate(1.timeTextSelected)
					1.timeTextSelected.picForShowConfigList = slot1
					slot1 = slot1:filtePicForShowByLike(slot1.curPicLikeValue)
					slot1.picForShowConfigList = slot1
					slot1.picForShowConfigList = slot1:filtePicForShowByLoadingBG(slot1.curFilteLoadingBGValue)

					slot1.filtePicForShowByLoadingBG(slot1.curFilteLoadingBGValue):sortPicConfigListForShow()
					slot1.filtePicForShowByLoadingBG(slot1.curFilteLoadingBGValue):updateCardListPanel()
				end

				triggerToggle(slot1.timeFilterToggle, false)
			end, SFX_PANEL)
		end
	end)
	slot0.timeSelectUIItemList.align(slot1, #GalleryConst.DateIndex)
end

slot0.initCardListPanel = function (slot0)
	slot0.lScrollPageSC.itemInitedCallback = function (slot0, slot1)
		slot0.cardTFList[slot0 + 1] = slot1

		slot0:cardUpdate(slot0, slot1)
	end

	slot0.lScrollPageSC.itemClickCallback = function (slot0, slot1)
		slot5, slot6 = nil
		slot6 = slot0.appreciateProxy:getPicExistStateByID(slot4)

		if slot0:getPicStateByID(slot0:getPicConfigForShowByIndex(slot2).id) == GalleryConst.CardStates.Unlocked and slot6 then
			slot0:updatePicImg(slot2)
			slot0:openPicPanel()
		end
	end

	slot0.lScrollPageSC.itemPitchCallback = function (slot0, slot1)
		slot0:setMovingTag(false)

		if slot0.curMiddleDataIndex ~= slot0 + 1 then
			slot0.curMiddleDataIndex = slot2

			slot0:saveRunData()

			if isActive(slot0.picPanel) then
				slot0:switchPicImg(slot0.curMiddleDataIndex)
			end
		end
	end

	slot0.lScrollPageSC.itemRecycleCallback = function (slot0, slot1)
		slot0.cardTFList[slot0 + 1] = nil
	end

	slot0.lScrollPageSC.itemMoveCallback = function (slot0)
		setText(slot0.progressText, math.clamp(math.round(slot0 * (#slot0.picForShowConfigList - 1)) + 1, 1, #slot0.picForShowConfigList) .. "/" .. #slot0.picForShowConfigList)
	end
end

slot0.updateCardListPanel = function (slot0)
	slot0.cardTFList = {}

	slot0.resLoader:Clear()

	if #slot0.picForShowConfigList > 0 then
		setActive(slot0.scrollPanel, true)
		setActive(slot0.emptyPanel, false)

		slot0.lScrollPageSC.DataCount = #slot0.picForShowConfigList

		slot0.lScrollPageSC:Init(slot0.curMiddleDataIndex - 1)
	else
		setActive(slot0.scrollPanel, false)
		setActive(slot0.emptyPanel, true)
	end
end

slot0.initPicPanel = function (slot0)
	onButton(slot0, slot0.picPanelBG, function ()
		slot0:closePicPanel()
	end, SFX_CANCEL)
	addSlip(SLIP_TYPE_HRZ, slot0.picImg, function ()
		triggerButton(slot0.picPreBtn)
	end, function ()
		triggerButton(slot0.picNextBtn)
	end, function ()
		slot0:emit(GalleryConst.OPEN_FULL_SCREEN_PIC_VIEW, slot0:getPicConfigForShowByIndex(slot0).id)
	end)
	onButton(slot0, slot0.picPreBtn, function ()
		if slot0.isMoving == true then
			return
		end

		slot0 = slot0.curMiddleDataIndex
		slot1 = nil

		while slot0 > 1 do
			slot5 = slot0:getPicStateByID(slot0:getPicConfigForShowByIndex(slot0).id)

			if slot0.appreciateProxy:getPicExistStateByID(slot3) and slot5 == GalleryConst.CardStates.Unlocked then
				slot1 = slot0

				break
			end
		end

		if slot1 and slot1 > 0 then
			slot0:setMovingTag(true)
			slot0.lScrollPageSC:MoveToItemID(slot1 - 1)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.picNextBtn, function ()
		if slot0.isMoving == true then
			return
		end

		slot0 = slot0.curMiddleDataIndex
		slot1 = nil

		while slot0 < #slot0.picForShowConfigList do
			slot5 = slot0:getPicStateByID(slot0:getPicConfigForShowByIndex(slot0).id)

			if slot0.appreciateProxy:getPicExistStateByID(slot3) and slot5 == GalleryConst.CardStates.Unlocked then
				slot1 = slot0

				break
			end
		end

		if slot1 and slot1 <= #slot0.picForShowConfigList then
			slot0:setMovingTag(true)
			slot0.lScrollPageSC:MoveToItemID(slot1 - 1)
		end
	end, SFX_PANEL)
	onToggle(slot0, slot0.picLikeToggle, function (slot0)
		if slot0.picLikeToggleTag == true then
			slot0.picLikeToggleTag = false

			return
		end

		slot2 = slot0:getPicConfigForShowByIndex(slot0.curMiddleDataIndex).id
		slot3 = (slot0 ~= true or 0) and 1

		if slot3 == 0 then
			if slot0.appreciateProxy:isLikedByPicID(slot2) then
				return
			else
				pg.m02:sendNotification(GAME.APPRECIATE_GALLERY_LIKE, {
					isAdd = 0,
					picID = slot2
				})
			end
		elseif slot3 == 1 then
			if slot0.appreciateProxy:isLikedByPicID(slot2) then
				function slot4()
					if slot0.curPicLikeValue == GalleryConst.Filte_Like_Value then
						slot0.picForShowConfigList = slot0:filtePicForShowByDate(slot0.curPicSelectDateValue)
						slot0.picForShowConfigList = slot0:filtePicForShowByLike(slot0.curPicLikeValue)
						slot0.picForShowConfigList = slot0:filtePicForShowByLoadingBG(slot0.curFilteLoadingBGValue)

						if slot0.curMiddleDataIndex > #slot0.picForShowConfigList then
							slot0.curMiddleDataIndex = slot0.curMiddleDataIndex - 1
						end

						slot0:updateCardListPanel()
					end
				end

				pg.m02.sendNotification(slot5, GAME.APPRECIATE_GALLERY_LIKE, {
					isAdd = 1,
					picID = slot2
				})
			else
				return
			end
		end
	end, SFX_PANEL)
end

slot0.updatePicImg = function (slot0, slot1)
	setImageSprite(slot0.picImg, LoadSprite(slot7, slot0:getPicConfigForShowByIndex(slot1 or slot0.curMiddleDataIndex).illustration))
	setText(slot0.picName, slot5)

	slot0.picLikeToggleTag = true

	triggerToggle(slot0.picLikeToggle, slot0.appreciateProxy:isLikedByPicID(slot4))
end

slot0.switchPicImg = function (slot0, slot1)
	slot5 = slot0:getPicConfigForShowByIndex(slot1 or slot0.curMiddleDataIndex).name

	setImageSprite(slot0.picBGImg, LoadSprite(slot7, slot6))

	slot0.picLikeToggleTag = true

	triggerToggle(slot0.picLikeToggle, slot8)
	LeanTween.value(go(slot0.picImg), 1, 0, 0.5):setOnUpdate(System.Action_float(function (slot0)
		setImageAlpha(slot0.picImg, slot0)
	end)).setOnComplete(slot9, System.Action(function ()
		setImageFromImage(slot0.picImg, slot0.picBGImg)
		setImageAlpha(slot0.picImg, 1)
	end))
end

slot0.openPicPanel = function (slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0.picPanel, false, {
		groupName = LayerWeightConst.GROUP_COLLECTION
	})

	slot0.picPanel.offsetMax = slot0._tf.parent.offsetMax
	slot0.picPanel.offsetMin = slot0._tf.parent.offsetMin

	setActive(slot0.picPanel, true)
	LeanTween.value(go(slot0.picTopContainer), 0, 1, 0.3):setOnUpdate(System.Action_float(function (slot0)
		setLocalScale(slot0.picTopContainer, {
			x = slot0,
			y = slot0
		})
	end)).setOnComplete(slot1, System.Action(function ()
		setLocalScale(slot0.picTopContainer, {
			x = 1,
			y = 1
		})
	end))
end

slot0.closePicPanel = function (slot0, slot1)
	if slot1 == true then
		pg.UIMgr.GetInstance():UnblurPanel(slot0.picPanel, slot0._tf)
		setActive(slot0.picPanel, false)

		return
	end

	if isActive(slot0.picPanel) then
		LeanTween.value(go(slot0.picTopContainer), 1, 0, 0.3):setOnUpdate(System.Action_float(function (slot0)
			setLocalScale(slot0.picTopContainer, {
				x = slot0,
				y = slot0
			})
		end)).setOnComplete(slot2, System.Action(function ()
			setLocalScale(slot0.picTopContainer, {
				x = 0,
				y = 0
			})
			pg.UIMgr.GetInstance():UnblurPanel(slot0.picPanel, slot0._tf)
			setActive(slot0.picPanel, false)
		end))
	end
end

slot0.setMovingTag = function (slot0, slot1)
	slot0.isMoving = slot1
end

slot0.saveRunData = function (slot0)
	slot0.appreciateProxy:updateGalleryRunData(slot0.curPicSelectDateValue, slot0.curPicSortValue, slot0.curMiddleDataIndex, slot0.curPicLikeValue, slot0.curFilteLoadingBGValue)
end

slot0.recoveryFromRunData = function (slot0)
	slot1 = slot0.appreciateProxy:getGalleryRunData()
	slot0.curPicSelectDateValue = slot1.dateValue
	slot0.curPicSortValue = slot1.sortValue
	slot0.curMiddleDataIndex = slot1.middleIndex
	slot0.curPicLikeValue = slot1.likeValue
	slot0.curFilteLoadingBGValue = slot1.bgFilteValue

	setText(slot0.progressText, slot0.curMiddleDataIndex .. "/" .. #slot0.picForShowConfigList)
	setText(slot0.timeTextSelected, slot3)

	slot0.picForShowConfigList = slot0:filtePicForShowByDate(slot0.curPicSelectDateValue)
	slot0.picForShowConfigList = slot0:filtePicForShowByLike(slot0.curPicLikeValue)
	slot0.picForShowConfigList = slot0:filtePicForShowByLoadingBG(slot0.curFilteLoadingBGValue)
	slot0.lScrollPageSC.MiddleIndexOnInit = slot0.curMiddleDataIndex - 1
	slot0.recoveryDataLikeTag = true

	triggerToggle(slot0.likeFilterToggle, slot0.curPicLikeValue == GalleryConst.Filte_Like_Value)

	slot0.recoveryDataTag = true

	triggerToggle(slot0.orderToggle, slot0.curPicSortValue == GalleryConst.Sort_Order_Down)
end

slot0.tryShowTipMsgBox = function (slot0)
	if slot0.appreciateProxy:isGalleryHaveNewRes() then
		pg.MsgboxMgr.GetInstance().ShowMsgBox(slot3, {
			hideClose = true,
			hideNo = true,
			content = i18n("res_pic_new_tip", GalleryConst.NewCount),
			onYes = function ()
				slot0.lScrollPageSC:MoveToItemID(GalleryConst.AutoScrollIndex - 1)
				PlayerPrefs.SetInt("galleryVersion", GalleryConst.Version)
				PlayerPrefs.SetInt:emit(CollectionScene.UPDATE_RED_POINT)
			end,
			onCancel = function ()
				slot0.lScrollPageSC.MoveToItemID(GalleryConst.AutoScrollIndex - 1)
				PlayerPrefs.SetInt("galleryVersion", GalleryConst.Version)
				PlayerPrefs.SetInt.emit(CollectionScene.UPDATE_RED_POINT)
			end,
			onClose = function ()
				slot0.lScrollPageSC.MoveToItemID(GalleryConst.AutoScrollIndex - 1)
				PlayerPrefs.SetInt("galleryVersion", GalleryConst.Version)
				PlayerPrefs.SetInt.emit(CollectionScene.UPDATE_RED_POINT)
			end
		})
	end
end

slot0.moveToRecMiddle = function (slot0)
	slot0.curMiddleDataIndex = slot0.appreciateProxy:getGalleryRunData().middleIndex

	slot0.lScrollPageSC:MoveToItemID(slot0.curMiddleDataIndex - 1)
end

slot0.cardUpdate = function (slot0, slot1, slot2)
	slot5 = slot0:findTF("SelectBtn", slot2)
	slot6 = slot0:findTF("BlackMask", slot2)
	slot7 = slot0:findTF("DownloadBtn", slot6)
	slot8 = slot0:findTF("LockImg", slot6)
	slot9 = slot0:findTF("TextUnlockTip", slot6)
	slot10 = slot0:findTF("UnLockBtn", slot6)

	setText(slot11, i18n("res_downloading"))
	slot0.resLoader:LoadSprite(slot15, slot14, slot3, false)
	setText(slot4, "#" .. slot12)

	slot17, slot18 = nil
	slot18 = slot0.appreciateProxy:getPicExistStateByID(slot16)

	if slot0:getPicStateByID(slot0:getPicConfigForShowByIndex(slot12).id) == GalleryConst.CardStates.DirectShow then
		print("is impossible to go to this, something wrong")

		if slot18 then
			setActive(slot5, true)
			setActive(slot6, false)
		else
			setActive(slot5, false)
			setActive(slot6, true)
			setActive(slot7, true)
			setActive(slot8, false)
			setActive(slot9, false)
			setActive(slot10, false)
			setActive(slot11, false)
		end
	elseif slot17 == GalleryConst.CardStates.Unlocked then
		if slot18 then
			setActive(slot5, slot19)
			setActive(slot6, false)
			onButton(slot0, slot5, function ()
				if strColor == green then
					if GalleryConst.RemoveBGID(GalleryConst.RemoveBGID) then
						strColor = white

						setImageColor(slot1, strColor)
					end
				elseif strColor == white and GalleryConst.AddBGID(GalleryConst.AddBGID) then
					strColor = green

					setImageColor(slot1, strColor)
				end
			end, SFX_PANEL)
		else
			setActive(slot5, false)

			if slot0.manager.state == DownloadState.None or slot19 == DownloadState.CheckFailure then
				slot0.manager:CheckD()
			end

			if slot0.manager:CheckF(GalleryConst.PIC_PATH_PREFIX .. slot20) == DownloadState.None or slot22 == DownloadState.CheckToUpdate or slot22 == DownloadState.UpdateFailure then
				setActive(slot6, true)
				setActive(slot7, true)
				setActive(slot8, false)
				setActive(slot9, false)
				setActive(slot10, false)
				setActive(slot11, false)
				table.removebyvalue(slot0.downloadCheckIDList, slot16, true)

				if #slot0.downloadCheckIDList == 0 and slot0.downloadCheckTimer then
					slot0.downloadCheckTimer:Stop()

					slot0.downloadCheckTimer = nil
				end

				onButton(slot0, slot7, function ()
					function slot0()
						setActive(setActive, true)
						setActive(setActive, false)
						setActive(false, false)
						setActive(slot3, false)
						setActive(slot4, false)
						setActive(slot5, true)
						VersionMgr.Inst:RequestUIForUpdateF("GALLERY_PIC", slot6, false)

						if not table.contains(slot7.downloadCheckIDList, slot8) then
							table.insert(slot7.downloadCheckIDList, slot8)
						end

						slot7:tryStartDownloadCheckTimer()
					end

					if Application.internetReachability == UnityEngine.NetworkReachability.ReachableViaCarrierDataNetwork then
						pg.MsgboxMgr.GetInstance().ShowMsgBox(slot1, {
							content = i18n("res_wifi_tip"),
							onYes = slot0
						})
					else
						slot0()
					end
				end, SFX_PANEL)
			elseif slot22 == DownloadState.Updating then
				setActive(slot6, true)
				setActive(slot7, false)
				setActive(slot8, false)
				setActive(slot9, false)
				setActive(slot10, false)
				setActive(slot11, true)
			elseif PathMgr.FileExists(PathMgr.getAssetBundle(slot21)) then
				slot0.appreciateProxy:updatePicFileExistStateTable(slot16, true)
				table.removebyvalue(slot0.downloadCheckIDList, slot16, true)

				if #slot0.downloadCheckIDList == 0 and slot0.downloadCheckTimer then
					slot0.downloadCheckTimer:Stop()

					slot0.downloadCheckTimer = nil
				end

				setActive(slot5, true)
				setActive(slot6, false)
			end
		end
	elseif slot17 == GalleryConst.CardStates.Unlockable then
		setActive(slot5, false)
		setActive(slot6, true)
		setActive(slot7, false)
		setActive(slot8, true)
		setActive(slot9, false)
		setActive(slot10, true)
		setActive(slot11, false)
		onButton(slot0, slot10, function ()
			if not slot0.appreciateUnlockMsgBox then
				slot0.appreciateUnlockMsgBox = AppreciateUnlockMsgBox.New(slot0._tf, slot0.event, slot0.contextData)
			end

			slot0.appreciateUnlockMsgBox:Reset()
			slot0.appreciateUnlockMsgBox.Reset.appreciateUnlockMsgBox:Load()
			slot0.appreciateUnlockMsgBox.Reset.appreciateUnlockMsgBox.Load.appreciateUnlockMsgBox:ActionInvoke("showCustomMsgBox", {
				content = i18n("res_unlock_tip"),
				items = slot0.appreciateProxy:getPicUnlockMaterialByID(slot0.appreciateUnlockMsgBox.Reset.appreciateUnlockMsgBox.Load.appreciateUnlockMsgBox),
				onYes = function ()
					pg.m02:sendNotification(GAME.APPRECIATE_GALLERY_UNLOCK, {
						picID = slot0,
						unlockCBFunc = function ()
							slot0:cardUpdate(slot0, )
							slot0.cardUpdate.appreciateUnlockMsgBox:hideCustomMsgBox()
						end
					})
				end
			})
		end, SFX_PANEL)
	elseif slot17 == GalleryConst.CardStates.DisUnlockable then
		setActive(slot5, false)
		setActive(slot6, true)
		setActive(slot7, false)
		setActive(slot8, true)
		setActive(slot9, true)
		setActive(slot10, false)
		setActive(slot11, false)
		setText(slot9, slot13.illustrate)
	end
end

slot0.getPicConfigForShowByIndex = function (slot0, slot1)
	if slot0.picForShowConfigList[slot1] then
		return slot2
	end
end

slot0.sortPicConfigListForShow = function (slot0)
	function slot1(slot0, slot1)
		if slot0.curPicSortValue == GalleryConst.Sort_Order_Up then
			if slot0.id < slot1.id then
				return true
			else
				return false
			end
		elseif slot0.curPicSortValue == GalleryConst.Sort_Order_Down then
			if slot0.id < slot1.id then
				return false
			else
				return true
			end
		end
	end

	table.sort(slot0.picForShowConfigList, slot1)
end

slot0.getPicStateByID = function (slot0, slot1)
	if not slot0.appreciateProxy:isPicNeedUnlockByID(slot1) then
		return GalleryConst.CardStates.Unlocked
	elseif slot0.appreciateProxy:isPicUnlockedByID(slot1) then
		return GalleryConst.CardStates.Unlocked
	elseif slot0.appreciateProxy:isPicUnlockableByID(slot1) then
		return GalleryConst.CardStates.Unlockable
	else
		return GalleryConst.CardStates.DisUnlockable
	end
end

slot0.filtePicForShow = function (slot0)
	slot1 = {}

	for slot5, slot6 in ipairs(pg.gallery_config.all) do
		slot7 = slot0.appreciateProxy:getSinglePicConfigByID(slot6)

		if slot0.appreciateProxy:isPicNeedUnlockByID(slot6) then
			if not slot0.appreciateProxy:isPicUnlockedByID(slot6) then
				slot10, slot11 = slot0.appreciateProxy:isPicUnlockableByID(slot6)

				if slot10 then
					slot1[#slot1 + 1] = slot7
				elseif slot11 then
					slot1[#slot1 + 1] = slot7
				end
			else
				slot1[#slot1 + 1] = slot7
			end
		else
			slot1[#slot1 + 1] = slot7
		end
	end

	return slot1
end

slot0.filtePicForShowByDate = function (slot0, slot1)
	if slot1 == GalleryConst.Data_All_Value then
		return slot0:filtePicForShow()
	end

	slot2 = {}

	for slot6, slot7 in ipairs(pg.gallery_config.all) do
		slot8 = slot0.appreciateProxy:getSinglePicConfigByID(slot7)

		if slot0.appreciateProxy:isPicNeedUnlockByID(slot7) then
			if not slot0.appreciateProxy:isPicUnlockedByID(slot7) then
				slot11, slot12 = slot0.appreciateProxy:isPicUnlockableByID(slot7)

				if slot11 then
					if slot1 == slot8.year then
						slot2[#slot2 + 1] = slot8
					end
				elseif slot12 and slot1 == slot8.year then
					slot2[#slot2 + 1] = slot8
				end
			elseif slot1 == slot8.year then
				slot2[#slot2 + 1] = slot8
			end
		elseif slot1 == slot8.year then
			slot2[#slot2 + 1] = slot8
		end
	end

	return slot2
end

slot0.filtePicForShowByLike = function (slot0, slot1)
	if slot1 == GalleryConst.Filte_Normal_Value then
		return slot0.picForShowConfigList
	end

	slot2 = {}

	for slot6, slot7 in ipairs(slot0.picForShowConfigList) do
		if slot0.appreciateProxy:isLikedByPicID(slot7.id) then
			slot2[#slot2 + 1] = slot7
		end
	end

	return slot2
end

slot0.filtePicForShowByLoadingBG = function (slot0, slot1)
	if slot1 == GalleryConst.Loading_BG_NO_Filte then
		return slot0.picForShowConfigList
	end

	slot2 = {}

	for slot6, slot7 in ipairs(slot0.picForShowConfigList) do
		if GalleryConst.IsInBGIDList(slot7.id) then
			slot2[#slot2 + 1] = slot7
		end
	end

	return slot2
end

slot0.tryStartDownloadCheckTimer = function (slot0)
	if #slot0.downloadCheckIDList == 0 and slot0.downloadCheckTimer then
		slot0.downloadCheckTimer:Stop()

		slot0.downloadCheckTimer = nil

		return
	end

	if not slot0.downloadCheckTimer and #slot0.downloadCheckIDList > 0 then
		function slot1()
			for slot3, slot4 in ipairs(slot0.downloadCheckIDList) do
				slot5 = nil

				for slot9, slot10 in ipairs(slot0.picForShowConfigList) do
					if slot10.id == slot4 then
						slot5 = slot9

						break
					end
				end

				if slot5 then
					slot0:cardUpdate(slot5 - 1, slot0.cardTFList[slot5])
				end
			end
		end

		slot0.downloadCheckTimer = Timer.New(slot1, 1, -1)

		slot0.downloadCheckTimer:Start()
	end
end

return slot0
