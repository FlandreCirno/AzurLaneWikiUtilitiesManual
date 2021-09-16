slot0 = class("BackYardShipModel")
slot1 = 0.5
slot2 = 15
slot3 = require("Mod/BackYard/view/BackYardTool")

slot0.Ctor = function (slot0, slot1, slot2)
	pg.DelegateInfo.New(slot0)

	slot0.go = slot1
	slot0.tf = tf(slot1)

	slot0:updateBoatVO(slot2)

	slot0.cfg = pg.ship_data_statistics[slot0.boatVO.configId]
	slot0.speed = slot0.cfg.backyard_speed
	slot0.effectContainer = slot0.tf:Find("_effect_")
	slot0.bodyMask = slot0.tf:Find("bodyMask")
	slot0.onDrag = false
end

slot0.updateBoatVO = function (slot0, slot1)
	slot0.boatVO = slot1
end

slot0.onLoadSlotModel = function (slot0, slot1)
	slot0.viewComponent = slot1

	pg.ViewUtils.SetLayer(slot0.tf, Layer.UI)

	slot0.tf.localScale = Vector3(slot0, slot0, 1)
	slot0.model = slot0.tf:Find("model")
	slot0.model.localScale = Vector3(1, 1, 1)
	slot0.floorGrid = slot1.floorContain
	slot0.shipGridContainer = slot1.floorContain.parent:Find("ship_grid")
	slot0.shipGrid = slot0.shipGridContainer:Find("grid")
	slot0.shipGridImg = slot0.shipGrid:GetComponent(typeof(Image))
	slot0.spineAnimUI = slot0.model:GetComponent("SpineAnimUI")

	slot0.spineAnimUI:SetAction("stand2", 0)

	slot0.canvasGroup = GetOrAddComponent(slot0.go, "CanvasGroup")
	slot0.chatTF = slot0.tf:Find("chat")

	slot0:loadExp()
	slot0:loadInimacy()
	slot0:loadMoeny()
	slot0:loadShadow(slot1:findTF("bg/furContain/shadow"))
	slot0.tf:SetParent(slot1.floorContain, false)
	slot0:updateShadowTF(true)
	slot0:updatePosition(slot0.boatVO:getPosition())
	slot0:updateShadowPos()

	if not slot0.boatVO:IsVisitor() then
		slot0:addBoatDragListenter()
		slot0:loadClick()
	else
		slot0:LoadName()
	end

	slot0.actionCallback = {}
end

slot0.LoadName = function (slot0)
	slot0.nameTF = slot0.tf:Find("name")

	setText(slot0.nameTF, slot0.boatVO:GetName())
end

slot0.CancelInterAction = function (slot0)
	SetParent(slot0.tf, slot0.floorGrid)
	slot0:setAction("stand2")
end

slot0.loadShadow = function (slot0, slot1)
	slot0.shadowTF = slot0.tf:Find("shadow")

	setParent(slot0.shadowTF, slot1)

	slot0.shadowTF.localPosition = slot0.tf.localPosition
end

slot0.showChat = function (slot0, slot1, slot2, slot3, slot4)
	LeanTween.scale(tf(slot1), slot2, 0.5):setEase(LeanTweenType.easeOutBack):setDelay(slot3):setOnComplete(System.Action(function ()
		slot0()
	end))
end

slot0.loadClick = function (slot0)
	slot0.clickTF = slot0.tf:Find("click")

	onButton(slot0, slot0.clickTF, function ()
		if slot0.boatVO:hasInterActionFurnitrue() then
			return
		end

		if slot0.boatVO:hasSpineInterAction() then
			return
		end

		if slot0.stageId or slot0.archId then
			return
		end

		if slot0.boatVO:hasSpineExtra() then
			return
		end

		slot0.viewComponent:emit(BackyardMainMediator.ON_CLICK_SHIP)
		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BOAT_CLICK)
		pg.CriMgr.GetInstance().PlaySoundEffect_V3:switchAnimation("touch")

		if pg.CriMgr.GetInstance().PlaySoundEffect_V3.switchAnimation.inimacyTF.gameObject.activeSelf == true or slot0.moneyTF.gameObject.activeSelf == true then
			return
		end

		setButtonEnabled(slot0.clickTF, false)
		setButtonEnabled:showChat(slot0.chatTF, Vector3(1 / slot1, 1 / slot1), 0, function ()
			slot0:showChat(slot0.chatTF, Vector3(0, 0, 0), 2, function ()
				setButtonEnabled(slot0.clickTF, true)
			end)
		end)
	end)
end

slot0.loadExp = function (slot0)
	slot0.expTF = slot0.tf:Find("addition")
	slot0.moneyAdditionTF = findTF(slot0.expTF, "money")
	slot0.inimacyAdditionTF = findTF(slot0.expTF, "intimacy")
	slot0.expAdditionTF = findTF(slot0.expTF, "exp")

	slot0:changeInnerDir(1)
end

slot0.updateModelDir = function (slot0)
	if slot0.spineFurniture then
		slot2 = slot0.spineFurniture:hasSpineShipBodyMask()

		if slot0.spineFurniture:getSpineAniScale() then
			slot0.model.localScale = Vector3((slot2 and slot0.spineFurniture.dir == 2 and slot1 * -1) or slot1, 1, 1)
		end

		if slot2 then
			slot0:showBodyMask(slot0.spineFurniture:getSpineShipBodyMask(), slot0.spineFurniture.dir)
		end
	end
end

slot0.changeInnerDir = function (slot0, slot1)
	if slot0.bodyMask and go(slot0.bodyMask).activeSelf then
		tf(slot0.bodyMask).localScale = Vector3(slot1, 1, 1)
	end
end

slot0.loadInimacy = function (slot0)
	slot0.inimacyTF = slot0.tf:Find("intimacy")

	floatAni(slot0.inimacyTF, 20, 1)
	slot0:updateInimacy(slot0.boatVO:hasInimacy())
end

slot0.loadMoeny = function (slot0)
	slot0.moneyTF = slot0.tf:Find("money")
	slot0.moneyTF.localPosition = Vector2(145, 290)
	slot0.moneyTF.localScale = Vector2(1 / slot0, 1 / slot0)

	floatAni(slot0.moneyTF, 20, 1)
	slot0:updateMoney(slot0.boatVO:hasMoney())
end

slot0.updateShadowPos = function (slot0)
	if IsNil(slot0.shadowTF) then
		return
	end

	if slot0.archId then
		slot0.shadowTF.localPosition = slot0.turnTransformLocalPos(slot0.tf.localPosition, slot0.viewComponent:GetFurnitureGo(slot0.archId).Find(slot1, "childs"), slot0.floorGrid)
	else
		slot0.shadowTF.localPosition = slot0.tf.localPosition
	end
end

slot0.updateShadowTF = function (slot0, slot1)
	if IsNil(slot0.shadowTF) then
		return
	end

	if slot0.boatVO:hasInterActionFurnitrue() or slot0.boatVO:hasSpineInterAction() or slot0.boatVO:inStageFurniture() then
		setActive(slot0.shadowTF, false)
	else
		setActive(slot0.shadowTF, slot1)
	end
end

slot0.updateBottomGridPos = function (slot0, slot1)
	if slot1 then
		SetActive(slot0.shipGridContainer, true)

		slot0.shipGrid.localPosition = slot0.getLocalPos(slot1)
	end
end

