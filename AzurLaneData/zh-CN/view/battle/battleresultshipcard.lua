slot0 = class("BattleResultShipCard")

slot0.Ctor = function (slot0, slot1)
	slot0._expTF = slot1

	slot0:init()
end

slot0.init = function (slot0)
	slot0._expContent = findTF(slot0._expTF, "content")
	slot0._expInfo = findTF(slot0._expContent, "exp")
	slot0._nameTxt = findTF(slot0._expContent, "info/name_mask/name")
	slot0._intimacyUpFX = findTF(slot0._expContent, "heartsfly")
	slot0._intimacyDownFX = findTF(slot0._expContent, "heartsbroken")
	slot0._lvText = findTF(slot0._expContent, "dockyard/lv/Text")
	slot0._lvUp = findTF(slot0._expContent, "dockyard/lv_bg/levelUpLabel")
	slot0._lvFX = findTF(slot0._expContent, "dockyard/lv_bg/levelup")
	slot0._expText = findTF(slot0._expInfo, "exp_text")
	slot0._expProgress = findTF(slot0._expInfo, "exp_progress")
	slot0._expImage = slot0._expProgress:GetComponent(typeof(Image))
	slot0._expBuff = findTF(slot0._expInfo, "exp_buff")

	slot0._expTF:GetComponent(typeof(DftAniEvent)).SetTriggerEvent(slot1, function (slot0)
		slot0:expAnimation()
	end)
	SetActive(slot0._expTF, false)
end

slot0.SetShipVO = function (slot0, slot1, slot2, slot3, slot4)
	flushShipCard(slot0._expTF, slot1)

	slot0._oldShipVO = slot1
	slot0._newShipVO = slot2
	slot0._isMVP = slot3
	slot0._buffName = slot4

	slot0:setShipInfo()
end

slot0.RegisterPreEXPTF = function (slot0, slot1)
	slot1:GetTF():GetComponent(typeof(DftAniEvent)):SetEndEvent(function (slot0)
		setActive(slot0._expTF, true)
	end)
end

slot0.ConfigCallback = function (slot0, slot1)
	slot0._expTF:GetComponent(typeof(DftAniEvent)):SetEndEvent(function (slot0)
		slot0()
	end)
end

slot0.setShipInfo = function (slot0)
	setScrollText(slot0._nameTxt, slot0._oldShipVO:getName())
	setActive(findTF(slot0._expContent, "mvp"), slot0._isMVP)
	SetActive(slot0._expBuff, slot0._buffName ~= nil)
	setText(slot0._expBuff, slot0._buffName or "")
end

slot0.expAnimation = function (slot0)
	SetActive(slot0._expInfo, true)
	SetActive(slot0._intimacyUpFX, slot0._oldShipVO:getIntimacy() < slot0._newShipVO:getIntimacy())
	SetActive(slot0._intimacyDownFX, slot0._newShipVO:getIntimacy() < slot0._oldShipVO:getIntimacy())

	slot0._expImage.fillAmount = slot0._oldShipVO:getExp() / getExpByRarityFromLv1(SetActive, slot0._oldShipVO.level)

	if slot0._oldShipVO.level < slot0._newShipVO.level then
		slot3 = 0

		for slot7 = slot0._oldShipVO.level, slot0._newShipVO.level - 1, 1 do
			slot3 = slot3 + getExpByRarityFromLv1(slot1, slot7)
		end

		slot0.playAnimation(slot0._expTF, 0, (slot3 + slot0._newShipVO:getExp()) - slot0._oldShipVO:getExp(), 1, 0, function (slot0)
			setText(slot0._expText, "+" .. math.ceil(slot0))
		end)

		slot0._animationLV = slot0._oldShipVO.level

		slot0.loopAnimation(slot0, slot0._oldShipVO:getExp() / slot2, 1, 0.7, true)
	else
		setText(slot0._expText, "+" .. math.ceil(slot0._newShipVO:getExp() - slot0._oldShipVO:getExp()))

		if slot0._oldShipVO.level == slot0._oldShipVO:getMaxLevel() then
			slot0._expImage.fillAmount = 1

			return
		end

		slot0.playAnimation(slot0._expTF, slot0._oldShipVO:getExp() / slot2, slot0._newShipVO:getExp() / slot2, 1, 0, function (slot0)
			slot0._expImage.fillAmount = slot0
		end)
	end
