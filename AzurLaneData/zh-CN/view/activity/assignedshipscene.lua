slot0 = class("AssignedShipScene", import("..base.BaseUI"))
slot0.TipWords = {
	login_year = "nine_choose_one",
	login_santa = "five_choose_one",
	shrine_year = "seven_choose_one",
	greeting_year = "spring_invited_2021"
}

slot0.setItemVO = function (slot0, slot1)
	slot0.itemVO = slot1
	slot2 = slot0.itemVO:getTempCfgTable()
	slot0.idList = slot2.usage_arg
	slot0.shipIdList = underscore.map(slot0.idList, function (slot0)
		return pg.item_usage_invitation[slot0].ship_id
	end)
	slot0.style = slot2.open_ui[1]
	slot0.title = slot2.open_ui[2]
	slot0.strTip = slot0.TipWords[slot0.style]
end

slot0.init = function (slot0)
	slot1 = slot0._tf:Find("layer")
	slot0.backBtn = slot1:Find("back")
	slot0.confirmBtn = slot1:Find("confirm")
	slot0.print = slot1:Find("print")
	slot0.rtName = slot1:Find("name")
	slot0.rtTitle = slot1:Find("title")
	slot0.selectPanel = slot1:Find("select_panel/layout")
	slot0.itemList = UIItemList.New(slot0.selectPanel, slot0.selectPanel:Find("item"))

	slot0.itemList:make(function (slot0, slot1, slot2)
		slot3 = slot0.shipIdList[slot1 + 1]

		if slot0 == UIItemList.EventUpdate then
			GetImageSpriteFromAtlasAsync("extra_page/" .. slot0.style .. "/i_" .. slot3, "", slot2)
			GetImageSpriteFromAtlasAsync("extra_page/" .. slot0.style .. "/is_" .. slot3, "", slot2:Find("selected"))
			onToggle(slot0, slot2, function (slot0)
				if slot0 and slot0.selectTarget ~=  then
					LeanTween.cancel(slot0.print)

					if slot0.rtName then
						LeanTween.cancel(slot0.rtName)
					end

					slot0:setSelectTarget(slot0.setSelectTarget)
				end
			end, SFX_PANEL)
		end
	end)

	slot0.selectTarget = nil
	slot0.count = 1
	slot0.spList = {}
	slot0.afterAnima = {}
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0.backBtn, function ()
		slot0:emit(slot1.ON_BACK)
	end, SOUND_BACK)
	onButton(slot0, slot0.confirmBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n(slot0.strTip, pg.ship_data_statistics[slot0.selectedShipNumber].name),
			onYes = function ()
				slot0:emit(AssignedShipMediator.ON_USE_ITEM, slot0.itemVO.id, slot0.count, {
					slot0.idList[slot0.selectTarget]
				})
			end
		})
	end, SFX_PANEL)
	slot0.itemList.align(slot1, #slot0.idList)
	setActive(slot0.rtTitle, slot0.title)

	if slot0.title then
		GetImageSpriteFromAtlasAsync("extra_page/" .. slot0.style .. "/" .. slot0.title, "", slot0.rtTitle, true)
	end

	triggerToggle(slot0.selectPanel:GetChild(0), true)
end

slot0.checkAndSetSprite = function (slot0, slot1, slot2)
	if slot0.spList[slot1] and slot0.afterAnima[slot1] then
		setImageSprite(slot2, slot0.spList[slot1], true)

		slot2:GetComponent(typeof(Image)).enabled = true
		slot0.spList[slot1] = nil
		slot0.afterAnima[slot1] = nil

		LeanTween.alpha(slot2, 1, 0.3):setFrom(0)
	end
end

slot0.changeShowCharacter = function (slot0, slot1, slot2, slot3)
	if slot3 then
		LeanTween.alpha(rtf(slot2), 0, 0.3):setOnComplete(System.Action(function ()
			slot0:GetComponent(typeof(Image)).enabled = false
			slot1.afterAnima[typeof] = true

			typeof:checkAndSetSprite(true, typeof.checkAndSetSprite)
		end))
	else
		slot2.GetComponent(slot2, typeof(Image)).enabled = false
		slot0.afterAnima[slot1] = true
	end

	GetSpriteFromAtlasAsync("extra_page/" .. slot0.style .. "/" .. slot1, "", function (slot0)
		slot0.spList[] = slot0

		slot0:checkAndSetSprite(slot0.checkAndSetSprite, slot0)
	end)
end

slot0.setSelectTarget = function (slot0, slot1)
	slot0:changeShowCharacter("p_" .. slot0.shipIdList[slot1], slot0.print, slot0.selectTarget)

	if slot0.rtName then
		slot0:changeShowCharacter("n_" .. slot0.shipIdList[slot1], slot0.rtName, slot0.selectTarget)
	end

	slot0.selectTarget = slot1
	slot0.selectedShipNumber = slot0.shipIdList[slot1]
end

slot0.willExit = function (slot0)
	return
end

return slot0
