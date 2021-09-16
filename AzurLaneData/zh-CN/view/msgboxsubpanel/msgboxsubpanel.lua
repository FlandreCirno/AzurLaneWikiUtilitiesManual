slot0 = class("MsgboxSubPanel", BaseSubPanel)
slot0.NeedAsyncLoading = false

slot0.SetWindowSize = function (slot0, slot1)
	setSizeDelta(slot0.viewParent._window, slot1)
end

slot0.UpdateView = function (slot0, slot1)
	slot0:PreRefresh(slot1)
	slot0:OnRefresh(slot1)
	slot0:PostRefresh(slot1)
end

slot0.PreRefresh = function (slot0, slot1)
	slot0.viewParent:commonSetting(slot1)
	slot0:Show()
end

slot0.PostRefresh = function (slot0, slot1)
	slot0.viewParent:Loaded(slot1)
end

slot0.OnRefresh = function (slot0)
	return
end

slot0.CloseView = function (slot0)
	pg.MsgboxMgr.GetInstance():hide()
end

return slot0
