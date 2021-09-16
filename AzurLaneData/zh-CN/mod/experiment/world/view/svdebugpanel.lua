slot0 = class("SVDebugPanel", import("view.base.BaseSubView"))

slot0.getUIName = function (slot0)
	return "SVDebugPanel"
end

slot0.OnLoaded = function (slot0)
	return
end

slot0.OnInit = function (slot0)
	slot0.scrollRect = slot0._tf.Find(slot1, "scrollview"):GetComponent(typeof(ScrollRect))
	slot0.rtContent = slot0._tf.Find(slot1, "scrollview/viewport/content")
	slot0.rtText = slot0.rtContent:Find("text")
	slot0.btnX = slot0._tf.Find(slot1, "panel/x")

	onButton(slot0, slot0.btnX, function ()
		slot0:Hide()
	end)
	setActive(slot0.rtText, false)
	setParent(slot0.rtText, slot1, false)

	slot5 = UIItemList.New(slot2, slot3)

	slot5:make(function (slot0, slot1, slot2)
		slot1 = slot1 + 1

		if slot0 == UIItemList.EventUpdate then
			setText(slot2:Find("Text"), slot0[slot1].name)
			onButton(slot1, slot2, slot0[slot1].func)
		end
	end)
	slot5.align(slot5, #{
		{
			name = "清理打印",
			func = function ()
				for slot3 = slot0.rtContent.childCount - 1, 0, -1 do
					Destroy(slot0.rtContent:GetChild(slot3))
				end
			end
		},
		{
			name = "entity缓存",
			func = function ()
				slot0:AppendText("-------------------------------------------------------------------------")
				slot0.AppendText:AppendText("打印entity缓存信息：")

				slot0 = {}

				for slot4, slot5 in pairs(WPool.pools) do
					table.insert(slot0, slot4.__cname .. " : " .. #slot5)
				end

				table.sort(slot0)

				for slot4, slot5 in ipairs(slot0) do
					slot0:AppendText(slot5)
				end

				slot0:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "地图信息",
			func = function ()
				slot0:AppendText("-------------------------------------------------------------------------")
				slot0.AppendText:AppendText("当前大世界进度：")
				slot0.AppendText.AppendText:AppendText(tostring(nowWorld:GetProgress()))
				slot0.AppendText.AppendText.AppendText:AppendText("")
				slot0.AppendText.AppendText.AppendText.AppendText:AppendText("当前所在入口信息：")

				if nowWorld:GetActiveEntrance() then
					slot0:AppendText(slot0:DebugPrint())
				end

				slot0:AppendText("")
				slot0:AppendText("当前所在地图信息：")

				if nowWorld:GetActiveMap() then
					slot0:AppendText(slot1:DebugPrint())
				end

				slot0:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "任务信息",
			func = function ()
				slot0:AppendText("-------------------------------------------------------------------------")
				slot0.AppendText:AppendText("任务信息：")

				for slot5, slot6 in pairs(slot1) do
					slot0:AppendText(slot6:DebugPrint())
				end

				slot0:AppendText("-------------------------------------------------------------------------")
			end
		},
		{
			name = "事件信息",
			func = function ()
				slot0:AppendText("-------------------------------------------------------------------------")
				slot0.AppendText:AppendText("事件信息：")

				if nowWorld:GetActiveMap() then
					_.each(slot0:FindAttachments(WorldMapAttachment.TypeEvent), function (slot0)
						slot0:AppendText(slot0:DebugPrint())
					end)
				end

				slot0.AppendText(slot1, "-------------------------------------------------------------------------")
			end
		},
		{
			name = "感染事件",
			func = function ()
				slot0:AppendText("-------------------------------------------------------------------------")
				slot0.AppendText:AppendText("感染事件：")

				if nowWorld:GetActiveMap() then
					_.each(slot0:FindAttachments(WorldMapAttachment.TypeEvent), function (slot0)
						if slot0.config.infection_value > 0 then
							slot0:AppendText(slot0:DebugPrint())
						end
					end)
				end

				slot0.AppendText(slot1, "-------------------------------------------------------------------------")
			end
		},
		{
			name = "路标事件",
			func = function ()
				slot0:AppendText("-------------------------------------------------------------------------")
				slot0.AppendText:AppendText("路标事件：")

				if nowWorld:GetActiveMap() then
					_.each(slot0:FindAttachments(WorldMapAttachment.TypeEvent), function (slot0)
						if slot0:IsSign() then
							slot0:AppendText(slot0:DebugPrint())
						end
					end)
				end

				slot0.AppendText(slot1, "-------------------------------------------------------------------------")
			end
		},
		{
			name = "舰队信息",
			func = function ()
				slot0:AppendText("-------------------------------------------------------------------------")
				slot0.AppendText:AppendText("打印舰队信息：")
				_.each(nowWorld:GetFleets(), function (slot0)
					slot0:AppendText(slot0:DebugPrint())
				end)
				_.each.AppendText(slot0, "-------------------------------------------------------------------------")
			end
		},
		{
			name = "敌人信息",
			func = function ()
				slot0:AppendText("-------------------------------------------------------------------------")
				slot0.AppendText:AppendText("打印敌人信息：")

				if nowWorld:GetActiveMap() then
					_.each(slot0:FindEnemys(), function (slot0)
						slot0:AppendText(slot0:DebugPrint())
					end)
				end

				slot0.AppendText(slot1, "-------------------------------------------------------------------------")
			end
		},
		{
			name = "陷阱信息",
			func = function ()
				slot0:AppendText("-------------------------------------------------------------------------")
				slot0.AppendText:AppendText("打印陷阱信息：")

				if nowWorld:GetActiveMap() then
					_.each(slot0:FindAttachments(WorldMapAttachment.TypeTrap), function (slot0)
						slot0:AppendText(slot0:DebugPrint())
					end)
				end

				slot0.AppendText(slot1, "-------------------------------------------------------------------------")
			end
		},
		{
			name = "场景物件",
			func = function ()
				slot0:AppendText("-------------------------------------------------------------------------")
				slot0.AppendText:AppendText("当前所在地图场景物件信息：")

				if nowWorld:GetActiveMap() then
					_.each(slot0:FindAttachments(WorldMapAttachment.TypeArtifact), function (slot0)
						slot0:AppendText(slot0:DebugPrint())
					end)
				end

				slot0.AppendText(slot1, "-------------------------------------------------------------------------")
			end
		},
		{
			name = "一键压制",
			func = function ()
				slot0:AppendText("-------------------------------------------------------------------------")
				slot0.AppendText:AppendText("当前地图压制啦")

				slot0 = nowWorld:GetAtlas()

				slot0:AddPressingMap(slot0.activeMapId)
				slot0:AppendText("-------------------------------------------------------------------------")
			end
		}
	})
