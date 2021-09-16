slot0 = class("AttachmentSpineAnimationCell", import(".StaticCellView"))
slot0.SDPosition = Vector2(0, -15)
slot0.SDScale = Vector3(0.4, 0.4, 0.4)

slot0.Ctor = function (slot0, slot1)
	slot0.super.Ctor(slot0, slot1)

	slot0.name = nil
	slot0.model = nil
	slot0.anim = nil
	slot0.AnimIndex = nil
	slot0.group = {}
	slot0.timer = nil
end

slot0.GetOrder = function (slot0)
	return ChapterConst.CellPriorityAttachment
end

slot0.Set = function (slot0, slot1)
	if slot0.name == slot1 then
		return
	end

	slot0:ClearLoader()
	table.clear(slot0.group)

	slot0.name = slot1

	if IsNil(slot0.go) then
		slot0:PrepareBase("SD")
	end

	slot0:GetLoader():GetSpine(slot1, function (slot0)
		slot0.model = slot0
		slot0.anim = slot0:GetComponent("SpineAnimUI")

		setParent(slot0, slot0.go)

		slot0.transform.anchoredPosition = slot0.SDPosition
		slot0.transform.localScale = slot0.SDScale

		slot0:PlayAction(slot0.AnimIndex)
	end, "SD")
end

slot0.SetRoutine = function (slot0, slot1)
	table.clear(slot0.group)

	slot0.AnimIndex = nil
	slot2 = ipairs
	slot3 = slot1 or {}

	for slot5, slot6 in slot2(slot3) do
		slot0.group[slot5] = slot6
	end

	if #slot0.group < 1 then
		table.insert(slot0.group, {
			action = "default",
			duration = 9999
		})
	end

	slot0:PlayAction(math.min(#slot0.group, 1))
end

slot0.PlayAction = function (slot0, slot1)
	if not slot1 or slot1 <= 0 or slot1 > #slot0.group or slot0.AnimIndexPlaying == slot1 then
		return
	end

	slot0.AnimIndex = slot1

	if not slot0.loader or slot0.loader:GetLoadingRP("SD") or not slot0.anim then
		return
	end

	slot0:ClearTimer()

	slot0.timer = Timer.New(function ()
		if slot0 + 1 > #slot1.group then
			slot0 = math.min(#slot1.group, 1)
		end

		slot1:PlayAction(slot1.PlayAction)
	end, slot0.group[slot1].duration)

	slot0.anim.SetAction(slot3, slot0.group[slot1].action, 0)
	slot0.timer:Start()

	slot0.AnimIndexPlaying = slot1
end

slot0.ClearTimer = function (slot0)
	if slot0.timer then
		slot0.timer:Stop()

		slot0.timer = nil
	end
end

slot0.Clear = function (slot0)
	slot0:ClearTimer()

	slot0.name = nil

	slot0.super.Clear(slot0)
end

return slot0
