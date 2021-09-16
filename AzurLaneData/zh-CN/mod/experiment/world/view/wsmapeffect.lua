slot0 = class("WSMapEffect", import(".WSMapTransform"))
slot0.Fields = {
	resName = "string",
	resPath = "string",
	particlesSize = "table",
	particles = "table"
}

slot0.Dispose = function (slot0)
	slot0:Unload()
	slot0.super.Dispose(slot0)
end

slot0.Setup = function (slot0, slot1, slot2)
	slot0.resPath = slot1
	slot0.resName = slot2
end

slot0.Load = function (slot0, slot1)
	slot0:LoadModel(WorldConst.ModelPrefab, slot0.resPath, slot0.resName, false, function ()
		slot0.particles = {}

		for slot4 = 0, slot0.model:GetComponentsInChildren(typeof(ParticleSystem)).Length - 1, 1 do
			table.insert(slot0.particles, slot0[slot4])
		end

		slot0.particlesSize = _.map(slot0.particles, function (slot0)
			return Vector4(slot0.main.startSizeXMultiplier, slot0.main.startSizeYMultiplier, slot0.main.startSizeZMultiplier, slot0.main.startSizeMultiplier)
		end)

		setParent(slot0.model, slot0.transform, false)

		return existCall(existCall)
	end)
end

slot0.Unload = function (slot0)
	for slot4, slot5 in ipairs(slot0.particles) do
		slot5.main.startSizeXMultiplier = slot0.particlesSize[slot4].x
		slot5.main.startSizeYMultiplier = slot0.particlesSize[slot4].y
		slot5.main.startSizeZMultiplier = slot0.particlesSize[slot4].z
		slot5.main.startSizeMultiplier = slot0.particlesSize[slot4].w
	end

	slot0.particles = {}
	slot0.particlesSize = {}

	slot0:UnloadModel()
end

slot0.FlushModelScale = function (slot0)
	if slot0.model and slot0.modelScale then
		slot0.model.localScale = slot0.modelScale

		for slot4, slot5 in ipairs(slot0.particles) do
			slot5.main.startSizeXMultiplier = slot0.particlesSize[slot4].x * slot0.modelScale.x
			slot5.main.startSizeYMultiplier = slot0.particlesSize[slot4].y * slot0.modelScale.y
			slot5.main.startSizeZMultiplier = slot0.particlesSize[slot4].z * slot0.modelScale.z
			slot5.main.startSizeMultiplier = (slot0.particlesSize[slot4].w * (slot0.modelScale.x + slot0.modelScale.y + slot0.modelScale.z)) / 3
		end
	end
end

return slot0
