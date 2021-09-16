slot0 = class("BackYardThemeTemplateDescPage", import("....base.BaseSubView"))
slot1 = 1
slot2 = 2
slot3 = 3
slot4 = {
	{
		"text_desc",
		"text_allin"
	},
	{
		"text_delete",
		"text_upload",
		"text_cancel_upload"
	},
	{
		"text_desc",
		"text_allin"
	}
}

function slot5(slot0)
	return slot0[slot0]
end

slot0.getUIName = function (slot0)
	return "BackYardThemeTemplateDescPage"
end

slot0.ThemeTemplateUpdate = function (slot0, slot1)
	if slot0.template and slot0.template.id == slot1.id then
		slot0.template = slot1

		slot0:Flush()
	end
end

slot0.UpdateDorm = function (slot0, slot1)
	slot0.dorm = slot1
end

slot0.PlayerUpdated = function (slot0, slot1)
	slot0.player = slot1
end

slot0.OnLoaded = function (slot0)
	slot0.icon = slot0:findTF("icon/icon"):GetComponent(typeof(Image))
	slot0.idTxt = slot0:findTF("ID"):GetComponent(typeof(Text))
	slot0.idLabel = slot0:findTF("ID_label"):GetComponent(typeof(Text))
	slot0.copyBtn = slot0:findTF("copy")
	slot0.nameTxt = slot0:findTF("name/Text"):GetComponent(typeof(Text))
	slot0.sortBtn = slot0:findTF("sort")
	slot0.sortArr = slot0:findTF("sort/arr")
	slot0.sortTxt = slot0:findTF("sort/Text"):GetComponent(typeof(Text))
	slot0.filterBtn = slot0:findTF("filter")
	slot0.filterTxt = slot0:findTF("filter/Text"):GetComponent(typeof(Text))

	setActive(slot0.sortBtn, false)
	setActive(slot0.filterBtn, false)

	slot0.mainPanel = slot0:findTF("main")
	slot0.timeTxt = slot0.mainPanel:Find("time"):GetComponent(typeof(Text))
	slot0.btn1 = slot0.mainPanel:Find("desc_btn")
	slot0.btn1Txt = slot0.mainPanel:Find("desc_btn/btn_word2"):GetComponent(typeof(Image))
	slot0.btn2 = slot0.mainPanel:Find("push_btn")
	slot0.btn2Txt = slot0.mainPanel:Find("push_btn/btn_word1"):GetComponent(typeof(Image))
	slot0.heart = slot0.mainPanel:Find("heart")
	slot0.heartSel = slot0.mainPanel:Find("heart/sel")
	slot0.heartTxt = slot0.mainPanel:Find("heart/Text"):GetComponent(typeof(Text))
	slot0.collection = slot0.mainPanel:Find("collection")
	slot0.collectionSel = slot0.mainPanel:Find("collection/sel")
	slot0.collectionTxt = slot0.mainPanel:Find("collection/Text"):GetComponent(typeof(Text))
	slot0.label1 = slot0.mainPanel:Find("search1"):GetComponent(typeof(Text))

	setActive(slot0.label1.gameObject, false)

	slot0.contextData.sortPage.OnChange = function (slot0)
		slot0.filterTxt.text = slot0
	end

	slot0.idLabel.text = i18n("word_theme") .. "ID:"
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0.copyBtn, function ()
		if slot0.player then
			UniPasteBoard.SetClipBoardString(slot0.template.id)
			pg.TipsMgr.GetInstance():ShowTips(i18n("friend_id_copy_ok"))
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.filterBtn, function ()
		slot0.contextData.sortPage:ExecuteAction("SetUp")
	end, SFX_PANEL)
end

slot0.SetUp = function (slot0, slot1, slot2, slot3, slot4)
	slot0.pageType = slot1
	slot0.template = slot2
	slot0.dorm = slot3
	slot0.player = slot4

	slot0:RefreshSortBtn()
	slot0:Flush()
	slot0:Show()
end

