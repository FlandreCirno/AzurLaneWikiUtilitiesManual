slot0 = class("SuperBulinPopView", import("view.base.BaseUI"))

slot0.getUIName = function (slot0)
	return "SuperBulinPopView"
end

slot0.init = function (slot0)
	return
end

slot0.didEnter = function (slot0)
	slot0.bulinAnim = slot0._tf:Find("Bulin"):GetComponent("SpineAnimUI")

	slot0.bulinAnim:SetActionCallBack(nil)
	onButton(slot0, slot0._tf, function ()
		seriesAsync({
			function (slot0)
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("super_bulin"),
					onYes = slot0,
					onNo = function ()
						slot0:closeView()
					end
				})
			end,
			function (slot0)
				slot1 = slot0.contextData.actId

				slot0:closeView()
				pg.m02:sendNotification(GAME.BEGIN_STAGE, {
					warnMsg = "bulin_tip_other3",
					system = SYSTEM_SIMULATION,
					stageId = slot0.contextData.stageId,
					exitCallback = function ()
						slot0 = getProxy(ActivityProxy)

						if slot0:getActivityById(slot0).data1 == 2 then
							return
						end

						slot1.data3 = 1

						slot0:updateActivity(slot1)
					end
				})
			end
		})
	end)
	pg.UIMgr.GetInstance().BlurPanel(slot1, slot0._tf)
end

slot0.willExit = function (slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf)
end

return slot0
