slot0 = class("CommanderPlayPanel", import("...base.BasePanel"))

slot0.init = function (slot0)
	slot0.skillTF = slot0:findTF("skill/frame")
	slot0.skillNameTxt = slot0:findTF("name", slot0.skillTF):GetComponent(typeof(Text))
	slot0.skillIcon = slot0:findTF("icon/Image", slot0.skillTF)
	slot0.skilllvTxt = slot0:findTF("level_container/level", slot0.skillTF):GetComponent(typeof(Text))
	slot0.skillAdditionTxt = slot0:findTF("level_container/addition", slot0.skillTF):GetComponent(typeof(Text))
	slot0.expTxt = slot0:findTF("exp/Text", slot0.skillTF):GetComponent(typeof(Text))
	slot0.descBtn = slot0:findTF("skill/frame/desc")
	slot0.descPage = slot0:findTF("skill_desc")
	slot0.descToggle = slot0:findTF("tags", slot0.descPage)
	slot0.descToggleMark = slot0.descToggle:Find("sel")
	slot0.skillDescList = UIItemList.New(slot0:findTF("content/list", slot0.descPage), slot0:findTF("content/list/tpl", slot0.descPage))

	setActive(slot0.descPage, false)

	slot0.commanderLvTxt = slot0:findTF("select_panel/exp_bg/level_bg/Text"):GetComponent(typeof(Text))
	slot0.levelAdditonTxt = slot0:findTF("select_panel/exp_bg/level_bg/addition"):GetComponent(typeof(Text))
	slot0.preExpSlider = slot0:findTF("select_panel/exp_bg/slider"):GetComponent(typeof(Slider))
	slot0.expSlider = slot0:findTF("select_panel/exp_bg/slider/exp"):GetComponent(typeof(Slider))
	slot0.sliderExpTxt = slot0:findTF("select_panel/exp_bg/slider/Text"):GetComponent(typeof(Text))
	slot0.uilist = UIItemList.New(slot0:findTF("select_panel/frame/list"), slot0:findTF("select_panel/frame/list/commandeTF"))
	slot0.consumeTxt = slot0:findTF("select_panel/consume/Text"):GetComponent(typeof(Text))
	slot0.confirmBtn = slot0:findTF("select_panel/confirm_btn")

	onButton(nil, slot0.descBtn, function ()
		if slot0.isOpenDescPage then
			slot0:CloseDescPage()

			slot0.CloseDescPage.isOpenDescPage = false
		else
			slot0.isOpenDescPage = true

			slot0:UpdateDescPage()
			slot0.UpdateDescPage:emit(CommanderInfoMediator.ON_CLOSE_PANEL)
		end

		setActive(slot0.descBtn:Find("sel"), slot0.isOpenDescPage)
	end, SFX_PANEL)
	setActive(slot0.descBtn.Find(slot2, "sel"), false)

	slot0.commonFlag = true

	onButton(nil, slot0.descToggle, function ()
		slot0.commonFlag = not slot0.commonFlag

		setAnchoredPosition((not slot0.commonFlag or 0) and slot0.descToggleMark.rect.width.descToggleMark, {
			x = (not slot0.commonFlag or 0) and slot0.descToggleMark.rect.width
		})
		(not slot0.commonFlag or 0) and slot0.descToggleMark.rect.width:UpdateDescPage()
	end, SFX_PANEL)
end

slot0.update = function (slot0, slot1, slot2)
	slot0.commanderVO = slot1
	slot0.detailPage = slot2

	slot0:updateMatrtials(slot0.parent.contextData.materialIds or {}, skill)

	if slot0.isOpenDescPage then
		slot0:UpdateDescPage()
	end
end

