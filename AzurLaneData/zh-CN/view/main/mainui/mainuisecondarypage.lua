slot0 = class("MainUISecondaryPage")

slot0.Ctor = function (slot0, slot1, slot2)
	slot0._tf = slot1
	slot0._parentTf = slot1.parent
	slot0.view = slot2

	pg.DelegateInfo.New(slot0)
	slot0:OnLoaded()
end

slot0.findTF = function (slot0, slot1, slot2)
	return findTF(slot2 or slot0._tf, slot1)
end

slot0.OnLoaded = function (slot0)
	SetActive(slot0._tf, false)

	slot1 = slot0:findTF("frame/bg", slot0._tf)
	slot0._academyBtn = slot0:findTF("school_btn", slot1)
	slot0._haremBtn = slot0:findTF("backyard_btn", slot1)
	slot0._commanderBtn = slot0:findTF("commander_btn", slot1)

	slot0:OnInit()
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0._commanderBtn, function ()
		slot0.view:emit(MainUIMediator.OPEN_COMMANDER)
	end, SFX_MAIN)
	onButton(slot0, slot0._haremBtn, function ()
		slot0.view:emit(MainUIMediator.OPEN_BACKYARD)
	end, SFX_MAIN)
	onButton(slot0, slot0._academyBtn, function ()
		slot0.view:emit(MainUIMediator.OPEN_SCHOOLSCENE)
	end, SFX_MAIN)
	onButton(slot0, slot0._tf, function ()
		slot0:Hide()
	end, SFX_PANEL)
end

slot0.Show = function (slot0, slot1)
	SetActive(slot0._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf, true, {
		weight = LayerWeightConst.SECOND_LAYER
	})

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(slot1.level, "CommandRoomMediator") then
		slot0._commanderBtn:GetComponent(typeof(Image)).color = Color(0.3, 0.3, 0.3, 1)
	else
		slot0._commanderBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end

	if not pg.SystemOpenMgr.GetInstance():isOpenSystem(slot1.level, "BackYardMediator") then
		slot0._haremBtn:GetComponent(typeof(Image)).color = Color(0.3, 0.3, 0.3, 1)
	else
		slot0._haremBtn:GetComponent(typeof(Image)).color = Color(1, 1, 1, 1)
	end
end

slot0.isShowing = function (slot0)
	return isActive(slot0._tf)
end

slot0.Hide = function (slot0)
	if slot0:isShowing() then
		SetActive(slot0._tf, false)
		pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)
	end
end

slot0.Destroy = function (slot0)
	slot0:Hide()
	pg.DelegateInfo.Dispose(slot0)
end

return slot0
