slot0 = class("NavalTacticsMediator", import("..base.ContextMediator"))
slot0.OPEN_DOCKYARD = "NavalTacticsMediator:OPEN_DOCKYARD"
slot0.ON_START = "NavalTacticsMediator:ON_START"
slot0.ON_CANCEL = "NavalTacticsMediator:ON_CANCEL"
slot0.ON_SHOPPING = "NavalTacticsMediator:ON_SHOPPING"
slot0.ON_SKILL = "NavalTacticsMediator:ON_SKILL"
slot1 = 10

slot0.register = function (slot0)
	slot0.viewComponent:setShips(slot2)

	slot0.bagProxy = getProxy(BagProxy)

	slot0.viewComponent:setItemVOs(slot3)

	slot4 = {}
	slot4 = getProxy(NavalAcademyProxy):getStudents()

	if slot0.contextData.students then
		for slot9, slot10 in pairs(slot0.contextData.students) do
			slot4[slot10.id] = slot10
		end

		slot0.contextData.students = nil
	end

	slot0.viewComponent:setStudents(slot4)
	slot0:bind(slot1.OPEN_DOCKYARD, function (slot0, slot1, slot2, slot3)
		slot0.contextData.students = slot2
		slot4 = {}

		for slot8, slot9 in pairs(slot1:getStudents()) do
			table.insert(slot4, slot9.shipId)
		end

		PoolMgr.GetInstance():AddTempCache("DockyardUI", "NavalAcademyUI")
		slot0:sendNotification(GAME.GO_SCENE, SCENE.DOCKYARD, {
			selectedMax = 1,
			ignoredIds = slot4,
			prevPage = slot0.__cname,
			hideTagFlags = ShipStatus.TAG_HIDE_TACTICES,
			onShip = function (slot0, slot1, slot2)
				slot3, slot4 = ShipStatus.ShipStatusCheck("inTactics", slot0, slot1)

				if not slot3 then
					return slot3, slot4
				end

				return true
			end,
			onSelected = function (slot0)
				if getProxy(BayProxy):getShipById(slot1):isMetaShip() then
					slot0.contextData.metaShipID = slot1

					return
				end

				if slot1 and slot0[1] then
					for slot6, slot7 in pairs(slot2) do
						if slot1 == slot7 then
							slot0.contextData.students[slot6] = nil
						end
					end
				end

				slot0.contextData.shipToLesson = {
					shipId = slot0[1],
					index = slot0.contextData
				}
			end
		})
	end)
	slot0.bind(slot0, slot1.ON_START, function (slot0, slot1)
		slot0:sendNotification(GAME.START_TO_LEARN_TACTICS, slot1)
	end)
	slot0.bind(slot0, slot1.ON_CANCEL, function (slot0, slot1, slot2)
		slot0:sendNotification(GAME.CANCEL_LEARN_TACTICS, {
			shipId = slot1,
			type = slot2
		})
	end)
	slot0.bind(slot0, slot1.ON_SHOPPING, function (slot0, slot1)
		slot0:sendNotification(GAME.SHOPPING, {
			count = 1,
			id = slot1
		})
	end)
	slot0.bind(slot0, slot1.ON_SKILL, function (slot0, slot1, slot2, slot3)
		slot0:addSubLayers(Context.New({
			mediator = SkillInfoMediator,
			viewComponent = NavalTacticsSkillInfoLayer,
			data = {
				skillOnShip = slot2,
				skillId = slot1
			}
		}))
	end)

	if slot0.contextData.shipToLesson then
		slot0.viewComponent.addStudent(slot7, slot0.contextData.shipToLesson.shipId, slot0.contextData.shipToLesson.index, slot0.contextData.shipToLesson.skillIndex)

		slot0.contextData.shipToLesson = nil
	elseif slot0.contextData.metaShipID then
		slot0.viewComponent:showMetaSkillPanel(slot0.contextData.metaShipID)

		slot0.contextData.metaShipID = nil
	end

	slot0.viewComponent:setSKillClassNum(slot6)
	slot0.viewComponent:setPlayer(getProxy(PlayerProxy):getData())
end

slot0.listNotificationInterests = function (slot0)
	return {
		NavalAcademyProxy.START_LEARN_TACTICS,
		GAME.CANCEL_LEARN_TACTICS_DONE,
		BagProxy.ITEM_UPDATED,
		NavalAcademyProxy.SKILL_CLASS_POS_UPDATED,
		GAME.TACTICS_META_UNLOCK_SKILL_DONE,
		GAME.TACTICS_META_SWITCH_SKILL_DONE
	}
end

slot0.handleNotification = function (slot0, slot1)
	slot3 = slot1:getBody()

	if slot1:getName() == NavalAcademyProxy.START_LEARN_TACTICS then
		slot0.viewComponent:updateStudentVO(slot3)
	elseif slot2 == GAME.CANCEL_LEARN_TACTICS_DONE then
		slot0.viewComponent:updateShipVO(slot3.newShipVO)
		slot0.viewComponent:addDeleteStudentQueue(slot3.id, slot3.totalExp, slot3.oldSkill, slot3.newSkill)
	elseif slot2 == BagProxy.ITEM_UPDATED then
		slot0.viewComponent:setItemVOs(slot0.bagProxy:getItemsByType(slot0))
	elseif slot2 == NavalAcademyProxy.SKILL_CLASS_POS_UPDATED then
		slot0.viewComponent:setSKillClassNum(slot3)
		slot0.viewComponent:updateLockStudentPos(slot3, true)
	elseif slot2 == GAME.TACTICS_META_UNLOCK_SKILL_DONE then
		slot0.viewComponent:updateMetaSkillPanel(slot3.metaShipID)
	elseif slot2 == GAME.TACTICS_META_SWITCH_SKILL_DONE then
		slot0.viewComponent:updateMetaSkillPanel(slot3.metaShipID)
	end
end

return slot0
