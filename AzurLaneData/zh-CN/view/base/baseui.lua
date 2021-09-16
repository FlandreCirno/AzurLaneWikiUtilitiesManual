slot0 = class("BaseUI", import("view.base.BaseEventLogic"))
slot0.LOADED = "BaseUI:LOADED"
slot0.DID_ENTER = "BaseUI:DID_ENTER"
slot0.AVALIBLE = "BaseUI:AVALIBLE"
slot0.DID_EXIT = "BaseUI:DID_EXIT"
slot0.ON_BACK = "BaseUI:ON_BACK"
slot0.ON_HOME = "BaseUI:ON_HOME"
slot0.ON_CLOSE = "BaseUI:ON_CLOSE"
slot0.ON_DROP = "BaseUI.ON_DROP"
slot0.ON_DROP_LIST = "BaseUI.ON_DROP_LIST"
slot0.ON_ITEM = "BaseUI:ON_ITEM"
slot0.ON_SHIP = "BaseUI:ON_SHIP"
slot0.ON_AWARD = "BaseUI:ON_AWARD"
slot0.ON_ACHIEVE = "BaseUI:ON_ACHIEVE"
slot0.ON_WORLD_ACHIEVE = "BaseUI:ON_WORLD_ACHIEVE"
slot0.ON_EQUIPMENT = "BaseUI:ON_EQUIPMENT"
slot0.ON_SHIP_EXP = "BaseUI.ON_SHIP_EXP"
slot0.ON_BACK_PRESSED = "BaseUI:ON_BACK_PRESS"

slot0.Ctor = function (slot0)
	slot0.super.Ctor(slot0)

	slot0._isLoaded = false
	slot0._go = nil
	slot0._tf = nil
end

slot0.setContextData = function (slot0, slot1)
	slot0.contextData = slot1
end

slot0.getUIName = function (slot0)
	return nil
end

slot0.getGroupName = function (slot0)
	return nil
end

slot0.getLayerWeight = function (slot0)
	return LayerWeightConst.BASE_LAYER
end

slot0.getBGM = function (slot0)
	return (pg.voice_bgm[slot0.__cname] and slot1.bgm) or nil
end

slot0.preload = function (slot0, slot1)
	slot1()
end

slot0.loadUISync = function (slot0, slot1)
	LoadAndInstantiateSync("UI", slot1, true, false).transform:SetParent(pg.UIMgr.GetInstance().UIMain.transform, false)

	return LoadAndInstantiateSync("UI", slot1, true, false)
end

slot0.load = function (slot0)
	slot1 = nil
	slot2 = Time.realtimeSinceStartup

	seriesAsync({
		function (slot0)
			PoolMgr.GetInstance():GetUI(slot0:getUIName(), true, function (slot0)
				slot0 = slot0

				slot1()
			end)
		end,
		function (slot0)
			slot0:preload(slot0)
		end
	}, function ()
		print("load " .. slot0.name .. " time cost: " .. Time.realtimeSinceStartup - "load ")
		slot0.transform:SetParent(pg.UIMgr.GetInstance().UIMain.transform, false)
		slot0:SetActive(true)
		slot0:onUILoaded(pg.UIMgr.GetInstance().UIMain)
		slot0:PlayBGM()
	end)
end

slot0.PlayBGM = function (slot0)
	if slot0:getBGM() and slot0.bgm ~= slot1 then
		playBGM(slot1)

		slot0.bgm = slot1
	end
end

slot0.SwitchToDefaultBGM = function (slot0)
	playBGM(slot0:getBGM() or pg.voice_bgm.MainUI.bgm)

	slot0.bgm = slot0.getBGM() or pg.voice_bgm.MainUI.bgm
end

slot0.isLoaded = function (slot0)
	return slot0._isLoaded
end

slot0.getGroupNameFromData = function (slot0)
	slot1 = nil

	return (slot0.contextData == nil or not slot0.contextData.LayerWeightMgr_groupName or slot0.contextData.LayerWeightMgr_groupName) and slot0:getGroupName()
end

slot0.getWeightFromData = function (slot0)
	slot1 = nil

	return (slot0.contextData == nil or not slot0.contextData.LayerWeightMgr_weight or slot0.contextData.LayerWeightMgr_weight) and slot0:getLayerWeight()
end

slot0.isLayer = function (slot0)
	return slot0.contextData ~= nil and slot0.contextData.isLayer
end

slot0.addToLayerMgr = function (slot0)
	pg.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SYSTEM, slot0._tf, {
		globalBlur = false,
		groupName = slot0:getGroupNameFromData(),
		weight = slot0:getWeightFromData()
	})
end

slot0.optionsPath = {
	"option",
	"top/option",
	"top/left_top/option",
	"blur_container/top/title/option",
	"blur_container/top/option",
	"top/top/option",
	"common/top/option",
	"blur_panel/top/option",
	"blurPanel/top/option",
	"blur_container/top/option",
	"top/title/option",
	"blur_panel/adapt/top/option",
	"mainPanel/top/option",
	"bg/top/option",
	"blur_container/adapt/top/title/option",
	"blur_container/adapt/top/option",
	"ForNorth/top/option",
	"top/top_chapter/option"
}