slot0.addBoatDragListenter = function (slot0)
	slot1 = GetOrAddComponent(slot0.go, "EventTriggerListener")
	slot0.dragTrigger = slot1
	slot2 = nil

	slot1:AddBeginDragFunc(function (slot0, slot1)
		if slot0.isInTransport then
			return
		end

		if slot0.viewComponent.zoom.pinching then
			return
		end

		if Input.touchCount > 1 then
			return
		end

		slot0.viewComponent.dragShip = slot0

		slot0.viewComponent:enableZoom(false)

		slot0.onDrag = true

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BOAT_DRAG)

		slot1 = slot0.boatVO:getPosition()
		slot0.isMove = nil

		if slot0.boatVO:hasSpineInterAction() then
			slot0:breakSpineAnim()
		end

		if slot0.boatVO:hasSpineExtra() then
			slot0.viewComponent:emit(BackyardMainMediator.ON_CLEAR_SPINR_EXTRA, slot0.boatVO.id, slot0.boatVO.spineExtra)
		end

		if slot0.boatVO:hasInterActionFurnitrue() then
			slot0:clearInterAction()
		end

		slot0.spineAnimUI:SetAction("tuozhuai2", 0)
		slot0:closeBodyMask()
		slot0.viewComponent:emit(BackyardMainMediator.CANCEL_SHIP_MOVE, slot0.boatVO.id)
		slot0:removeItem()
		pg.BackYardSortMgr.GetInstance():AddToTopSortGroup(slot0.tf)
		slot0:changeInnerDir(Mathf.Sign(slot0.tf.localScale.x))
		slot0:changeGridColor(BackYardConst.BACKYARD_GREEN)
		slot0:updateBottomGridPos(slot0.boatVO:getPosition())
		slot0:updateShadowPos()
	end)
	slot1.AddDragFunc(slot1, function (slot0, slot1)
		if slot0.viewComponent.dragShip == slot0 then
			tf(slot0.go).localPosition = Vector3(slot1.getLocalPos(slot3).x, slot1.getLocalPos(slot3).y + slot2, 0)

			slot0:updateShadowPos()

			slot5, slot6 = slot0.viewComponent.houseVO:canMoveBoat(slot0.boatVO.id, slot1.getMapPos(slot2))

			slot0:changeGridColor(((slot5 or (slot0.viewComponent.furnitureVOs[slot6] and slot0.viewComponent.furnitureVOs[slot6]:canTriggerInteraction())) and BackYardConst.BACKYARD_GREEN) or BackYardConst.BACKYARD_RED)
			slot0:updateBottomGridPos(slot3)
		end
	end)
	slot1.AddDragEndFunc(slot1, function (slot0, slot1)
		if slot0.viewComponent.dragShip == slot0 then
			slot0.onDrag = false
			slot0.viewComponent.dragShip = nil

			slot0.viewComponent:enableZoom(true)
			slot0:endDrag(slot2, slot1.getMapPos(slot2))
			slot0:updateShadowPos()
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_BOAT_DRAG)
		end
	end)
end

slot0.endDrag = function (slot0, slot1, slot2)
	slot4, slot5 = slot0.viewComponent.houseVO.canPutShip(slot3, slot0.boatVO.id, slot2)

	if slot0.viewComponent.houseVO:getArchByPos(slot2) and (slot6:canInterAction() or slot6:canInterActionSpine()) and slot6:canInterActionShipGroup(slot0.boatVO.gruopId) then
		slot0:triggerInterAction(slot1, slot6.id)
	elseif not slot4 then
		slot0:triggerInterAction(slot1, slot5)
	else
		slot0:clearStage()

		tf(slot0.go).localPosition = Vector3(slot0.getLocalPos(slot2).x, slot0.getLocalPos(slot2).y + slot1, 0)
		slot0.isMove = nil

		SetActive(slot0.shipGridContainer, false)
		slot0.spineAnimUI:SetAction("stand2", 0)
		slot0:changeInnerDir(Mathf.Sign(slot0.tf.localScale.x))
		slot0.viewComponent:emit(BackyardMainMediator.END_DRAG_SHIP, slot0.boatVO.id, slot2)
		slot0:updateShadowTF(true)
	end

	if slot0.save then
		slot0.viewComponent:emit(BackyardMainMediator.SAVE_FURNITURE, false)
	end

	slot0.save = nil
end

slot0.triggerInterAction = function (slot0, slot1, slot2)
	slot4 = slot0.boatVO
	slot5 = slot0.viewComponent.furnitureVOs[slot2]

	function slot6()
		LeanTween.moveLocal(slot2.go, Vector3(slot0.getLocalPos(slot1).x, slot0.getLocalPos(slot1).y + slot3, 0), 0):setOnComplete(System.Action(function ()
			slot0.isMove = nil

			SetActive(slot0.shipGridContainer, false)
			SetActive:changeGridColor(BackYardConst.BACKYARD_GREEN)
			SetActive.changeGridColor.spineAnimUI:SetAction("stand2", 0)
			SetActive.changeGridColor.spineAnimUI.SetAction.viewComponent:emit(BackyardMainMediator.END_DRAG_SHIP, slot1.id, )
		end))
	end

	function slot7()
		if slot0:hasInterActionFurnitrue() then
			slot1:clearStage()

			slot0 = slot1.clearStage:getInterActionFurnitrueId()
			slot1 = slot2[slot0]:getOrderByShipId(slot0.id)

			slot1:updateInterActionPos(slot2[slot0], slot1)
			slot1:InterActionSortSibling(slot0)
		elseif slot0:inStageFurniture() then
			slot1:updateStageInterAction(slot0:getPosition())
			SetActive(slot1.shipGridContainer, false)
		else
			slot0 = nil

			for slot4, slot5 in pairs(slot2) do
				for slot10, slot11 in pairs(slot6) do
					if slot11.x == slot3.x and slot11.y == slot3.y then
						slot0 = slot5

						break
					end
				end

				if slot0 then
					break
				end
			end

			if slot0 and slot0:canInterActionShipGroup(slot0.gruopId) and slot0:isInterActionSpine() and slot0:canInterActionSpine() then
				if slot0:isMoveable() then
					slot1.save = nil
				end

				slot1.viewComponent:emit(BackyardMainMediator.INTERACTION_SPINE, slot1.boatVO.id, slot0.id)
			else
				slot4()
			end
		end
	end

	if slot2 and slot5.IsFollower(slot5) then
		if slot4:hasInterActionFurnitrue() then
			slot7()
		else
			slot6()
		end
	elseif slot2 and slot5:isTransPort() and slot5:canInterActionShipGroup(slot4.gruopId) and not slot5:isLock() then
		slot0:clearStage()
		slot0.viewComponent:emit(BackyardMainMediator.INTERACTION_TRANSPORT, slot0.boatVO.id, slot5.id)
	elseif slot2 and slot5:canInterActionShipGroup(slot4.gruopId) and slot5:isInterActionSpine() and slot5:canInterActionSpine() and not slot5:isTransPort() then
		slot0:clearStage()
		slot0.viewComponent:emit(BackyardMainMediator.INTERACTION_SPINE, slot0.boatVO.id, slot5.id)
	elseif slot2 and slot5:canInterActionShipGroup(slot4.gruopId) and slot5:isInterActionSpine() and slot5:canInterActionSpineExtra() and not slot5:isTransPort() then
		slot0:clearStage()
		slot0.viewComponent:emit(BackyardMainMediator.ON_SPINE_EXTRA, slot4.id, slot2)
	elseif slot2 and slot5:canInterActionShipGroup(slot4.gruopId) and slot5:canInterAction() then
		slot0:clearStage()

		if slot4:hasInterActionFurnitrue() and slot2 == slot4:getInterActionFurnitrueId() then
			slot0:updateInterActionPos(slot5, slot5:getOrderByShipId(slot4.id))
			slot0:InterActionSortSibling(slot2)
		else
			slot0.viewComponent:emit(BackyardMainMediator.INTERACTION, slot4.id, slot2)
		end
	elseif slot2 and slot5:canInterActionShipGroup(slot4.gruopId) and slot5:isStageFurniture() then
		slot0:clearStage()
		slot0.spineAnimUI:SetAction("stand2", 0)
		slot0.viewComponent:emit(BackyardMainMediator.INTERACTION_STAGE, slot0.boatVO.id, slot5.id)
		SetActive(slot0.shipGridContainer, false)
	else
		slot7()
	end
