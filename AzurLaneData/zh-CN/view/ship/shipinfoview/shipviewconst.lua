return {
	PAGE = {
		EQUIPMENT = 2,
		DETAIL = 1,
		INTENSIFY = 3,
		CORE = 7,
		UPGRADE = 4,
		REMOULD = 6,
		FASHION = 5
	},
	currentPage = nil,
	SUB_VIEW_PAGE = {
		()["PAGE"].DETAIL,
		()["PAGE"].EQUIPMENT,
		()["PAGE"].INTENSIFY,
		()["PAGE"].UPGRADE,
		()["PAGE"].FASHION
	},
	SUB_LAYER_PAGE = {
		()["PAGE"].REMOULD,
		()["PAGE"].CORE
	},
	IsSubLayerPage = function (slot0)
		return table.contains(slot0.SUB_LAYER_PAGE, slot0)
	end,
	SWITCH_TO_PAGE = "ShipViewConst.switch_to_page",
	LOAD_PAINTING = "ShipViewConst.load_painting",
	LOAD_PAINTING_BG = "ShipViewConst.load_painting_bg",
	HIDE_SHIP_WORD = "ShipViewConst.hide_ship_word",
	SET_CLICK_ENABLE = "ShipViewConst.set_click_enable",
	SHOW_CUSTOM_MSG = "ShipViewConst.show_custom_msg",
	HIDE_CUSTOM_MSG = "ShipViewConst.hide_custom_msg",
	DISPLAY_HUNTING_RANGE = "ShipViewConst.display_hunting_range",
	PAINT_VIEW = "ShipViewConst.paint_view"
}
