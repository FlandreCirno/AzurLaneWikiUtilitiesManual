slot0 = class("WorldAchAwardSubview", import("view.base.BaseSubView"))
slot0.ShowDrop = "WorldAchAwardSubview.ShowDrop"

slot0.getUIName = function (slot0)
	return "WorldAchAwardSubview"
end

slot0.OnLoaded = function (slot0)
	return
end

slot0.OnInit = function (slot0)
	slot0.textTitle = slot0._tf:Find("title/Text")
	slot0.btnBG = slot0._tf:Find("bg")
	slot0.itemContent = slot0._tf:Find("award_list/content")
	slot0.itemList = UIItemList.New(slot0.itemContent, slot0.itemContent:Find("item"))

	slot0.itemList:make(function (slot0, slot1, slot2)
		slot1 = slot1 + 1

		if slot0 == UIItemList.EventUpdate then
			slot7 = slot2:Find("award")

			setActive(slot7, true)
			setActive(slot2:Find("lock_award"), false)
			updateDrop(slot7, slot0.awards[slot1].drop)
			setGray(slot7:Find("icon_bg"), not slot0.nextStar or slot0.awards[slot1].star < slot0.nextStar or (slot0.nextStar and slot0.nextStar < slot0.awards[slot1].star))
			onButton(slot0, slot7, function ()
				slot0:emit(slot1.ShowDrop, slot2.drop)
			end, SFX_PANEL)
			setText(slot2.Find(slot2, "star/count"), slot0.awards[slot1].star)
			setActive(slot2:Find("star/bg_on"), slot0.nextStar and slot0.awards[slot1].star == slot0.nextStar)
			setActive(slot2:Find("star/bg_off"), not (slot0.nextStar and slot0.awards[slot1].star == slot0.nextStar))
			setActive(slot2:Find("star/lock"), slot0.nextStar and slot0.nextStar < slot0.awards[slot1].star)
			setActive(slot2:Find("ready_mark"), slot0.nextStar and slot0.awards[slot1].star == slot0.nextStar and not (not slot0.nextStar or slot0.awards[slot1].star < slot0.nextStar) and not slot0.hasAward)
			setActive(slot2:Find("get_mark"), slot0.nextStar and slot0.awards[slot1].star == slot0.nextStar and slot0.hasAward)
			setActive(slot2:Find("got_mark"), not slot0.nextStar or slot0.awards[slot1].star < slot0.nextStar)
			setActive(slot2:Find("lock_mark"), slot0.nextStar and slot0.nextStar < slot0.awards[slot1].star)
			setActive(slot2:Find("mark/on"), not slot0.nextStar or slot0.awards[slot1].star < slot0.nextStar)
			setActive(slot2:Find("mark/off"), not (not slot0.nextStar or slot0.awards[slot1].star < slot0.nextStar))
		end
	end)
	onButton(slot0, slot0.btnBG, function ()
		slot0:Hide()
	end, SFX_PANEL)
end

slot0.OnDestroy = function (slot0)
	return
end

slot0.Show = function (slot0)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
	setActive(slot0._tf, true)
end

slot0.Hide = function (slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)
	setActive(slot0._tf, false)
end

slot0.isShowing = function (slot0)
	return slot0._tf and isActive(slot0._tf)
end

slot0.Setup = function (slot0, slot1)
	slot0.awards = slot1:GetAchievementAwards()
	slot0.hasAward, slot3 = nowWorld:AnyUnachievedAchievement(slot1)
	slot0.nextStar = (slot3 and slot3.star) or nil

	slot0.itemList:align(#slot0.awards)
	setText(slot0._tf:Find("title/Text"), slot1:GetBaseMap():GetName())
end

return slot0
