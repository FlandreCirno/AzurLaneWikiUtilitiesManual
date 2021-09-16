slot0 = class("ActivityBossAisaikesiScene", import(".ActivityBossSceneTemplate"))
slot0.ASKSRemasterStage = 1201204

slot0.getUIName = function (slot0)
	return "ActivityBossAisaikesiUI"
end

slot0.init = function (slot0)
	slot0.super.init(slot0)

	slot0.loader = AutoLoader.New()
end

slot0.didEnter = function (slot0)
	slot0.super.didEnter(slot0)

	slot1 = 0

	onButton(slot0, slot0.mainTF:Find("logo"), function ()
		if slot0 + 1 >= 10 then
			slot1:RemasterSuffering()

			slot0 = 0

			return
		end

		pg.TipsMgr.GetInstance():ShowTips(10 - slot0)
	end)
end

slot0.UpdatePage = function (slot0)
	slot0.super.UpdatePage(slot0)
end

slot0.EnterAnim = function (slot0)
	function slot1()
		slot0.super.EnterAnim(slot1)
		slot1.loader:GetPrefab("ui/ASKS_Loop", "", function (slot0)
			setParent(slot0, slot0.mainTF)
			setAnchoredPosition(slot0, {
				x = -154.7,
				y = -120.9
			})
			tf(slot0):SetAsFirstSibling()

			slot0.raidarAnim = slot0

			setActive(slot0, true)
		end)
	end

	if not slot0.contextData.showAni then
		slot1()

		return
	end

	slot0.contextData.showAni = nil

	setActive(slot2, false)

	slot3 = nil

	function slot4()
		setActive(setActive, true)
		setActive(setActive, false)
		slot2.loader:ReturnPrefab(slot2.loader)
	end

	slot0.loader.GetPrefab(slot5, "ui/asks", "asks", function (slot0)
		setParent(slot0, slot0._tf)

		slot1 = slot0
		slot1 = nil
		slot2 = slot0:GetComponent("DftAniEvent")

		slot2:SetEndEvent(slot2)
		slot2:SetTriggerEvent(function ()
			slot0()

			slot1 = true
		end)
		onButton(slot0, slot0, function ()
			slot0 = slot0 or slot1() or true
			slot0 = slot0

			slot2()
		end)
	end)
end

slot0.RemasterSuffering = function (slot0)
	slot1 = GameObject.New("Mask")
	slot2 = slot1:AddComponent(typeof(RectTransform))
	slot2.anchorMin = Vector2.zero
	slot2.anchorMax = Vector2.one
	slot1:AddComponent(typeof(Image)).color = Color.New(0, 0, 0, 1)
	slot1.AddComponent(typeof(Image)).raycastTarget = false

	slot2:SetParent(slot0._tf)
	pg.NewStoryMgr.GetInstance():Play("AISAIKESICAIDAN", function ()
		slot0:emit(slot0.contextData.mediatorClass.ON_PERFORM_COMBAT, slot0.ASKSRemasterStage)
	end)
end

slot0.willExit = function (slot0)
	slot0.loader:Clear()
	slot0.super.willExit(slot0)
end

return slot0
