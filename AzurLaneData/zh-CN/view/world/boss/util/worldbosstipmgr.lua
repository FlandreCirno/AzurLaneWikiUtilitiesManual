pg = pg or {}
pg.WorldBossTipMgr = singletonClass("WorldBossTipMgr")
slot1 = true
slot2 = false
slot3 = {
	"LevelMediator2",
	"WorldMediator",
	"WorldBossMediator"
}

pg.WorldBossTipMgr.Init = function (slot0, slot1)
	slot0.isInit = true
	slot0.list = {}

	PoolMgr.GetInstance():GetUI("WorldBossTipUI", true, function (slot0)
		slot0._go = slot0
		slot0._tf = tf(slot0)

		setActive(slot0._go, true)

		slot0.tipTF = slot0._tf:Find("BG")
		slot0.tipTFCG = slot0.tipTF:GetComponent(typeof(CanvasGroup))
		slot0.scrollText = slot0.tipTF:Find("Text"):GetComponent("ScrollText")

		setParent(slot0._tf, GameObject.Find("OverlayCamera/Overlay/UIOverlay").transform)

		slot0.richText = slot0.tipTF:Find("Text"):GetComponent("RichText")

		setActive(slot0.tipTF, false)

		if setActive then
			slot1()
		end
	end)
end

pg.WorldBossTipMgr.Show = function (slot0, slot1)
	if slot0 then
		function slot2()
			if slot0:IsEnable(slot1:GetType()) then
				table.insert(slot0.list, )

				if #table.insert.list == 1 then
					slot0:Start()
				end
			else
				print("Message intercepted")
			end
		end

		if not slot0.isInit then
			slot0.Init(slot0, slot2)
		else
			slot2()
		end
	end

	if slot1 and slot0:IsEnableNotify(slot1:GetType()) then
		slot2 = slot1:GetRoleName()
		slot4, slot5 = nil

		if WorldBoss.SUPPORT_TYPE_FRIEND == slot1:GetType() then
			slot4 = ChatConst.ChannelFriend
			slot5 = i18n("world_word_friend")
		elseif WorldBoss.SUPPORT_TYPE_GUILD == slot3 then
			slot4 = ChatConst.ChannelGuild
			slot5 = i18n("world_word_guild_member")
		else
			slot4 = ChatConst.ChannelWorldBoss
			slot5 = i18n("world_word_guild_player")
		end

		slot8 = {
			id = 4,
			timestamp = pg.TimeMgr.GetInstance():GetServerTime(),
			args = {
				isDeath = false,
				supportType = slot5,
				playerName = slot2,
				bossName = slot1.config.name,
				level = slot1.level,
				wordBossId = slot1.id,
				lastTime = slot1.lastTime
			},
			player = slot1:GetPlayer() or getProxy(PlayerProxy):getData(),
			uniqueId = slot1.id .. "_" .. slot1.lastTime
		}

		if slot4 == ChatConst.ChannelGuild then
			slot0:AddGuildMsg(slot4, slot8)
		else
			getProxy(ChatProxy):addNewMsg(ChatMsg.New(slot4, slot8))
		end
	end
end

pg.WorldBossTipMgr.AddGuildMsg = function (slot0, slot1, slot2)
	if not getProxy(GuildProxy):getRawData() then
		return
	end

	if not slot3:getMemberById(slot2.player.id) then
		return
	end

	slot2.player = slot4

	getProxy(GuildProxy):AddNewMsg(ChatMsg.New(slot1, slot2))
end

pg.WorldBossTipMgr.IsEnableNotify = function (slot0, slot1)
	return true
end

pg.WorldBossTipMgr.IsEnable = function (slot0, slot1)
	function slot3()
		slot0 = getProxy(ContextProxy)
		slot1 = slot0:getCurrentContext()

		return _.any(slot0, function (slot0)
			return slot0.mediator.__cname == slot0
		end)
	end

	return slot0:IsEnableNotify(slot1) and slot3()
end

pg.WorldBossTipMgr.Start = function (slot0)
	if #slot0.list > 0 then
		slot0:AddTimer()
	end
end

pg.WorldBossTipMgr.BuildClickableTxt = function (slot0, slot1)
	return string.format("<material=underline c=#FFFFFF h=1 event=onClick args=" .. slot1.id .. ">%s</material>", slot1:BuildTipText())
end

pg.WorldBossTipMgr.AddTimer = function (slot0)
	slot0:RemoveTimer()
	setActive(slot0.tipTF, true)
	slot0.scrollText:SetText(slot0:BuildClickableTxt(slot1))
	LeanTween.value(go(slot0.tipTF), 1, 0, 1):setOnUpdate(System.Action_float(function (slot0)
		slot0.tipTFCG.alpha = slot0
	end)).setOnComplete(slot2, System.Action(function ()
		setActive(slot0.tipTF, false)
		setActive.scrollText:SetText("")

		setActive.scrollText.SetText.tipTFCG.alpha = 1

		table.remove(slot0.list, 1)
		table.remove:Start()
	end)).setDelay(slot2, 4)
end

function slot4(slot0, slot1)
	if not slot0 or #slot0 == 0 then
		return
	end

	if not _.detect(slot0, function (slot0)
		return slot0.id == tonumber(slot0)
	end) or slot2.isDeath(slot2) then
		return
	end

	return true
end

pg.WorldBossTipMgr.OnClick = function (slot0, slot1, slot2, slot3, slot4)
	if not nowWorld or not slot5:IsActivate() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_boss_unactivated"))

		return
	end

	if not slot5:GetBossProxy() then
		return
	end

	function slot7(slot0)
		function slot3()
			pg.m02.sendNotification(slot1, GAME.CHECK_WORLD_BOSS_STATE, {
				bossId = tonumber(slot1),
				time = slot3,
				callback = function ()
					if slot1:getCurrentContext():getContextByMediator(CombatLoadMediator) then
						return
					end

					if slot0.mediator.__cname == "WorldBossMediator" then
						return
					end

					pg.m02:sendNotification(GAME.GO_WORLD_BOSS_SCENE)
					pg.m02:sendNotification(GAME.GO_SCENE, SCENE.WORLDBOSS, {
						worldBossId = tonumber(GAME.GO_SCENE)
					})
				end,
				failedCallback = 
			})
		end

		if getProxy(ContextProxy).getCurrentContext(slot1).mediator.__cname == "BattleMediator" then
			pg.MsgboxMgr.GetInstance().ShowMsgBox(slot4, {
				content = i18n("world_joint_exit_battle_tip"),
				onYes = function ()
					pg.m02:sendNotification(GAME.QUIT_BATTLE)
					pg.m02.sendNotification()
				end
			})
		else
			slot3()
		end
	end

	if slot6.isSetup then
		if not slot6.GetBossById(slot6, tonumber(slot2)) or slot8:isDeath() then
			slot9 = getProxy(ChatProxy)
			slot10 = (slot8 and slot8.lastTime) or "0"

			for slot15, slot16 in ipairs(slot11) do
				slot16.args.isDeath = true

				slot9:UpdateMsg(slot16)
			end

			for slot17, slot18 in ipairs(slot13) do
				slot18.args.isDeath = true

				slot12:UpdateMsg(slot18)
			end

			slot4()
			pg.TipsMgr:GetInstance():ShowTips(i18n("world_boss_none"))

			return
		end

		slot7()
	end
end

pg.WorldBossTipMgr.RemoveTimer = function (slot0)
	if LeanTween.isTweening(go(slot0.tipTF)) then
		LeanTween.cancel(go(slot0.tipTF))
	end
end

return