slot0.updateMatrtials = function (slot0, slot1)
	slot0.uilist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot4 = slot2:Find("add")
			slot5 = slot2:Find("icon")

			if slot0[slot1 + 1] then
				onButton(slot1, slot5, function ()
					slot0 = table.indexof(table.indexof, )

					table.remove(slot0, slot0)
					slot0:updateMatrtials(slot0)
				end, SFX_PANEL)

				slot6 = getProxy(CommanderProxy).getCommanderById(slot6, slot3)

				GetImageSpriteFromAtlasAsync("commandericon/" .. slot6:getPainting(), "", slot5)
				setActive(slot5:Find("up"), slot1.commanderVO:isSameGroup(slot6.groupId))
				setActive(slot5:Find("formation"), slot6.inFleet)
				setText(slot5:Find("level_bg/Text"), slot6.level)
			else
				onButton(slot1, slot4, function ()
					if not slot0.commanderVO:getSkills()[1]:isMaxLevel() or not slot0.commanderVO:isMaxLevel() then
						slot0.parent:emit(CommanderInfoMediator.ON_SELECT)
					end
				end, SFX_PANEL)
			end

			setActive(slot4, not slot3)
			setActive(slot5, slot3)
		end
	end)
	slot0.uilist.align(slot2, CommanderConst.PLAY_MAX_COUNT)
	slot0:updateSkillTF(slot3)
	slot0:updateCommanderTF(slot2)
	slot0:updateConsume(slot1)
	setActive(go(slot0.skillAdditionTxt), #slot1 > 0)
	setActive(go(slot0.levelAdditonTxt), #slot1 > 0)
end

slot0.getSkillExpAndCommanderExp = function (slot0, slot1)
	slot2 = slot0
	slot3 = 0
	slot4 = 0
	slot5 = getProxy(CommanderProxy)

	for slot9, slot10 in pairs(slot1) do
		slot11 = slot5:getCommanderById(slot10)
		slot4 = slot4 + slot11:getDestoryedExp(slot2.groupId)
		slot3 = slot3 + slot11:getDestoryedSkillExp(slot2.groupId)
	end

	return math.floor(slot4), math.floor(slot3)
end

slot0.UpdateDescPage = function (slot0)
	setActive(slot0.descPage, true)

	slot4 = slot0.commanderVO.getSkills(slot1)[1].getConfig(slot2, "lv")

	slot0.skillDescList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setText(slot2, "<color=" .. ((slot0[slot1 + 1].lv <= slot2 and "#66472a") or "#a3a2a2") .. ">" .. slot1:GetDesc(slot1.commonFlag, slot0[slot1 + 1]) .. "</color>" .. ((slot2 < slot3.lv and "(Lv." .. slot3.lv .. i18n("word_take_effect") .. ")") or ""))
			setText(slot2:Find("level"), "<color=" .. ((slot0[slot1 + 1].lv <= slot2 and "#66472a") or "#a3a2a2") .. ">" .. "Lv." .. slot3.lv .. "</color>")
		end
	end)
	slot0.skillDescList.align(slot5, #slot0.commanderVO.getSkills(slot1)[1].GetSkillGroup(slot2))
end

slot0.GetDesc = function (slot0, slot1, slot2)
	if not slot1 and slot2.desc_world and slot2.desc_world ~= "" then
		return slot2.desc_world
	else
		return slot2.desc
	end
end

slot0.CloseDescPage = function (slot0)
	setActive(slot0.descPage, false)
end

slot0.updateSkillTF = function (slot0, slot1)
	slot5 = Clone(slot4)

	slot5:addExp(slot1)

	slot6 = slot0.commanderVO.getSkills(slot2)[1].getConfig(slot4, "lv")
	slot0.skillNameTxt.text = slot0.commanderVO.getSkills(slot2)[1].getConfig(slot4, "name")

	GetImageSpriteFromAtlasAsync("CommanderSkillIcon/" .. slot0.commanderVO.getSkills(slot2)[1].getConfig(slot4, "icon"), "", slot0.skillIcon)

	slot0.skilllvTxt.text = "Lv." .. slot0.commanderVO.getSkills(slot2)[1].getLevel(slot4)
	slot0.skillAdditionTxt.text = "+" .. slot5:getLevel() - slot0.commanderVO.getSkills(slot2)[1]:getLevel()

	if slot0.commanderVO.getSkills(slot2)[1]:isMaxLevel() then
		slot0.expTxt.text = "0/0"
	else
		slot0.expTxt.text = slot4.exp .. ((slot1 == 0 and "") or "<color=#A9F548FF>(+" .. slot1 .. ")</color>") .. "/" .. slot4:getNextLevelExp()
	end

	slot0.expOverflow = false

	if slot5:isMaxLevel() and slot5.exp > 0 and not slot4:isMaxLevel() then
		slot0.expOverflow = true
	end
end

slot0.updateCommanderTF = function (slot0, slot1)
	slot3 = Clone(slot2)

	slot3:addExp(slot1)
	slot0.detailPage:ActionInvoke("updatePreView", slot3)

	slot0.commanderLvTxt.text = "LV." .. slot0.commanderVO.level

	if slot0.commanderVO:isMaxLevel() then
		slot0.expSlider.value = 1
		slot0.sliderExpTxt.text = "EXP: +0/MAX"
		slot0.preExpSlider.value = 1
		slot0.levelAdditonTxt.text = "+0"
	else
		slot0.expSlider.value = slot2.exp / slot2:getNextLevelExp()
		slot0.sliderExpTxt.text = "EXP: " .. ((slot1 > 0 and "<color=#A9F548FF>" .. slot2.exp + slot1 .. "</color>") or slot2.exp) .. "/" .. slot2:getNextLevelExp()

		if slot3:isMaxLevel() then
			slot0.preExpSlider.value = 1
		else
			slot0.preExpSlider.value = slot3.exp / slot3:getNextLevelExp()
		end

		slot0.levelAdditonTxt.text = "+" .. slot3.level - slot2.level
	end
end

slot0.updateConsume = function (slot0, slot1)
	slot0.total = slot0:calcConsume(slot1)
	slot0.consumeTxt.text = (slot0.parent.playerVO.gold < slot0.total and "<color=" .. COLOR_RED .. ">" .. slot0.total .. "</color>") or slot0.total

	function slot3()
		if _.any(getProxy(CommanderProxy), function (slot0)
			return slot0:getCommanderById(slot0).getRarity(slot1) >= 5
		end) then
			return true
		end

		return false
	end

	function slot4()
		if slot0.parent.playerVO.gold < slot0.total then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
				{
					59001,
					slot0.total - slot0.gold,
					slot0.total
				}
			})

			return
		end

		slot0.parent:emit(CommanderInfoMediator.ON_UPGRADE, slot0.commanderVO.id, slot0.commanderVO:getSkills(), slot0.commanderVO.getSkills()[1].id)
	end

	function slot5()
		if slot0() then
			table.insert(slot0, i18n("commander_material_is_rarity"))
		end

		if slot1.expOverflow then
			table.insert(slot0, i18n("commander_exp_overflow_tip"))
		end

		if slot1.commanderVO:isMaxLevel() then
			table.insert(slot0, i18n("commander_material_is_maxLevel"))
		end

		return slot0
	end

	onButton(slot0, slot0.confirmBtn, function ()
		if slot0 and #slot0 > 0 then
			slot1 = {}

			for slot5, slot6 in ipairs(slot0) do
				table.insert(slot1, function (slot0)
					slot0.parent:openMsgBox({
						content = slot1,
						onYes = function ()
							onNextTick(onNextTick)
						end
					})
				end)
			end

			seriesAsync(slot1, )
		end
	end, SFX_PANEL)
