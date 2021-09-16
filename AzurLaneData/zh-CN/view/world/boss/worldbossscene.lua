slot0 = class("WorldBossScene", import("...base.BaseUI"))
slot0.PAGE_OTHER = 1
slot0.PAGE_SELF = 2
slot0.Listeners = {
	onPtUpdated = "OnPtUpdated",
	onBossUpdated = "OnBossUpdated"
}

slot0.getUIName = function (slot0)
	return "WorldBossUI"
end

slot0.SetBossProxy = function (slot0, slot1, slot2)
	slot0.bossProxy = slot1
	slot0.metaCharacterProxy = slot2
	slot0.boss = slot0.bossProxy:GetBoss()
	slot0.listPage = WorldBossListPage.New(slot0.pagesTF, slot0.event, slot0.contextData)

	slot0.listPage:Setup(slot0.bossProxy)

	slot0.emptyPage = WorldBossEmptyPage.New(slot0.pagesTF, slot0.event)

	slot0.emptyPage:Setup(slot0.bossProxy)

	slot0.detailPage = WorldBossDetailPage.New(slot0.pagesTF, slot0.event)

	slot0.detailPage:Setup(slot0.bossProxy)

	slot0.formationPreviewPage = WorldBossFormationPreViewPage.New(slot0.pagesTF, slot0.event)

	slot0:AddListeners()
	slot0:UpdatePt()
	slot0:UpdateMeta()
end

slot0.AddListeners = function (slot0)
	slot0.bossProxy:AddListener(WorldBossProxy.EventBossUpdated, slot0.onBossUpdated)
	slot0.bossProxy:AddListener(WorldBossProxy.EventPtUpdated, slot0.onPtUpdated)
end

slot0.RemoveListeners = function (slot0)
	slot0.bossProxy:RemoveListener(WorldBossProxy.EventPtUpdated, slot0.onPtUpdated)
	slot0.bossProxy:RemoveListener(WorldBossProxy.EventBossUpdated, slot0.onBossUpdated)
end

slot0.OnPtUpdated = function (slot0, slot1)
	slot0:UpdatePt()
end

slot0.OnShowFormationPreview = function (slot0, slot1)
	slot0.formationPreviewPage:ExecuteAction("Show", slot1)
end

slot0.init = function (slot0)
	for slot4, slot5 in pairs(slot0.Listeners) do
		slot0[slot4] = function (...)
			slot0[slot1](slot2, ...)
		end
	end

	slot0.ptTF = slot0.findTF(slot0, "point")
	slot0.pt = slot0:findTF("point/Text"):GetComponent(typeof(Text))
	slot0.ptRecoveTF = slot0:findTF("point/time")
	slot0.ptRecove = slot0:findTF("point/time/Text"):GetComponent(typeof(Text))
	slot0.backBtn = slot0:findTF("back_btn")
	slot0.pagesTF = slot0:findTF("pages")
	slot0.switchBtn = slot0:findTF("switch_btn")
	slot0.metaBtn = slot0:findTF("meta_btn")
	slot0.metaProgress = slot0:findTF("meta_btn/Text"):GetComponent(typeof(Text))
	slot0.metaTip = slot0:findTF("meta_btn/tip")
	slot0.helpBtn = slot0:findTF("point/help")
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0.backBtn, function ()
		slot0:emit(slot1.ON_BACK)
	end, SOUND_BACK)
	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.world_boss_help_meta.tip
		})
	end, SFX_PANEL)

	slot0.ptRecoveTFFlag = false

	onButton(slot0, slot0.ptTF, function ()
		slot0.ptRecoveTFFlag = not slot0.ptRecoveTFFlag

		setActive(slot0.ptRecoveTF, slot0.ptRecoveTFFlag)
	end, SFX_PANEL)
	setActive(slot0.ptRecoveTF, slot0.ptRecoveTFFlag)
	onToggle(slot0, slot0.switchBtn, function (slot0)
		slot0:SwitchPage((slot0 and slot0.SwitchPage.PAGE_SELF) or slot0.SwitchPage.PAGE_OTHER)
	end, SFX_PANEL)
	onButton(slot0, slot0.metaBtn, function ()
		slot0 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLD_WORLDBOSS)

		slot0:emit(WorldBossMediator.GO_META, slot0:getConfig("config_client").id)
	end, SFX_PANEL)
	slot0.emit(slot0, WorldBossMediator.ON_FETCH_BOSS)
