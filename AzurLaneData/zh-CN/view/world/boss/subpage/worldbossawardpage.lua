slot0 = class("WorldBossAwardPage", import("....base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "WorldBossAwardUI"
end

slot0.OnLoaded = function (slot0)
	return
end

slot0.OnInit = function (slot0)
	slot0.uilist1 = UIItemList.New(slot0:findTF("frame/list/container1"), slot1)
	slot0.uilist2 = UIItemList.New(slot0:findTF("frame/list/container2"), slot1)

	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_PANEL)
end

slot0.Update = function (slot0, slot1)
	slot0.worldBoss = slot1

	slot0:UpdateAwards()
	slot0:Show()
end

slot0.UpdateAwards = function (slot0)
	function slot3(slot0, slot1)
		updateDrop(slot1:Find("equipment/bg"), slot3)
		slot1:Find("mask/name"):GetComponent("ScrollText").SetText(slot4, slot5)
		onButton(slot1, slot1, function ()
			slot0:emit(BaseUI.ON_DROP, slot0)
		end, SFX_PANEL)
	end

	slot0.uilist1.make(slot4, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot0(slot1, slot2)
		end
	end)
	slot0.uilist2.make(slot4, function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot0(slot1 + 4, slot2)
		end
	end)
	slot0.uilist1.align(slot4, math.min(#slot0.worldBoss.GetAwards(slot1), 4))
	slot0.uilist2:align(math.max(0, #slot0.worldBoss.GetAwards(slot1) - 4))
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0