slot0.RefreshSortBtn = function (slot0)
	slot1, slot2 = nil

	if slot0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		slot1, slot2 = BackYardConst.ServerIndex2ThemeSortIndex(getProxy(DormProxy).TYPE)
	else
		slot2 = true
		slot1 = 1
	end

	slot0.filterTxt.text = BackYardThemeTemplateSortPanel.GetChineseByIndex(slot1)

	function slot4(slot0)
		slot0.sortArr.localScale = Vector3(1, (slot0 and 1) or -1, 1)
		slot0.sortTxt.text = (slot0 and i18n("word_asc")) or i18n("word_desc")
	end

	slot0.sortFlag = slot2

	onButton(slot0, slot0.sortBtn, function ()
		slot0.sortFlag = not slot0.sortFlag

		not slot0.sortFlag(slot0.sortFlag)

		if not slot0.sortFlag.OnSortChange then
			slot0.OnSortChange(slot0.sortFlag)
		end
	end, SFX_PANEL)
	slot4(slot0.sortFlag)
end

slot0.Flush = function (slot0)
	slot0:UpdateWindow()
	slot0:UpdatePlayer()
	slot0:UpdateLikeInfo()
	slot0["Update" .. slot0.pageType](slot0)
end

slot0.Update1 = function (slot0)
	onButton(slot0, slot0.btn1, function ()
		slot0.contextData.infoPage:ExecuteAction("SetUp", slot0.template, slot0.dorm, slot0.player)
	end, SFX_PANEL)
	onButton(slot0, slot0.btn2, function ()
		slot0.contextData.msgBox:ExecuteAction("SetUp", {
			type = BackYardThemeTemplateMsgBox.TYPE_IMAGE,
			content = i18n("backyard_theme_apply_tip2"),
			srpiteName = slot0.template:GetTextureIconName(),
			md5 = slot0.template:GetIconMd5(),
			onYes = function ()
				slot0:emit(NewBackYardThemeTemplateMediator.ON_APPLY_TEMPLATE, slot0.template, function ()
					triggerButton(slot0.btn1)
				end)
			end
		})
	end, SFX_PANEL)
end

slot0.Update2 = function (slot0)
	onButton(slot0, slot0.btn1, function ()
		slot0:emit(NewBackYardThemeTemplateMediator.ON_DELETE_TEMPLATE, slot0)
	end, SFX_PANEL)
	onButton(slot0, slot0.btn2, function ()
		if slot0 then
			slot1:emit(NewBackYardThemeTemplateMediator.ON_CANCEL_UPLOAD_TEMPLATE, )
		else
			slot1:emit(NewBackYardThemeTemplateMediator.ON_UPLOAD_TEMPLATE, )
		end
	end, SFX_PANEL)

	if not slot0.template.IsPushed(slot1) then
		slot0.timeTxt.text = i18n("backyard_theme_upload_cnt", getProxy(DormProxy).GetUploadThemeTemplateCnt(slot3), BackYardConst.MAX_UPLOAD_THEME_CNT)
	end
end

slot0.Update3 = function (slot0)
	slot0:Update1()

	slot0.timeTxt.text = i18n("backyard_theme_template_collection_cnt") .. getProxy(DormProxy):GetThemeTemplateCollectionCnt() .. "/" .. BackYardConst.MAX_COLLECTION_CNT
end

slot0.UpdatePlayer = function (slot0)
	if not slot0.template:ExistPlayerInfo() then
		slot0:emit(NewBackYardThemeTemplateMediator.GET_TEMPLATE_PLAYERINFO, slot0.pageType, slot0.template)
	else
		slot0.player = slot0.template.player
		slot0.nameTxt.text = slot0.template.player.name
		slot0.idTxt.text = slot0.template.id
		slot0.timeTxt.text = i18n("backyard_theme_upload_time") .. slot0.template:GetUploadTime()

		LoadSpriteAsync("qicon/" .. slot0.template.player:getPainting(), function (slot0)
			if IsNil(slot0.icon) then
				return
			end

			slot0.icon.sprite = slot0
		end)

		if slot0.preLoadIcon then
			PoolMgr.GetInstance().ReturnPrefab(slot3, "IconFrame/" .. slot2, slot0.preLoadIcon.name, slot0.preLoadIcon)
		end

		PoolMgr.GetInstance():GetPrefab("IconFrame/" .. slot2, slot2, true, function (slot0)
			if slot0.icon then
				slot0.name = slot1
				findTF(slot0.transform, "icon").GetComponent(slot1, typeof(Image)).raycastTarget = false

				setParent(slot0, slot0.icon.gameObject, false)

				slot0.preLoadIcon = slot0
			end
		end)
		onButton(slot0, slot0.icon, function ()
			if slot0.id == getProxy(PlayerProxy):getRawData().id then
				return
			end

			slot1:emit(NewBackYardThemeTemplateMediator.ON_DISPLAY_PLAYER_INFO, slot0.id, tf(slot1.icon.gameObject).position, slot1.template.id)
		end, SFX_PANEL)
	end
