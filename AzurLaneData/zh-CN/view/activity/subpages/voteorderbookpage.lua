slot0 = class("VoteOrderBookPage", import(".TemplatePage.PtTemplatePage"))

slot0.OnInit = function (slot0)
	slot0.super.OnInit(slot0)

	slot0.honorBtn = slot0:findTF("honor_btn")
	slot0.goVoteBtn = slot0:findTF("go_vote_btn")
	slot0.netBtn = slot0:findTF("net_btn")
	slot0.goBattleBtn = slot0:findTF("go_battle")
	slot0.timerTF = slot0:findTF("timer")
	slot0.timerTxt = slot0:findTF("timer/Text"):GetComponent(typeof(Text))
	slot0.helpBtn = slot0:findTF("help_btn")
	slot0.getLabel = slot0:findTF("get")
	slot0.title = slot0:findTF("AD/title"):GetComponent(typeof(Text))
	slot0.subTitle = slot0:findTF("AD/title/Text"):GetComponent(typeof(Text))
	slot0.isInit = true

	function slot2(slot0)
		return VoteGroup.New({
			id = slot0,
			list = {}
		}):getTimeDesc()
	end

	slot3 = false
	slot4 = ""

	if _.detect(pg.activity_vote.all, function (slot0)
		return #pg.activity_vote[slot0].time_show > 0 and pg.TimeMgr.GetInstance():inTime(slot2) and slot1.is_in_game == 1
	end) then
		slot3 = pg.activity_vote[slot1].is_on_web == 1
		slot0.voteTime = slot5.time_vote
		slot0.title.text = slot5.name
		slot4 = slot2(slot1)
	elseif _.detect(pg.activity_vote.all, function (slot0)
		return pg.TimeMgr.GetInstance():inTime(pg.activity_vote[slot0].time_show)
	end) then
		slot4 = slot2(slot5)
	end

	slot0.subTitle.text = slot4

	setActive(slot0.netBtn, slot3)
	onButton(slot0, slot0.honorBtn, function ()
		slot0:emit(ActivityMediator.GO_FISRT_VOTE)
	end, SFX_PANEL)
	onButton(slot0, slot0.goVoteBtn, function ()
		slot0:emit(ActivityMediator.GO_VOTE_LAYER)
	end, SFX_PANEL)
	onButton(slot0, slot0.netBtn, function ()
		Application.OpenURL(pg.gameset.vote_web_url.description)
	end, SFX_PANEL)
	onButton(slot0, slot0.goBattleBtn, function ()
		if slot0.voteTime and pg.TimeMgr.GetInstance():inTime(slot0.voteTime) then
			slot0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("vote_book_is_over"))
		end
	end, SFX_PANEL)
	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.help_vote.tip,
			weight = LayerWeightConst.THIRD_LAYER
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.timerTF, function ()
		slot0:emit(ActivityMediator.OPEN_VOTEBOOK)
	end, SFX_PANEL)
	slot0.UpdateOrderBookBtn(slot0, getProxy(VoteProxy):GetOrderBook())
end

slot0.OnUpdateFlush = function (slot0)
	slot0.super.OnUpdateFlush(slot0)

	slot1, slot2, slot3 = slot0.ptData:GetResProgress()

	setText(slot0.progress, ((slot3 >= 1 and setColorStr(slot1, "#1E55E3")) or slot1) .. "/" .. slot2)
end

slot0.UpdateOrderBookBtn = function (slot0, slot1)
	if not slot0.isInit then
		return
	end

	slot0:RemoveOrderBookTimer()
	setActive(slot0.goBattleBtn, not (slot1 and not slot1:IsExpired()))
	setActive(slot0.timerTF, slot1 and not slot1.IsExpired())
	setActive(slot0.getLabel, not (slot1 and not slot1.IsExpired()))

	if slot1 and not slot1.IsExpired() then
		slot0:AddOrderBookTimer(slot1)
	end
end

slot0.OnFirstFlush = function (slot0)
	slot0.super.OnFirstFlush(slot0)
	onButton(slot0, slot0.getBtn, function ()
		if not getProxy(ActivityProxy):GetVoteActivity() or slot0:isEnd() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		slot1, slot6.arg1 = slot0.ptData:GetResProgress()

		slot0:emit(ActivityMediator.EVENT_PT_OPERATION, {
			cmd = 1,
			activity_id = slot0.ptData:GetId(),
			arg1 = slot2
		})
	end, SFX_PANEL)
end

slot0.AddOrderBookTimer = function (slot0, slot1)
	slot0.timer = Timer.New(function ()
		slot0.timerTxt.text = slot1:GetCDTime("#054DFE")
	end, 1, -1)

	slot0.timer.Start(slot2)
	slot0.timer.func()
end

slot0.RemoveOrderBookTimer = function (slot0)
	if slot0.timer then
		slot0.timer:Stop()

		slot0.timer = nil
	end
end

slot0.OnDestroy = function (slot0)
	slot0.super.OnDestroy(slot0)
	slot0:RemoveOrderBookTimer()
end

return slot0
