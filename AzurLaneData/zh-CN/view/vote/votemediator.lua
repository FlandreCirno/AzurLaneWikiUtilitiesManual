slot0 = class("VoteMediator", import("..base.ContextMediator"))
slot0.ON_VOTE = "VoteMediator:ON_VOTE"
slot0.ON_FILTER = "VoteMediator:ON_FILTER"
slot0.ON_WEB = "VoteMediator:ON_WEB"

slot0.register = function (slot0)
	slot0:bind(slot0.ON_VOTE, function (slot0, slot1, slot2, slot3)
		slot0:sendNotification(GAME.ON_NEW_VOTE, {
			voteId = slot1,
			gid = slot2,
			count = slot3
		})
	end)
	slot0.bind(slot0, slot0.ON_WEB, function (slot0)
		if not _.detect(pg.activity_vote.all, function (slot0)
			return pg.TimeMgr.GetInstance():inTime(pg.activity_vote[slot0].time_show) and slot1.is_in_game == 1
		end) then
			pg.TipsMgr.GetInstance().ShowTips(slot2, i18n("common_activity_not_start"))

			return
		end

		slot0:sendNotification(GAME.REQUEST_WEB_VOTE_INFO, {
			configId = slot1,
			callback = function ()
				slot0:addSubLayers(Context.New({
					mediator = WebVoteMediator,
					viewComponent = WebVoteLayer
				}))
			end
		})
	end)
	slot0.bind(slot0, slot0.ON_FILTER, function (slot0, slot1)
		slot0:addSubLayers(Context.New({
			viewComponent = IndexLayer,
			mediator = IndexMediator,
			data = slot1
		}))
	end)
	slot0.setShareData(slot0)
end

slot0.setShareData = function (slot0)
	slot1 = getProxy(VoteProxy)

	slot0.viewComponent:setVotes(slot1:getVoteGroup(), slot1.votes)
end

slot0.listNotificationInterests = function (slot0)
	return {
		GAME.ON_NEW_VOTE_DONE,
		VoteProxy.VOTEGROUP_UPDATE
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == GAME.ON_NEW_VOTE_DONE then
		slot0:setShareData()
		slot0.viewComponent:updateMainview(false)
		pg.TipsMgr.GetInstance():ShowTips(i18n("vote_success"))
	end
end

return slot0