end

slot0.OnDestroy = function (slot0)
	setParent(slot0.rtText, slot0.rtContent, false)
end

slot0.Show = function (slot0)
	pg.UIMgr.GetInstance():OverlayPanel(slot0._tf)
	setActive(slot0._tf, true)
end

slot0.Hide = function (slot0)
	pg.UIMgr.GetInstance():UnOverlayPanel(slot0._tf, slot0._parentTf)
	setActive(slot0._tf, false)
end

slot0.Setup = function (slot0)
	return
end

slot0.OnClickRichText = function (slot0, slot1, slot2)
	if slot1 == "ShipProperty" then
		slot4 = nowWorld:GetShipVO(slot3)

		slot0:AppendText("-------------------------------------------------------------------------")
		slot0:AppendText("打印舰娘属性：")
		slot0:AppendText(string.format("[%s] [id: %s] [config_id: %s]", slot4:getName(), slot4.id, slot4.configId))

		slot6 = slot4:getProperties()

		for slot10, slot11 in ipairs(slot5) do
			slot12 = nil

			if (slot11[1] ~= AttributeType.Armor or slot4:getShipArmorName()) and slot6[slot11[1]] then
				slot0:AppendText(string.format("\t\t%s[%s] : <color=#A9F548>%s</color>", slot11[1], slot11[2], slot12))
			end
		end

		slot0:AppendText("-------------------------------------------------------------------------")
	end
end

slot0.AppendText = function (slot0, slot1)
	cloneTplTo(slot0.rtText, slot0.rtContent, false).GetComponent(slot2, "RichText"):AddListener(function (slot0, slot1)
		slot0:OnClickRichText(slot0, slot1)
	end)
	setText(slot2, slot1)
	print(slot1)
end

return slot0
