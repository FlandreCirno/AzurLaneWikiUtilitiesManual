slot1 = class("MapBuilderEscort", import(".MapBuilder"))

slot1.GetType = function (slot0)
	return slot0.TYPEESCORT
end

slot1.getUIName = function (slot0)
	return "escort_levels"
end

slot1.OnInit = function (slot0)
	slot0.tpl = slot0._tf:Find("escort_level_tpl")
	slot0.itemHolder = slot0._tf:Find("items")
end

slot1.Update = function (slot0, slot1)
	slot0.map.pivot = Vector2(0.5, 0.5)
	slot0.float.pivot = Vector2(0.5, 0.5)
	slot4 = 1

	if slot0.map.rect.width / slot0.map.rect.height < slot0._parentTf.rect.width / slot0._parentTf.rect.height then
		slot0._tf.localScale = Vector3(slot0._parentTf.rect.width / 1280, , 1)
	else
		slot0._tf.localScale = Vector3(slot0._parentTf.rect.height / 720, , 1)
	end

	slot0.scaleRatio = slot4

	setText(slot0.sceneParent.chapterName, string.split(slot1:getConfig("name"), "||")[1])
	slot0.sceneParent.loader:GetSprite("chapterno", "chapterex", slot0.sceneParent.chapterNoTitle, true)
	slot0.super.Update(slot0, slot1)
end

slot1.UpdateButtons = function (slot0)
	slot0.sceneParent:updateDifficultyBtns()
	slot0.sceneParent:updateActivityBtns()
end

slot1.UpdateEscortInfo = function (slot0)
	slot1 = getProxy(ChapterProxy)

	setText(slot0.sceneParent.escortBar:Find("times/text"), slot1:getMaxEscortChallengeTimes() - slot1.escortChallengeTimes .. "/" .. slot2)
	onButton(slot0.sceneParent, slot0.sceneParent.mapHelpBtn, function ()
		slot0:InvokeParent("HandleShowMsgBox", {
			type = MSGBOX_TYPE_HELP,
			helps = i18n("levelScene_escort_help_tip")
		})
	end, SFX_PANEL)
end

slot1.UpdateMapItems = function (slot0)
	slot0.super.UpdateMapItems(slot0)
	slot0:UpdateEscortInfo()
	setActive(slot0.sceneParent.escortBar, true)
	setActive(slot0.sceneParent.mapHelpBtn, true)

	slot2 = getProxy(ChapterProxy)
	slot3 = getProxy(ChapterProxy):getEscortChapterIds()

	UIItemList.New(slot0.itemHolder, slot0.tpl).make(slot5, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot0:UpdateEscortItem(slot2, slot1[slot1 + 1].id, slot1[slot1 + 1])
		end
	end)
	UIItemList.New(slot0.itemHolder, slot0.tpl).align(slot5, #_.filter(slot0.data.getChapters(slot1), function (slot0)
		return table.contains(slot0, slot0.id)
	end))
end

slot1.UpdateEscortItem = function (slot0, slot1, slot2, slot3)
	slot1.name = "chapter_" .. slot3.id
	slot1.anchoredPosition = Vector2(slot0.map.rect.width / slot0.scaleRatio * (tonumber(pg.escort_template[slot2].pos_x) - 0.5), slot0.map.rect.height / slot0.scaleRatio * (tonumber(pg.escort_template[slot2].pos_y) - 0.5))

	setActive(slot1:Find("fighting"), getProxy(ChapterProxy):getActiveChapter() and slot5.id == slot3.id)
	slot0:DeleteTween("fighting" .. slot3.id)

	if slot8 then
		setImageAlpha(slot7, 1)
		slot0:RecordTween("fighting" .. slot3.id, LeanTween.alpha(slot7, 0, 0.5):setEase(LeanTweenType.easeInOutSine):setLoopPingPong().uniqueId)
	end

	GetImageSpriteFromAtlasAsync("levelmap/mapquad/" .. slot4.pic, "", slot1, true)

	slot9 = slot1:Find("anim")
	slot13 = ({
		Color.green,
		Color.yellow,
		Color.red
	})[table.indexof(slot10, slot2) or 1]

	for slot18 = 0, slot9:GetComponentsInChildren(typeof(Image)).Length - 1, 1 do
		slot14[slot18].color = slot13
	end

	setImageColor(slot1, slot13)

	slot15 = slot3.id

	onButton(slot0.sceneParent, slot1, function ()
		getProxy(ChapterProxy):InvokeParent("TrySwitchChapter", getProxy(ChapterProxy):getChapterById(getProxy(ChapterProxy).getChapterById))
	end, SFX_PANEL)
end

slot1.OnShow = function (slot0)
	setActive(slot0.sceneParent.mainLayer:Find("title_chapter_lines"), true)
	setActive(slot0.sceneParent.topChapter:Find("title_chapter"), true)
	setActive(slot0.sceneParent.topChapter:Find("type_escort"), true)
end

slot1.OnHide = function (slot0)
	setActive(slot0.sceneParent.mainLayer:Find("title_chapter_lines"), false)
	setActive(slot0.sceneParent.topChapter:Find("title_chapter"), false)
	setActive(slot0.sceneParent.topChapter:Find("type_escort"), false)
	setActive(slot0.sceneParent.escortBar, false)
	setActive(slot0.sceneParent.mapHelpBtn, false)
end

return slot1
