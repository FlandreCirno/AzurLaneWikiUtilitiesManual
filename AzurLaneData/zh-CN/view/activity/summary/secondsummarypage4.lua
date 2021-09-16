slot0 = class("SecondSummaryPage4", import(".SummaryAnimationPage"))
slot0.PerPageCount = 6
slot0.PageTypeFurniture = 1
slot0.PageTypeIconFrame = 2

slot0.OnInit = function (slot0)
	setActive(slot0._tf:Find("tip"), slot0.summaryInfoVO.pageType == slot0.PageTypeFurniture)
	setActive(slot0._tf:Find("tip_2"), slot1 == slot0.PageTypeIconFrame)

	slot2 = nil

	if slot1 == slot0.PageTypeFurniture then
		slot2 = slot0.summaryInfoVO.activityVO:getConfig("config_data")
	elseif slot1 == slot0.PageTypeIconFrame then
		slot2 = slot0.summaryInfoVO.activityVO:getConfig("config_client")
	end

	slot3 = {}

	for slot8 = slot0.PerPageCount * (slot0.summaryInfoVO.samePage - 1) + 1, math.min((slot0.PerPageCount * (slot0.summaryInfoVO.samePage - 1) + 1 + slot0.PerPageCount) - 1, #slot2), 1 do
		table.insert(slot3, slot2[slot8])
	end

	slot5 = UIItemList.New(slot0._tf:Find("scroll_rect/content"), slot0._tf:Find("scroll_rect/content/item_tpl"))

	slot5:make(function (slot0, slot1, slot2)
		slot3 = slot1 + 1

		if slot0 == UIItemList.EventUpdate then
			setActive(slot2:Find("icon/Image"), slot0 == slot1.PageTypeFurniture)
			setActive(slot2:Find("icon/frame"), slot0 == slot1.PageTypeIconFrame)
			setActive(slot2:Find("date"), slot0 == slot1.PageTypeFurniture)

			if slot2.summaryInfoVO.pageType == slot1.PageTypeFurniture then
				GetImageSpriteFromAtlasAsync("furnitureicon/" .. pg.furniture_data_template[slot3[slot3]].icon, "", slot2:Find("icon/Image"), true)
				setGray(slot2:Find("icon"), not slot2.summaryInfoVO.furnitures[slot3[slot3]])
				setText(slot2:Find("name/Text"), HXSet.hxLan(pg.furniture_data_template[slot3[slot3]].name))
				setGray(slot2:Find("name"), not slot2.summaryInfoVO.furnitures[slot3[slot3]])
				setText(slot2:Find("from/Text"), pg.furniture_data_template[slot3[slot3]].gain_by)
				setText(slot2:Find("date/Text"), (slot2.summaryInfoVO.furnitures[slot3[slot3]] and slot5:getDate()) or i18n("summary_page_un_rearch"))
			elseif slot2.summaryInfoVO.pageType == slot1.PageTypeIconFrame then
				slot9, slot11 = unpack(slot3[slot3])
				slot6 = getProxy(AttireProxy):getAttireFrame(AttireConst.TYPE_ICON_FRAME, slot4)

				setLocalScale(slot2:Find("icon/frame"), Vector3(slot5, slot5, slot5))
				PoolMgr.GetInstance():GetPrefab(slot6:getIcon(), slot6:getConfig("id"), true, function (slot0)
					setParent(slot0, slot0:Find("icon/frame"), false)
					setGray(slot0:Find("icon"), not slot1)
				end)
				setText(slot2.Find(slot2, "name/Text"), HXSet.hxLan(slot6:getConfig("name")))
				setGray(slot2:Find("name"), not slot6:isOwned())
				setText(slot2:Find("from/Text"), slot6:getConfig("gain_by"))
			end
		end
	end)
	slot5.align(slot5, #slot3)
end

return slot0
