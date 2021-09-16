slot0 = class("SVSalvageResult", import("view.base.BaseSubView"))
slot0.HideView = "SVSalvageResult.HideView"

slot0.getUIName = function (slot0)
	return "SVSalvageResult"
end

slot0.OnLoaded = function (slot0)
	return
end

slot0.OnInit = function (slot0)
	slot0.rtPanel = slot0._tf:Find("window/display_panel")

	setText(slot0.rtPanel:Find("info/Text"), i18n("world_catsearch_help_1"))
	setText(slot0.rtPanel:Find("info/items_btn/Text"), i18n("world_catsearch_help_2"))
	onButton(slot0, slot0.rtPanel:Find("info/items_btn"), function ()
		slot0:emit(BaseUI.ON_DROP_LIST, {
			item2Row = true,
			itemList = _.map(pg.gameset.world_catsearchdrop_show.description, function (slot0)
				return {
					type = slot0[1],
					id = slot0[2],
					count = slot0[3]
				}
			end),
			content = i18n("world_catsearch_help_6")
		})
	end, SFX_PANEL)
	onButton(slot0, slot0._tf:Find("bg"), function ()
		slot0:Hide()
	end, SFX_CANCEL)

	slot0.btnBack = slot0._tf.Find(slot1, "window/top/btnBack")

	onButton(slot0, slot0.btnBack, function ()
		slot0:Hide()
	end, SFX_CANCEL)

	slot0.btnCanel = slot0._tf.Find(slot1, "window/button_container/custom_button_2")

	onButton(slot0, slot0.btnCanel, function ()
		slot0:Hide()
	end, SFX_CANCEL)

	slot0.btnHelp = slot0.rtPanel.Find(slot1, "info/help")

	onButton(slot0, slot0.btnHelp, function ()
		slot0:Hide()
		slot0.Hide:emit(WorldScene.SceneOp, "OpOpenLayer", Context.New({
			mediator = WorldHelpMediator,
			viewComponent = WorldHelpLayer,
			data = {
				titleId = 3,
				pageId = 10
			}
		}))
	end, SFX_PANEL)

	slot0.btnConfirm = slot0._tf.Find(slot1, "window/button_container/custom_button_1")

	onButton(slot0, slot0.btnConfirm, function ()
		slot0:Hide()
		slot0.Hide:emit(WorldScene.SceneOp, "OpReqCatSalvage", slot0.fleetId)
	end, SFX_CONFIRM)
end

slot0.OnDestroy = function (slot0)
	return
end

slot0.Show = function (slot0)
	setActive(slot0._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(slot0._tf)
end

slot0.Hide = function (slot0)
	pg.UIMgr.GetInstance():UnblurPanel(slot0._tf, slot0._parentTf)
	setActive(slot0._tf, false)
end

slot0.Setup = function (slot0, slot1)
	slot0.fleetId = slot1
end

return slot0
