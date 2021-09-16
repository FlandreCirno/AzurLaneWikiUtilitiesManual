slot0 = class("TowerClimbingController")

slot0.Ctor = function (slot0)
	slot0.view = TowerClimbingView.New(slot0)
end

slot0.SetCallBack = function (slot0, slot1, slot2)
	slot0.OnGameEndCallBack = slot1
	slot0.OnOverMapScore = slot2
end

slot0.SetUp = function (slot0, slot1)
	slot0:NetUpdateData(slot1)
	slot0.view:OnEnter()
end

slot0.NetUpdateData = function (slot0, slot1)
	slot0.data = slot1
end

slot0.StartGame = function (slot0, slot1)
	if slot0.enterGame then
		return
	end

	slot0.enterGame = true

	seriesAsync({
		function (slot0)
			slot0.map = TowerClimbingMapVO.New(slot0, slot0.view)

			slot0.view:OnCreateMap(slot0.map, slot0)
		end,
		function (slot0)
			slot0.map:Init(slot0.data, slot0)
		end,
		function (slot0)
			slot0.view:DoEnter(slot0)
		end
	}, function ()
		slot0.IsStarting = true

		slot0:MainLoop()
		slot0.MainLoop.view:OnStartGame()
	end)
end

slot0.EnterBlock = function (slot0, slot1, slot2)
	if slot0.map:GetPlayer():IsFatalInjured() then
		return
	end

	if slot0.map:GetPlayer():IsDeath() then
		return
	end

	if slot1.normal == Vector2.up then
		slot0.map:GetPlayer():UpdateStand(true)

		slot0.level = slot2

		slot0.map:SetCurrentLevel(slot2)
	end
end

slot0.StayBlock = function (slot0, slot1, slot2)
	if slot0.map:GetPlayer():IsFatalInjured() then
		return
	end

	if slot0.map:GetPlayer():IsDeath() then
		return
	end

	if _.any(slot1, function (slot0)
		return slot0.normal == Vector2.up
	end) and not slot0.map.GetPlayer(slot3):IsIdle() and slot2 == Vector2(0, 0) then
		slot0.map:GetPlayer():Idle()
	end
end

slot0.ExitBlock = function (slot0, slot1)
	if slot0.map:GetPlayer():IsFatalInjured() then
		return
	end

	if slot0.map:GetPlayer():IsDeath() then
		return
	end

	if slot0.level == slot1 then
		slot0.map:GetPlayer():UpdateStand(false)
	end
end

slot0.EnterAttacker = function (slot0)
	if slot0.map:GetPlayer():IsFatalInjured() then
		return
	end

	if slot0.map:GetPlayer():IsDeath() then
		return
	end

	slot0.map:GetPlayer():BeInjured()
	slot0.map:GetPlayer():AddInvincibleEffect(TowerClimbingGameSettings.INVINCEIBLE_TIME)
end

slot0.EnterGround = function (slot0)
	if slot0.map:GetPlayer():IsFatalInjured() then
		return
	end

	if slot0.map:GetPlayer():IsDeath() then
		return
	end

	slot0.map:GetPlayer():BeFatalInjured(function ()
		if not slot0.map:GetPlayer():IsDeath() then
			slot0.map:GetPlayer():AddInvincibleEffect(TowerClimbingGameSettings.INVINCEIBLE_TIME)
			slot0.map.GetPlayer().AddInvincibleEffect.map:GetPlayer():UpdateStand(true)
			slot0.map.GetPlayer().AddInvincibleEffect.map.GetPlayer().UpdateStand.map:ReBornPlayer()
			slot0.map.GetPlayer().AddInvincibleEffect.map.GetPlayer().UpdateStand.map.ReBornPlayer.map:GetPlayer():Idle()
		end
	end)

	if not slot0.map.GetPlayer(slot1):IsDeath() then
		slot0.map:SetGroundSleep(TowerClimbingGameSettings.GROUND_SLEEP_TIME)
	end
end

slot0.OnStickChange = function (slot0, slot1)
	if slot0.map:GetPlayer():IsFatalInjured() then
		return
	end

	if slot1 > 0.05 then
		slot0.map:GetPlayer():MoveRight()
	elseif slot1 < -0.05 then
		slot0.map:GetPlayer():MoveLeft()
	end
end

slot0.MainLoop = function (slot0)
	if not slot0.handle then
		slot0.handle = UpdateBeat:CreateListener(slot0.Update, slot0)
	end

	UpdateBeat:AddListener(slot0.handle)
end

slot0.Update = function (slot0)
	slot0.view:Update()
	slot0.map:Update()

	if slot0.IsStarting and slot0.map:GetPlayer():IsDeath() then
		slot0:EndGame()
	end
end

slot0.PlayerJump = function (slot0)
	slot0.map:GetPlayer():Jump()
end

slot0.PlayerIdle = function (slot0)
	slot0.map:GetPlayer():Idle()
end

function slot1(slot0)
	slot0.IsStarting = false

	if slot0.handle then
		UpdateBeat:RemoveListener(slot0.handle)
	end
end

slot0.EndGame = function (slot0)
	slot0(slot0)
	slot0.view:OnEndGame(slot0.map:GetPlayer().score, slot0.map.GetPlayer().mapScore)

	if slot0.OnGameEndCallBack then
		slot0.OnGameEndCallBack(slot1.score, slot1.higestscore, slot1.pageIndex)
	end

	if slot0.OnOverMapScore and slot1:IsOverMapScore() then
		slot0.OnOverMapScore(slot0.map.id, slot1.score)
	end
end

slot0.ExitGame = function (slot0)
	slot0(slot0)
	slot0.view:OnExitGame()

	if slot0.map then
		slot0.map:Dispose()

		slot0.map = nil
	end

	slot0.enterGame = nil
end

slot0.onBackPressed = function (slot0)
	return slot0.view:onBackPressed()
end

slot0.Dispose = function (slot0)
	slot0:ExitGame()
	slot0.view:Dispose()
end

return slot0
