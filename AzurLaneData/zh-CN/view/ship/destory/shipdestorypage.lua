slot0 = class("ShipDestoryPage", import("...base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "destoryinfoui"
end

slot0.OnLoaded = function (slot0)
	slot0.uilist = UIItemList.New(slot0:findTF("frame/sliders/content"), slot1)
	slot0.destoryGoldText = slot0:findTF("frame/bg_award/res")
	slot0.cancelBtn = slot0:findTF("frame/cancel_button")
	slot0.backBtn = slot0:findTF("frame/top/btnBack")
	slot0.confirmBtn = slot0:findTF("frame/confirm_button")
	slot0.resList = UIItemList.New(slot0:findTF("frame/bg_award"), slot0:findTF("frame/bg_award/res"))
end

slot0.OnInit = function (slot0)
	onButton(slot0, slot0.cancelBtn, function ()
		slot0:Hide()
	end, SFX_CANCEL)
	onButton(slot0, slot0.backBtn, function ()
		slot0:Hide()
	end, SFX_CANCEL)
	onButton(slot0, slot0.confirmBtn, function ()
		if slot0.OnConfirm then
			slot0.OnConfirm()
		end
	end, SFX_PANEL)
end

slot0.SetConfirmCallBack = function (slot0, slot1)
	slot0.OnConfirm = slot1
end

slot0.SetCardClickCallBack = function (slot0, slot1)
	slot0.OnCardClick = slot1
end

slot0.Refresh = function (slot0, slot1, slot2)
	slot0.shipIds = slot1
	slot0.shipVOs = slot2

	slot0:DisplayShipList()
	slot0:RefreshRes()
	slot0:Show()
end

slot0.DisplayShipList = function (slot0)
	slot2 = slot0.shipVOs

	slot0.uilist:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot4 = DockyardShipItem.New(slot2.gameObject, ShipStatus.TAG_HIDE_DESTROY)

			slot4:update(slot1[slot0[slot1 + 1]])
			onButton(slot2, slot4.tr, function ()
				for slot3, slot4 in ipairs(ipairs) do
					if slot1.shipVO.id == slot4 then
						if slot2.OnCardClick then
							slot2.OnCardClick(slot1)
						end

						break
					end
				end

				slot2:DisplayShipList()
			end, SFX_PANEL)
		end
	end)
	slot0.uilist.align(slot3, #slot0.shipIds)

	if #slot0.shipIds == 0 then
		slot0:Hide()
	end
end

slot0.CalcShipsReturnRes = function (slot0, slot1)
	slot2 = _.map(slot0, function (slot0)
		return slot0[slot0]
	end)

	return ShipCalcHelper.CalcDestoryRes(slot2)
end

slot0.RefreshRes = function (slot0)
	slot3, slot4, slot5 = slot0.CalcShipsReturnRes(slot1, slot2)

	slot0.resList:make(function (slot0, slot1, slot2)
		if slot0 == UIItemList.EventUpdate then
			slot3 = ""
			slot4 = 0

			if slot1 == 0 then
				slot4 = slot0
				slot3 = "Props/gold"
			elseif slot1 == 1 then
				slot4 = slot1
				slot3 = "Props/oil"
			else
				slot4 = slot2[slot1 - 1].count
				slot3 = pg.item_data_statistics[slot2[slot1 - 1].id].icon
			end

			GetImageSpriteFromAtlasAsync(slot3, "", slot2:Find("icon"))
			setText(slot2:Find("Text"), "X" .. slot4)
		end
	end)
	slot0.resList.align(slot7, 2 + #slot5)
end

slot0.Show = function (slot0)
	slot0.super.Show(slot0)
	pg.UIMgr:GetInstance():BlurPanel(slot0._tf)
end

slot0.Hide = function (slot0)
	slot0.super.Hide(slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)
end

slot0.OnDestroy = function (slot0)
	slot0.OnCardClick = nil

	slot0:Hide()
end

return slot0
