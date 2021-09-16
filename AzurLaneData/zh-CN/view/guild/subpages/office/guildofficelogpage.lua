slot0 = class("GuildOfficeLogPage", import("....base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "GuildOfficeLogPage"
end

slot0.OnLoaded = function (slot0)
	slot0.uilist = UIItemList.New(slot0:findTF("frame/window/sliders/list/content"), slot0:findTF("frame/window/sliders/list/content/tpl"))
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0._tf:Find("frame/window/top/btnBack"), function ()
		slot0:Close()
	end, SFX_PANEL)
	onButton(slot0, slot0._tf:Find("frame"), function ()
		slot0:Close()
	end, SFX_PANEL)
end

slot0.Show = function (slot0, slot1)
	slot0.guild = slot1

	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
	setActive(slot0._tf, true)
	slot0.uilist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			setText(slot2, slot0[slot1 + 1]:getText())
		end
	end)
	slot0.uilist.align(slot3, #slot1:getCapitalLogs())
end

slot0.Close = function (slot0)
	setActive(slot0._tf, false)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)
end

slot0.OnDestroy = function (slot0)
	slot0:Close()
end

return slot0