end

slot0.OnRemoveLayers = function (slot0)
	if slot0.detailPage and slot0.detailPage:GetLoaded() and slot0.detailPage:isShowing() then
		slot0.detailPage:TryPlayGuide()
	end
end

slot0.UpdateMeta = function (slot0)
	setActive(slot0.metaTip, MetaCharacterConst.isMetaSynRedTag(getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_WORLD_WORLDBOSS).getConfig(slot1, "config_client").id))
end

slot0.getAwardDone = function (slot0)
	if slot0.page == slot0.listPage then
		slot0.listPage:ExecuteAction("CloseGetPage")
	end

	slot0:UpdateMeta()
end

slot0.SwitchPage = function (slot0, slot1)
	if slot0.page then
		slot0.page:ExecuteAction("Hide")
	end

	if slot1 == slot0.PAGE_OTHER then
		slot0.page = slot0.listPage
	elseif slot1 == slot0.PAGE_SELF then
		if slot0.boss then
			slot0.page = slot0.detailPage
		else
			slot0.page = slot0.emptyPage
		end
	end

	slot0.page:ExecuteAction("Update")
	slot0:LoadEffect(slot1)
	setActive(slot0.metaBtn, slot1 == slot0.PAGE_SELF)
end

slot0.LoadEffect = function (slot0, slot1)
	if ((slot1 == slot0.PAGE_SELF and slot0.boss) or (slot1 == slot0.PAGE_OTHER and slot0.bossProxy:ExistCacheBoss())) and not slot0.fireEffect then
		pg.UIMgr.GetInstance():LoadingOn()
		PoolMgr.GetInstance():GetUI("gondouBoss_huoxing", true, function (slot0)
			pg.UIMgr.GetInstance():LoadingOff()

			slot0.fireEffect = slot0

			setParent(slot0.fireEffect, slot0._tf)
			setActive(slot0.fireEffect, true)
		end)
	elseif slot0.fireEffect then
		setActive(slot0.fireEffect, slot2)
	end
end

slot0.OnBossUpdated = function (slot0)
	slot0.boss = slot0.bossProxy:GetBoss()

	if slot0.page == slot0.detailPage or slot0.page == slot0.emptyPage then
		slot0:SwitchPage(slot0.PAGE_SELF)
	end
end

slot0.UpdatePt = function (slot0)
	slot0.pt.text = (slot0.bossProxy.pt or 0) .. "/" .. slot0.bossProxy:GetMaxPt()
	slot0.ptRecove.text = i18n("world_boss_pt_recove_desc", pg.gameset.joint_boss_ap_recove_cnt_pre_day.key_value)
end

slot0.willExit = function (slot0)
	if slot0.fireEffect then
		PoolMgr.GetInstance():ReturnUI("gondouBoss_huoxing", slot0.fireEffect)
	end

	if slot0.bossProxy then
		slot0:RemoveListeners()
	end

	if slot0.listPage then
		slot0.listPage:Destroy()

		slot0.listPage = nil
	end

	if slot0.emptyPage then
		slot0.emptyPage:Destroy()

		slot0.emptyPage = nil
	end

	if slot0.detailPage then
		slot0.detailPage:Destroy()

		slot0.detailPage = nil
	end

	if slot0.formationPreviewPage then
		slot0.formationPreviewPage:Destroy()

		slot0.formationPreviewPage = nil
	end
end

return slot0
