slot0 = class("GuildOfficeSelectTaskPage", import("...base.GuildBasePage"))

slot0.getTargetUI = function (slot0)
	return "GuildTaskSelectBluePage", "GuildTaskSelectRedPage"
end

slot0.OnLoaded = function (slot0)
	slot0.uilist = UIItemList.New(slot0:findTF("frame/bg/scrollrect/content"), slot0:findTF("frame/bg/scrollrect/content/tpl"))
	slot0.closeBtn = slot0._tf:Find("frame/title/close")
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0._tf, function ()
		slot0:Close()
	end, SFX_PANEL)
	onButton(slot0, slot0.closeBtn, function ()
		slot0:Close()
	end, SFX_PANEL)
end

slot0.Show = function (slot0, slot1, slot2)
	slot0.guild = slot1
	slot0.isAdmin = slot2

	setActive(slot0._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
	slot0._tf:SetAsLastSibling()
	slot0:Update()
end

slot0.Update = function (slot0)
	slot0.uilist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			onButton(slot1, GuildTaskCard.New(slot2).acceptBtn, function ()
				pg.MsgboxMgr:GetInstance():ShowMsgBox({
					content = i18n("guild_task_selecte_tip", slot0:getConfig("name")),
					onYes = function ()
						slot0:emit(GuildOfficeMediator.ON_SELECT_TASK, slot1.task.id)
						slot0.emit:Close()
					end
				})
			end, SFX_PANEL)
			GuildTaskCard.New(slot2).Update(slot3, slot0[slot1 + 1])
		end
	end)
	slot0.uilist.align(slot3, #slot0.guild.getSelectableWeeklyTasks(slot1))
end

slot0.Close = function (slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)
	setActive(slot0._tf, false)
end

slot0.OnDestroy = function (slot0)
	slot0:Close()
end

return slot0
