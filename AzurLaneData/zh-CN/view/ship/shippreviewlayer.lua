slot0 = class("ShipPreviewLayer", import("..base.BaseUI"))
slot1 = 12
slot2 = 3
slot3 = Vector3(0, 1, 40)

slot0.getUIName = function (slot0)
	return "ShipPreviewUI"
end

slot0.init = function (slot0)
	slot0.UIMgr = pg.UIMgr.GetInstance()

	slot0.UIMgr:BlurPanel(slot0._tf)

	slot0.UIMain = slot0.UIMgr.UIMain
	slot0.seaCameraGO = GameObject.Find("BarrageCamera")
	slot0.leftPanel = slot0:findTF("left_panel")
	slot0.sea = slot0:findTF("sea", slot0.leftPanel)
	slot0.seaCamera = slot0.seaCameraGO:GetComponent("Camera")
	slot0.seaCamera.enabled = true
	slot0.rawImage = slot0.sea:GetComponent("RawImage")

	setActive(slot0.rawImage, false)

	slot0.seaCamera.targetTexture = slot0.rawImage.texture
	slot0.healTF = slot0:findTF("resources/heal")
	slot0.healTF.transform.localPosition = Vector3(-360, 50, 40)

	setActive(slot0.healTF, false)
	slot0.healTF:GetComponent("DftAniEvent").SetEndEvent(slot1, function ()
		setActive(slot0.healTF, false)
		setText(slot0.healTF:Find("text"), "")
	end)

	slot0.seaLoading = slot0.findTF(slot0, "bg/loading", slot0.leftPanel)

	slot0:playLoadingAni()
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0.seaLoading, function ()
		if not slot0.previewer then
			slot0:showBarrage()
		end
	end)
	onButton(slot0, slot0._tf, function ()
		slot0:emit(slot1.ON_CLOSE)
	end)
end

slot0.setShip = function (slot0, slot1, slot2, slot3)
	slot0.shipVO = slot1
	slot0.weaponIds = slot2
	slot0.equipSkinId = slot3
end

slot0.showBarrage = function (slot0)
	slot0.previewer = WeaponPreviewer.New(slot0.rawImage)

	slot0.previewer:configUI(slot0.healTF)
	slot0.previewer:setDisplayWeapon(slot0.weaponIds, slot0.equipSkinId, true)
	slot0.previewer:load(40000, slot0.shipVO, slot0.weaponIds, function ()
		slot0:stopLoadingAni()
	end)
end

slot0.getWaponIdsById = function (slot0, slot1)
	return slot0.ship_data_breakout[slot1].weapon_ids
end

slot0.playLoadingAni = function (slot0)
	setActive(slot0.seaLoading, true)
end

slot0.stopLoadingAni = function (slot0)
	setActive(slot0.seaLoading, false)
end

slot0.willExit = function (slot0)
	slot0.UIMgr:UnblurPanel(slot0._tf, slot0.UIMain)

	if slot0.previewer then
		slot0.previewer:clear()

		slot0.previewer = nil
	end
end

return slot0
