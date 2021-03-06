slot0 = class("IndexLayer", import("..base.BaseUI"))

slot0.getUIName = function (slot0)
	return "IndexUI"
end

slot0.panelNames = {
	{
		"indexsort_sort",
		"indexsort_sorteng"
	},
	{
		"indexsort_index",
		"indexsort_indexeng"
	},
	{
		"indexsort_camp",
		"indexsort_campeng"
	},
	{
		"indexsort_rarity",
		"indexsort_rarityeng"
	},
	{
		"indexsort_extraindex",
		"indexsort_indexeng"
	}
}

slot0.init = function (slot0)
	slot0.panel = slot0:findTF("index_panel")
	slot0.displayTFs = {
		slot0:findTF("layout/sort", slot0.panel),
		slot0:findTF("layout/index", slot0.panel),
		slot0:findTF("layout/camp", slot0.panel),
		slot0:findTF("layout/rarity", slot0.panel),
		slot0:findTF("layout/extra", slot0.panel),
		slot0:findTF("layout/EquipSkinSort", slot0.panel),
		slot0:findTF("layout/EquipSkinIndex", slot0.panel),
		slot0:findTF("layout/EquipSkinTheme", slot0.panel)
	}

	_.each(slot0.displayTFs, function (slot0)
		setActive(slot0, false)
	end)

	for slot4 = 1, #slot0.panelNames, 1 do
		setText(slot0.displayTFs[slot4].Find(slot6, "title1/Image"), i18n(slot0.panelNames[slot4][1]))
		setText(slot0.displayTFs[slot4]:Find("title1/Image_en"), i18n(slot0.panelNames[slot4][2]))
	end

	slot0.displayList = {}
	slot0.typeList = {}
	slot0.btnConfirm = slot0:findTF("layout/btns/ok", slot0.panel)
	slot0.btnCancel = slot0:findTF("layout/btns/cancel", slot0.panel)
	slot0.greySprite = slot0:findTF("resource/grey", slot0.panel):GetComponent(typeof(Image)).sprite
	slot0.blueSprite = slot0:findTF("resource/blue", slot0.panel):GetComponent(typeof(Image)).sprite
	slot0.yellowSprite = slot0:findTF("resource/yellow", slot0.panel):GetComponent(typeof(Image)).sprite
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0.btnConfirm, function ()
		if slot0.contextData.callback then
			slot0.contextData.callback({
				sort = Clone(slot0.contextData.sort),
				index = Clone(slot0.contextData.index),
				camp = Clone(slot0.contextData.camp),
				rarity = Clone(slot0.contextData.rarity),
				extra = Clone(slot0.contextData.extra),
				equipSkinSort = Clone(slot0.contextData.equipSkinSort),
				equipSkinIndex = Clone(slot0.contextData.equipSkinIndex),
				equipSkinTheme = Clone(slot0.contextData.equipSkinTheme)
			})

			slot0.contextData.callback.contextData.callback = nil
		end

		slot0:emit(slot1.ON_CLOSE)
	end, SFX_CONFIRM)
	onButton(slot0, slot0.btnCancel, function ()
		slot0:emit(slot1.ON_CLOSE)
	end, SFX_CANCEL)

	slot0.panel.localScale = Vector3.zero

	LeanTween.scale(slot0.panel, Vector3(1, 1, 1), 0.2)
	slot0.initDisplays(slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
end

slot0.initDisplays = function (slot0)
	slot1 = {
		"sort",
		"index",
		"camp",
		"rarity",
		"extra",
		"equipSkinSort",
		"equipSkinIndex",
		"equipSkinTheme"
	}

	for slot5, slot6 in ipairs(slot0.displayTFs) do
		setActive(slot6, tobool(slot0.contextData.display[slot1[slot5]]))

		if tobool(slot0.contextData.display[slot1[slot5]]) then
			if slot5 == IndexConst.DisplaySort then
				slot0:initSort()
				slot0:updateSort()
			elseif slot5 == IndexConst.DisplayIndex then
				slot0:initIndex()
				slot0:updateIndex()
			elseif slot5 == IndexConst.DisplayCamp then
				slot0:initCamp()
				slot0:updateCamp()
			elseif slot5 == IndexConst.DisplayRarity then
				slot0:initRarity()
				slot0:updateRarity()
			elseif slot5 == IndexConst.DisplayExtra then
				slot0:initExtra()
				slot0:updateExtra()
			elseif slot5 == IndexConst.DisplayEquipSkinSort then
				slot0:initEquipSkinSort()
				slot0:updateEquipSkinSort()
			elseif slot5 == IndexConst.DisplayEquipSkinIndex then
				slot0:initEquipSkinIndex()
				slot0:updateEquipSkinIndex()
			elseif slot5 == IndexConst.DisplayEquipSkinTheme then
				slot0:initEquipSkinTheme()
				slot0:updateEquipSkinTheme()
			end
		end
	end
end

slot0.initSort = function (slot0)
	_.each(IndexConst.SortTypes, function (slot0)
		if bit.band(slot0.contextData.display.sort, bit.lshift(1, slot0)) > 0 then
			table.insert(slot1, slot0)
		end
	end)

	slot0.typeList[IndexConst.DisplaySort] = {}
	slot3 = UIItemList.New(slot0.findTF(slot0, "panel", slot2), slot0:findTF("panel/tpl", slot0.displayTFs[IndexConst.DisplaySort]))

	slot3:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setText(slot6, slot5)
			setImageSprite(slot2, slot1.greySprite)
			GetOrAddComponent(slot2, typeof(Button))
			onButton(slot1, slot2, function ()
				slot0.contextData.sort = slot1

				slot0.contextData:updateSort()
			end, SFX_UI_TAG)
		end
	end)
	slot3.align(slot3, #)

	slot0.displayList[IndexConst.DisplaySort] = slot3
end

slot0.updateSort = function (slot0)
	slot2 = slot0.typeList[IndexConst.DisplaySort]

	slot0.displayList[IndexConst.DisplaySort]:each(function (slot0, slot1)
		slot3 = findTF(slot1, "Image")

		setImageSprite(slot1, (slot0.contextData.sort == slot1[slot0 + 1] and slot0.yellowSprite) or slot0.greySprite)
	end)
end

slot0.initIndex = function (slot0)
	_.each(IndexConst.IndexTypes, function (slot0)
		if bit.band(slot0.contextData.display.index, bit.lshift(1, slot0)) > 0 then
			table.insert(slot1, slot0)
		end
	end)

	slot0.typeList[IndexConst.DisplayIndex] = {}
	slot3 = UIItemList.New(slot0.findTF(slot0, "panel", slot2), slot0:findTF("panel/tpl", slot0.displayTFs[IndexConst.DisplayIndex]))

	slot3:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setText(slot6, i18n(slot5))
			setImageSprite(slot2, slot1.greySprite)
			GetOrAddComponent(slot2, typeof(Button))
			onButton(slot1, slot2, function ()
				slot0.contextData.index = IndexConst.ToggleBits(slot0.contextData.index, IndexConst.ToggleBits, IndexConst.IndexAll, )

				slot0.contextData:updateIndex()
			end, SFX_UI_TAG)
		end
	end)
	slot3.align(slot3, #)

	slot0.displayList[IndexConst.DisplayIndex] = slot3
end

slot0.updateIndex = function (slot0)
	slot2 = slot0.typeList[IndexConst.DisplayIndex]

	slot0.displayList[IndexConst.DisplayIndex]:each(function (slot0, slot1)
		slot4 = findTF(slot1, "Image")

		setImageSprite(slot1, (bit.band(slot1.contextData.index, bit.lshift(1, slot0[slot0 + 1])) > 0 and slot1.yellowSprite) or slot1.greySprite)
	end)
end

slot0.initCamp = function (slot0)
	_.each(IndexConst.CampTypes, function (slot0)
		if bit.band(slot0.contextData.display.camp, bit.lshift(1, slot0)) > 0 then
			table.insert(slot1, slot0)
		end
	end)

	slot0.typeList[IndexConst.DisplayCamp] = {}
	slot3 = UIItemList.New(slot0.findTF(slot0, "panel", slot2), slot0:findTF("panel/tpl", slot0.displayTFs[IndexConst.DisplayCamp]))

	slot3:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setText(slot6, i18n(slot5))
			setImageSprite(slot2, slot1.greySprite)
			GetOrAddComponent(slot2, typeof(Button))
			onButton(slot1, slot2, function ()
				slot0.contextData.camp = IndexConst.ToggleBits(slot0.contextData.camp, IndexConst.ToggleBits, IndexConst.CampAll, )

				slot0.contextData:updateCamp()
			end, SFX_UI_TAG)
		end
	end)
	slot3.align(slot3, #)

	slot0.displayList[IndexConst.DisplayCamp] = slot3
end

slot0.updateCamp = function (slot0)
	slot2 = slot0.typeList[IndexConst.DisplayCamp]

	slot0.displayList[IndexConst.DisplayCamp]:each(function (slot0, slot1)
		slot4 = findTF(slot1, "Image")

		setImageSprite(slot1, (bit.band(slot1.contextData.camp, bit.lshift(1, slot0[slot0 + 1])) > 0 and slot1.blueSprite) or slot1.greySprite)
	end)
end

slot0.initRarity = function (slot0)
	_.each(IndexConst.RarityTypes, function (slot0)
		if bit.band(slot0.contextData.display.rarity, bit.lshift(1, slot0)) > 0 then
			table.insert(slot1, slot0)
		end
	end)

	slot0.typeList[IndexConst.DisplayRarity] = {}
	slot3 = UIItemList.New(slot0.findTF(slot0, "panel", slot2), slot0:findTF("panel/tpl", slot0.displayTFs[IndexConst.DisplayRarity]))

	slot3:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setText(slot6, i18n(slot5))
			setImageSprite(slot2, slot1.greySprite)
			GetOrAddComponent(slot2, typeof(Button))
			onButton(slot1, slot2, function ()
				slot0.contextData.rarity = IndexConst.ToggleBits(slot0.contextData.rarity, IndexConst.ToggleBits, IndexConst.RarityAll, )

				slot0.contextData:updateRarity()
			end, SFX_UI_TAG)
		end
	end)
	slot3.align(slot3, #)

	slot0.displayList[IndexConst.DisplayRarity] = slot3
end

slot0.updateRarity = function (slot0)
	slot2 = slot0.typeList[IndexConst.DisplayRarity]

	slot0.displayList[IndexConst.DisplayRarity]:each(function (slot0, slot1)
		slot4 = findTF(slot1, "Image")

		setImageSprite(slot1, (bit.band(slot1.contextData.rarity, bit.lshift(1, slot0[slot0 + 1])) > 0 and slot1.blueSprite) or slot1.greySprite)
	end)
end

slot0.initExtra = function (slot0)
	_.each(IndexConst.ExtraTypes, function (slot0)
		if bit.band(slot0.contextData.display.extra, bit.lshift(1, slot0)) > 0 then
			table.insert(slot1, slot0)
		end
	end)

	slot0.typeList[IndexConst.DisplayExtra] = {}
	slot3 = UIItemList.New(slot0.findTF(slot0, "panel", slot2), slot0:findTF("panel/tpl", slot0.displayTFs[IndexConst.DisplayExtra]))

	slot3:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setText(slot6, i18n(slot5))
			setImageSprite(slot2, slot1.greySprite)
			GetOrAddComponent(slot2, typeof(Button))
			onButton(slot1, slot2, function ()
				slot0.contextData.extra = IndexConst.SingleToggleBits(slot0.contextData.extra, IndexConst.SingleToggleBits, IndexConst.ExtraAll, )

				slot0.contextData:updateExtra()
			end, SFX_UI_TAG)
		end
	end)
	slot3.align(slot3, #)

	slot0.displayList[IndexConst.DisplayExtra] = slot3
end

slot0.updateExtra = function (slot0)
	slot2 = slot0.typeList[IndexConst.DisplayExtra]

	slot0.displayList[IndexConst.DisplayExtra]:each(function (slot0, slot1)
		slot4 = findTF(slot1, "Image")

		setImageSprite(slot1, (bit.band(slot1.contextData.extra, bit.lshift(1, slot0[slot0 + 1])) > 0 and slot1.blueSprite) or slot1.greySprite)
	end)
end

slot0.initEquipSkinSort = function (slot0)
	_.each(IndexConst.EquipSkinSortTypes, function (slot0)
		if bit.band(slot0.contextData.display.equipSkinSort, bit.lshift(1, slot0)) > 0 then
			table.insert(slot1, slot0)
		end
	end)

	slot0.typeList[IndexConst.DisplayEquipSkinSort] = {}
	slot3 = UIItemList.New(slot0.findTF(slot0, "panel", slot2), slot0:findTF("panel/tpl", slot0.displayTFs[IndexConst.DisplayEquipSkinSort]))

	slot3:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setText(slot6, slot5)
			setImageSprite(slot2, slot1.greySprite)
			GetOrAddComponent(slot2, typeof(Button))
			onButton(slot1, slot2, function ()
				slot0.contextData.equipSkinSort = slot1

				slot0.contextData:updateEquipSkinSort()
			end, SFX_UI_TAG)
		end
	end)
	slot3.align(slot3, #)

	slot0.displayList[IndexConst.DisplayEquipSkinSort] = slot3
end

slot0.updateEquipSkinSort = function (slot0)
	slot2 = slot0.typeList[IndexConst.DisplayEquipSkinSort]

	slot0.displayList[IndexConst.DisplayEquipSkinSort]:each(function (slot0, slot1)
		slot3 = findTF(slot1, "Image")

		setImageSprite(slot1, (slot0.contextData.equipSkinSort == slot1[slot0 + 1] and slot0.yellowSprite) or slot0.greySprite)
	end)
end

slot0.initEquipSkinIndex = function (slot0)
	_.each(IndexConst.EquipSkinIndexTypes, function (slot0)
		if bit.band(slot0.contextData.display.equipSkinIndex, bit.lshift(1, slot0)) > 0 then
			table.insert(slot1, slot0)
		end
	end)

	slot0.typeList[IndexConst.DisplayEquipSkinIndex] = {}
	slot3 = UIItemList.New(slot0.findTF(slot0, "panel", slot2), slot0:findTF("panel/tpl", slot0.displayTFs[IndexConst.DisplayEquipSkinIndex]))

	slot3:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setText(slot6, slot5)
			setImageSprite(slot2, slot1.greySprite)
			GetOrAddComponent(slot2, typeof(Button))
			onButton(slot1, slot2, function ()
				slot0.contextData.equipSkinIndex = IndexConst.ToggleBits(slot0.contextData.equipSkinIndex, IndexConst.ToggleBits, IndexConst.EquipSkinIndexAll, )

				slot0.contextData:updateEquipSkinIndex()
			end, SFX_UI_TAG)
		end
	end)
	slot3.align(slot3, #)

	slot0.displayList[IndexConst.DisplayEquipSkinIndex] = slot3
end

slot0.updateEquipSkinIndex = function (slot0)
	slot2 = slot0.typeList[IndexConst.DisplayEquipSkinIndex]

	slot0.displayList[IndexConst.DisplayEquipSkinIndex]:each(function (slot0, slot1)
		slot4 = findTF(slot1, "Image")

		setImageSprite(slot1, (bit.band(slot1.contextData.equipSkinIndex, bit.lshift(1, slot0[slot0 + 1])) > 0 and slot1.yellowSprite) or slot1.greySprite)
	end)
end

slot0.initEquipSkinTheme = function (slot0)
	_.each(IndexConst.EquipSkinThemeTypes, function (slot0)
		if bit.band(slot0.contextData.display.equipSkinTheme, bit.lshift(1, slot0)) > 0 then
			table.insert(slot1, slot0)
		end
	end)

	slot0.typeList[IndexConst.DisplayEquipSkinTheme] = {}
	slot3 = UIItemList.New(slot0.findTF(slot0, "bg/panel", slot2), slot0:findTF("bg/panel/tpl", slot0.displayTFs[IndexConst.DisplayEquipSkinTheme]))

	slot3:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setText(slot6, slot5)
			setImageSprite(slot2, slot1.greySprite)
			GetOrAddComponent(slot2, typeof(Button))
			onButton(slot1, slot2, function ()
				slot0.contextData.equipSkinTheme = IndexConst.ToggleBits(slot0.contextData.equipSkinTheme, IndexConst.ToggleBits, IndexConst.EquipSkinThemeAll, )

				slot0.contextData:updateEquipSkinTheme()
			end, SFX_UI_TAG)
		end
	end)
	slot3.align(slot3, #)

	slot0.displayList[IndexConst.DisplayEquipSkinTheme] = slot3
end

slot0.updateEquipSkinTheme = function (slot0)
	slot2 = slot0.typeList[IndexConst.DisplayEquipSkinTheme]

	slot0.displayList[IndexConst.DisplayEquipSkinTheme]:each(function (slot0, slot1)
		slot4 = findTF(slot1, "Image")

		setImageSprite(slot1, (bit.band(slot1.contextData.equipSkinTheme, bit.lshift(1, slot0[slot0 + 1])) > 0 and slot1.yellowSprite) or slot1.greySprite)
	end)
end

slot0.willExit = function (slot0)
	LeanTween.cancel(go(slot0.panel))
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf)
end

return slot0
