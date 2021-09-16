pg = pg or {}
pg.UserAgreementMgr = singletonClass("UserAgreementMgr")
slot1 = "UserAgreementUI"
slot2 = 0
slot3 = 1
slot4 = 2

pg.UserAgreementMgr.Init = function (slot0, slot1)
	slot0.state = slot0

	if slot1 then
		slot1()
	end
end

pg.UserAgreementMgr.Show = function (slot0, slot1)
	slot0.onClose = slot1.onClose
	slot0.content = slot1.content
	slot0.forceRead = slot1.forceRead
	slot0.title = slot1.title

	if slot0.state == slot0 then
		slot0:LoadUI()
	elseif slot0.state == slot1 then
		slot0:Flush()
	elseif slot0.state ==  then
	end
end

pg.UserAgreementMgr.LoadUI = function (slot0)
	slot0.state = slot0

	pg.UIMgr.GetInstance():LoadingOn()
	PoolMgr.GetInstance():GetUI(PoolMgr.GetInstance().GetUI, true, function (slot0)
		slot0.state = slot0

		pg.UIMgr.GetInstance():LoadingOff()

		slot0._go = slot0

		slot0:OnLoaded()
		slot0:Flush()
		setActive(slot0._go, true)
		pg.UIMgr.GetInstance():BlurPanel(slot0._go.transform, false, {
			weight = LayerWeightConst.THIRD_LAYER
		})
	end)
end

pg.UserAgreementMgr.OnLoaded = function (slot0)
	slot0.contentTxt = slot0._go.transform:Find("window/container/scrollrect/content/Text"):GetComponent(typeof(Text))
	slot0.acceptBtn = slot0._go.transform:Find("window/accept_btn")
	slot0.acceptBtnTxt = slot0.acceptBtn:Find("Text"):GetComponent(typeof(Text))
	slot0.scrollrect = slot0._go.transform:Find("window/container/scrollrect"):GetComponent(typeof(ScrollRect))
	slot0.titleTxt = slot0._go.transform:Find("window/title"):GetComponent(typeof(Text))
end

pg.UserAgreementMgr.Flush = function (slot0)
	slot0.contentTxt.text = slot0.content
	slot0.acceptBtnTxt.text = i18n("word_back")
	slot0.titleTxt.text = slot0.title
	slot1 = not slot0.forceRead

	onButton(nil, slot0.acceptBtn, function ()
		if slot0 then
			slot1:Hide()
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("read_the_user_agreement"))
		end
	end)
	onScroll(nil, slot0.scrollrect.gameObject, function (slot0)
		if slot0.y <= 0.01 and not slot0 then
			setButtonEnabled(slot1.acceptBtn, true)
		end
	end)
	setButtonEnabled(slot0.acceptBtn, slot1)
	scrollTo(slot0.scrollrect.gameObject, 0, 1)
end

pg.UserAgreementMgr.Hide = function (slot0)
	if slot0.onClose then
		slot0.onClose()
	end

	if slot0.acceptBtn then
		removeOnButton(slot0.acceptBtn)
	end

	if slot0.scrollrect then
		slot0.scrollrect.onValueChanged:RemoveAllListeners()
	end

	slot0.onClose = nil
	slot0.content = nil
	slot0.forceRead = nil
	slot0.title = nil

	if slot0._go then
		pg.UIMgr.GetInstance():UnblurPanel(slot0._go.transform, pg.UIMgr.GetInstance().UIMain)
		PoolMgr.GetInstance():ReturnUI(slot0, slot0._go)

		slot0._go = nil
	end

	slot0.state = slot1
end

pg.UserAgreementMgr.ShowForBiliPrivate = function (slot0)
	slot0:Show({
		content = require("GameCfg.useragreems.BiliPrivate").content,
		title = require("GameCfg.useragreems.BiliPrivate").title
	})
end

pg.UserAgreementMgr.ShowForBiliLicence = function (slot0)
	slot0:Show({
		content = require("GameCfg.useragreems.BiliLicence").content,
		title = require("GameCfg.useragreems.BiliLicence").title
	})
end

return