end

slot0.calcConsume = function (slot0, slot1)
	slot2 = getProxy(CommanderProxy)
	slot3 = 0

	for slot7, slot8 in ipairs(slot1) do
		slot3 = slot3 + slot2:getCommanderById(slot8):getUpgradeConsume()
	end

	return slot3
end

slot1 = 0.3

slot0.playAnim = function (slot0, slot1, slot2, slot3)
	slot0.preExpSlider.value = 0

	function slot5()
		TweenValue(go(slot1.expSlider), 0, slot0.exp, , 0, function (slot0)
			slot0.expSlider.value = slot0 / slot1
		end, function ()
			slot0:update(slot0, slot0.detailPage)

			if slot0 then
				slot2()
			end
		end)
	end

	if slot2.level - slot1.level > 0 then
		TweenValue(go(slot0.expSlider), slot1.exp, slot1.getNextLevelExp(slot1), slot0, 0, function (slot0)
			slot0.expSlider.value = slot0
		end, function ()
			if slot0 - 1 > 0 then
				TweenValue(go(slot1.expSlider), 0, 1, , 0, function (slot0)
					slot0.expSlider.value = slot0
				end, function ()
					if slot0 - 1 == 0 then
						slot1()
					end
				end, TweenValue)
			else
				slot3()
			end
		end)
	else
		slot6 = slot1.getNextLevelExp(slot1)

		TweenValue(go(slot0.expSlider), slot1.exp, slot2.exp, slot0, 0, function (slot0)
			slot0.expSlider.value = slot0 / slot1
		end, function ()
			slot0:update(slot0, slot0.detailPage)

			if slot0 then
				slot2()
			end
		end)
	end
end

slot0.ClosePanel = function (slot0)
	if slot0.isOpenDescPage then
		slot0:CloseDescPage()

		slot0.isOpenDescPage = nil
	end
end

slot0.exit = function (slot0)
	removeOnButton(slot0.descBtn)
	removeOnButton(slot0.descToggle)
end

return slot0
