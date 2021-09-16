slot0 = class("LevelStageIMasFeverPanel", import("view.base.BaseSubPanel"))

slot0.GetUIName = function (slot0)
	return "LevelStageIMasFeverPanel"
end

slot0.OnInit = function (slot0)
	slot0.fillImg = slot0._tf:Find("Fill")
	slot0.banner = slot0._tf:Find("Banner")

	setActive(slot0.banner, false)
end

slot1 = {
	[0] = 0,
	0.38,
	0.5471839,
	0.7228736,
	1
}
slot2 = {
	"Yellow",
	"Red",
	"Blue"
}

slot0.UpdateView = function (slot0, slot1, slot2)
	slot5 = slot0[Mathf.Min(pg.gameset.doa_fever_count.key_value, slot1.defeatEnemies)]
	slot6 = pg.gameset.doa_fever_count.key_value <= slot1.defeatEnemies

	seriesAsync({
		function (slot0)
			LeanTween.cancel(go(slot0.fillImg))

			if not LeanTween.cancel or slot3 < slot2 then
				slot0()

				return
			end

			slot3 = slot4[math.max(slot0.fillImg:GetComponent(typeof(Image)) - 1, 0)]

			LeanTween.value(go(slot0.fillImg), 0, 1, 1):setOnUpdate(System.Action_float(function (slot0)
				slot0.fillAmount = Mathf.Lerp(slot0, Mathf.Lerp, slot0)
			end)).setOnComplete(slot4, System.Action(slot0))
		end,
		function (slot0)
			slot0.fillImg:GetComponent(typeof(Image)).fillAmount = slot0.fillImg.GetComponent(typeof(Image))

			if slot0.fillImg.GetComponent(typeof(Image)) and slot3 == slot4 then
				slot0:ShowPanel(slot5)
			end
		end
	})
end

slot0.ShowPanel = function (slot0, slot1)
	slot0.viewParent:emit(LevelUIConst.FROZEN)
	pg.UIMgr.GetInstance():OverlayPanel(slot0.banner)

	slot2 = slot0[1]

	if slot1:GetBuffOfLinkAct() then
		slot2 = slot0[table.indexof(pg.gameset.doa_fever_buff.description, slot3)]
	end

	slot4 = slot0.banner:Find(slot2)
	slot5 = slot4:Find("Character")

	setImageSprite(slot5, LoadSprite("ui/LevelStageIMasFeverPanel_atlas", "character" .. tostring(math.random(1, 7))))
	setActive(slot0.banner, true)
	setActive(slot4, true)

	slot5:GetComponent(typeof(Image)).enabled = true

	slot4.GetComponent(slot4, typeof(DftAniEvent)).SetEndEvent(slot9, slot8)
	onButton(slot0, slot0.banner, function ()
		slot0:ClosePanel()
	end)

	slot0.showingPanel = true
end

slot0.ClosePanel = function (slot0)
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0.banner, slot0._tf)
	setActive(slot0.banner, false)
	slot0.viewParent:emit(LevelUIConst.UN_FROZEN)

	slot0.showingPanel = nil
end

slot0.OnDestroy = function (slot0)
	if slot0.showingPanel then
		slot0:ClosePanel()
	end
end

return slot0