slot0.onUILoaded = function (slot0, slot1)
	slot0._go = slot1
	slot0._tf = slot1 and slot1.transform

	if slot0:isLayer() then
		slot0:addToLayerMgr()
	end

	pg.SeriesGuideMgr.GetInstance():dispatch({
		view = slot0.__cname
	})
	pg.NewStoryMgr.GetInstance():OnSceneEnter({
		view = slot0.__cname
	})

	slot0._isLoaded = true

	pg.DelegateInfo.New(slot0)

	slot0.optionBtns = {}

	for slot5, slot6 in ipairs(slot0.optionsPath) do
		table.insert(slot0.optionBtns, slot0:findTF(slot6))
	end

	slot0:init()
	setActive(slot0._tf, not slot0.event:chectConnect(slot0.LOADED))
	slot0:emit(slot0.LOADED)
end

slot0.onUIAnimEnd = function (slot0, slot1)
	slot1()
end

slot0.init = function (slot0)
	return
end

slot0.quickExitFunc = function (slot0)
	slot0:emit(slot0.ON_HOME)
end

slot0.quickExit = function (slot0)
	for slot4, slot5 in ipairs(slot0.optionBtns) do
		onButton(slot0, slot5, function ()
			slot0:quickExitFunc()
		end, SFX_PANEL)
	end
end

slot0.enter = function (slot0)
	slot0:quickExit()
	setActive(slot0._tf, true)

	function slot1()
		slot0:emit(slot1.DID_ENTER)
		slot0.emit:didEnter()
		slot0.emit.didEnter:emit(slot1.AVALIBLE)
		slot0.emit.didEnter.emit:onUIAnimEnd(function ()
			pg.SeriesGuideMgr.GetInstance():start({
				view = slot0.__cname,
				code = {
					pg.SeriesGuideMgr.CODES.MAINUI
				}
			})
			pg.GuideMgr.GetInstance():onSceneAnimDone({
				view = slot0.__cname
			})
		end)
	end

	slot2 = false

	if not IsNil(slot0._tf.GetComponent(slot4, typeof(Animation))) then
		slot0.animTF = slot0._tf
	else
		slot0.animTF = slot0:findTF("blur_panel")
	end

	if slot0.animTF ~= nil then
		slot4 = slot0.animTF:GetComponent(typeof(UIEventTrigger))

		if slot0.animTF:GetComponent(typeof(Animation)) ~= nil and slot4 ~= nil then
			if slot3:get_Item("enter") == nil then
				print("cound not found enter animation")
			else
				slot3:Play("enter")
			end
		elseif slot3 ~= nil then
			print("cound not found [UIEventTrigger] component")
		elseif slot4 ~= nil then
			print("cound not found [Animation] component")
		end
	end

	if not slot2 then
		slot1()
	end
end

slot0.closeView = function (slot0)
	if slot0.contextData.isLayer then
		slot0:emit(slot0.ON_CLOSE)
	else
		slot0:emit(slot0.ON_BACK)
	end
end

slot0.didEnter = function (slot0)
	return
end

slot0.willExit = function (slot0)
	return
end

slot0.exit = function (slot0)
	slot0.exited = true

	pg.DelegateInfo.Dispose(slot0)

	function slot1()
		slot0:willExit()
		slot0.willExit:detach()
		pg.GuideMgr.GetInstance():onSceneExit({
			view = slot0.__cname
		})
		pg.NewStoryMgr.GetInstance():OnSceneExit({
			view = slot0.__cname
		})
		pg.NewStoryMgr.GetInstance().OnSceneExit:emit(slot1.DID_EXIT)
	end

	if not false then
		slot1()
	end
end

slot0.attach = function (slot0, slot1)
	return
end

slot0.ClearTweens = function (slot0, slot1)
	slot0:cleanManagedTween(slot1)
end

slot0.detach = function (slot0, slot1)
	slot0._isLoaded = false

	pg.LayerWeightMgr.GetInstance():DelFromOverlay(slot0._tf)
	pg.DynamicBgMgr.GetInstance():ClearBg(slot0:getUIName())
	slot0:disposeEvent()
	slot0:ClearTweens(false)

	slot0._tf = nil

	PoolMgr.GetInstance():DelTempCache(slot0:getUIName())

	if slot0._go ~= nil and slot3 then
		slot2:ReturnUI(slot3, slot0._go)

		slot0._go = nil
	end
end

slot0.findGO = function (slot0, slot1, slot2)
	return findGO(slot2 or slot0._go, slot1)
end

slot0.findTF = function (slot0, slot1, slot2)
	return findTF(slot2 or slot0._tf, slot1)
end

slot0.getTpl = function (slot0, slot1, slot2)
	slot3 = slot0:findTF(slot1, slot2)

	slot3:SetParent(slot0._tf, false)
	SetActive(slot3, false)

	return slot3
end

slot0.setSpriteTo = function (slot0, slot1, slot2, slot3)
	slot2:GetComponent(typeof(Image)).sprite = slot0:findTF(slot1):GetComponent(typeof(Image)).sprite

	if slot3 then
		slot4:SetNativeSize()
	end
end

slot0.setImageAmount = function (slot0, slot1, slot2)
	slot1:GetComponent(typeof(Image)).fillAmount = slot2
end

slot0.onBackPressed = function (slot0)
	slot0:emit(slot0.ON_BACK_PRESSED)
end

return slot0
