slot0 = class("NissinFoodPage", import("...base.BaseActivityPage"))

slot0.OnInit = function (slot0)
	slot0.bg = slot0:findTF("AD")
	slot0.helpBtn = slot0:findTF("help_btn", slot0.bg)
	slot0.startBtn = slot0:findTF("start_btn", slot0.bg)
	slot0.cupList = slot0:findTF("cup_list", slot0.bg)
end

slot0.OnFirstFlush = function (slot0)
	slot0.hubID = slot0.activity:getConfig("config_id")
	slot0.drop_list = slot0.activity:getConfig("config_client")

	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("chazi_tips")
		})
	end, SFX_PANEL)
	onButton(slot0, slot0.startBtn, function ()
		pg.m02:sendNotification(GAME.GO_MINI_GAME, 29)
	end, SFX_PANEL)
end

slot0.OnUpdateFlush = function (slot0)
	eachChild(slot0.cupList, function (slot0)
		slot1 = tonumber(slot0.name)

		setActive(slot0:findTF("lock", slot0), slot1 > slot1.count + slot1.usedtime)
		setActive(slot0:findTF("got", slot0), slot1 <= slot1.usedtime)
		updateDrop(setActive, slot1 <= slot1.usedtime)
		onButton(slot0, slot0:findTF("mask/award", slot0), function ()
			slot0:emit(BaseUI.ON_DROP, slot0)
		end, SFX_PANEL)
	end)

	if getProxy(MiniGameProxy).GetHubByHubId(slot1, slot0.hubID).ultimate == 0 and slot2.getConfig(slot2, "reward_need") <= slot2.usedtime then
		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = slot2.id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

return slot0
