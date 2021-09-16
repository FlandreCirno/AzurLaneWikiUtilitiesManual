pg = pg or {}
pg.GuildLayerMgr = singletonClass("GuildLayerMgr")

pg.GuildLayerMgr.Ctor = function (slot0)
	slot0.overlayMain = pg.UIMgr.GetInstance().OverlayMain.transform
	slot0.originLayer = GameObject.Find("UICamera/Canvas")
	slot0.levelGrid = GameObject.Find("LevelCamera/Canvas/UIMain/LevelGrid")
end

pg.GuildLayerMgr.Init = function (slot0, slot1)
	if slot1 then
		slot1()
	end
end

pg.GuildLayerMgr.BlurTopPanel = function (slot0, slot1)
	if not slot0.topPanel then
		slot0.topPrevParent = slot1.parent
		slot0.topPanel = slot1
	end

	setParent(slot1, slot0.overlayMain)
end

pg.GuildLayerMgr.OnShowMsgBox = function (slot0)
	if slot0.topPanel then
		slot0.topPanel:SetAsFirstSibling()
	end
end

pg.GuildLayerMgr.UnBlurTopPanel = function (slot0)
	setParent(slot0.topPanel, slot0.originLayer)
end

pg.GuildLayerMgr.Blur = function (slot0, slot1)
	slot0:UnBlurTopPanel()
	pg.UIMgr.GetInstance():BlurPanel(slot1)
	slot1:SetAsLastSibling()
end

pg.GuildLayerMgr.UnBlur = function (slot0, slot1, slot2)
	slot0:BlurTopPanel(slot0.topPanel)
	pg.UIMgr.GetInstance():UnblurPanel(slot1, slot2)
end

pg.GuildLayerMgr.BlurForLevel = function (slot0, slot1)
	setActive(slot0.levelGrid, false)
	slot0:Blur(slot1)
end

pg.GuildLayerMgr.UnBlurForLevel = function (slot0, slot1, slot2)
	setActive(slot0.levelGrid, true)
	slot0:UnBlur(slot1, slot2)
end

pg.GuildLayerMgr.SetOverlayParent = function (slot0, slot1, slot2)
	setParent(slot1, slot2 or slot0.overlayMain)
end

pg.GuildLayerMgr.Clear = function (slot0)
	setParent(slot0.topPanel, slot0.topPrevParent)

	slot0.topPrevParent = nil
	slot0.topPanel = nil
end

return
