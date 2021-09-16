slot0 = class("WSAtlasRight", import("...BaseEntity"))
slot0.Fields = {
	btnSettings = "userdata",
	rtNameBg = "userdata",
	rtDisplayIcon = "userdata",
	transform = "userdata",
	isDisplay = "boolean",
	rtDisplayPanel = "userdata",
	world = "table",
	rtWorldInfo = "userdata",
	rtMapInfo = "userdata",
	rtBg = "userdata",
	wsWorldInfo = "table"
}

slot0.Setup = function (slot0)
	pg.DelegateInfo.New(slot0)
	slot0:Init()
end

slot0.Dispose = function (slot0)
	slot0.wsWorldInfo:Dispose()
	pg.DelegateInfo.Dispose(slot0)
	slot0:Clear()
end

slot0.Init = function (slot0)
	slot0.rtBg = slot0.transform.Find(slot1, "bg")
	slot0.rtNameBg = slot0.transform.Find(slot1, "name_bg")
	slot0.rtDisplayIcon = slot0.transform.Find(slot1, "line/display_icon")
	slot0.rtDisplayPanel = slot0.transform.Find(slot1, "line/display_panel")
	slot0.rtWorldInfo = slot0.rtDisplayPanel:Find("world_info")
	slot0.btnSettings = slot0.rtDisplayPanel:Find("settings_btn")
	slot0.wsWorldInfo = WSWorldInfo.New()
	slot0.wsWorldInfo.transform = slot0.rtWorldInfo

	slot0.wsWorldInfo:Setup()
	setActive(slot0.rtWorldInfo, nowWorld:IsSystemOpen(WorldConst.SystemWorldInfo))
	setText(slot0.rtDisplayIcon:Find("name"), i18n("world_map_title_tips"))
	onButton(slot0, slot0.rtDisplayIcon, function ()
		slot0.isDisplay = not slot0.isDisplay

		slot0:Collapse()
	end, SFX_PANEL)

	slot0.isDisplay = true

	slot0.Collapse(slot0)
end

slot0.Collapse = function (slot0)
	slot0.rtDisplayIcon:Find("icon").localScale = (slot0.isDisplay and Vector3.one) or Vector3(-1, 1, 1)

	setActive(slot0.rtDisplayPanel, slot0.isDisplay)
	setActive(slot0.rtBg, slot0.isDisplay)
	setActive(slot0.rtNameBg, not slot0.isDisplay)
end

slot0.SetOverSize = function (slot0, slot1)
	slot0.rtBg.offsetMax = Vector2(-slot1, slot0.rtBg.offsetMax.y)
	slot0.rtNameBg.offsetMax = Vector2(-slot1, slot0.rtNameBg.offsetMax.y)
end

return slot0
