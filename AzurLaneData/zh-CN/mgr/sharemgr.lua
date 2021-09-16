pg = pg or {}
pg.ShareMgr = singletonClass("ShareMgr")
pg.ShareMgr.TypeAdmira = 1
pg.ShareMgr.TypeShipProfile = 2
pg.ShareMgr.TypeNewShip = 3
pg.ShareMgr.TypeBackyard = 4
pg.ShareMgr.TypeNewSkin = 5
pg.ShareMgr.TypeSummary = 6
pg.ShareMgr.TypePhoto = 7
pg.ShareMgr.TypeReflux = 8
pg.ShareMgr.TypeCommander = 9
pg.ShareMgr.TypeColoring = 10
pg.ShareMgr.TypeChallenge = 11
pg.ShareMgr.TypeInstagram = 12
pg.ShareMgr.TypePizzahut = 13
pg.ShareMgr.TypeSecondSummary = 14
pg.ShareMgr.TypePoraisMedals = 15
pg.ShareMgr.TypeIcecream = 16
pg.ShareMgr.PANEL_TYPE_BLACK = 1
pg.ShareMgr.PANEL_TYPE_PINK = 2
pg.ShareMgr.ANCHORS_TYPE = {
	{
		0,
		0,
		0,
		0
	},
	{
		1,
		0,
		1,
		0
	},
	{
		0,
		1,
		0,
		1
	},
	{
		1,
		1,
		1,
		1
	}
}

pg.ShareMgr.Init = function (slot0)
	PoolMgr.GetInstance():GetUI("ShareUI", false, function (slot0)
		slot0.go = slot0

		slot0.go:SetActive(false)

		slot0.tr = slot0.transform
		slot0.panelBlack = slot0.tr:Find("panel")
		slot0.panelPink = slot0.tr:Find("panel_pink")
		slot0.deckTF = slot0.tr:Find("deck")

		setActive(slot0.panelBlack, false)
		setActive(slot0.panelPink, false)
	end)

	slot0.screenshot = Application.persistentDataPath .. "/screen_scratch/last_picture_for_share.jpg"
	slot0.cacheComps = {}
	slot0.cacheShowComps = {}
	slot0.cacheMoveComps = {}
end