end

slot0.loopAnimation = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = getExpByRarityFromLv1(slot0._oldShipVO:getConfig("rarity"), slot0._newShipVO.level)

	LeanTween.value(go(slot0._expTF), slot1, slot2, slot3):setOnUpdate(System.Action_float(function (slot0)
		slot0._expImage.fillAmount = slot0
	end)).setOnComplete(slot6, System.Action(function ()
		slot0._animationLV = slot0._animationLV + 1

		if slot0._animationLV + 1 then
			slot0:levelUpEffect()
		end

		if slot0._newShipVO.level == slot0._animationLV then
			if slot0._animationLV == slot0._newShipVO:getMaxLevel() then
				slot0._expImage.fillAmount = 1
			else
				slot0:loopAnimation(0, slot0._newShipVO:getExp() / slot2, 1, false)
			end
		elseif slot0._animationLV < slot0._newShipVO.level then
			slot0:loopAnimation(0, 1, 0.7, true)
		end
	end))
end

slot0.levelUpEffect = function (slot0)
	SetActive(slot0._lvUp, true)
	SetActive(slot0._lvFX, true)
	LeanTween.moveY(rtf(slot0._lvUp), slot0._lvUp.localPosition.y + 30, 0.5):setOnComplete(System.Action(function ()
		SetActive(slot0._lvUp, false)

		SetActive._lvUp.localPosition = slot0._lvUp

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BOAT_LEVEL_UP)
	end))

	if slot0._animationLV <= slot0._newShipVO.level then
		setText(slot0._lvText, slot0._animationLV)
	end
end

slot0.Play = function (slot0)
	setActive(slot0._expTF, true)
end

slot0.SkipAnimation = function (slot0)
	slot0._expTF:GetComponent(typeof(Animator)).enabled = false

	SetActive(slot0._expTF, true)
	SetActive(slot0._expContent, true)
	SetActive(slot0._expInfo, true)

	slot0._expTF:GetComponent(typeof(CanvasGroup)).alpha = 1

	LeanTween.cancel(go(slot0._lvUp))
	LeanTween.cancel(go(slot0._expTF))
	SetActive(slot0._intimacyUpFX, slot0._oldShipVO:getIntimacy() < slot0._newShipVO:getIntimacy())
	SetActive(slot0._intimacyDownFX, slot0._newShipVO:getIntimacy() < slot0._oldShipVO:getIntimacy())

	slot0._expContent.localPosition = Vector3(0, 0, 0)

	setText(slot0._lvText, slot0._newShipVO.level)

	if slot0._oldShipVO.level == slot0._oldShipVO:getMaxLevel() then
		setText(slot0._expText, "+" .. math.ceil(slot0._newShipVO:getExp() - slot0._oldShipVO:getExp()))

		slot0._expImage.fillAmount = 1
	else
		slot1 = slot0._oldShipVO:getConfig("rarity")

		if slot0._oldShipVO.level < slot0._newShipVO.level then
			slot2 = 0

			for slot6 = slot0._oldShipVO.level, slot0._newShipVO.level - 1, 1 do
				slot2 = slot2 + getExpByRarityFromLv1(slot1, slot6)
			end

			setText(slot0._expText, "+" .. (slot2 + slot0._newShipVO:getExp()) - slot0._oldShipVO:getExp())
		else
			setText(slot0._expText, "+" .. math.ceil(slot0._newShipVO:getExp() - slot0._oldShipVO:getExp()))
		end

		slot0._expImage.fillAmount = slot0._newShipVO:getExp() / getExpByRarityFromLv1(slot1, slot0._newShipVO.level)
	end

	SetActive(slot0._lvUp, false)
end

slot0.GetTF = function (slot0)
	return slot0._expTF
end

slot0.playAnimation = function (slot0, slot1, slot2, slot3, slot4, slot5)
	LeanTween.value(slot0.gameObject, slot1, slot2, slot3):setDelay(slot4):setOnUpdate(System.Action_float(function (slot0)
		slot0(slot0)
	end))
end

slot0.Dispose = function (slot0)
	slot0._oldShipVO = nil
	slot0._newShipVO = nil
end

return slot0
