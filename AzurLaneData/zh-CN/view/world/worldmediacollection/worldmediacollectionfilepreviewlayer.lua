slot0 = class("WorldMediaCollectionFilePreviewLayer", import("view.base.BaseUI"))

slot0.__index = function (slot0, slot1)
	return rawget(slot0, slot1) or slot0.super[slot1] or WorldMediaCollectionFileDetailLayer[slot1]
end

slot0.getUIName = function (slot0)
	return "WorldMediaCollectionFilePreviewUI"
end

slot0.init = function (slot0)
	slot0.canvasGroup = slot0._tf:GetComponent(typeof(CanvasGroup))

	slot0:InitDocument()

	slot0.tipTF = slot0._tf:Find("Tip")
	slot0.animBar = slot0._tf:Find("Bar")

	setActive(slot0.animBar, false)
	setActive(slot0.document, false)
	setActive(slot0.tipTF, false)

	slot0.loader = AutoLoader.New()

	setText(slot0.animBar:Find("Text"), i18n("world_collection_back"))
end

slot0.didEnter = function (slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
	slot0:SetDocument(slot1)
	setActive(slot0.animBar, true)

	slot3 = slot0.animBar:Find("Anim/Frame/Mask/Name")
	slot3:GetComponent(typeof(ScrollText)).enabled = false
	slot3.pivot = Vector2(0, 0.5)
	slot3.anchorMin = Vector2(0, 0.5)
	slot3.anchorMax = Vector2(0, 0.5)
	slot3.anchoredPosition = Vector2.zero
	slot3:GetComponent(typeof(Text)).text = tostring(WorldCollectionProxy.GetCollectionTemplate(slot0.contextData.collectionId).name or "")
	slot2.preferredWidth = math.min(slot3.GetComponent(typeof(Text)).preferredWidth, slot0.animBar:Find("Anim/Frame/Mask"):GetComponent(typeof(LayoutElement)).preferredWidth)

	function slot7()
		onButton(onButton, slot0._tf, function ()
			slot0:closeView()
		end)
	end

	function slot8()
		if slot1 < slot0.preferredWidth then
			slot2.pivot = Vector2(0.5, 0.5)
			0.5.anchorMin = Vector2(0.5, 0.5)
			0.5.anchorMax = Vector2(0.5, 0.5)
			0.5.enabled = true
		end
	end

	removeOnButton(slot0._tf)

	if slot0.animBar.GetComponent(slot9, typeof(DftAniEvent)) then
		slot9:SetTriggerEvent(slot8)
		slot9:SetEndEvent(slot7)
	else
		slot8()
		slot7()
	end

	onButton(slot0, slot0.animBar:Find("Button"), function ()
		setActive(slot0.animBar, false)
		setActive(slot0.document, true)
		setActive(slot0.tipTF, true)
		slot0.tipTF()
	end, SFX_PANEL)

	slot10 = WorldCollectionProxy.GetCollectionGroup(slot1.id)

	setImageSprite(slot0.animBar:Find("Anim/Icon"), LoadSprite("ui/WorldMediaCollectionFilePreviewUI_atlas", WorldCollectionProxy.GetCollectionFileGroupTemplate(slot10).type))
end

slot0.willExit = function (slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf)
	slot0.loader:Clear()

	if slot0.contextData.callback then
		slot1()
	end

	slot0.super.willExit(slot0)
end

return slot0
