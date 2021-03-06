slot0 = class("BackYardMsgBox")

slot0.Ctor = function (slot0, slot1)
	pg.DelegateInfo.New(slot0)

	slot0._go = slot1
	slot0.msgBoxPanel = tf(slot1)
	slot0.parent = slot0.msgBoxPanel.parent
	slot0.valueTxt = findTF(slot0.msgBoxPanel, "frame/tip_2/value_bg/Text")
	slot0.text1 = findTF(slot0.msgBoxPanel, "frame/tip_1/text_1")
	slot0.text2 = findTF(slot0.msgBoxPanel, "frame/tip_1/value_bg/Text")
	slot0.text3 = findTF(slot0.msgBoxPanel, "frame/tip_1/text_2")
	slot0.text4 = findTF(slot0.msgBoxPanel, "frame/tip_2/text_1")
	slot0.text5 = findTF(slot0.msgBoxPanel, "frame/tip_2/text_2")
	slot0.itemTF = findTF(slot0.msgBoxPanel, "frame")
	slot0.okBtn = findTF(slot0.msgBoxPanel, "frame/ok_btn")
	slot0.cancelBtn = findTF(slot0.msgBoxPanel, "frame/cancel_btn")
end

slot0.Show = function (slot0, slot1, slot2, slot3)
	setActive(slot0.msgBoxPanel, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0.msgBoxPanel)
	setText(slot0.text1, slot1.text1)
	setText(slot0.text2, setColorStr(slot1.text2, COLOR_GREEN))
	setText(slot0.text3, slot1.text3)
	setText(slot0.text4, slot1.text4)
	slot0:updateItemCount(slot1.text5)
	setText(slot0.text5, slot1.text6)
	updateDrop(slot0.itemTF, slot4)
	onButton(slot0, slot0.okBtn, function ()
		if slot0 then
			slot0()
		end
	end, SFX_CONFIRM)
	onButton(slot0, slot0.cancelBtn, function ()
		slot0:Close()
	end, SFX_CANCEL)
	onButton(slot0, slot0.msgBoxPanel, function ()
		slot0:Close()
	end, SFX_CANCEL)
end

slot0.updateItemCount = function (slot0, slot1)
	setText(slot0.valueTxt, (tonumber(slot1) <= 0 and setColorStr(slot1, COLOR_RED)) or setColorStr(slot1, COLOR_GREEN))
end

slot0.Close = function (slot0)
	setActive(slot0.msgBoxPanel, false)
	pg.UIMgr.GetInstance():UnblurPanel(slot0.msgBoxPanel, slot0.parent)
end

slot0.Destroy = function (slot0)
	slot0:Close()
	pg.DelegateInfo.Dispose(slot0)
end

return slot0
