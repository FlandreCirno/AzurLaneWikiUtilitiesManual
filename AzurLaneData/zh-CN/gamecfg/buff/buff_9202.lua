return {
	init_effect = "",
	name = "龙宫机关-土：我方占领 TAG",
	time = 3,
	color = "yellow",
	picture = "",
	desc = "",
	stack = 1,
	id = 9202,
	icon = 9202,
	last_effect = "",
	effect_list = {
		{
			type = "BattleBuffAddTag",
			trigger = {
				"onAttach"
			},
			arg_list = {
				tag = "JIGUANTU"
			}
		}
	}
}
