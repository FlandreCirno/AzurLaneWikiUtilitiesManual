slot0 = class("SnapshotShareLayer", import("..base.BaseUI"))

slot0.getUIName = function (slot0)
	return "snapshotshareui"
end

slot0.init = function (slot0)
	slot0.photoImgTrans = slot0:findTF("PhotoImg")
	slot0.rawImage = slot0.photoImgTrans:GetComponent("RawImage")
	slot0.shareBtnTrans = slot0:findTF("BtnPanel/ShareBtn")
	slot0.confirmBtnTrans = slot0:findTF("BtnPanel/ConfirmBtn")
	slot0.cancelBtnTrans = slot0:findTF("BtnPanel/CancelBtn")
	slot0.userAgreenTF = slot0:findTF("UserAgreement")
	slot0.userAgreenMainTF = slot0:findTF("window", slot0.userAgreenTF)
	slot0.closeUserAgreenTF = slot0:findTF("close_btn", slot0.userAgreenMainTF)
	slot0.userRefuseConfirmTF = slot0:findTF("refuse_btn", slot0.userAgreenMainTF)
	slot0.userAgreenConfirmTF = slot0:findTF("accept_btn", slot0.userAgreenMainTF)

	setActive(slot0.userAgreenTF, false)

	slot0.rawImage.texture = slot0.contextData.photoTex
	slot0.bytes = slot0.contextData.photoData
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0.shareBtnTrans, function ()
		if not PlayerPrefs.GetInt("snapshotAgress") or slot0 <= 0 then
			slot0:showUserAgreement(function ()
				PlayerPrefs.SetInt("snapshotAgress", 1)
				pg.ShareMgr.GetInstance():Share(pg.ShareMgr.TypePhoto)
			end)
		else
			pg.ShareMgr.GetInstance().Share(slot1, pg.ShareMgr.TypePhoto)
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.confirmBtnTrans, function ()
		slot0 = pg.TimeMgr.GetInstance():STimeDescS(pg.TimeMgr.GetInstance():GetServerTime(), "*t")

		YARecorder.Inst:WritePictureToAlbum(slot1, slot0.bytes)
		pg.TipsMgr.GetInstance():ShowTips(i18n("word_save_ok"))
		slot0:closeView()
	end)
	onButton(slot0, slot0.cancelBtnTrans, function ()
		slot0:closeView()
	end)
end

slot0.willExit = function (slot0)
	return
end

slot0.showUserAgreement = function (slot0, slot1)
	setButtonEnabled(slot0.userAgreenConfirmTF, true)

	slot2 = nil
	slot0.userAgreenTitleTF = slot0:findTF("UserAgreement/window/title")
	slot0.userAgreenTitleTF:GetComponent("Text").text = i18n("word_snapshot_share_title")

	setActive(slot0.userAgreenTF, true)
	setText(slot0.userAgreenTF:Find("window/container/scrollrect/content/Text"), i18n("word_snapshot_share_agreement"))
	onButton(slot0, slot0.userRefuseConfirmTF, function ()
		setActive(slot0.userAgreenTF, false)
	end)
	onButton(slot0, slot0.userAgreenConfirmTF, function ()
		setActive(slot0.userAgreenTF, false)

		if slot0.userAgreenTF then
			slot1()
		end
	end)
	onButton(slot0, slot0.self.closeUserAgreenTF, function ()
		setActive(slot0.userAgreenTF, false)
	end)
end

return slot0
