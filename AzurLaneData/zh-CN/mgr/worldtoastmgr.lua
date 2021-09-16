pg = pg or {}
pg.WorldToastMgr = singletonClass("WorldToastMgr")
pg.WorldToastMgr.Type2PictrueName = {
	[0] = "type_operation",
	"type_fight",
	"type_search",
	"type_build",
	"type_defience",
	"type_special"
}

pg.WorldToastMgr.Init = function (slot0, slot1)
	PoolMgr.GetInstance():GetUI("WorldTaskFloatUI", true, function (slot0)
		slot0._go = slot0

		slot0._go:SetActive(false)

		slot0._tf = slot0._go.transform

		slot0._tf:SetParent(pg.UIMgr.GetInstance().OverlayToast, false)

		slot0.displayList = {}

		if slot0 then
			slot1()
		end
	end)
end

pg.WorldToastMgr.ShowToast = function (slot0, slot1, slot2)
	table.insert(slot0.displayList, {
		taskVO = slot1,
		isSubmitDone = slot2
	})

	if #slot0.displayList == 1 then
		slot0:StartToast()
	end
end

pg.WorldToastMgr.StartToast = function (slot0)
	setAnchoredPosition(slot0._tf, {
		y = slot0._tf.rect.height
	})
	setActive(slot0._tf, true)
	setActive(slot0._tf:Find("accept_info"), not slot0.displayList[1].isSubmitDone)
	setActive(slot0._tf:Find("submit_info"), slot0.displayList[1].isSubmitDone)
	GetImageSpriteFromAtlasAsync("ui/worldtaskfloatui_atlas", slot0.Type2PictrueName[slot0.displayList[1].taskVO.config.type], slot0._tf:Find("type_icon"), true)
	setText(slot0._tf:Find("desc"), setColorStr(shortenString(HXSet.hxLan(slot0.displayList[1].taskVO.config.name), 12), (slot0.displayList[1].isSubmitDone and COLOR_GREEN) or COLOR_WHITE))
	table.insert(setText, function (slot0)
		slot0.twId = LeanTween.moveY(slot0._tf, 0, 0.5):setOnComplete(System.Action(slot0))
	end)
	table.insert(slot3, function (slot0)
		slot0.twId = LeanTween.moveY(slot0._tf, slot0._tf.rect.height, 0.5):setDelay(3):setOnComplete(System.Action(slot0))
	end)
	seriesAsync(slot3, function ()
		table.remove(slot0.displayList, 1)

		if #table.remove.displayList > 0 then
			slot0:StartToast()
		else
			setActive(slot0._tf, false)
		end
	end)
end

pg.WorldToastMgr.Dispose = function (slot0)
	LeanTween.cancel(slot0.twId)

	slot0.displayList = nil

	PoolMgr.GetInstance():ReturnUI("WorldTaskFloatUI", slot0._go)
end

return
