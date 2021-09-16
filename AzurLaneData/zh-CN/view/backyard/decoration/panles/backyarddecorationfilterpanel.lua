slot0 = class("BackYardDecorationFilterPanel", import("....base.BaseSubView"))
slot0.SORT_MODE = {
	BY_DEFAULT = 1,
	BY_CONFIG = 3,
	BY_FUNC = 2
}
slot0.SORT_TAG = {
	{
		{
			1,
			"default"
		},
		i18n("backyard_sort_tag_default")
	},
	{
		{
			2,
			"sortPriceFunc"
		},
		i18n("backyard_sort_tag_price")
	},
	{
		{
			3,
			"comfortable"
		},
		i18n("backyard_sort_tag_comfortable")
	},
	{
		{
			2,
			"sortSizeFunc"
		},
		i18n("backyard_sort_tag_size")
	}
}
slot0.ORDER_MODE_ASC = 1
slot0.ORDER_MODE_DASC = 2

slot0.getUIName = function (slot0)
	return "BackYardIndexUI"
end

slot0.Ctor = function (slot0, slot1, slot2, slot3)
	slot0.super.Ctor(slot0, slot1, slot2, slot3)

	slot0.filterConfig = pg.backyard_theme_template
	slot0.sortData = slot0.SORT_TAG[1][1]
	slot0.sortTxt = slot0.SORT_TAG[1][2]
	slot0.filterData = _.select(slot0.filterConfig.all, function (slot0)
		return slot0.filterConfig[slot0].is_view == 1
	end)
	slot0.themes = slot0.GetThemes(slot0)
end

slot0.OnLoaded = function (slot0)
	slot0.sortTpl = slot0:findTF("bg/sort_tpl")
	slot0.filterTpl = slot0:findTF("bg/filter_tpl")
	slot0.sortContainer = slot0:findTF("bg/frame/sorts/sort_container")
	slot0.filterContainer = slot0:findTF("bg/frame/filters/rect_view/conent/theme_panel")
	slot0.selectedAllBtn = slot0:findTF("bg/frame/filters/rect_view/conent/all_panel/sort_tpl")
end

slot0.setFilterData = function (slot0, slot1)
	slot0.furnitures = slot1 or {}
end

slot0.GetFilterData = function (slot0)
	return slot0.furnitures
end

slot0.SetDorm = function (slot0, slot1)
	slot0.dorm = slot1
end

slot0.updateOrderMode = function (slot0, slot1)
	slot0.orderMode = slot1 or slot0.ORDER_MODE_ASC
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0:findTF("bg/frame/confirm_btn"), function ()
		slot0:filter()
		slot0.filter:Hide()

		if slot0.filter.Hide.confirmFunc then
			slot0.confirmFunc()
		end
	end, SFX_PANEL)
	onButton(slot0, slot0._go, function ()
		slot0:Hide()
	end, SFX_PANEL)
	slot0.initSortPanel(slot0)
	slot0:initFilterPanel()
	triggerToggle(slot0.selectedAllBtn, true)
	triggerToggle(slot0.sortBtns[1], true)
end

slot0.initSortPanel = function (slot0)
	slot0.sortBtns = {}

	for slot4, slot5 in pairs(slot0.SORT_TAG) do
		slot6 = cloneTplTo(slot0.sortTpl, slot0.sortContainer)

		setText(slot6:Find("Text"), slot5[2])

		slot0.sortBtns[slot4] = slot6

		slot0:onSwitch(slot6, function (slot0)
			if slot0 then
				slot0.sortData = slot1[1]
				slot0.sortTxt = slot1[2]
			end
		end)
	end
end

slot0.onSwitch = function (slot0, slot1, slot2)
	onToggle(slot0, slot1, function (slot0)
		setActive(slot0:Find("mark"), not slot0)
		setActive(slot0)
	end, SFX_PANEL)
end

slot0.initFilterPanel = function (slot0)
	slot0.filterBtns = {}

	table.sort(slot1, function (slot0, slot1)
		return slot0.filterConfig[slot0].order < slot0.filterConfig[slot1].order
	end)

	for slot5, slot6 in ipairs(slot1) do
		if slot0.filterConfig[slot6].is_view == 1 then
			slot8 = cloneTplTo(slot0.filterTpl, slot0.filterContainer)

			setText(slot8:Find("Text"), slot7.name)

			slot0.filterBtns[slot6] = slot8

			slot0:onSwitch(slot8, function (slot0)
				if slot0 then
					table.insert(slot0.filterData, table.insert)
					triggerToggle(slot0.selectedAllBtn, slot0:isSelectedAll())
				else
					slot0.filterData = _.reject(slot0.filterData, function (slot0)
						return slot0 == slot0
					end)

					if slot0.isSelectedNone(slot1) then
						triggerToggle(slot0.selectedAllBtn, true)
						setActive(slot0.selectedAllBtn:Find("mark"), false)
					end
				end
			end)
		end
	end

	slot0.otherTF = cloneTplTo(slot0.filterTpl, slot0.filterContainer)

	setText(slot0.otherTF.Find(slot3, "Text"), i18n("backyard_filter_tag_other"))

	slot0.otherTFToggle = slot0.otherTF:GetComponent(typeof(Toggle))
	slot0.selectedOther = false

	slot0:onSwitch(slot0.otherTF, function (slot0)
		slot0.selectedOther = slot0

		if slot0 then
			triggerToggle(slot0.selectedAllBtn, slot0:isSelectedAll())
		elseif slot0:isSelectedNone() then
			triggerToggle(slot0.selectedAllBtn, true)
			setActive(slot0.selectedAllBtn:Find("mark"), false)
		end
	end)
	onToggle(slot0, slot0.selectedAllBtn, function (slot0)
		if slot0:isSelectedNone() then
			return
		end

		if slot0 then
			_.each(slot0.filterData, function (slot0)
				triggerToggle(slot0.filterBtns[slot0], false)
			end)

			slot0.filterData = {}

			triggerToggle(slot0.otherTF, false)

			slot0.selectedOther = false
		end

		setActive(slot0.selectedAllBtn.Find(slot2, "mark"), not slot0)
	end, SFX_PANEL)
