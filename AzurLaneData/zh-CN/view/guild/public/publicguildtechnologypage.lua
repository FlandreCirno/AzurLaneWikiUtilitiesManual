slot0 = class("PublicGuildTechnologyPage", import("...base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "PublicGuildTechnologyPage"
end

slot0.OnTechGroupUpdate = function (slot0, slot1)
	slot0:UpdateUpgradeList()
end

slot0.OnLoaded = function (slot0)
	slot0.upgradeList = UIItemList.New(slot0:findTF("frame/upgrade/content"), slot0:findTF("frame/upgrade/content/tpl"))
end

slot0.OnInit = function (slot0)
	slot0.upgradeList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			PublicGuildTechnologyCard.New(slot2:Find("content"), slot0).Update(slot4, slot3)
			setActive(slot2:Find("back"), false)
		end
	end)
end

slot0.Show = function (slot0, slot1)
	slot0.guildVO = slot1

	slot0:UpdateUpgradeList()
	slot0.super.Show(slot0)
end

slot0.UpdateUpgradeList = function (slot0)
	slot0.technologyVOs = {}

	for slot5, slot6 in pairs(slot1) do
		if not slot6:IsGuildMember() then
			table.insert(slot0.technologyVOs, slot6)
		end
	end

	table.sort(slot0.technologyVOs, function (slot0, slot1)
		return slot0.id < slot1.id
	end)
	slot0.upgradeList.align(slot2, #slot0.technologyVOs)
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0