pg.ShareMgr.Share = function (slot0, slot1, slot2, slot3)
	slot4 = LuaHelper.GetCHPackageType()

	if PLATFORM_CODE == PLATFORM_CH and slot4 ~= PACKAGE_TYPE_BILI then
		slot0.TipsMgr.GetInstance():ShowTips("指挥官，当前平台不支持分享功能哦")

		return
	end

	if IsNil(slot0.go) then
		slot0:Init()
	end

	if (slot2 or slot1.PANEL_TYPE_BLACK) == slot1.PANEL_TYPE_BLACK then
		slot0.panel = slot0.panelBlack
	elseif slot2 == slot1.PANEL_TYPE_PINK then
		slot0.panel = slot0.panelPink
	end

	setActive(slot0.panelBlack, slot2 == slot1.PANEL_TYPE_BLACK)
	setActive(slot0.panelPink, slot2 == slot1.PANEL_TYPE_PINK)

	slot6 = getProxy(PlayerProxy):getRawData()
	slot0.deckTF.anchorMin = Vector2(slot0.ANCHORS_TYPE[slot0.share_template[slot1].deck] or {
		0.5,
		0.5,
		0.5,
		0.5
	}[1], slot0.ANCHORS_TYPE[slot0.share_template[slot1].deck] or [2])
	slot0.deckTF.anchorMax = Vector2(slot0.ANCHORS_TYPE[slot0.share_template[slot1].deck] or [3], slot0.ANCHORS_TYPE[slot0.share_template[slot1].deck] or [4])

	setText(slot0.deckTF:Find("name/value"), (slot6 and slot6.name) or "")
	setText(slot0.deckTF:Find("server/value"), (getProxy(ServerProxy):getRawData()[(getProxy(UserProxy):getRawData() and slot2 == slot1.PANEL_TYPE_PINK.server) or 0] and getProxy(ServerProxy).getRawData()[(getProxy(UserProxy).getRawData() and slot2 == slot1.PANEL_TYPE_PINK.server) or 0].name) or "")
	setText(slot0.deckTF:Find("lv/value"), slot6.level)

	slot0.deckTF.anchoredPosition3D = Vector3(slot0.share_template[slot1].qrcode_location[1], slot0.share_template[slot1].qrcode_location[2], -100)
	slot0.deckTF.anchoredPosition = Vector2(slot0.share_template[slot1].qrcode_location[1], slot0.share_template[slot1].qrcode_location[2])

	_.each(slot0.share_template[slot1].hidden_comps, function (slot0)
		if not IsNil(GameObject.Find(slot0)) and slot1.activeSelf then
			table.insert(slot0.cacheComps, slot1)
			slot1:SetActive(false)
		end
	end)
	_.each(slot0.share_template[slot1].show_comps, function (slot0)
		if not IsNil(GameObject.Find(slot0)) and not slot1.activeSelf then
			table.insert(slot0.cacheShowComps, slot1)
			slot1:SetActive(true)
		end
	end)
	_.each(slot0.share_template[slot1].move_comps, function (slot0)
		if not IsNil(GameObject.Find(slot0.path)) then
			table.insert(slot0.cacheMoveComps, {
				slot1,
				slot1.transform.anchoredPosition.x,
				slot1.transform.anchoredPosition.y
			})
			setAnchoredPosition(slot1, {
				x = slot0.x,
				y = slot0.y
			})
		end
	end)
	SetParent(slot11, slot14, false)
	slot0.deckTF:SetAsLastSibling()

	slot15 = ScreenShooter.New(Screen.width, Screen.height, TextureFormat.ARGB32)

	if (PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US) and slot0.SdkMgr.GetInstance():GetIsPlatform() then
		slot0.SdkMgr.GetInstance():GameShare(slot5.description, slot15:EncodeToJPG(slot15:TakePhoto(slot13)))
		slot0.UIMgr.GetInstance():LoadingOn()
		onDelayTick(function ()
			slot0.UIMgr.GetInstance():LoadingOff()
		end, 2)
	elseif PLATFORM_CODE == PLATFORM_CH and slot4 == PACKAGE_TYPE_BILI then
		if slot15.Take(slot15, slot13, slot0.screenshot) then
			slot0.SdkMgr.GetInstance():GameShare(slot5.description, slot0.screenshot)
		end
	elseif slot15:Take(slot13, slot0.screenshot) then
		print("截图位置: " .. slot0.screenshot)
		slot0:Show(slot5, slot3)
	else
		slot0.TipsMgr.GetInstance():ShowTips("截图失败")
	end

	SetParent(slot11, slot0.tr, false)
	_.each(slot0.cacheComps, function (slot0)
		slot0:SetActive(true)
	end)

	slot0.cacheComps = {}

	_.each(slot0.cacheShowComps, function (slot0)
		slot0:SetActive(false)
	end)

	slot0.cacheShowComps = {}

	_.each(slot0.cacheMoveComps, function (slot0)
		setAnchoredPosition(slot0[1], {
			x = slot0[2],
			y = slot0[3]
		})
	end)

	slot0.cacheMoveComps = {}
end

pg.ShareMgr.Show = function (slot0, slot1, slot2)
	slot0.go:SetActive(true)
	slot0.UIMgr.GetInstance():BlurPanel(slot0.panel, true, slot2)
	slot0.DelegateInfo.New(slot0)
	onButton(slot0, slot0.panel:Find("main/top/btnBack"), slot3)
	onButton(slot0, slot0.panel:Find("main/buttons/weibo"), function ()
		slot0()
	end)
	onButton(slot0, slot0.panel:Find("main/buttons/weixin"), function ()
		slot0()
	end)

	if PLATFORM_CODE == PLATFORM_KR then
		onButton(slot0, slot0.panel:Find("main/buttons/facebook"), function ()
			slot0.SdkMgr.GetInstance():ShareImg(slot1.screenshot, function (slot0, slot1)
				if slot0 and slot1 == 0 then
					slot0.TipsMgr.GetInstance():ShowTips(i18n("share_success"))
				end
			end)
			slot1.screenshot()
		end)
	end
end

return