end

slot0.InterActionSortSibling = function (slot0, slot1)
	slot2 = slot0.viewComponent:GetFurnitureGo(slot1)
	slot5 = slot0.viewComponent.furnitureVOs[slot1].getConfig(slot3, "interAction")
	slot6 = {}
	slot7 = false

	for slot11, slot12 in pairs(slot4) do
		slot13 = nil

		if slot5[slot11][5] and slot5[slot11][5] == BackyardBoatVO.INTERACTION_TYPE_AFTER then
			slot13 = slot2:Find("icon/char_" .. slot12)
			slot7 = true
		else
			slot13 = slot2:Find("char_" .. slot12)
		end

		if slot13 then
			table.insert(slot6, {
				go = slot13,
				order = slot3:getOrderByShipId(slot12) or "",
				x = slot11
			})
		end
	end

	table.sort(slot6, function (slot0, slot1)
		return slot0.x < slot1.x
	end)

	for slot11, slot12 in pairs(slot6) do
		slot12.go:SetAsLastSibling()

		if slot2:Find(BackYardConst.FURNITRUE_MASK_ORDER_NAME .. slot12.order) then
			if slot7 then
				slot13:SetSiblingIndex(2)
			else
				slot13:SetAsLastSibling()
			end
		end
	end
end

slot0.changeGridColor = function (slot0, slot1)
	slot0.shipGridImg.color = slot1
end

slot0.createItem = function (slot0, slot1)
	if not IsNil(slot0.tf) then
		slot2 = nil
		slot3 = (not slot0.archId or slot0.viewComponent:getMap({
			parent = slot0.archId
		})) and (not slot0.stageId or slot0.viewComponent:getMap({
			parent = slot0.stageId
		})) and slot0.viewComponent.map:CreateItem(1, 1, {
			isBoat = true,
			id = slot0.boatVO.id
		})

		slot3:SetPos(slot1.x + 1, slot1.y + 1)

		slot4 = (not slot0.archId or slot0.viewComponent.getMap()) and (not slot0.stageId or slot0.viewComponent.getMap()) and slot0.viewComponent.map:InsertChar(slot3)

		pg.BackYardSortMgr.GetInstance():SortHandler()

		slot0.item = slot3
	end
end

slot0.removeItem = function (slot0)
	if slot0.item then
		slot1 = nil

		(not slot0.archId or slot0.viewComponent:getMap({
			parent = slot0.archId
		})) and (not slot0.stageId or slot0.viewComponent:getMap({
			parent = slot0.stageId
		})) and slot0.viewComponent.map:RemoveChar(slot0.item)

		slot0.item = nil

		slot0.tf:SetAsLastSibling()
	end
end

slot0.updatePosition = function (slot0, slot1)
	slot0:removeItem()
	slot0:createItem(slot0.boatVO:getPosition())

	slot2 = nil
	slot0.tf.localPosition = Vector3((not slot0.archId or slot0:calcOnFurnitureLPos(slot1, slot0.archId)) and (not slot0.stageId or slot0:calcOnFurnitureLPos(slot1, slot0.stageId)) and slot0.getLocalPos(slot1).x, (not slot0.archId or slot0.calcOnFurnitureLPos(slot1, slot0.archId)) and (not slot0.stageId or slot0.calcOnFurnitureLPos(slot1, slot0.stageId)) and slot0.getLocalPos(slot1).y + slot1, 0)

	slot0:updateShadowTF(true)
	slot0:updateShadowPos()
end

slot0.setAction = function (slot0, slot1)
	slot0.spineAnimUI:SetAction(slot1, 0)
end

slot0.updateInterActionPos = function (slot0, slot1, slot2)
	slot0.print("start interaction..................")
	slot0:removeItem()

	slot3 = slot0.viewComponent:GetFurnitureGo(slot1.id)
	slot4, slot5, slot6, slot7, slot8, slot9 = slot1:getInterActionData(slot2)

	SetParent(slot0.tf, (slot8 and slot8 == BackyardBoatVO.INTERACTION_TYPE_AFTER and slot3:Find("icon")) or slot3)

	if slot6 or {
		1,
		1
	}[3] then
		slot0.tf.localScale = Vector3(slot3.localScale.x * -1 * slot1, slot1, 1)
	elseif slot1:getConfig("dir") == 1 and slot3.localScale.x < 0 then
		slot0.tf.localScale = Vector3(1 * slot1, slot1 * slot11[2], 1)
	else
		slot0.tf.localScale = Vector3(slot1 * slot11[1], slot1 * slot11[2], 1)
	end

	if slot9 then
		slot0:showBodyMask(slot9)
	end

	if slot7 then
		slot12 = slot3:Find(BackYardConst.FURNITRUE_MASK_ORDER_NAME .. slot2)

		setActive(slot12, true)
		slot12:SetAsLastSibling()
	end

	if slot0.nameTF then
		slot0.nameTF.localScale = Vector3(Mathf.Sign(slot0.tf.localScale.x), 1, 1)
	end

	slot0.tf.anchoredPosition = Vector3(slot5[1], slot5[2], 0)

	slot0.spineAnimUI:SetAction(slot4, 0)
	slot0:updateShadowTF(false)
	slot0:updateShadowPos()

	slot0.isMove = nil

	SetActive(slot0.shipGridContainer, false)
end

slot0.clearInterAction = function (slot0)
	slot0.print("clear interaction.............")

	if slot0.viewComponent:GetFurnitureGo(slot1):Find(BackYardConst.FURNITRUE_MASK_ORDER_NAME .. slot0.viewComponent.furnitureVOs[slot0.boatVO:getInterActionFurnitrueId()].getOrderByShipId(slot3, slot0.boatVO.id)) then
		setActive(slot5, false)
	end
end

slot0.updateSpineInterAction = function (slot0, slot1)
	SetActive(slot0.shipGridContainer, false)
	slot0.print(" start spine interaciton...............")
	slot0:removeItem()

	slot0.spineFurniture = slot1

	slot0:updateModelDir()
	slot0:updateShadowTF(false)
	SetParent(slot0.tf, slot2, true)

	slot0.tf.localScale = Vector3(slot1, slot1, 1)

	if slot1:getSpineAniPos() then
		slot0.tf.anchoredPosition = slot3
	end

	slot4 = slot1:getSpineAnims()
	slot5 = slot2:Find(BackYardConst.FURNITRUE_MASK_NAME)
	slot0.roles = {}
	slot0.breakActionName = slot1:getBreakAnim()

	table.insert(slot0.roles, slot0.spineAnimUI)
	table.insert(slot0.roles, GetOrAddComponent(slot2:Find("icon/spine"), typeof(SpineAnimUI)))

	if slot1:hasSpineMask() then
		SetActive(slot5, true)
		slot5:SetAsLastSibling()
		table.insert(slot0.roles, GetOrAddComponent(slot5:Find("spine"), typeof(SpineAnimUI)))
	end

	for slot11, slot12 in pairs(slot0.roles) do
		slot12:SetActionCallBack(nil)
		slot12:SetAction(slot13, 0)
		setActive(slot12.gameObject, false)
		setActive(slot12.gameObject, true)
	end

	if slot1:IsRandomController() then
		slot0:PlayRandomControllerAction(slot1)
	else
		slot0:PlaySpineAction(slot1)
	end
