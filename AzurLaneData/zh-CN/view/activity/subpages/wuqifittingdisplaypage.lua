slot0 = class("WuQiFittingDisplayPage", import("view.base.BaseActivityPage"))

slot0.OnInit = function (slot0)
	slot0.btnClick = slot0._tf:Find("bg/click_area")
	slot0.rtAnim = slot0._tf:Find("bg/CircleBlue02")
end

slot0.OnFirstFlush = function (slot0)
	slot0.rtAnim:GetComponent(typeof(DftAniEvent)):SetEndEvent(function (slot0)
		slot0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SHIPBLUEPRINT, {
			shipGroupId = 39904
		})
	end)
	onButton(slot0, slot0.btnClick, function ()
		slot0, slot1 = pg.SystemOpenMgr.GetInstance():isOpenSystem(getProxy(PlayerProxy):getData().level, "TechnologyMediator")

		if not slot0 then
			pg.TipsMgr.GetInstance():ShowTips(slot1)

			return
		end

		setActive(slot0.rtAnim, true)
	end, SFX_PANEL)
end

return slot0
