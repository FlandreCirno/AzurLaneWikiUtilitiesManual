class("JiFengJKSkinPage", import(".TemplatePage.SkinTemplatePage")).OnUpdateFlush = function (slot0)
	slot0.super.OnUpdateFlush(slot0)
	setText(slot0.dayTF, setColorStr(slot0.nday, "#EC8FBBFF") .. "/" .. #slot0.taskGroup)
end

return class("JiFengJKSkinPage", import(".TemplatePage.SkinTemplatePage"))
