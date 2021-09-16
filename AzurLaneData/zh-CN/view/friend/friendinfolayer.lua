slot0 = class("FriendInfoLayer", import("..base.BaseUI"))

slot0.getUIName = function (slot0)
	return "FriendInfoUI"
end

slot0.setFriend = function (slot0, slot1)
	slot0.friend = slot1
end

slot0.setFriendProxy = function (slot0, slot1)
	slot0.friendProxy = slot1
end

slot1 = {
	"OPEN_RESUME",
	"OPEND_FRIEND",
	"OPEN_BACKYARD",
	"TOGGLE_BLACK",
	"OPEN_INFORM"
}

slot0.init = function (slot0)
	if slot0.contextData.form == NotificationLayer.FORM_BATTLE then
		setParent(slot0._tf, slot0.contextData.parent)
	elseif slot0.contextData.form == NotificationLayer.FORM_MAIN then
		pg.UIMgr.GetInstance():BlurPanel(slot0._tf, false, {
			groupName = slot0:getGroupNameFromData()
		})
	else
		pg.UIMgr.GetInstance():OverlayPanel(slot0._tf, {
			groupName = slot0:getGroupNameFromData()
		})
	end

	slot0.frame = slot0:findTF("frame")
	slot0.iconTF = slot0:findTF("frame/left_bg/icon_bg/frame/icon"):GetComponent(typeof(Image))
	slot0.starsTF = slot0:findTF("frame/left_bg/icon_bg/stars")
	slot0.starTF = slot0:findTF("frame/left_bg/icon_bg/stars/star")
	slot0.playerNameTF = slot0:findTF("frame/left_bg/name_bg/Text"):GetComponent(typeof(Text))
	slot0.levelTF = slot0:findTF("frame/left_bg/icon_bg/lv/Text"):GetComponent(typeof(Text))
	slot0.resumeEmblem = slot0:findTF("frame/left_bg/emblem")
	slot0.resumeRank = slot0:findTF("frame/left_bg/emblem/Text"):GetComponent(typeof(Text))
	slot0.informPanel = slot0:findTF("inform_panel")
	slot0.toggleTpl = slot0:findTF("inform_panel/frame/window/main/Toggle")
	slot0.buttonTpl = slot0:findTF("inform_panel/frame/window/main/button")
	slot0.toggleContainer = slot0:findTF("inform_panel/frame/window/main/toggles")
	slot0.confirmBtn = slot0:findTF("frame/window/buttons/confirm_btn", slot0.informPanel)
	slot0.cancelBtn = slot0:findTF("frame/window/buttons/cancel_btn", slot0.informPanel)
	slot0.backBtn = slot0:findTF("inform_panel/frame/window/top/btnBack")
	slot0.nameTF = slot0:findTF("inform_panel/frame/window/name"):GetComponent(typeof(Text))

	if slot0.contextData.pos then
		if slot0.contextData.backyardView then
			slot2 = slot0:findTF("frame_for_backyard")
			slot2.position = slot0.contextData.pos
			slot2.localPosition = Vector3(slot2.localPosition.x, slot2.localPosition.y, 0)
		else
			slot0.height = slot0._tf.rect.height
			slot0.frame.position = slot0.contextData.pos
			slot0.frame.localPosition = Vector3(slot2.x, (slot0.frame.localPosition.y <= -1 * (slot0.height / 2 - slot0.frame.sizeDelta.y) and slot3) or slot2.y, 0)
		end
	end
end

slot0.didEnter = function (slot0)
	slot0:Init()
	onButton(slot0, slot0._tf, function ()
		slot0:emit(slot1.ON_CLOSE)
	end, SOUND_BACK)
end

slot0.Init = function (slot0)
	slot0:initInfo()
	setActive(slot0:findTF("frame_for_backyard"), slot1)
	setActive(slot0:findTF("frame"), not slot0.contextData.backyardView)

	slot2 = nil
	slot2 = (not slot0.contextData.backyardView or slot0:findTF("frame_for_backyard/right_bg")) and slot0:findTF("frame/right_bg")
	slot0.btnTFs = {}

	for slot6, slot7 in ipairs(slot0) do
		slot8 = slot2:GetChild(slot6 - 1)

		setActive(slot8, true)
		onButton(slot0, slot8, function ()
			if slot0 == "" then
				return
			end

			if slot0 == "OPEN_INFORM" then
				if not table.contains(getProxy(ChatProxy).informs, slot1.friend.id .. slot1.contextData.msg) then
					slot1:openInfromPanel()
				else
					pg.TipsMgr.GetInstance():ShowTips(i18n("chat_msg_inform"))
				end
			else
				slot1:emit(FriendInfoMediator[slot1.emit])
			end
		end)

		slot0.btnTFs[slot6] = slot8
	end

	setActive(slot0.btnTFs[5], slot0.contextData.msg)
	setButtonEnabled(slot0.btnTFs[2], not slot0.friendProxy.isFriend(slot5, slot0.friend.id))
	slot0:updateBlack()

	if slot0.contextData.form == NotificationLayer.FORM_BATTLE then
		setActive(slot0.btnTFs[3], false)

		slot0:findTF("frame").sizeDelta = Vector2(slot0.findTF("frame").sizeDelta.x, slot0.findTF("frame").sizeDelta.y - 66.7)
	end

	setActive(slot0:findTF("frame/left_bg", false))
