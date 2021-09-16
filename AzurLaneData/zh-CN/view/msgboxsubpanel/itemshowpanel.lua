slot0 = class("ItemShowPanel", import(".MsgboxSubPanel"))

slot0.GetUIName = function (slot0)
	return "ItemChangeNoticeBox"
end

slot0.UpdateView = function (slot0, slot1)
	slot0:PreRefresh(slot1)

	rtf(slot0.viewParent._window).sizeDelta = Vector2.New(1000, 638)

	slot0:PostRefresh(slot1)
end

return slot0
