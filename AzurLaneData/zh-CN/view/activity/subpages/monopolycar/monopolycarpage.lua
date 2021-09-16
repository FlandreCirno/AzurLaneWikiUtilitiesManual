slot0 = class("MonopolyCarPage", import("....base.BaseActivityPage"))
slot0.ON_START = "MonopolyGame:ON_START"
slot0.ON_MOVE = "MonopolyGame:ON_MOVE"
slot0.ON_TRIGGER = "MonopolyGame:ON_TRIGGER"
slot0.ON_AWARD = "MonopolyGame:ON_AWARD"

slot0.OnInit = function (slot0)
	slot0:bind(MonopolyCarPage.ON_START, function (slot0, slot1, slot2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = slot1,
			cmd = ActivityConst.MONOPOLY_OP_THROW,
			callback = slot2
		})
	end)
	slot0.bind(slot0, MonopolyCarPage.ON_MOVE, function (slot0, slot1, slot2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = slot1,
			cmd = ActivityConst.MONOPOLY_OP_MOVE,
			callback = slot2
		})
	end)
	slot0.bind(slot0, MonopolyCarPage.ON_TRIGGER, function (slot0, slot1, slot2)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = slot1,
			cmd = ActivityConst.MONOPOLY_OP_TRIGGER,
			callback = slot2
		})
	end)
	slot0.bind(slot0, MonopolyCarPage.ON_AWARD, function (slot0)
		pg.m02:sendNotification(GAME.MONOPOLY_OP, {
			activity_id = slot0.activity.id,
			cmd = ActivityConst.MONOPOLY_OP_AWARD
		})
	end)
end

slot0.OnFirstFlush = function (slot0)
	return
end

slot0.OnUpdateFlush = function (slot0)
	if slot0.gameUI then
		slot0.gameUI:updataActivity(slot0.activity)
	else
		slot0.gameUI = MonopolyCarGame.New(slot0, findTF(slot0._tf, "AD"), slot0._event)

		slot0.gameUI:firstUpdata(slot0.activity)
	end
end

slot0.OnDestroy = function (slot0)
	return
end

return slot0
