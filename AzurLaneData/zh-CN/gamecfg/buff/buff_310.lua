return {
	init_effect = "",
	name = "åé",
	time = 6,
	picture = "",
	desc = "6såé",
	stack = 1,
	id = 310,
	icon = 310,
	last_effect = "Darkness",
	effect_list = {
		{
			type = "BattleBuffFixVelocity",
			trigger = {
				"onAttach",
				"onStack",
				"onRemove"
			},
			arg_list = {
				add = 0,
				mul = -4000,
				group = {
					id = 300,
					level = 10
				}
			}
		}
	}
}
