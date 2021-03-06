slot0 = class("VoteScene", import("..base.BaseUI"))
slot0.ShipIndex = {
	display = {
		index = IndexConst.FlagRange2Bits(IndexConst.IndexAll, IndexConst.IndexOther),
		camp = IndexConst.FlagRange2Bits(IndexConst.CampAll, IndexConst.CampOther),
		rarity = IndexConst.FlagRange2Bits(IndexConst.RarityAll, IndexConst.Rarity5)
	},
	index = IndexConst.Flags2Bits({
		IndexConst.IndexAll
	}),
	camp = IndexConst.Flags2Bits({
		IndexConst.CampAll
	}),
	rarity = IndexConst.Flags2Bits({
		IndexConst.RarityAll
	})
}

slot0.getUIName = function (slot0)
	return "VoteUI"
end

slot0.setVotes = function (slot0, slot1, slot2)
	slot0.count = slot2
	slot0.voteGroup = slot1
	slot0.voteShips = slot0.voteGroup:getList()
end

slot0.init = function (slot0)
	slot0.title = slot0:findTF("main/right_panel/title/main"):GetComponent(typeof(Text))
	slot0.titleBg1 = slot0:findTF("main/right_panel/title/title_bg1")
	slot0.titleBg2 = slot0:findTF("main/right_panel/title/title_bg2")
	slot0.titleBg3 = slot0:findTF("main/right_panel/title/title_bg3")
	slot0.subTitle = slot0:findTF("main/right_panel/title/Text"):GetComponent(typeof(Text))
	slot0.tagtimeTF = slot0:findTF("main/right_panel/title/sub"):GetComponent(typeof(Text))
	slot0.backBtn = slot0:findTF("blur_panel/adapt/top/back_btn")
	slot0.helpBtn = slot0:findTF("main/right_panel/title/help")
	slot0.filterBtn = slot0:findTF("main/right_panel/filter_bg/filter_btn")
	slot0.urlBtn = slot0:findTF("main/right_panel/filter_bg/web_btn")
	slot0.numberTxt = slot0:findTF("main/right_panel/filter_bg/Text"):GetComponent(typeof(Text))
end

slot0.didEnter = function (slot0)
	slot0.PAGES = {
		[5] = {
			VotePreRaceShipPage,
			VotePreRaceRankPage
		},
		[6] = {
			VoteGroupRaceShipPage,
			VoteGroupRaceRankPage
		},
		[7] = {
			VoteGroupRaceShipPage,
			VoteGroupRaceRankPage
		},
		[8] = {
			VoteGroupRaceShipPage,
			VoteGroupRaceRankPage
		},
		[9] = {
			VoteGroupRaceShipPage,
			VoteGroupRaceRankPage
		},
		[10] = {
			VoteGroupRaceShipPage,
			VoteGroupRaceRankPage
		},
		[11] = {
			VoteGroupRaceShipPage,
			VoteGroupRaceRankPage
		},
		[12] = {
			VoteGroupRaceShipPage,
			VoteGroupRaceRankPage
		},
		[13] = {
			VoteFinalsRaceShipsPage,
			VoteFinalsRaceRankPage
		}
	}
	slot0.shipsPage = slot0.PAGES[slot0.voteGroup.id][1].New(slot0:findTF("main/right_panel"), slot0.event)

	slot0.shipsPage:SetCallBack(function (slot0, slot1)
		slot0:OnVote(slot0, slot1)
	end)

	slot0.rankPage = slot0.PAGES[slot0.voteGroup.id][2].New(slot0.findTF(slot0, "main/left_panel"), slot0.event)
	slot0.voteMsgBox = VoteDiaplayPage.New(slot0._tf, slot0._event)

	onButton(slot0, slot0.backBtn, function ()
		slot0:emit(slot1.ON_BACK)
	end, SFX_CANCEL)
	onButton(slot0, slot0.urlBtn, function ()
		Application.OpenURL(pg.gameset.vote_web_url.description)
	end, SFX_PANEL)
	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip[pg.MsgboxMgr.GetInstance().ShowMsgBox].tip
		})
	end, SFX_PANEL)
	setActive(slot0.helpBtn, slot0.voteGroup.getConfig(slot3, "help_text") and slot3 ~= "")
	onButton(slot0, slot0.filterBtn, function ()
		slot0:emit(VoteMediator.ON_FILTER, {
			display = slot1.ShipIndex.display,
			index = slot1.ShipIndex.index,
			camp = slot1.ShipIndex.camp,
			rarity = slot1.ShipIndex.rarity,
			callback = function (slot0)
				slot0.ShipIndex.index = slot0.index
				slot0.ShipIndex.camp = slot0.camp
				slot0.ShipIndex.rarity = slot0.rarity

				slot0.ShipIndex:initShips()
			end
		})
	end, SFX_PANEL)
	slot0.updateMainview(slot0, true)
	slot0:initTitles()
	slot0:UpdateMode()
