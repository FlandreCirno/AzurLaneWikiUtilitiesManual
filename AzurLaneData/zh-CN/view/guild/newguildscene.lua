slot0 = class("NewGuildScene", import("..base.BaseUI"))

slot0.getUIName = function (slot0)
	return "NewGuildUI"
end

slot0.setPlayer = function (slot0, slot1)
	slot0.playerVO = slot1

	slot0._resPanel:setResources(slot1)
end

slot0.init = function (slot0)
	slot0.createPanel = slot0:findTF("create_panel")
	slot0.factionPanel = slot0:findTF("faction_panel")
	slot0.createBtn = slot0:findTF("create_panel/frame/create_btn")
	slot0.joinBtn = slot0:findTF("create_panel/frame/join_btn")
	slot0.topPanel = slot0:findTF("blur_panel/adapt/top")
	slot0.publicGuildBtn = slot0:findTF("create_panel/frame/public_btn")
	slot0._playerResOb = slot0:findTF("playerRes", slot0.topPanel)
	slot0._resPanel = PlayerResource.New()

	tf(slot0._resPanel._go):SetParent(tf(slot0._playerResOb), false)

	slot0.backBtn = slot0:findTF("back", slot0.topPanel)

	setActive(slot0.factionPanel, false)

	slot0.mask = slot0:findTF("mask")

	SetActive(slot0.mask, false)

	slot0.mainRedPage = NewGuildMainRedPage.New(slot0._tf, slot0.event)
	slot0.mainBluePage = NewGuildMainBluePage.New(slot0._tf, slot0.event)
end

slot0.didEnter = function (slot0)
	slot0:startCreate()
	onButton(slot0, slot0.createBtn, function ()
		slot0:createGuild()
	end, SFX_PANEL)
	onButton(slot0, slot0.joinBtn, function ()
		slot0:emit(NewGuildMediator.OPEN_GUILD_LIST)
	end, SFX_PANEL)
	onButton(slot0, slot0.createPanel, function ()
		slot0:emit(slot1.ON_BACK)
	end, SOUND_BACK)
	onButton(slot0, slot0.publicGuildBtn, function ()
		slot0:emit(NewGuildMediator.OPEN_PUBLIC_GUILD)
	end, SOUND_BACK)
	onButton(slot0, slot0.backBtn, function ()
		if go(slot0.createPanel).activeSelf then
			slot0:emit(slot1.ON_BACK)
		end
	end, SFX_CANCEL)
end

slot0.startCreate = function (slot0)
	setActive(slot0.createPanel, true)
end

slot0.createGuild = function (slot0)
	setActive(slot0.createPanel, false)
	setActive(slot0.factionPanel, false)

	slot0.createProcess = coroutine.wrap(function ()
		setActive(slot0.createPanel, false)

		slot0 = Guild.New({})

		slot0:selectFaction(slot0, slot0.createProcess)
		coroutine.yield()
		slot0:setDescInfo(slot0)
	end)

	slot0.createProcess()
end

slot0.selectFaction = function (slot0, slot1, slot2)
	function slot3(slot0, slot1)
		slot0.isPlaying = true
		slot2 = slot0:Find("bg")

		setActive(slot2, true)

		slot3 = slot2:GetComponent("CanvasGroup")

		LeanTween.value(go(slot2), 1, 3, 0.5):setOnUpdate(System.Action_float(function (slot0)
			slot0.localScale = Vector3(slot0, slot0, 1)
			slot0.alpha = 1 - slot0 / 3
		end)).setOnComplete(slot4, System.Action(function ()
			setActive(setActive, false)

			setActive.localScale = Vector3(1, 1, 1)
			Vector3(1, 1, 1).isPlaying = false

			1()
		end))
	end

	setActive(slot0.factionPanel, true)

	slot5 = slot0.factionPanel.Find(slot4, "panel")
	slot6 = slot5:Find("blhx")
	slot7 = slot5:Find("cszz")
	slot8 = slot5:Find("bg")

	if not slot0.isInitFaction then
		setImageSprite(slot8, GetSpriteFromAtlas("commonbg/camp_bg", ""))
		setImageSprite(slot6:Find("bg"), GetSpriteFromAtlas("clutter/blhx_icon", ""))
		setImageSprite(slot7:Find("bg"), GetSpriteFromAtlas("clutter/cszz_icon", ""))
		setActive(slot6:Find("bg"), false)
		setActive(slot7:Find("bg"), false)

		slot0.isInitFaction = true
	end

	onButton(slot0, slot6, function ()
		if slot0.isPlaying then
			return
		end

		slot1:setFaction(GuildConst.FACTION_TYPE_BLHX)

		if GuildConst.FACTION_TYPE_BLHX then
			slot2()
		else
			return
		end

		slot3(slot4, function ()
			slot0 = nil
		end)
	end, SFX_PANEL)
	onButton(slot0, slot7, function ()
		if slot0.isPlaying then
			return
		end

		slot1:setFaction(GuildConst.FACTION_TYPE_CSZZ)

		if GuildConst.FACTION_TYPE_CSZZ then
			slot2()
		else
			return
		end

		slot3(slot4, function ()
			slot0 = nil
		end)
	end)
	onButton(slot0, slot0.backBtn, function ()
		if slot0.isPlaying then
			return
		end

		slot0.createProcess = nil

		setActive(slot0.createPanel, true)
		setActive(slot0.factionPanel, false)
		onButton(onButton, slot0.backBtn, function ()
			slot0:emit(slot1.ON_BACK)
		end, SFX_CANCEL)
	end, SFX_CANCEL)
	setActive(slot0.topPanel, true)
end

slot0.setDescInfo = function (slot0, slot1)
	if slot1:getFaction() == GuildConst.FACTION_TYPE_BLHX then
		slot0.mainPage = slot0.mainBluePage
	elseif slot2 == GuildConst.FACTION_TYPE_CSZZ then
		slot0.mainPage = slot0.mainRedPage
	end

	slot0.mainPage.ExecuteAction(slot4, "Show", slot1, slot0.playerVO, function ()
		setActive(slot0.factionPanel, false)
	end, slot3)
	onButton(slot0, slot0.backBtn, function ()
		if not slot0.mainPage:GetLoaded() or slot0.mainPage:IsPlaying() then
			return
		end

		slot0.createProcess = nil

		slot0:createGuild()
		slot0.createGuild.mainPage:Hide()
	end, SFX_CANCEL)
end

slot0.ClosePage = function (slot0)
	if slot0.page and slot0.page:GetLoaded() and slot0.page:isShowing() then
		slot0.page:Hide()
	end
end

slot0.onBackPressed = function (slot0)
	if slot0.createProcess ~= nil then
		triggerButton(slot0.backBtn)
	else
		triggerButton(slot0.createPanel)
	end
end

slot0.willExit = function (slot0)
	if slot0._resPanel then
		slot0._resPanel:exit()

		slot0._resPanel = nil
	end

	slot0.mainRedPage:Destroy()
	slot0.mainBluePage:Destroy()
end

return slot0
