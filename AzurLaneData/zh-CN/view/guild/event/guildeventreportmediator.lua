slot0 = class("GuildEventReportMediator", import("...base.ContextMediator"))
slot0.ON_GET_REPORTS = "GuildEventReportMediator:ON_GET_REPORTS"
slot0.ON_SUBMIT_REPORTS = "GuildEventReportMediator:ON_SUBMIT_REPORTS"

slot0.register = function (slot0)
	slot0:bind(slot0.ON_SUBMIT_REPORTS, function (slot0, slot1)
		slot0:sendNotification(GAME.SUBMIT_GUILD_REPORT, {
			ids = slot1
		})
	end)
	slot0.bind(slot0, slot0.ON_GET_REPORTS, function (slot0, slot1)
		slot0:sendNotification(GAME.GET_GUILD_REPORT, {
			callback = slot1
		})
	end)
end

slot0.listNotificationInterests = function (slot0)
	return {
		GAME.SUBMIT_GUILD_REPORT_DONE
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == GAME.SUBMIT_GUILD_REPORT_DONE then
		slot0.viewComponent:UpdateReports(slot3.list)
	end
end

return slot0
