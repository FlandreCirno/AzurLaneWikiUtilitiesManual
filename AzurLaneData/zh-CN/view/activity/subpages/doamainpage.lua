slot0 = class("DoaMainPage", import(".TemplatePage.PreviewTemplatePage"))

slot0.OnInit = function (slot0)
	slot0.bg = slot0:findTF("AD")
	slot0.btnList = slot0:findTF("btn_list", slot0.bg)
	slot1 = getProxy(MiniGameProxy)
	slot2 = getProxy(ActivityProxy)

	onButton(slot0, findTF(slot0.bg, "btnMiniGame"), function ()
		if slot1:IsActivityNotEnd(slot0:GetHubByGameId(17).getConfig(slot0, "act_id")) then
			slot2:emit(ActivityMediator.GO_MINI_GAME, 17)
		else
			pg.TipsMgr:GetInstance():ShowTips(i18n("common_activity_end"))
		end
	end)
end

slot0.OnFirstFlush = function (slot0)
	slot0.super.OnFirstFlush(slot0)
end

slot0.OnUpdateFlush = function (slot0)
	if not slot0.charactorTf then
		slot0.charactorTf = findTF(slot0.bg, "charactor")
	end

	slot1 = math.random(1, 7)

	for slot5 = 1, 7, 1 do
		setActive(findTF(slot0.charactorTf, "charactor" .. slot5), slot1 == slot5)
	end
end

return slot0
