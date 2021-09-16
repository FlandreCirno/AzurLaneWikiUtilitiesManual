ys = ys or {}
ys.Battle.BattleControllerCommand = class("BattleControllerCommand", ys.MVC.Command)
ys.Battle.BattleControllerCommand.__name = "BattleControllerCommand"

ys.Battle.BattleControllerCommand.Ctor = function (slot0)
	slot0.Battle.BattleControllerCommand.super.Ctor(slot0)
end

ys.Battle.BattleControllerCommand.Initialize = function (slot0)
	slot0.Battle.BattleControllerCommand.super.Initialize(slot0)

	slot0._dataProxy = slot0._state:GetProxyByName(slot0.Battle.BattleDataProxy.__name)

	slot0:InitBattleEvent()
end

ys.Battle.BattleControllerCommand.InitBattleEvent = function (slot0)
	return
end

ys.Battle.BattleControllerCommand.addSpeed = function (slot0)
	slot0.Battle.BattleConfig.BASIC_TIME_SCALE = slot0.Battle.BattleConfig.BASIC_TIME_SCALE * slot0

	slot0.Battle.BattleVariable.AppendIFFFactor(slot0.Battle.BattleConfig.FOE_CODE, "cheat_speed_up_" .. slot0.Battle.BattleConfig.BASIC_TIME_SCALE, slot0)
	slot0.Battle.BattleVariable.AppendIFFFactor(slot0.Battle.BattleConfig.FRIENDLY_CODE, "cheat_speed_up_" .. slot0.Battle.BattleConfig.BASIC_TIME_SCALE, slot0)
end

ys.Battle.BattleControllerCommand.removeSpeed = function (slot0)
	slot0.Battle.BattleVariable.RemoveIFFFactor(slot0.Battle.BattleConfig.FOE_CODE, "cheat_speed_up_" .. slot0.Battle.BattleConfig.BASIC_TIME_SCALE)
	slot0.Battle.BattleVariable.RemoveIFFFactor(slot0.Battle.BattleConfig.FRIENDLY_CODE, "cheat_speed_up_" .. slot0.Battle.BattleConfig.BASIC_TIME_SCALE)

	slot0.Battle.BattleConfig.BASIC_TIME_SCALE = slot0.Battle.BattleConfig.BASIC_TIME_SCALE * slot0
end

ys.Battle.BattleControllerCommand.scaleTime = function (slot0)
	pg.TipsMgr.GetInstance():ShowTips("┏━━━━━━━━━━━━┓")
	pg.TipsMgr.GetInstance():ShowTips("┃ヽ(•̀ω•́ )ゝ嗑药 X" .. slot0.Battle.BattleConfig.BASIC_TIME_SCALE .. " ！(ง •̀_•́)ง┃")
	pg.TipsMgr.GetInstance():ShowTips("┗━━━━━━━━━━━━┛")
	slot0._state:ScaleTimer()
end

return
