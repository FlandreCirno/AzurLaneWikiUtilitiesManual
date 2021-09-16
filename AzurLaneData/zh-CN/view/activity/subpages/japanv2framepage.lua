class("JapanV2framePage", import(".TemplatePage.FrameTemplatePage")).OnUpdateFlush = function (slot0)
	slot0.super.OnUpdateFlush(slot0)
	setActive(slot0.gotBtn, false)
end

return class("JapanV2framePage", import(".TemplatePage.FrameTemplatePage"))
