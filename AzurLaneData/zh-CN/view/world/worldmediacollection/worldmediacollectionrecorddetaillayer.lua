slot0 = class("WorldMediaCollectionRecordDetailLayer", import(".WorldMediaCollectionSubLayer"))

slot0.getUIName = function (slot0)
	return "WorldMediaCollectionMemoryDetailUI"
end

slot0.OnInit = function (slot0)
	slot0.super.OnInit(slot0)
	setActive(slot0._tf:Find("ItemRect/TitleRecord"), true)
	setActive(slot0._tf:Find("ItemRect/TitleMemory"), false)

	slot0.recordItemList = slot0:findTF("ItemRect"):GetComponent("LScrollRect")

	slot0.recordItemList.onInitItem = function (slot0)
		slot0:OnInitRecordItem(slot0)
	end

	slot0.recordItemList.onUpdateItem = function (slot0, slot1)
		slot0:OnUpdateRecordItem(slot0 + 1, slot1)
	end

	slot0.recordItems = {}

	setActive(slot1, false)

	slot0.loader = WorldMediaCollectionLoader.New()

	setText(slot0._tf:Find("ItemRect/ProgressDesc"), i18n("world_collection_2"))
end

slot0.OnInitRecordItem = function (slot0, slot1)
	if slot0.exited then
		return
	end

	onButton(slot0, slot1, function ()
		slot1 = nowWorld:GetCollectionProxy()

		if slot0.recordItems[slot1] and slot0:CheckRecordIsUnlock() then
			slot0:PlayMemory(slot0)
		end
	end, SOUND_BACK)
end

slot0.OnUpdateRecordItem = function (slot0, slot1, slot2)
	if slot0.exited then
		return
	end

	slot0.recordItems[slot2] = slot0.records and slot0.records[slot1]
	slot4 = tf(slot2)

	if slot0.CheckRecordIsUnlock(slot0.records and slot0.records[slot1]) then
		setActive(slot4:Find("normal"), true)
		setActive(slot4:Find("lock"), false)

		slot4:Find("normal/title"):GetComponent(typeof(Text)).text = HXSet.hxLan(slot3.name)

		slot0.loader:GetSprite("memoryicon/" .. slot3.icon, "", slot4:Find("normal"))
		setText(slot4:Find("normal/id"), string.format("#%u", slot3.group_ID))
	else
		setActive(slot4:Find("normal"), false)
		setActive(slot4:Find("lock"), true)
		setText(slot4:Find("lock/condition"), slot3.condition)
	end

	onButton(slot0, slot4, function ()
		if not slot0.CheckRecordIsUnlock(slot1) then
			return
		end

		slot0:PlayMemory(slot0)
	end, SFX_PANEL)
end

slot0.SetStoryMask = function (slot0, slot1)
	slot0.memoryMask = slot1
end

slot0.PlayMemory = function (slot0, slot1)
	slot2 = findTF(slot0.memoryMask, "pic")

	if string.len(slot1.mask) > 0 then
		setActive(slot2, true)

		slot2:GetComponent(typeof(Image)).sprite = LoadSprite(slot1.mask)
	else
		setActive(slot2, false)
	end

	setActive(slot0.memoryMask, true)
	pg.NewStoryMgr.GetInstance():Play(slot1.story, function ()
		setActive(slot0.memoryMask, false)
	end, true)
end

slot0.ShowRecordGroup = function (slot0, slot1)
	slot0.contextData.recordGroup = slot1
	slot0.records = _.map(WorldCollectionProxy.GetCollectionRecordGroupTemplate(slot1).child, function (slot0)
		return WorldCollectionProxy.GetCollectionTemplate(slot0)
	end)

	slot0.recordItemList.SetTotalCount(slot3, #slot0.records, 0)
	setText(slot0._tf.Find(slot6, "ItemRect/ProgressText"), slot4 .. "/" .. #slot0.records)
end

slot0.CheckRecordIsUnlock = function (slot0)
	return nowWorld:GetCollectionProxy():IsUnlock(slot0.id) or pg.NewStoryMgr.GetInstance():IsPlayed(slot0.story, true)
end

slot0.CleanList = function (slot0)
	slot0.records = nil

	slot0.recordItemList:SetTotalCount(0)
end

return slot0
