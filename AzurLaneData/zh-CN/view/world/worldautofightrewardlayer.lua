slot0 = class("WorldAutoFightRewardLayer", BaseUI)

slot0.getUIName = function (slot0)
	return "WorldAutoFightRewardUI"
end

slot1 = 0.1

slot0.init = function (slot0)
	slot0.window = slot0._tf:Find("Window")
	slot0.boxView = slot0.window:Find("Layout/Box/ScrollView")
	slot0.itemList = slot0.boxView:Find("Viewport/Content/ItemGrid")
	Instantiate(slot0.itemList:GetComponent(typeof(ItemList)).prefabItem[0]).name = "Icon"

	setParent(slot1, slot0.itemList:Find("GridItem/Shell"))
	setText(slot0.window:Find("Fixed/top/bg/obtain/title"), i18n("autofight_rewards"))
	setText(slot0.window:Find("Layout/Box/Title/Text"), i18n("battle_end_subtitle1"))
end

slot0.didEnter = function (slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
	slot0:UpdateView()

	if getProxy(MetaCharacterProxy):getMetaTacticsInfoOnEnd() and #slot1 > 0 then
		slot0.metaExpView = MetaExpView.New(slot0.window:Find("Layout"), slot0.event, slot0.contextData)

		slot0.metaExpView.Reset(slot2)
		slot0.metaExpView.Load(slot2)
		slot0.metaExpView.setData(slot2, slot1)
		slot0.metaExpView:ActionInvoke("Show")
	end
end

slot0.willExit = function (slot0)
	slot0:SkipAnim()

	if slot0.metaExpView then
		slot0.metaExpView:Destroy()
	end

	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf)
end

slot0.UpdateView = function (slot0)
	slot1 = slot0.contextData

	onButton(slot0, slot0._tf:Find("BG"), function ()
		if slot0.isRewardAnimating then
			slot0:SkipAnim()

			return
		end

		existCall(slot1.onClose)
		existCall:closeView()
	end)
	setText(slot0.window.Find(slot3, "Fixed/ButtonExit/pic"), i18n("autofight_leave"))
	onButton(slot0, slot0.window:Find("Fixed/ButtonExit"), function ()
		existCall(slot0.onClose)
		slot0.onClose:closeView()
	end, SFX_CANCEL)
	nowWorld.InitAutoInfos(slot3)
	DropResultIntegration(nowWorld.autoInfos.drops)

	slot3 = underscore.map(nowWorld.autoInfos.drops, function (slot0)
		if slot0.type == DROP_TYPE_WORLD_COLLECTION then
			table.insert(slot0.message, i18n("autofight_file", WorldCollectionProxy.GetCollectionTemplate(slot0.id).name))
		else
			return {
				drop = slot0
			}
		end
	end)

	for slot7, slot8 in ipairs(nowWorld.autoInfos.salvage) do
		DropResultIntegration(slot8)
		underscore.each(slot8, function (slot0)
			table.insert(slot0, {
				drop = slot0,
				salvage = table.insert
			})
		end)
	end

	setActive(slot0.itemList, #slot3 > 0)

	slot0.tweenItems = {}
	slot4 = CustomIndexLayer.Clone2Full(slot0.itemList, #slot3)
	slot5 = {}

	for slot9, slot10 in ipairs(slot3) do
		updateDrop(slot4[slot9].Find(slot12, "Shell/Icon"), slot11)
		onButton(slot0, slot4[slot9].Find(slot12, "Shell/Icon"), function ()
			slot0:emit(BaseUI.ON_DROP, slot0)
		end, SFX_PANEL)
		setActive(slot4[slot9].Find(slot12, "salvage"), slot10.salvage)

		if slot10.salvage then
			eachChild(slot12:Find("salvage"), function (slot0)
				setActive(slot0, slot0.name == tostring(slot0.salvage))
			end)
		end

		setActive(slot12, false)
		table.insert(slot5, function (slot0)
			if not slot0.tweenItems then
				slot0()

				return
			end

			setActive(setActive, true)

			slot0.boxView:GetComponent(typeof(ScrollRect)).verticalNormalizedPosition = 0

			table.insert(slot0.tweenItems, LeanTween.delayedCall(slot0.tweenItems, System.Action(slot0)).id)
		end)
	end

	slot0.isRewardAnimating = true

	seriesAsync(slot5, function ()
		slot0:SkipAnim()
	end)

	slot6 = {}

	for slot10, slot11 in ipairs(slot2.buffs) do
		if slot6[slot11.id] then
		else
			slot6[slot11.id] = slot11.before
		end
	end

	slot7 = pg.gameset.world_mapbuff_list.description
	slot8 = underscore.map(slot7, function (slot0)
		if not slot0[slot0] then
			return 0
		else
			return nowWorld:GetGlobalBuff(slot0):GetFloor() - slot0[slot0]
		end
	end)

	if underscore.any(slot8, function (slot0)
		return slot0 ~= 0
	end) then
		table.insert(slot2.message, i18n("autofight_effect", unpack(slot8)))
	end

	setActive(slot0.boxView:Find("Viewport/Content/TextArea"), #slot2.message > 0)
	setText(slot0.boxView:Find("Viewport/Content/TextArea/Text"), table.concat(slot2.message, "\n"))
end

slot0.CloneIconTpl = function (slot0, slot1)
	slot3 = Instantiate(slot0:GetComponent(typeof(ItemList)).prefabItem[0])

	if slot1 then
		slot3.name = slot1
	end

	setParent(slot3, slot0)

	return slot3
end

slot0.SkipAnim = function (slot0)
	if not slot0.isRewardAnimating then
		return
	end

	for slot4, slot5 in ipairs(slot0.tweenItems) do
		LeanTween.cancel(slot5)
	end

	for slot4 = 1, slot0.itemList.childCount, 1 do
		setActive(slot0.itemList:GetChild(slot4 - 1), true)
	end

	slot0.isRewardAnimating = nil
end

return slot0
