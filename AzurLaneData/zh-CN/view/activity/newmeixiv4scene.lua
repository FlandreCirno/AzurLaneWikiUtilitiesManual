slot0 = class("NewMeixiV4Scene", import("..base.BaseUI"))

slot0.getUIName = function (slot0)
	return "NewMeixiV4UI"
end

slot0.init = function (slot0)
	slot0.resPanel = PlayerResource.New()

	SetParent(slot0.resPanel._go, slot0:findTF("top/res"), false)

	slot0.ani = slot0:findTF("TV01")
	slot0.progress = slot0:findTF("progress/Text")
	slot0.nodes = slot0:findTF("nodes")
	slot0.nodeInfo = slot0:findTF("node_info")
	slot0.titleTxt = slot0:findTF("progress/title")
	slot0.titleNum = slot0:findTF("progress/cur")
	slot0.helpBtn = slot0:findTF("help_btn")
	slot0.storyTip = slot0:findTF("get_story")
	slot0.taskProxy = getProxy(TaskProxy)
	slot0.storyGroup = pg.activity_template[ActivityConst.NEWMEIXIV4_SKIRMISH_ID].config_client.storys
	slot0.memoryGroup = pg.activity_template[ActivityConst.NEWMEIXIV4_SKIRMISH_ID].config_client.memoryGroup
end

slot0.didEnter = function (slot0)
	onButton(slot0, slot0:findTF("top/back_btn"), function ()
		slot0:emit(slot1.ON_BACK)
	end, SOUND_BACK)
	onButton(slot0, slot0:findTF("top/option"), function ()
		slot0:emit(slot1.ON_HOME)
	end, SFX_CANCEL)
	onButton(slot0, slot0.helpBtn, function ()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("MeixiV4_help")
		})
	end, SFX_PANEL)
	setText(slot0.findTF(slot0, "bar/tip", slot0.storyTip), i18n("world_collection_back"))
	slot0:playAni()
	slot0:updateNodes()
end

slot0.setPlayer = function (slot0, slot1)
	slot0.player = slot1

	slot0:onUpdateRes(slot1)
end

slot0.onUpdateRes = function (slot0, slot1)
	slot0.resPanel:setResources(slot1)

	slot0.player = slot1
end

slot0.playAni = function (slot0)
	SetActive(slot0.ani, true)
	slot0.ani:GetComponent("DftAniEvent").SetEndEvent(slot1, function (slot0)
		SetActive(slot0.ani, false)
	end)
	pg.CriMgr.GetInstance().PlaySoundEffect_V3(slot2, SFX_UI_WARNING)
end

slot0.setCurIndex = function (slot0)
	slot0.curIndex = 1
	slot0.clearTaskNum = 0

	function slot1()
		for slot3, slot4 in ipairs(slot0.contextData.taskList) do
			if slot0.taskProxy:getTaskById(slot4) or slot0.taskProxy:getFinishTaskById(slot4) then
				return slot3 - 1
			end
		end
	end

	slot0.clearTaskNum = slot1()

	for slot5, slot6 in ipairs(slot0.contextData.taskList) do
		slot7 = slot0.taskProxy:getTaskById(slot6) or slot0.taskProxy:getFinishTaskById(slot6)
		slot9 = slot0.taskProxy:getTaskById(slot0.contextData.taskList[slot5 + 1]) or slot0.taskProxy:getFinishTaskById(slot8)

		if slot7 and slot7:getTaskStatus() == 2 then
			slot0.curIndex = slot0.curIndex + 1

			if not slot8 or not slot9 then
				slot0.curIndex = slot0.curIndex - 1
			end
		end
	end

	slot0.curIndex = slot0.curIndex + slot0.clearTaskNum
end