end

slot0.openInfromPanel = function (slot0)
	setActive(slot0.informPanel, true)

	if not slot0.isInitInform then
		slot0.isInitInform = true

		slot0:initInform()
	end
end

slot0.initInform = function (slot0)
	slot0.informInfoForBackYard = {}
	slot1 = nil

	if slot0.contextData.backyardView then
		slot0.nameTF.text = i18n("inform_player", slot0.friend.name) .. i18n("backyard_theme_inform_them", slot0.contextData.msg)

		for slot6, slot7 in ipairs(slot1) do
			slot8 = cloneTplTo(slot0.buttonTpl, slot0.toggleContainer)
			slot8:Find("Label"):GetComponent("Text").text = slot7.content
			slot9 = false

			onButton(slot0, slot8, function ()
				slot0 = not slot0

				setActive(slot1:Find("Background/Checkmark"), setActive)

				if setActive then
					table.insert(slot2.informInfoForBackYard, slot3)
				elseif table.contains(slot2.informInfoForBackYard, slot3) then
					table.removebyvalue(slot2.informInfoForBackYard, slot3)
				end
			end)
		end
	else
		slot0.nameTF.text = i18n("inform_player", slot0.friend.name)
		slot3 = require("ShareCfg.informCfg")

		for slot6, slot7 in ipairs(slot1) do
			slot8 = cloneTplTo(slot0.toggleTpl, slot0.toggleContainer)
			slot8:Find("Label"):GetComponent("Text").text = slot7.content

			onToggle(slot0, slot8, function (slot0)
				if slot0 then
					slot0.informInfo = slot1.content
				end
			end)
		end
	end

	onButton(slot0, slot0.confirmBtn, function ()
		if not slot0.contextData.msg then
			pg.TipsMgr.GetInstance():ShowTips(i18n("inform_chat_msg"))

			return
		end

		if slot1 then
			if #slot0.informInfoForBackYard == 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("inform_select_type"))

				return
			end

			slot0:emit(FriendInfoMediator.INFORM_BACKYARD, slot0.friend.id, slot0.informInfoForBackYard, slot0.contextData.msg, slot0.friend.name)
		else
			if not slot0.informInfo then
				pg.TipsMgr.GetInstance():ShowTips(i18n("inform_select_type"))

				return
			end

			slot0:emit(FriendInfoMediator.INFORM, slot0.friend.id, slot0.informInfo, slot0.contextData.msg)
		end
	end)
	onButton(slot0, slot0.cancelBtn, function ()
		slot0:closeInfromPanel()
	end)
	onButton(slot0, slot0.backBtn, function ()
		slot0:closeInfromPanel()
	end)
end

slot0.closeInfromPanel = function (slot0)
	setActive(slot0.informPanel, false)

	slot0.informInfo = nil
end

slot0.initInfo = function (slot0)
	LoadSpriteAsync("qicon/" .. pg.ship_skin_template[pg.ship_data_statistics[slot0.friend.icon].skin_id].painting, function (slot0)
		if not IsNil(slot0.iconTF) then
			if not slot0 then
				slot0.iconTF.sprite = GetSpriteFromAtlas("heroicon/unknown", "")
			else
				slot0.iconTF.sprite = slot0
			end
		end
	end)

	slot3 = slot0.starsTF.childCount

	for slot7 = slot3, pg.ship_data_statistics[slot0.friend.icon].star - 1, 1 do
		cloneTplTo(slot0.starTF, slot0.starsTF)
	end

	for slot7 = 1, slot1.star, 1 do
		setActive(slot0.starsTF:GetChild(slot7 - 1), slot7 <= slot1.star)
	end

	slot0.playerNameTF.text = slot0.friend.name
	slot0.levelTF.text = slot0.friend.level
	slot4 = SeasonInfo.getMilitaryRank(slot0.friend.score, slot0.friend.rank)

	LoadImageSpriteAsync("emblem/" .. slot5, slot0.resumeEmblem)
end

slot0.updateBlack = function (slot0)
	setActive(findTF(slot0.btnTFs[4], "black"), not (slot0.friendProxy:getBlackPlayerById(slot0.friend.id) ~= nil))
	setActive(findTF(slot0.btnTFs[4], "unblack"), slot0.friendProxy.getBlackPlayerById(slot0.friend.id) ~= nil)
end

slot0.willExit = function (slot0)
	return
end

return slot0
