slot0 = class("LevelStageDOAFeverPanel", import("view.base.BaseSubPanel"))

slot0.GetUIName = function (slot0)
	return "LevelStageDOAFeverPanel"
end

slot0.OnInit = function (slot0)
	slot0.fillImg = slot0._tf:Find("Fill")
	slot0.maxImg = slot0._tf:Find("Max")

	setActive(slot0.maxImg, false)

	slot0.ratioText = slot0._tf:Find("Text")
	slot0.banner = slot0._tf:Find("Banner")

	setActive(slot0.banner, false)
	cloneTplTo(GetComponent(slot0._tf, typeof(ItemList)).prefabItem[0], slot0.fillImg, "Anim")

	slot0.fillAnim = slot0.fillImg:GetChild(0)

	cloneTplTo(GetComponent(slot0._tf, typeof(ItemList)).prefabItem[1], slot0.maxImg)
end

slot0.UpdateView = function (slot0, slot1, slot2)
	slot5 = slot1.defeatEnemies / pg.gameset.doa_fever_count.key_value
	slot6 = pg.gameset.doa_fever_count.key_value <= slot1.defeatEnemies

	seriesAsync({
		function (slot0)
			LeanTween.cancel(go(slot0.fillImg), true)

			if not LeanTween.cancel or slot3 < slot2 then
				slot0()

				return
			end

			setActive(slot0.maxImg, false)
			setActive(slot0.fillImg, true)
			setActive(slot0.ratioText, true)
			setActive(slot0.fillAnim, true)

			slot1 = math.max(slot0.fillAnim - 1, 0)
			slot2 = slot0.fillImg:GetComponent(typeof(Image))
			slot4 = slot0.fillImg.rect.height
			slot5 = slot0.fillAnim.rect.height
			slot6 = 3.115264797507788

			LeanTween.value(go(slot0.fillImg), 0, 1, 1):setOnUpdate(System.Action_float(function (slot0)
				slot4.fillAnim.anchoredPosition = Vector2(0, slot2)
				slot4.fillAnim.sizeDelta = Vector2(slot3, slot4)
				slot8.fillAmount = Mathf.Lerp(slot0, Mathf.Lerp, slot0) / slot0

				setText(slot4.ratioText, string.format("%02d.%d%%", math.floor(Mathf.Lerp(slot0, Mathf.Lerp, slot0) / slot0 * 100), math.round(Mathf.Lerp(slot0, Mathf.Lerp, slot0) / slot0 * 1000) % 10))
			end)).setOnComplete(slot7, System.Action(slot0))
		end,
		function (slot0)
			setActive(slot0.fillImg, not slot1)
			setActive(slot0.ratioText, not slot1)
			setActive(slot0.maxImg, setActive)
			setActive(slot0.fillAnim, false)

			slot0.fillImg:GetComponent(typeof(Image)).fillAmount = slot0.fillImg

			setText(slot0.ratioText, string.format("%02d.%d%%", math.floor(slot2 * 100), math.round(slot2 * 1000) % 10))

			if string.format and slot4 == slot5 then
				slot0.viewParent:emit(LevelUIConst.FROZEN)
				pg.UIMgr.GetInstance():OverlayPanel(slot0.banner)

				slot1 = slot0.banner:Find("Main/Painting")

				setImageSprite(slot1, LoadSprite("ui/LevelStageDOAFeverPanel_atlas", tostring(slot3)), true)
				setActive(slot0.banner, true)

				slot1:GetComponent(typeof(Image)).enabled = true

				slot0.banner.GetComponent(slot5, typeof(DftAniEvent)).SetEndEvent(slot5, slot4)
				onButton(slot0, slot0.banner, function ()
					slot0.enabled = false
					slot0.sprite = nil

					pg.UIMgr.GetInstance():UnOverlayPanel(slot1.banner, slot1._tf)
					setActive(pg.UIMgr.GetInstance().banner, false)
					slot1.viewParent:emit(LevelUIConst.UN_FROZEN)
				end)
			end
		end
	})
end

return slot0