end

slot0.PlayRandomControllerAction = function (slot0, slot1)
	slot5 = slot1:getSpineAnims()[math.random(1, #slot1.getSpineAnims())][1]
	slot6 = slot1.getSpineAnims()[math.random(1, #slot1.getSpineAnims())][2]
	slot7 = slot1.getSpineAnims()[math.random(1, #slot1.getSpineAnims())][3]

	function slot8(slot0, slot1, slot2)
		slot0:SetActionCallBack(function (slot0)
			if slot0 == "finish" then
				slot0()
			end
		end)
		slot0.SetAction(slot0, slot1, 0)
	end

	slot9 = {}

	for slot13, slot14 in ipairs(slot0.roles) do
		if slot13 == 1 then
			slot14.SetAction(slot14, slot7, 0)
		else
			table.insert(slot9, function (slot0)
				slot0(slot0, , slot0)
			end)
		end
	end

	setParent(slot0.tf, slot13)
	setActive(slot13, true)
	parallelAsync(slot9, function ()
		setParent(slot0.tf, )
		setActive(slot0.tf, false)
		setActive:clearSpine()
		setActive.clearSpine:updateShadowTF(true)
		setActive.clearSpine.updateShadowTF:updateShadowPos()
		setActive.clearSpine.updateShadowTF.updateShadowPos.viewComponent:emit(BackyardMainMediator.RESET_BOAT_POS, slot0.boatVO.id)
	end)
end

slot0.PlaySpineAction = function (slot0, slot1)
	function slot2()
		if slot0:HasFollower() then
			slot1:startSpineAnimator(slot1.startSpineAnimator)
		end
	end

	function slot3(slot0)
		if slot0:isFollowFurnitrueAnim() then
			slot1:PlayActionAccordingFurniture(slot0, slot0)
		else
			slot1:PlayActionTogether(slot0, slot0)
		end
	end

	if slot1.getPreheatAnim(slot1) and type(slot4) == "string" then
		setActive(slot0.tf, false)
		slot0:PlayPerHeatAnim({
			slot0.roles[2]
		}, slot4, function ()
			setActive(slot0.tf, true)
			slot1()
			true()
		end)
	elseif slot4 and type(slot4) == "table" then
		slot2()
		slot0:PlayPerHeatAnim({
			slot0.roles[2],
			slot0.roles[3]
		}, slot5, function ()
			slot0(true)
		end)
		slot0.roles[1].SetAction(slot7, slot4[2], 0)
	else
		slot2()
		slot3()
	end
end

slot0.PlayPerHeatAnim = function (slot0, slot1, slot2, slot3)
	function slot4(slot0, slot1)
		slot0:SetActionCallBack(function (slot0)
			if slot0 == "finish" then
				slot0:SetActionCallBack(nil)
				slot0.SetActionCallBack()
			end
		end)
		slot0.SetAction(slot0, slot0, 0)
	end

	slot5 = {}

	for slot9, slot10 in ipairs(slot1) do
		table.insert(slot5, function (slot0)
			slot0(slot0, slot0)
		end)
	end

	parallelAsync(slot5, slot3)
end

slot0.PlayActionAccordingFurniture = function (slot0, slot1, slot2)
	slot3 = slot1:getSpineAnims()
	slot4 = slot0.roles[2]
	slot5, slot6 = nil

	function slot7(slot0)
		if slot0 > #slot0 then
			slot1:SetActionCallBack(nil)

			slot1, slot2 = slot1:isLoopSpineInterAction()

			if slot1 then
				if slot2 == BackyardFurnitureVO.INTERACTION_LOOP_TYPE_ALL then
					slot3()
				elseif slot2 == BackyardFurnitureVO.INTERACTION_LOOP_TYPE_LAST_ONE then
				end
			elseif slot2:hasTailAction() then
				if slot2 ~= slot2:getTailAction() then
					slot5:playTailActions(slot3)
				end
			else
				slot5:clearSpine()
				slot5:updateShadowTF(true)
				slot5:updateShadowPos()
				slot5.viewComponent:emit(BackyardMainMediator.RESET_BOAT_POS, slot5.boatVO.id)
			end
		else
			if type(slot0[slot0][1]) == "table" then
				slot1 = slot1[math.random(1, #slot1)]
			end

			slot1:SetAction(slot1, 0)

			if slot5.roles[1] then
				slot5.roles[1]:SetAction(slot1, 0)
			end

			if slot5.roles[3] then
				slot5.roles[3]:SetAction(slot1, 0)
			end

			if slot5.bodyMask then
				slot5.bodyMask:GetComponent(typeof(Image)).enabled = not slot0[slot0][2]
			end

			slot4 = slot1

			slot5:callActionCB("update", slot1)
		end
	end

	function slot5()
		if slot0:HasFollower() and not slot1 then
			slot2:endSpineAnimator(slot2.endSpineAnimator)
			slot2:startSpineAnimator(slot2.startSpineAnimator)
		end

		slot2:callActionCB("end")

		slot0 = 1

		slot3:SetActionCallBack(function (slot0)
			if slot0 == "finish" then
				slot0 + 1(slot0 + 1)
			end
		end)
		slot4(1)
	end

	slot5()
end

slot0.pauseAnim = function (slot0, slot1)
	slot2 = pairs
	slot3 = slot0.roles or {}

	for slot5, slot6 in slot2(slot3) do
		slot6:SetActionCallBack(nil)
		slot6:SetAction(slot0:getSpineNormalAction(slot6), 0)
	end

	slot0:endSpineAnimator(slot0.spineFurniture, slot1)
end

slot0.registerActionCB = function (slot0, slot1, slot2, slot3)
	slot0.actionCallback[slot1] = {
		updateCb = slot2,
		endCb = slot3
	}
end

slot0.removeAllActionCB = function (slot0)
	slot0.actionCallback = {}
end

slot0.removeActionCB = function (slot0, slot1)
	slot0.actionCallback[slot1] = nil
end

slot0.callActionCB = function (slot0, slot1, slot2)
	for slot6, slot7 in pairs(slot0.actionCallback) do
		if slot1 == "update" then
			slot7.updateCb(slot2)
		elseif slot1 == "end" then
			slot7.endCb(slot2)
		end
	end
end

slot0.resumeAnim = function (slot0)
	if slot0.spineFurniture:isFollowFurnitrueAnim() then
		slot0:PlayActionAccordingFurniture(slot1)
	else
		slot0:PlayActionTogether(slot1)
	end
end

slot4 = 0
slot5 = 1
slot6 = 2

slot0.PlayActionTogether = function (slot0, slot1, slot2)
	slot3 = slot1:getSpineAnims()
	slot4 = 0
	slot5, slot6, slot7, slot8, slot9 = nil

	function slot8(slot0)
		slot0:SetActionCallBack(nil)

		slot1, slot2 = slot0:isLoopSpineInterAction()

		if not slot1 then
			if slot0:hasEndAnimName() then
				slot0:SetAction(slot0:getEndAnimName(), 0)

				return
			elseif not slot0:hasTailAction() then
				slot0:SetAction(slot1:getSpineNormalAction(slot0), 0)
			end
		end

		if slot2 == #slot1.roles then
			if slot1 then
				slot1:callActionCB("end")

				if slot2 == BackyardFurnitureVO.INTERACTION_LOOP_TYPE_ALL then
					slot3()
				elseif slot2 == BackyardFurnitureVO.INTERACTION_LOOP_TYPE_LAST_ONE then
				end
			elseif slot0:hasTailAction() then
				if slot0 ~= slot0:getTailAction() then
					slot1:playTailActions(slot3)
				end
			else
				slot1:clearSpine()
				slot1:updateShadowTF(true)
				slot1:updateShadowPos()
				slot1.viewComponent:emit(BackyardMainMediator.RESET_BOAT_POS, slot1.boatVO.id)
			end
		end
	end

	function slot7(slot0, slot1)
		if slot1 > #slot0 then
			slot1 = slot1 + 1

			slot1 + 1(slot0)
		else
			slot3(slot0, slot1, function ()
				slot0 = slot0 + 1

				slot1(slot2, slot1)
			end)
		end
	end

	function slot6(slot0, slot1, slot2)
		if type(slot0[slot1][1]) == "table" then
			slot3 = slot3[math.random(1, #slot3)]
		end

		slot1:callActionCB("update", slot3)

		if slot0 == slot1.roles[1] and slot0[slot1][3] then
			slot3 = slot0[slot1][3]
		end

		slot4, slot5 = slot2:getUniqueShipAction(slot3, slot1.boatVO)

		if slot4 and slot5 == slot3 then
			slot3 = slot4
		elseif slot4 and slot5 == slot4 and slot0 == slot1.roles[1] then
			slot3 = slot4
		elseif slot4 and slot5 == slot5 and slot0 ~= slot1.roles[1] then
			slot3 = slot4
		end

		slot0:SetAction(slot3, 0)

		slot6 = slot3

		if slot2:GetSpecailActiont(slot3) and slot6 > 0 then
			if slot1.timer[slot0] then
				slot1.timer[slot0]:Stop()

				slot1.timer[slot0] = nil
			end

			slot1.timer[slot0] = Timer.New(function ()
				slot0.timer[slot1]:Stop()

				slot0.timer[slot1].Stop.timer[slot0.timer[slot1]] = nil

				nil()
			end, slot6, 1)

			slot1.timer[slot0]:Start()
		else
			slot0:SetActionCallBack(function (slot0)
				if slot0 == "finish" then
					slot0:SetActionCallBack(nil)
					slot0.SetActionCallBack()
				end
			end)
		end
	end

	slot0.timer = {}

	function slot5()
		if slot0:HasFollower() and not slot1 then
			slot2:endSpineAnimator(slot2.endSpineAnimator)
			slot2:startSpineAnimator(slot2.startSpineAnimator)
		end

		slot3 = 0

		for slot3, slot4 in pairs(slot2.roles) do
			slot4(slot4, 1, function ()
				slot0 = slot0 + 1

				slot1(slot2, slot1)
			end)
		end
	end

	slot5()
end

slot0.playTailActions = function (slot0, slot1)
	for slot5, slot6 in pairs(slot0.roles) do
		slot6:SetAction(slot1, 0)
	end
end

slot0.startSpineAnimator = function (slot0, slot1, slot2)
	if slot1:ExistFollowBoneNode() then
		slot0:StartFollowBone(slot1)
	else
		slot0.animtorNameIndex = slot0.animtorNameIndex or math.random(1, #slot1:getAnimtorControlName(slot2 or 0))
		slot6 = slot0.viewComponent:GetFurnitureGo(slot1.id):Find(slot0.animtorNameIndex or math.random(1, #slot1.getAnimtorControlName(slot2 or 0)))
		slot7 = slot6:GetComponent(typeof(Animator))

		SetParent(slot0.tf, slot6)

		if slot1:hasAnimatorMask() then
			slot8 = slot1:getAnimatorMaskConfig()
			slot9 = slot3:Find("mask")
			slot9.sizeDelta = Vector2(slot8[1][1], slot8[1][2])
			slot9.anchoredPosition = Vector3(slot8[2][1], slot8[2][2], 0)

			setActive(slot9, true)
			SetParent(slot6, slot9)
		end

		if slot6:GetComponent(typeof(DftAniEvent)) then
			slot9 = 1

			slot8:SetTriggerEvent(function (slot0)
				if slot0.localScale.x < 0 then
					slot1 = -1

					slot2:changeInnerDir(1)
				end
			end)
			slot8.SetEndEvent(slot8, function (slot0)
				if slot0 == -1 then
					slot1:changeInnerDir(-1)

					slot0 = 1
				end
			end)
		end

		slot0.inAnimator = true

		setActive(slot6, true)
	end
end

slot0.endSpineAnimator = function (slot0, slot1, slot2, slot3)
	if slot1:ExistFollowBoneNode() then
		slot0:EndFollowBone(slot1)
	else
		if not slot0.animtorNameIndex then
			return
		end

		slot2 = slot2 or 0

		if slot1 and slot1:hasAnimator() and slot0.viewComponent:GetFurnitureGo(slot1.id) then
			slot5 = nil
			slot6 = slot1:getAnimtorControlGoName(slot2, slot0.animtorNameIndex)

			if slot1:hasAnimatorMask() then
				slot5 = slot4:Find("mask/" .. slot6)
				slot7 = slot4:Find("mask")

				if not slot3 then
					setActive(slot7, false)
				end

				SetParent(slot5, slot4)
			else
				slot5 = slot4:Find(slot6)
			end

			if slot5:GetComponent(typeof(DftAniEvent)) then
				slot7:SetTriggerEvent(nil)
				slot7:SetTriggerEvent(nil)
			end

			setActive(slot5, false)
		end

		slot0.animtorNameIndex = nil
		slot0.inAnimator = nil
	end
end

slot0.StartFollowBone = function (slot0, slot1)
	slot6, slot3 = slot1:GetFollowBone()
	slot0.tf.localScale = Vector3(slot3 * slot0, slot0, slot0)
	SpineAnimUI.AddFollower(slot2, slot0.viewComponent:GetFurnitureGo(slot1.id).Find(slot4, "icon/spine"), slot0.tf).GetComponent(slot5, "Spine.Unity.BoneFollowerGraphic").followLocalScale = true
end

slot0.EndFollowBone = function (slot0, slot1)
	slot2 = slot1:GetFollowBone()
	slot3 = slot0.viewComponent:GetFurnitureGo(slot1.id)
	slot0.tf.localScale = Vector3(slot0, slot0, slot0)
end

slot0.setSpineAnimtorParent = function (slot0, slot1)
	if slot1 and slot1:hasAnimator() and slot0.viewComponent:GetFurnitureGo(slot1.id) then
		SetParent(slot0.tf, slot2, true)
	end
end

slot0.breakSpineAnim = function (slot0, slot1)
	if slot0.roles and #slot0.roles > 0 then
		slot2 = 0

		function slot3(slot0)
			slot0 + 1.SetAction(slot0, slot1, 0)
			slot0 + 1.SetActionCallBack(slot0, nil)

			if slot0 + 1 == #slot1.roles then
				slot1:clearSpine()

				if slot1.clearSpine then
					slot2()
				end
			end
		end

		for slot7, slot8 in pairs(slot0.roles) do
			slot8.SetActionCallBack(slot8, nil)

			if slot0.breakActionName then
				slot8:SetAction(slot0.breakActionName, 0)
				slot8:SetActionCallBack(function (slot0)
					if slot0 == "finish" then
						slot0(slot0)
					end
				end)
			else
				slot3(slot8)
			end
		end

		return
	end

	if slot1 then
		slot1()
	end
end

slot0.getSpineNormalAction = function (slot0, slot1)
	if slot1 == slot0.spineAnimUI then
		return "stand2"
	elseif slot0.spineFurniture then
		slot2, slot3 = slot0.spineFurniture:getSpineName()

		return (slot3 and slot3) or "normal"
	end

	return "stand2"
end

slot0.clearSpine = function (slot0)
	slot0.viewComponent:emit(BackyardMainMediator.CLEAR_SPINE, slot0.boatVO.id)
end

slot0.clearSpineInteraction = function (slot0, slot1)
	slot0.print("clear spine interaction.............")

	for slot5, slot6 in pairs(slot0.roles) do
		slot7 = slot0:getSpineNormalAction(slot6)

		slot6:SetActionCallBack(nil)

		if slot5 == 3 then
			slot6:SetActionCallBack(function (slot0)
				if slot0 == "action" then
					slot0:SetActionCallBack(nil)
					setActive(tf(go(slot0)).parent, false)
				end
			end)
		end

		slot6.SetAction(slot6, slot7, 0)

		if slot0.timer and slot0.timer[slot6] then
			slot0.timer[slot6]:Stop()

			slot0.timer[slot6] = nil
		end
	end

	slot0.roles = {}
	slot0.model.localScale = Vector3(1, 1, 1)

	if not slot0.spineFurniture:IsRandomController() then
		slot0:endSpineAnimator(slot0.spineFurniture)
	end

	SetParent(slot0.tf, slot0.viewComponent.floorContain, true)

	if slot0.spineFurniture and slot0.spineFurniture:getSpineAniPos() then
		slot0.tf.localPosition = slot0.getLocalPos(slot0.spineFurniture:getSpineAinTriggerPos())
	end

	slot0:closeBodyMask()

	slot0.spineFurniture = nil
	slot0.breakActionName = nil
	slot0.tf.localScale = Vector3(slot1, slot1, 1)
	slot0.tf.eulerAngles = Vector3(0, 0, 0)
	slot0.save = slot1
end

slot0.updateStageInterAction = function (slot0, slot1)
	slot2 = slot0.boatVO:getStageId()

	if slot1 and slot2 then
		slot0.isMove = false

		slot0:removeItem()

		slot0.stageId = slot2

		SetParent(slot0.tf, slot5)
		slot0:createItem(slot0.boatVO:getPosition())

		slot0.tf.localPosition = slot0:calcOnFurnitureLPos(slot1, slot0.stageId)

		slot0.spineAnimUI:SetAction("stand2", 0)

		if slot0.viewComponent.maps[slot2] then
			slot0.viewComponent.maps[slot3].afterSortFunc(slot0.viewComponent.maps[slot3].sortedItems)
		end

		slot0.viewComponent:emit(BackyardMainMediator.ADD_MOVE_FURNITURE, slot0.boatVO.id, slot3)
		slot0:updateShadowTF(false)
	end
end

slot0.clearStageInterAction = function (slot0)
	slot0.stageId = nil

	SetParent(slot0.tf, slot0.floorGrid)
end

slot0.clearStage = function (slot0)
	if slot0.stageId then
		slot0.viewComponent:emit(BackyardMainMediator.CLEAR_STAGE_INTERACTION, slot0.boatVO.id)
	end
end

slot0.updateArchInterAction = function (slot0, slot1)
	slot0:removeItem()

	if slot0.nextPosition then
		slot0.targetLPosition = slot0:calcOnFurnitureLPos(slot0.nextPosition, slot1)
	end

	slot0.archId = slot1
	slot2 = slot0.viewComponent:GetFurnitureGo(slot1)

	SetParent(slot0.tf, slot2:Find("childs"), true)

	if slot2:Find(BackYardConst.ARCH_MASK_NAME) then
		slot3:SetAsLastSibling()
		setActive(slot3, true)
	end

	slot0:createItem(slot0.boatVO:getPosition())
end

slot0.clearArchInterAction = function (slot0)
	slot0:removeItem()

	if slot0.nextPosition then
		if slot0.stageId then
			slot0.targetLPosition = slot0:calcOnFurnitureLPos(slot0.nextPosition, slot0.stageId)
		else
			slot0.targetLPosition = slot0.getLocalPos(slot0.nextPosition)
		end
	end

	if slot0.stageId then
		SetParent(slot0.tf, slot0.viewComponent:GetFurnitureGo(slot0.stageId).Find(slot1, "childs"), true)
	else
		SetParent(slot0.tf, slot0.floorGrid, true)
	end

	if slot0.viewComponent:GetFurnitureGo(slot0.archId):Find(BackYardConst.ARCH_MASK_NAME) then
		setActive(slot2, false)
	end

	slot0.archId = nil

	slot0:createItem(slot0.boatVO:getPosition())
end

slot0.calcOnFurnitureLPos = function (slot0, slot1, slot2)
	return slot0.turnTransformLocalPos(slot0.getLocalPos(slot1), slot0.floorGrid, slot0.viewComponent:GetFurnitureGo(slot2).Find(slot3, "childs"))
end

slot0.moveOnFurniture = function (slot0, slot1, slot2, slot3)
	slot4 = slot0.stageId
	slot5 = nil

	slot0:startMove((not slot0.archId or slot0:calcOnFurnitureLPos(slot1, slot0.archId)) and slot0:calcOnFurnitureLPos(slot1, slot0.stageId), slot1, slot2, slot3)
end

slot0.move = function (slot0, slot1, slot2, slot3)
	slot4 = nil

	slot0:startMove((not slot0.archId or slot0:calcOnFurnitureLPos(slot1, slot0.archId)) and slot0.getLocalPos(slot1), slot1, slot2, slot3)
end

slot0.startMove = function (slot0, slot1, slot2, slot3, slot4)
	slot5 = math.floor(1 / slot0.speed)
	slot0.nextPosition = slot2
	slot0.targetLPosition = slot1

	if not slot0.isMove then
		slot0.spineAnimUI:SetAction("walk", 0)

		slot0.isMove = true
	end

	slot7 = slot0.getSign((slot2.x < slot0.boatVO:getPosition().x and slot2.y == slot6.y) or (slot2.x == slot6.x and slot6.y < slot2.y))
	slot8 = 1

	if slot0.stageId then
		slot8 = slot0.viewComponent:GetFurnitureGo(slot0.stageId).localScale.x
	end

	slot0.tf.localScale = Vector3(slot1 * slot7 * slot8, slot1, 1)

	if slot0.nameTF then
		slot0.nameTF.localScale = Vector3(Mathf.Sign(slot0.tf.localScale.x), 1, 1)
	end

	slot0:changeInnerDir(slot7)

	slot0.moveNextTimer = Timer.New(function ()
		if slot0.moveNextTimer then
			slot0.moveNextTimer:Stop()

			slot0.moveNextTimer.Stop.moveNextTimer = nil
		end

		slot0.viewComponent:emit(BackyardMainMediator.ON_HALF_MOVE, slot0.boatVO.id, slot0.viewComponent)

		if slot0.viewComponent.emit.targetLPosition ~= BackyardMainMediator.ON_HALF_MOVE then
			LeanTween.cancel(slot0.go)
			slot3(slot0.targetLPosition)
		end

		slot0:removeItem()
		slot0.removeItem:createItem(slot0.removeItem)
	end, slot5 / 2, 1)

	slot0.moveNextTimer.Start(slot10)

	slot0.shadowTF.localScale = Vector2(slot7, 1)

	function (slot0)
		slot0.shadowTF.localScale = Vector2(slot0.shadowTF, 1)

		LeanTween.moveLocal(slot0.go, Vector3(slot0.x, slot0.y + slot2, 0), ):setOnUpdate(System.Action_float(function (slot0)
			slot0:updateShadowPos()
		end)).setOnComplete(slot1, System.Action(function ()
			if slot0 then
				slot1.spineAnimUI:SetAction("stand2", 0)

				slot1.spineAnimUI.isMove = nil
			end

			if slot2 then
				slot2()
			end
		end))
	end(slot1)
end

slot0.cancelMove = function (slot0)
	if slot0.moveNextTimer then
		slot0.moveNextTimer:Stop()

		slot0.moveNextTimer = nil
	end

	if LeanTween.isTweening(slot0.go) then
		LeanTween.cancel(slot0.go)
	end

	if slot0.isMove then
		slot0.spineAnimUI:SetAction("stand2", 0)

		slot0.isMove = nil
	end

	slot0:updateShadowPos()
end

slot0.acquireEffect = function (slot0, slot1, slot2)
	if slot1 == 0 then
		return
	end

	if IsNil(slot0.expTF) then
		return
	end

	slot3 = nil

	if slot2 == BackYardConst.ADDITION_TYPE_MONEY then
		slot3 = slot0.moneyAdditionTF
	elseif slot2 == BackYardConst.ADDITION_TYPE_INTIMACY then
		slot3 = slot0.inimacyAdditionTF
		slot1 = ""

		slot0:playIntimacyEffect()
	elseif slot2 == BackYardConst.ADDITION_TYPE_EXP then
		slot3 = slot0.expAdditionTF
		slot1 = ""
	end

	function slot4()
		slot1 = slot0.tf.localScale.x

		while go(slot0).name ~= "floor" do
			slot1 = slot1 * slot0.parent.localScale.x
		end

		return slot1
	end

	slot0.expTF.localScale = Vector3(Mathf.Sign(slot5) * 2, 2, 2)

	for slot9 = 0, slot0.expTF.childCount - 1, 1 do
		SetActive(slot0.expTF:GetChild(slot9), false)
	end

	setActive(slot3, true)
	setText(findTF(slot3, "Text"), slot1)
	LeanTween.cancel(slot0.expTF.gameObject)
	LeanTween.moveY(rtf(slot0.expTF), slot0.expTF.localPosition.y + 110, 1.2):setOnUpdate(System.Action_float(function ()
		if not IsNil(slot0.go) and slot2 ~= slot1() then
			slot0.expTF.localScale = Vector3(Mathf.Sign(slot0) * 2, 2, 2)
		end
	end)).setOnComplete(slot7, System.Action(function ()
		setActive(setActive, false)

		slot1.expTF.localPosition = false
	end))
end

slot0.playIntimacyEffect = function (slot0)
	if slot0.hasEffect then
		return
	end

	slot0.hasEffect = true

	ResourceMgr.Inst:getAssetAsync("Effect/Heart", "", UnityEngine.Events.UnityAction_UnityEngine_Object(function (slot0)
		slot1 = Instantiate(slot0)

		pg.ViewUtils.SetLayer(tf(slot1), Layer.UI)
		tf(slot1):SetParent(slot0.tf, false)

		tf(slot1).localPosition = Vector3(0, 200, -100)
		tf(slot1).localScale = Vector3(100, 100, 100)
		slot0.removeEffectTimer = Timer.New(function ()
			Destroy(Destroy)

			slot0 = nil

			slot1.removeEffectTimer:Stop()

			slot1.removeEffectTimer.removeEffectTimer = nil
			nil.hasEffect = nil
		end, 2, 1)

		slot0.removeEffectTimer.Start(slot2)
	end), true, true)
end

slot0.updateInimacy = function (slot0, slot1)
	SetActive(slot0.inimacyTF, slot1)
	onButton(slot0, slot0.inimacyTF, function ()
		if not slot0.boatVO:hasInterActionFurnitrue() and not slot0.boatVO:hasSpineInterAction() and not slot0.boatVO:hasSpineExtra() then
			slot0:switchAnimation("motou")
		end

		slot0.viewComponent:emit(BackyardMainMediator.ADD_INTIMACY, slot0.boatVO.id)
	end, SFX_PANEL)
end

slot0.updateMoney = function (slot0, slot1)
	SetActive(slot0.moneyTF, slot1)
	onButton(slot0, slot0.moneyTF, function ()
		if not slot0.boatVO:hasInterActionFurnitrue() and not slot0.boatVO:hasSpineInterAction() and not slot0.boatVO:hasSpineExtra() then
			slot0:switchAnimation("motou")
		end

		slot0.viewComponent:emit(BackyardMainMediator.ADD_MONEY, slot0.boatVO.id)
	end, SFX_PANEL)
end

slot0.switchAnimation = function (slot0, slot1)
	if slot0.isAnim then
		return
	end

	slot0.isAnim = true
	slot0.canvasGroup.blocksRaycasts = false

	slot0.viewComponent:emit(BackyardMainMediator.CANCEL_SHIP_MOVE, slot0.boatVO.id)
	slot0.spineAnimUI:SetAction(slot1, 0)

	slot0.isMove = nil

	slot0.spineAnimUI:SetActionCallBack(function (slot0)
		if slot0 == "finish" then
			slot0.spineAnimUI:SetAction("stand2", 0)
			slot0.viewComponent:emit(BackyardMainMediator.ADD_BOAT_MOVE, slot0.boatVO.id)

			slot0.isAnim = false
			slot0.canvasGroup.blocksRaycasts = true

			slot0.spineAnimUI:SetActionCallBack(nil)
		end
	end)
end

slot0.addSpineExtra = function (slot0, slot1, slot2)
	SetActive(slot0.shipGridContainer, false)
	slot0:removeItem()
	slot0:updateShadowTF(false)

	slot5 = slot0.viewComponent.furnitureVOs[slot1].getSpineExtraConfig(slot4, slot2)

	SetParent(slot0.tf, slot3, true)

	slot0.tf.localScale = Vector3(slot0 * slot5[3][1], slot0 * slot5[3][2], 1)
	slot0.tf.anchoredPosition = Vector3(slot5[2][1], slot5[2][2], 0)

	if slot0.viewComponent.furnitureVOs[slot1]:HasFollower() then
		slot0:startSpineAnimator(slot4, slot2)
	end

	if slot4:getSpineExtraBodyMask(slot2) ~= nil and #slot6 > 0 then
		slot0:showBodyMask(slot6)
	end

	slot0.spineFurniture = slot4
end

slot0.clearSpineExtra = function (slot0, slot1, slot2)
	SetParent(slot0.tf, slot0.viewComponent.floorContain, true)

	slot3 = slot0.viewComponent:GetFurnitureGo(slot1)

	slot0:endSpineAnimator(slot4, slot2, true)

	if slot0.viewComponent.furnitureVOs[slot1]:getSpineExtraBodyMask(slot2) ~= nil and #slot5 > 0 then
		slot0:closeBodyMask()
	end

	slot0.tf.eulerAngles = Vector3(0, 0, 0)
	slot0.spineFurniture = nil
end

slot0.InterActionTransport = function (slot0, slot1)
	slot0:removeItem()

	slot0.isInTransport = true
	slot2 = slot0.viewComponent:GetFurnitureGo(slot1)

	SetParent(slot0.tf, slot2, true)

	slot3 = slot0.viewComponent.furnitureVOs[slot1]
	slot4 = GetOrAddComponent(slot2:Find("icon/spine"), typeof(SpineAnimUI))

	function slot5(slot0, slot1)
		if slot0 <= 0 then
			slot1()

			return
		end

		Timer.New(slot1, slot0, 1):Start()
	end

	slot6 = slot0.tf.localScale

	setActive(slot0.shadowTF, false)
	setActive(slot0.shipGridContainer, false)
	seriesAsync({
		function (slot0)
			slot0.tf.localScale = Vector3(-1 * math.abs(slot1.x), slot1.y, slot1.z)
			slot1 = {}

			for slot6, slot7 in ipairs(slot2) do
				slot8 = slot7[1][1]
				slot9 = slot7[1][2]
				slot10 = slot7[2]

				table.insert(slot1, function (slot0)
					parallelAsync({
						function (slot0)
							slot0.spineAnimUI:SetAction(slot0.spineAnimUI.SetAction, 0)
							slot0.spineAnimUI(slot0.spineAnimUI.SetAction, slot0)
						end,
						function (slot0)
							slot0:SetAction(slot0.SetAction, 0)
							slot0(slot0.SetAction, slot0)
						end
					}, slot0)
				end)
			end

			seriesAsync(slot1, slot0)
		end,
		function (slot0)
			slot0.tf.localScale = Vector3(math.abs(slot1.x), slot1.y, slot1.z)
			slot1 = Vector3(math.abs(slot1.x), slot1.y, slot1.z):Find("Animator01")

			SetParent(slot0.tf, slot1)

			slot0.tf.localPosition = Vector3(0, 0, 0)

			slot1:GetComponent(typeof(DftAniEvent)).SetEndEvent(slot2, function (slot0)
				slot3, slot5 = slot0:getSpineName()

				slot1:SetAction(slot2, 0)
				setActive(slot2, false)
				setActive()
			end)
			setActive(slot1, true)
		end
	}, function ()
		slot0.viewComponent:emit(BackyardMainMediator.INTERACTION_TRANSPORT_AGAIN, slot0.boatVO.id, slot0.viewComponent)
	end)
end

slot0.InterActionTransportAgain = function (slot0, slot1)
	slot3 = slot0.viewComponent.furnitureVOs[slot1]
	slot4 = GetOrAddComponent(slot0.viewComponent:GetFurnitureGo(slot1).Find(slot2, "icon/spine"), typeof(SpineAnimUI))

	function slot5(slot0, slot1)
		if slot0 <= 0 then
			slot1()

			return
		end

		Timer.New(slot1, slot0, 1):Start()
	end

	seriesAsync({
		function (slot0)
			slot1 = {}

			for slot6, slot7 in ipairs(slot2) do
				slot8 = slot7[1][1]
				slot9 = slot7[1][2]
				slot10 = slot7[2]

				table.insert(slot1, function (slot0)
					slot0:SetAction(slot0.SetAction, 0)
					slot0(slot0.SetAction, slot0)
				end)
			end

			seriesAsync(slot1, slot0)
		end,
		function (slot0)
			slot1 = slot0:Find("Animator11")

			SetParent(slot1.tf, slot1)

			slot1.tf.localPosition = Vector3(0, 0, 0)

			slot1:GetComponent(typeof(DftAniEvent)).SetEndEvent(slot2, function (slot0)
				slot3, slot5 = slot0:getSpineName()

				slot1:SetAction(slot2, 0)
				setActive(slot2, false)
				setActive()
			end)
			setActive(slot1, true)
		end
	}, function ()
		slot0.viewComponent:emit(BackyardMainMediator.INTERACTION_TRANSPORT_END, slot0.boatVO.id, slot0.viewComponent)
	end)
end

slot0.InterActionTransportEnd = function (slot0)
	slot0.isInTransport = nil

	slot0.spineAnimUI:SetAction("stand2", 0)
	SetParent(slot0.tf, slot0.floorGrid)
	setActive(slot0.shadowTF, true)
end

slot0.inTransport = function (slot0)
	return slot0.isInTransport
end

slot0.showBodyMask = function (slot0, slot1)
	slot2 = slot1[1]
	slot3 = slot1[2][1]
	slot4 = slot1[2][2]

	if slot1[3] then
		slot0.bodyMask:GetComponent(typeof(Image)).sprite = LoadSprite("furniture/" .. slot1[3])
	else
		slot0.bodyMask:GetComponent(typeof(Image)).sprite = nil
	end

	slot0.isShowBodyMask = true

	setActive(slot0.bodyMask, true)

	tf(slot0.bodyMask).localPosition = Vector3(slot2[1], slot2[2], 0)
	rtf(slot0.bodyMask).sizeDelta = Vector2(slot3, slot4)

	SetParent(slot0.model, slot0.bodyMask)

	slot0.model.localScale = Vector3(slot9, 1, 1)
	tf(slot0.model).localPosition = Vector3(-slot2[1], -slot2[2], 0)
end

slot0.closeBodyMask = function (slot0, slot1)
	if not slot0.bodyMask or not slot0.isShowBodyMask then
		return
	end

	setActive(slot0.bodyMask, false)
	SetParent(slot0.model, slot0.tf)
	slot0.model:SetSiblingIndex(1)

	tf(slot0.model).localPosition = Vector3(0, 0, 0)
	tf(slot0.bodyMask).localScale = Vector3(1, 1, 1)

	if slot1 then
		Destroy(slot0.bodyMask)
	end

	if slot0.bodyMask:GetComponent(typeof(Image)).enabled == false then
		slot2.enabled = true
	end

	slot0.isShowBodyMask = nil
end

slot0.dispose = function (slot0)
	slot0:removeItem()
	removeAllChildren(slot0.effectContainer)

	if slot0.timer then
		for slot4, slot5 in pairs(slot0.timer) do
			slot5:Stop()
		end

		slot0.timer = nil
	end

	if slot0.dragTrigger then
		ClearEventTrigger(slot0.dragTrigger)

		slot0.dragTrigger = nil
	end

	pg.DelegateInfo.Dispose(slot0)

	if slot0.moveNextTimer then
		slot0.moveNextTimer:Stop()

		slot0.moveNextTimer = nil
	end

	if slot0.removeEffectTimer then
		slot0.removeEffectTimer:Stop()

		slot0.removeEffectTimer = nil
	end

	if LeanTween.isTweening(slot0.go) then
		LeanTween.cancel(slot0.go)
	end

	slot0.canvasGroup.blocksRaycasts = true

	if slot0.spineAnimUI then
		slot0.spineAnimUI:SetActionCallBack(nil)
	end

	if slot0.shadowTF then
		Destroy(slot0.shadowTF)
	end

	slot0:closeBodyMask(true)
	PoolMgr.GetInstance():ReturnSpineChar(slot0.boatVO:getPrefab(), go(slot0.model))
	Destroy(slot0.go)
end

slot0.enableTouch = function (slot0, slot1)
	slot0.canvasGroup.alpha = (not slot1 and 1) or 0
	slot0.canvasGroup.blocksRaycasts = not slot1

	slot0:updateShadowTF(not slot1)
end

slot0.SetAsLastSibling = function (slot0)
	slot0.tf:SetAsLastSibling()
end

slot0.SetAsFirstSibling = function (slot0)
	slot0.tf:SetAsFirstSibling()
end

slot0.SetParent = function (slot0, slot1, slot2)
	slot0.tf:SetParent(slot1, slot2)
end

return slot0