end

slot0.UpdateMode = function (slot0)
	slot1 = slot0.voteGroup:isResurrectionRace()

	setActive(slot0.filterBtn, not slot1)
	setActive(slot0.urlBtn, slot1)
	setActive(slot0.titleBg1, not slot1 and not slot0.voteGroup:isFinalsRace())
	setActive(slot0.titleBg2, slot1)
	setActive(slot0.titleBg3, slot0.voteGroup.isFinalsRace())
end

slot0.OnVote = function (slot0, slot1, slot2)
	slot0.voteMsgBox:ExecuteAction("Open", slot1.voteShip, slot0.voteGroup:GetRank(slot3), slot0.count, defaultValue(slot2, false), function (slot0)
		if slot0.voteGroup:GetStage() ~= VoteGroup.VOTE_STAGE then
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

			return
		end

		if slot0 <= slot1 then
			slot0:emit(VoteMediator.ON_VOTE, slot0.voteGroup.id, slot2.group, slot0)
		else
			pg.TipsMgr.GetInstance():ShowTips(i18n("vote_not_enough"))
		end
	end)
end

slot0.updateMainview = function (slot0)
	slot0:initShips()
	slot0:initRanks()
	slot0:updateNumber()
end

slot0.initRanks = function (slot0)
	slot0.rankPage:ExecuteAction("Update", slot0.voteGroup)
end

slot0.initShips = function (slot0)
	slot0.displays = {}

	for slot4, slot5 in ipairs(slot0.voteShips) do
		if slot0.ShipIndex.index == bit.lshift(1, IndexConst.IndexAll) and slot0.ShipIndex.rarity == bit.lshift(1, IndexConst.RarityAll) and slot0.ShipIndex.camp == bit.lshift(1, IndexConst.CampAll) then
			table.insert(slot0.displays, slot5)
		elseif IndexConst.filterByIndex(slot5.shipVO, slot0.ShipIndex.index) and IndexConst.filterByRarity(slot6, slot0.ShipIndex.rarity) and IndexConst.filterByCamp(slot6, slot0.ShipIndex.camp) then
			table.insert(slot0.displays, slot5)
		end
	end

	slot0.shipsPage:ExecuteAction("Update", slot0.voteGroup, slot0.displays, slot0.count)
end

slot0.initTitles = function (slot0)
	slot1 = slot0.voteGroup:getConfig("time_vote")
	slot0.tagtimeTF.text = slot0.voteGroup:getTimeDesc()

	if not slot0.voteGroup:isFinalsRace() then
		slot0.title.text = slot0.voteGroup:getConfig("name")
	end

	slot0.subTitle.text = slot0.voteGroup:getConfig("desc")
end

slot0.updateNumber = function (slot0)
	slot0.numberTxt.text = "X" .. slot0.count
end

slot0.willExit = function (slot0)
	slot0.rankPage:Destroy()
	slot0.shipsPage:Destroy()
	slot0.voteMsgBox:Destroy()
end

return slot0