end

slot0.UpdateLikeInfo = function (slot0)
	slot0.heartTxt.text = i18n("backyard_theme_word_like") .. slot0.template.GetLikeCnt(slot1)
	slot0.collectionTxt.text = i18n("backyard_theme_word_collection") .. slot0.template:GetCollectionCnt()
	slot2 = slot0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM

	onButton(slot0, slot0.heart, function ()
		if slot0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
			return
		end

		if not slot1 then
			slot0:emit(NewBackYardThemeTemplateMediator.ON_LIKE_THEME, slot0.template, slot0.template.time)
		end
	end, SFX_PANEL)
	setActive(slot0.heartSel, slot1:IsLiked() or slot2)
	onButton(slot0, slot0.collection, function ()
		if slot0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
			return
		end

		if slot1 then
			slot0.contextData.msgBox:ExecuteAction("SetUp", {
				content = i18n("backyard_theme_cancel_collection"),
				onYes = function ()
					slot0:emit(NewBackYardThemeTemplateMediator.ON_COLECT_THEME, slot0.template, true, slot0.template.time)
				end
			})
		else
			slot0.emit(slot0, NewBackYardThemeTemplateMediator.ON_COLECT_THEME, slot0.template, false, slot0.template.time)
		end
	end, SFX_PANEL)
	setActive(slot0.collectionSel, slot1:IsCollected() or slot2)
end

slot0.UpdateWindow = function (slot0)
	function slot1(slot0)
		slot1 = -224
		slot2 = -314
		slot3 = 0
		slot4 = 0

		if slot0 == slot0 then
			slot4 = 338
			slot3 = 580
		elseif slot0 == slot1 then
			slot4 = 265
			slot3 = 505
			slot1 = -153
			slot2 = -230
		elseif slot0 == slot2 then
			slot4 = 196
			slot3 = 436
			slot1 = -145
			slot2 = -237
		end

		setAnchoredPosition(slot3.btn1, {
			y = slot1
		})
		setAnchoredPosition(slot3.btn2, {
			y = slot1
		})

		slot3._tf.sizeDelta = Vector2(slot3._tf.sizeDelta.x, slot3)
		slot3.mainPanel.sizeDelta = Vector2(slot3.mainPanel.sizeDelta.x, slot4)

		setActive(slot3.heart, slot0 ~= slot2)
		setActive(slot3.collection, slot0 ~= slot2)
		setAnchoredPosition(slot3.heart, {
			y = slot2
		})
		setAnchoredPosition(slot3.collection, {
			y = slot2
		})
	end

	slot2, slot4 = nil
	slot4 = slot3(slot0.pageType)

	if slot0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_CUSTOM then
		slot1((slot0.template.IsPushed(slot5) and slot1) or slot2)

		slot2 = slot4[1]
		slot3 = (((slot0.template.IsPushed(slot5) and slot1) or slot2) == slot1 and slot4[3]) or slot4[2]
	elseif slot0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_COLLECTION then
		slot1(slot1)

		slot2 = slot4[1]
		slot3 = slot4[2]
	elseif slot0.pageType == BackYardConst.THEME_TEMPLATE_TYPE_SHOP then
		slot1(slot1)

		slot2 = slot4[1]
		slot3 = slot4[2]
	end

	slot0.btn1Txt.sprite = GetSpriteFromAtlas("ui/NewBackYardShopUI_atlas", slot2)

	slot0.btn1Txt:SetNativeSize()

	slot0.btn2Txt.sprite = GetSpriteFromAtlas("ui/NewBackYardShopUI_atlas", slot3)

	slot0.btn2Txt:SetNativeSize()
end

slot0.Show = function (slot0)
	slot0.super.Show(slot0)
	slot0._tf:SetSiblingIndex(3)
end

slot0.OnDestroy = function (slot0)
	slot0.contextData.sortPage.OnChange = nil

	if slot0.preLoadIcon then
		PoolMgr.GetInstance():ReturnPrefab("IconFrame/" .. slot1, slot0.preLoadIcon.name, slot0.preLoadIcon)
	end
end

return slot0