slot0.updateNodes = function (slot0)
	slot0:setCurIndex()
	setText(slot0.titleTxt, "POSITION " .. string.format("%02d", slot0.curIndex))
	setText(slot0.titleNum, string.format("%02d", slot0.curIndex))
	eachChild(slot0.nodes, function (slot0)
		slot3 = slot0.taskProxy:getTaskById(slot0.contextData.taskList[tonumber(slot0.name)]) or slot0.taskProxy:getFinishTaskById(slot2)

		setActive(slot0, slot1 <= slot0.curIndex)
		onButton(slot0, slot0, function ()
			slot0:updateNodeInfo(slot0)
		end, SFX_PANEL)
	end)
	slot0.updateNodeInfo(slot0, slot0.curIndex)
end

slot0.nodeInfoTween = function (slot0, slot1)
	slot2 = tf(slot0:findTF(tostring(slot1), slot0.nodes)).localPosition

	if slot1 == 9 then
		slot2.x = slot2.x - 80
	end

	if slot1 == 7 then
		slot2.y = slot2.y - 20
	end

	function slot3()
		setLocalPosition(slot0.nodeInfo, Vector3(slot1.x, slot1.y + 120, 0))
		setLocalScale(slot0.nodeInfo, Vector3(0, 0, 0))
		LeanTween.scale(tf(slot0.nodeInfo), Vector3.one, 0.1)
	end

	function slot4(slot0)
		setLocalScale(slot0.nodeInfo, Vector3(1, 1, 1))
		LeanTween.scale(tf(slot0.nodeInfo), Vector3.zero, 0.1):setOnComplete(System.Action(function ()
			if slot0 then
				slot0()
			end
		end))
	end

	if not isActive(slot0.nodeInfo) then
		setActive(slot0.nodeInfo, true)
		slot3()
	else
		slot4(slot3)
	end
end

slot0.updateNodeInfo = function (slot0, slot1)
	updateActivityTaskStatus(slot2)
	setSlider(slot0:findTF("progress", slot0.nodeInfo), 0, ((slot0.taskProxy:getTaskById(slot0.contextData.taskList[slot1]) or slot0.taskProxy:getFinishTaskById(slot3)) and slot0.taskProxy.getTaskById(slot0.contextData.taskList[slot1]) or slot0.taskProxy.getFinishTaskById(slot3):getConfig("target_num")) or pg.task_data_template[slot3].target_num, ((slot0.taskProxy.getTaskById(slot0.contextData.taskList[slot1]) or slot0.taskProxy.getFinishTaskById(slot3)) and slot0.taskProxy.getTaskById(slot0.contextData.taskList[slot1]) or slot0.taskProxy.getFinishTaskById(slot3):getProgress()) or pg.task_data_template[slot3].target_num)
	setText(slot0:findTF("step", slot0.nodeInfo), (((slot0.taskProxy.getTaskById(slot0.contextData.taskList[slot1]) or slot0.taskProxy.getFinishTaskById(slot3)) and slot0.taskProxy.getTaskById(slot0.contextData.taskList[slot1]) or slot0.taskProxy.getFinishTaskById(slot3).getProgress()) or pg.task_data_template[slot3].target_num) .. "/" .. (((slot0.taskProxy.getTaskById(slot0.contextData.taskList[slot1]) or slot0.taskProxy.getFinishTaskById(slot3)) and slot0.taskProxy.getTaskById(slot0.contextData.taskList[slot1]) or slot0.taskProxy.getFinishTaskById(slot3).getConfig("target_num")) or pg.task_data_template[slot3].target_num))
	setText(slot0:findTF("content", slot0.nodeInfo), ((slot0.taskProxy.getTaskById(slot0.contextData.taskList[slot1]) or slot0.taskProxy.getFinishTaskById(slot3)) and slot0.taskProxy.getTaskById(slot0.contextData.taskList[slot1]) or slot0.taskProxy.getFinishTaskById(slot3):getConfig("desc")) or pg.task_data_template[slot3].desc)
	setText(slot0:findTF("title", slot0.nodeInfo), string.format("%02d", slot1))
	setActive(slot0:findTF("go_btn", slot0.nodeInfo), (((slot0.taskProxy.getTaskById(slot0.contextData.taskList[slot1]) or slot0.taskProxy.getFinishTaskById(slot3)) and slot0.taskProxy.getTaskById(slot0.contextData.taskList[slot1]) or slot0.taskProxy.getFinishTaskById(slot3):getTaskStatus()) or 2) == 0)
	setActive(slot0:findTF("get_btn", slot0.nodeInfo), (((slot0.taskProxy.getTaskById(slot0.contextData.taskList[slot1]) or slot0.taskProxy.getFinishTaskById(slot3)) and slot0.taskProxy.getTaskById(slot0.contextData.taskList[slot1]) or slot0.taskProxy.getFinishTaskById(slot3).getTaskStatus()) or 2) == 1)
	setActive(slot0:findTF("step/finish", slot0.nodeInfo), (((slot0.taskProxy.getTaskById(slot0.contextData.taskList[slot1]) or slot0.taskProxy.getFinishTaskById(slot3)) and slot0.taskProxy.getTaskById(slot0.contextData.taskList[slot1]) or slot0.taskProxy.getFinishTaskById(slot3).getTaskStatus()) or 2) == 2)
	onButton(slot0, slot10, function ()
		slot0:emit(NewMeixiV4Mediator.ON_TASK_GO, slot0)
	end, SFX_PANEL)
	onButton(slot0, slot0.findTF("get_btn", slot0.nodeInfo), function ()
		slot0:emit(NewMeixiV4Mediator.ON_TASK_SUBMIT, slot0)
	end, SFX_PANEL)
	eachChild(slot0.nodes, function (slot0)
		slot1 = slot0:findTF("arrow", slot0)

		LeanTween.cancel(slot1.gameObject)
		setLocalPosition(slot1, Vector3(0, 27, 0))

		if tonumber(slot0.name) == slot1 then
			setActive(slot1, true)
			LeanTween.moveY(slot1, 40, 0.5):setEase(LeanTweenType.easeInOutSine):setLoopPingPong()
		else
			setActive(slot1, false)
		end
	end)
	slot0.nodeInfoTween(slot0, slot1)