end

slot0.isSelectedAll = function (slot0)
	return (_.all(_.select(slot0.filterConfig.all, function (slot0)
		return slot0.filterConfig[slot0].is_view == 1
	end), function (slot0)
		return table.contains(slot0.filterData, slot0)
	end) and slot0.otherTFToggle.isOn == true) or slot0.isSelectedNone(slot0)
end

slot0.isSelectedNone = function (slot0)
	return #slot0.filterData == 0 and slot0.otherTFToggle.isOn == false
end

slot0.GetThemes = function (slot0)
	slot2 = {}

	for slot6, slot7 in ipairs(pg.furniture_data_template.all) do
		if not slot2[slot1[slot7].themeId] then
			slot2[slot8.themeId] = {}
		end

		table.insert(slot2[slot8.themeId], slot7)
	end

	return slot2
end

slot0.filter = function (slot0)
	if table.getCount(slot0.furnitures) == 0 then
		return
	end

	slot1 = {}

	for slot5, slot6 in ipairs(slot0.filterData) do
		slot7 = slot0.themes[slot6] or {}

		for slot11, slot12 in ipairs(slot7) do
			table.insert(slot1, slot12)
		end
	end

	function slot2(slot0)
		slot1 = slot0.id
		slot2 = slot0.selectedOther and slot0:getConfig("themeId") == 0

		if slot2 then
			return false
		end

		return not table.contains(slot1, slot1)
	end

	if #slot1 ~= 0 or not not slot0.selectedOther then
		for slot6 = #slot0.furnitures, 1, -1 do
			slot7 = slot0.furnitures[slot6].id

			if slot2(slot0.furnitures[slot6]) then
				table.remove(slot0.furnitures, slot6)
			end
		end
	end

	slot0:sort(slot0.furnitures)
end

slot0.SORT_BY_FUNC = function (slot0, slot1, slot2, slot3, slot4)
	if slot0[slot2](slot0) == slot1[slot2](slot1) then
		return slot4()
	elseif slot3 == slot0.ORDER_MODE_ASC then
		return slot0[slot2](slot0) < slot1[slot2](slot1)
	else
		return slot1[slot2](slot1) < slot0[slot2](slot0)
	end
end

slot0.SORT_BY_CONFIG = function (slot0, slot1, slot2, slot3, slot4)
	if slot0:getConfig(slot2) == slot1:getConfig(slot2) then
		return slot4()
	elseif slot3 == slot0.ORDER_MODE_ASC then
		return slot0:getConfig(slot2) < slot1:getConfig(slot2)
	else
		return slot1:getConfig(slot2) < slot0:getConfig(slot2)
	end
end

slot0.SortForDecorate = function (slot0, slot1, slot2)
	slot3 = slot2[1]
	slot4 = slot2[2]
	slot5 = slot2[3]
	slot6 = slot2[4]
	slot7 = slot2[5]

	slot0.SortByDefault1 = function (slot0, slot1)
		return slot0.id < slot1.id
	end

	slot0.SortByDefault2 = function (slot0, slot1)
		return slot1.id < slot0.id
	end

	slot9 = slot2[6][slot0.configId] or 0

	if ((slot9 == slot0.count and 1) or 0) == (((slot8[slot1.configId] or 0) == slot1.count and 1) or 0) then
		if slot3 == slot0.SORT_MODE.BY_DEFAULT then
			return slot0["SortByDefault" .. slot6](slot0, slot1)
		elseif slot3 == slot0.SORT_MODE.BY_FUNC then
			return slot0:SORT_BY_FUNC(slot1, slot4, slot6, function ()
				return slot0["SortByDefault" .. ]("SortByDefault", slot3)
			end)
		elseif slot3 == slot0.SORT_MODE.BY_CONFIG then
			return slot0.SORT_BY_CONFIG(slot0, slot1, slot4, slot6, function ()
				return slot0["SortByDefault" .. ]("SortByDefault", slot3)
			end)
		end
	else
		return slot10 < slot9
	end
end

slot0.sort = function (slot0, slot1)
	slot2 = {}

	for slot7, slot8 in pairs(slot3) do
		if not slot2[slot8:getConfig("id")] then
			slot2[slot9] = 0
		end

		slot2[slot9] = slot2[slot9] + 1
	end

	slot4 = GetCanBePutFurnituresForThemeCommand.GetAllFloorFurnitures()

	table.sort(slot1, function (slot0, slot1)
		return slot0:SortForDecorate(slot1, {
			slot1.sortData[1],
			slot1.sortData[2],
			slot1.dorm,
			slot1.orderMode,
			slot2,
			slot0
		})
	end)

	slot0.furnitures = slot1
end

slot0.Sort = function (slot0)
	slot0:sort(slot0.furnitures)
end

slot0.Show = function (slot0)
	setActive(slot0._go, true)
end

slot0.Hide = function (slot0)
	setActive(slot0._go, false)

	if slot0.onHideFunc then
		slot0.onHideFunc()
	end
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0
