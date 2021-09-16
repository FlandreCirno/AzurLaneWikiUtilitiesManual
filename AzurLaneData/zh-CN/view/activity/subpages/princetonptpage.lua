slot0 = class("PrincetonPtPage", import(".TemplatePage.PtTemplatePage"))

slot0.OnInit = function (slot0)
	slot0.super.OnInit(slot0)

	slot0.buildBtn = slot0:findTF("build", slot0.bg)
end

slot0.OnFirstFlush = function (slot0)
	slot0.super.OnFirstFlush(slot0)
	onButton(slot0, slot0.buildBtn, function ()
		slot0:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GETBOAT, {
			projectName = BuildShipScene.PROJECTS.SPECIAL
		})
	end, SFX_PANEL)
end

slot0.OnUpdateFlush = function (slot0)
	slot0.super.OnUpdateFlush(slot0)

	slot10, slot11, slot3 = slot0.ptData:GetLevelProgress()
	slot10, slot11, slot6 = slot0.ptData:GetResProgress()

	setText(slot0.step, setColorStr(slot1, "#4180FFFF") .. "/" .. slot2)
	setText(slot0.progress, setColorStr(slot4, "#4180FFFF") .. "/" .. slot5)
end

return slot0