end

slot0.onUpdateTask = function (slot0)
	slot1 = slot0.contextData.taskList[slot0.curIndex]

	for slot5, slot6 in pairs(slot0.storyGroup) do
		if slot1 == slot6[1] then
			slot0:getStory(slot6[2], slot6[3])
		end
	end

	slot0:updateNodes()
end

slot0.getStory = function (slot0, slot1, slot2)
	setActive(slot0.storyTip, true)
	pg.NewStoryMgr.GetInstance():SetPlayedFlag(slot2)
	setText(slot0:findTF("bar/Anim/Frame/Mask/Name", slot0.storyTip), HXSet.hxLan(slot3))
	removeOnButton(slot0.storyTip)
	removeOnButton(slot0:findTF("bar/Button", slot0.storyTip))
	pg.UIMgr.GetInstance():BlurPanel(slot0.storyTip)
	slot0:findTF("bar", slot0.storyTip):GetComponent(typeof(DftAniEvent)).SetEndEvent(slot4, function ()
		onButton(onButton, slot0.storyTip, function ()
			pg.UIMgr.GetInstance():UnblurPanel(slot0.storyTip)
			setActive(slot0.storyTip, false)
		end)
		onButton(onButton, slot0.findTF(slot2, "bar/Button", slot0.storyTip), function ()
			slot0:emit(NewMeixiV4Mediator.GO_STORY, slot0.memoryGroup)
			triggerButton(slot0.storyTip)
		end, SFX_PANEL)
	end)
end

slot0.willExit = function (slot0)
	if slot0.resPanel then
		slot0.resPanel:exit()

		slot0.resPanel = nil
	end

	setActive(slot0.storyTip, false)
	pg.UIMgr.GetInstance():UnblurPanel(slot0.storyTip)
end

return slot0
