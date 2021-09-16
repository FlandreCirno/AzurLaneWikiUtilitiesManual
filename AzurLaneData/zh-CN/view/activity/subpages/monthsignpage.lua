slot0 = class("MonthSignPage", import("...base.BaseActivityPage"))
slot0.SHOW_RE_MONTH_SIGN = "show re month sign award"
slot0.MONTH_SIGN_SHOW = {}

slot0.OnInit = function (slot0)
	slot0.bg = slot0:findTF("bg")
	slot0.items = slot0:findTF("items")
	slot0.item = slot0:findTF("item", slot0.items)
	slot0.monthSignReSignUI = MonthSignReSignUI.New(slot0._tf, slot0._event, nil)

	slot0:bind(slot0.SHOW_RE_MONTH_SIGN, function (slot0, slot1, slot2)
		if not slot0.monthSignReSignUI:GetLoaded() then
			slot0.monthSignReSignUI:Load()
		end

		slot0.monthSignReSignUI:ActionInvoke("setAwardShow", slot1, slot2)
	end)
end

slot0.OnDataSetting = function (slot0)
	slot0.config = pg.activity_month_sign[slot0.activity.data2]

	if not slot0.config then
		return true
	end

	slot0.monthDays = pg.TimeMgr.GetInstance():CalcMonthDays(slot0.activity.data1, slot0.activity.data2)

	if tonumber(pg.TimeMgr.GetInstance():STimeDescS(pg.TimeMgr.GetInstance():GetServerTime(), "%m")) == pg.activity_template[ActivityConst.MONTH_SIGN_ACTIVITY_ID].config_client[1] then
		slot0.specialTag = true
		slot0.specialDay = pg.activity_template[ActivityConst.MONTH_SIGN_ACTIVITY_ID].config_client[2]
		slot0.isShowFrame = pg.activity_template[ActivityConst.MONTH_SIGN_ACTIVITY_ID].config_client[3]
	end
end

slot0.OnFirstFlush = function (slot0)
	slot1 = pg.TimeMgr.GetInstance():GetServerTime()
	slot0.list = UIItemList.New(slot0.items, slot0.item)

	slot0.list:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			updateDrop(slot2, _.map(slot0.config["day" .. slot3], function (slot0)
				return {
					type = slot0[1],
					id = slot0[2],
					count = slot0[3]
				}
			end)[1])
			onButton(slot0, slot2, function ()
				if #slot0 == 1 then
					slot1:emit(BaseUI.ON_DROP, slot0[1])
				else
					slot1:emit(BaseUI.ON_DROP_LIST, {
						content = "",
						item2Row = true,
						itemList = slot1.emit
					})
				end
			end, SFX_PANEL)
			setText(slot2.Find(slot2, "day/Text"), "Day " .. slot3)
			setActive(slot2:Find("got"), slot1 + 1 <= #slot0.activity.data1_list)
			setActive(slot2:Find("today"), slot3 == #slot0.activity.data1_list)

			if slot0.specialTag and slot3 == slot0.specialDay then
				slot5 = slot0:findTF("icon_bg/SpecialFrame", slot2)

				if slot0.isShowFrame == 1 then
					setActive(slot5, false)
				else
					setActive(slot5, true)
				end
			end
		end
	end)
end

slot0.OnUpdateFlush = function (slot0)
	if slot0:isDirtyRes() then
		return
	end

	slot0.list:align(slot0.monthDays)

	if slot0.specialTag then
		slot1 = slot0:findTF("DayNumText")

		if slot0.specialDay - #slot0.activity.data1_list < 0 then
			slot2 = 0
		end

		setText(slot1, slot2)

		GetComponent(slot3, "Slider").value = #slot0.activity.data1_list
	end

	if slot0.activity:getSpecialData("month_sign_awards") and #slot1 > 0 then
		if not table.contains(MonthSignPage.MONTH_SIGN_SHOW, slot0.activity.id) then
			table.insert(MonthSignPage.MONTH_SIGN_SHOW, slot0.activity.id)

			if not slot0.monthSignReSignUI:GetLoaded() then
				slot0.monthSignReSignUI:Load()
			end

			slot0.monthSignReSignUI:ActionInvoke("setAwardShow", slot1)
		elseif slot0.monthSignReSignUI then
			slot0.monthSignReSignUI:ActionInvoke("setAwardShow", slot1)
		end
	end
end

slot0.showReMonthSign = function (slot0)
	return
end

slot0.OnDestroy = function (slot0)
	removeAllChildren(slot0.items)

	slot0.monthSignPageTool = nil

	slot0.monthSignReSignUI:Destroy()

	slot0.monthSignReSignUI = nil
end

slot0.UseSecondPage = function (slot0, slot1)
	return tonumber(pg.TimeMgr.GetInstance():CurrentSTimeDesc("%m", true)) == pg.activity_template[slot1.id].config_client[1]
end

slot0.isDirtyRes = function (slot0)
	if slot0.specialTag and slot0:getUIName() ~= slot0.activity:getConfig("page_info").ui_name2 then
		return true
	end
end

return slot0
