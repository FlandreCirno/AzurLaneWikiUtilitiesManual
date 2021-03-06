slot0 = class("HoloLivePtPage", import(".TemplatePage.PtTemplatePage"))

slot0.OnInit = function (slot0)
	slot0.super.OnInit(slot0)

	slot0.charImg = slot0:findTF("charImg", slot0.bg)
	slot0.numImg = slot0:findTF("numImg", slot0.bg)
	slot0.chapterImg = slot0:findTF("chapterImg", slot0.bg)
	slot0.spineCharContainer = slot0:findTF("SpineChar", slot0.bg)
	slot0.scrollTextMask = slot0:findTF("ScrollText", slot0.bg)
	slot0.scrollTextContainer = slot0:findTF("ScrollText/TextList", slot0.bg)
	slot0.scrollTextTpl = slot0:findTF("TextTpl", slot0.bg)
end

slot0.OnDataSetting = function (slot0)
	slot0.super.OnDataSetting(slot0)

	slot0.ptCount = slot0.ptData:GetResProgress()
	slot0.ptRank = pg.activity_event_pt[slot0.activity.id].pt_list
	slot0.picNameList = pg.activity_event_pt[slot0.activity.id].pic_list
end

slot0.OnFirstFlush = function (slot0)
	slot0.super.OnFirstFlush(slot0)
	slot0:initScrollTextList()

	if math.floor(slot0.ptCount / (slot0.ptRank[2] - slot0.ptRank[1])) + 1 > #slot0.picNameList then
		slot2 = #slot0.picNameList
	end

	LoadSpriteAtlasAsync("ui/activityuipage/hololiveptpage", slot3, function (slot0)
		setImageSprite(slot0.charImg, slot0)
	end)
	LoadSpriteAtlasAsync("ui/activityuipage/hololiveptpage", "#" .. slot2, function (slot0)
		setImageSprite(slot0.numImg, slot0)
	end)
	LoadSpriteAtlasAsync("ui/activityuipage/hololiveptpage", "jiaobiao_" .. slot2, function (slot0)
		setImageSprite(slot0.chapterImg, slot0)
	end)
	pg.UIMgr.GetInstance().LoadingOn(slot5)
	PoolMgr.GetInstance():GetSpineChar("vtuber_shion", true, function (slot0)
		pg.UIMgr.GetInstance():LoadingOff()

		slot0.prefab = slot0
		slot0.model = slot0
		tf(slot0).localScale = Vector3(1, 1, 1)

		slot0:GetComponent("SpineAnimUI"):SetAction("stand", 0)
		setParent(slot0, slot0.spineCharContainer)
	end)
end

slot0.OnDestroy = function (slot0)
	if slot0.scrollTextTimer then
		slot0.scrollTextTimer:Stop()

		slot0.scrollTextTimer = nil
	end

	if slot0.prefab and slot0.model then
		PoolMgr.GetInstance():ReturnSpineChar(slot0.prefab, slot0.model)

		slot0.prefab = nil
		slot0.model = nil
	end
end

slot0.initScrollTextList = function (slot0)
	setText(slot0.scrollTextTpl, slot0.activity:getConfig("config_client").scrollStr)

	slot6 = slot0.scrollTextContainer.localPosition.x - (GetComponent(slot0.scrollTextTpl, "Text").preferredWidth + slot0.scrollTextMask.rect.width + 50)
	slot7 = 50
	slot8 = 0.016666666666666666

	UIItemList.New(slot0.scrollTextContainer, slot0.scrollTextTpl).align(slot9, 2)

	slot10 = slot0.scrollTextContainer:GetChild(1)
	slot0.scrollTextTimer = Timer.New(function ()
		if slot0.scrollTextContainer.localPosition.x - slot1 * slot2 <= slot3 then
			slot0 = slot4.localPosition.x + slot0.scrollTextContainer.localPosition.x
		end

		slot0.scrollTextContainer.localPosition = Vector3(slot0, 0, 0)
	end, slot8, -1, true)

	slot0.scrollTextTimer:Start()
end

return slot0
