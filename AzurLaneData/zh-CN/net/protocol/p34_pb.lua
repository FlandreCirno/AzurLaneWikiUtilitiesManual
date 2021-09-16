slot0 = require("protobuf")
slot1 = require("common_pb")

module("p34_pb")

CS_34501 = slot0.Descriptor()
SC_34502 = slot0.Descriptor()
CS_34503 = slot0.Descriptor()
SC_34504 = slot0.Descriptor()
CS_34505 = slot0.Descriptor()
SC_34506 = slot0.Descriptor()
SC_34507 = slot0.Descriptor()
SC_34508 = slot0.Descriptor()
CS_34509 = slot0.Descriptor()
SC_34510 = slot0.Descriptor()
CS_34511 = slot0.Descriptor()
SC_34512 = slot0.Descriptor()
CS_34513 = slot0.Descriptor()
SC_34514 = slot0.Descriptor()
CS_34515 = slot0.Descriptor()
SC_34516 = slot0.Descriptor()
CS_34517 = slot0.Descriptor()
SC_34518 = slot0.Descriptor()
CS_34519 = slot0.Descriptor()
SC_34520 = slot0.Descriptor()
WORLDBOSS_INFO = slot0.Descriptor()
WORLDBOSS_RANK = slot0.Descriptor()
WORLDBOSS_SIMPLE = slot0.Descriptor()
({
	CS_34501_TYPE_FIELD = slot0.FieldDescriptor(),
	SC_34502_FIGHT_COUNT_FIELD = slot0.FieldDescriptor(),
	SC_34502_FIGHT_COUNT_UPDATE_TIME_FIELD = slot0.FieldDescriptor(),
	SC_34502_SELF_BOSS_FIELD = slot0.FieldDescriptor(),
	SC_34502_OTHER_BOSS_FIELD = slot0.FieldDescriptor(),
	CS_34503_USER_ID_LIST_FIELD = slot0.FieldDescriptor(),
	SC_34504_BOSS_LIST_FIELD = slot0.FieldDescriptor(),
	CS_34505_BOSS_ID_FIELD = slot0.FieldDescriptor(),
	SC_34506_RANK_LIST_FIELD = slot0.FieldDescriptor(),
	SC_34507_BOSS_INFO_FIELD = slot0.FieldDescriptor(),
	SC_34507_USER_INFO_FIELD = slot0.FieldDescriptor(),
	SC_34507_TYPE_FIELD = slot0.FieldDescriptor(),
	SC_34508_BOSS_ID_FIELD = slot0.FieldDescriptor(),
	SC_34508_HP_FIELD = slot0.FieldDescriptor(),
	CS_34509_TYPE_FIELD = slot0.FieldDescriptor(),
	SC_34510_RESULT_FIELD = slot0.FieldDescriptor(),
	CS_34511_BOSS_ID_FIELD = slot0.FieldDescriptor(),
	SC_34512_RESULT_FIELD = slot0.FieldDescriptor(),
	SC_34512_DROPS_FIELD = slot0.FieldDescriptor(),
	CS_34513_TYPE_FIELD = slot0.FieldDescriptor(),
	SC_34514_RESULT_FIELD = slot0.FieldDescriptor(),
	CS_34515_BOSS_ID_FIELD = slot0.FieldDescriptor(),
	CS_34515_LAST_TIME_FIELD = slot0.FieldDescriptor(),
	SC_34516_RESULT_FIELD = slot0.FieldDescriptor(),
	CS_34517_BOSS_ID_FIELD = slot0.FieldDescriptor(),
	SC_34518_LIST_FIELD = slot0.FieldDescriptor(),
	CS_34519_BOSS_ID_FIELD = slot0.FieldDescriptor(),
	CS_34519_USERID_FIELD = slot0.FieldDescriptor(),
	SC_34520_RESULT_FIELD = slot0.FieldDescriptor(),
	SC_34520_SHIP_LIST_FIELD = slot0.FieldDescriptor(),
	WORLDBOSS_INFO_ID_FIELD = slot0.FieldDescriptor(),
	WORLDBOSS_INFO_TEMPLATE_ID_FIELD = slot0.FieldDescriptor(),
	WORLDBOSS_INFO_LV_FIELD = slot0.FieldDescriptor(),
	WORLDBOSS_INFO_HP_FIELD = slot0.FieldDescriptor(),
	WORLDBOSS_INFO_OWNER_FIELD = slot0.FieldDescriptor(),
	WORLDBOSS_INFO_LAST_TIME_FIELD = slot0.FieldDescriptor(),
	WORLDBOSS_INFO_GUILD_SUPPORT_FIELD = slot0.FieldDescriptor(),
	WORLDBOSS_INFO_FRIEND_SUPPORT_FIELD = slot0.FieldDescriptor(),
	WORLDBOSS_INFO_WORLD_SUPPORT_FIELD = slot0.FieldDescriptor(),
	WORLDBOSS_INFO_KILL_TIME_FIELD = slot0.FieldDescriptor(),
	WORLDBOSS_INFO_FIGHT_COUNT_FIELD = slot0.FieldDescriptor(),
	WORLDBOSS_INFO_RANK_COUNT_FIELD = slot0.FieldDescriptor(),
	WORLDBOSS_RANK_ID_FIELD = slot0.FieldDescriptor(),
	WORLDBOSS_RANK_NAME_FIELD = slot0.FieldDescriptor(),
	WORLDBOSS_RANK_DAMAGE_FIELD = slot0.FieldDescriptor(),
	WORLDBOSS_SIMPLE_ID_FIELD = slot0.FieldDescriptor(),
	WORLDBOSS_SIMPLE_HP_FIELD = slot0.FieldDescriptor(),
	WORLDBOSS_SIMPLE_RANK_COUNT_FIELD = slot0.FieldDescriptor()
})["CS_34501_TYPE_FIELD"].name = "type"
()["CS_34501_TYPE_FIELD"].full_name = "p34.cs_34501.type"
()["CS_34501_TYPE_FIELD"].number = 1
()["CS_34501_TYPE_FIELD"].index = 0
()["CS_34501_TYPE_FIELD"].label = 2
()["CS_34501_TYPE_FIELD"].has_default_value = false
()["CS_34501_TYPE_FIELD"].default_value = 0
()["CS_34501_TYPE_FIELD"].type = 13
()["CS_34501_TYPE_FIELD"].cpp_type = 3
CS_34501.name = "cs_34501"
CS_34501.full_name = "p34.cs_34501"
CS_34501.nested_types = {}
CS_34501.enum_types = {}
CS_34501.fields = {
	()["CS_34501_TYPE_FIELD"]
}
CS_34501.is_extendable = false
CS_34501.extensions = {}
()["SC_34502_FIGHT_COUNT_FIELD"].name = "fight_count"
()["SC_34502_FIGHT_COUNT_FIELD"].full_name = "p34.sc_34502.fight_count"
()["SC_34502_FIGHT_COUNT_FIELD"].number = 1
()["SC_34502_FIGHT_COUNT_FIELD"].index = 0
()["SC_34502_FIGHT_COUNT_FIELD"].label = 2
()["SC_34502_FIGHT_COUNT_FIELD"].has_default_value = false
()["SC_34502_FIGHT_COUNT_FIELD"].default_value = 0
()["SC_34502_FIGHT_COUNT_FIELD"].type = 13
()["SC_34502_FIGHT_COUNT_FIELD"].cpp_type = 3
()["SC_34502_FIGHT_COUNT_UPDATE_TIME_FIELD"].name = "fight_count_update_time"
()["SC_34502_FIGHT_COUNT_UPDATE_TIME_FIELD"].full_name = "p34.sc_34502.fight_count_update_time"
()["SC_34502_FIGHT_COUNT_UPDATE_TIME_FIELD"].number = 2
()["SC_34502_FIGHT_COUNT_UPDATE_TIME_FIELD"].index = 1
()["SC_34502_FIGHT_COUNT_UPDATE_TIME_FIELD"].label = 2
()["SC_34502_FIGHT_COUNT_UPDATE_TIME_FIELD"].has_default_value = false
()["SC_34502_FIGHT_COUNT_UPDATE_TIME_FIELD"].default_value = 0
()["SC_34502_FIGHT_COUNT_UPDATE_TIME_FIELD"].type = 13
()["SC_34502_FIGHT_COUNT_UPDATE_TIME_FIELD"].cpp_type = 3
()["SC_34502_SELF_BOSS_FIELD"].name = "self_boss"
()["SC_34502_SELF_BOSS_FIELD"].full_name = "p34.sc_34502.self_boss"
()["SC_34502_SELF_BOSS_FIELD"].number = 3
()["SC_34502_SELF_BOSS_FIELD"].index = 2
()["SC_34502_SELF_BOSS_FIELD"].label = 1
()["SC_34502_SELF_BOSS_FIELD"].has_default_value = false
()["SC_34502_SELF_BOSS_FIELD"].default_value = nil
()["SC_34502_SELF_BOSS_FIELD"].message_type = WORLDBOSS_INFO
()["SC_34502_SELF_BOSS_FIELD"].type = 11
()["SC_34502_SELF_BOSS_FIELD"].cpp_type = 10
()["SC_34502_OTHER_BOSS_FIELD"].name = "other_boss"
()["SC_34502_OTHER_BOSS_FIELD"].full_name = "p34.sc_34502.other_boss"
()["SC_34502_OTHER_BOSS_FIELD"].number = 4
()["SC_34502_OTHER_BOSS_FIELD"].index = 3
()["SC_34502_OTHER_BOSS_FIELD"].label = 3
()["SC_34502_OTHER_BOSS_FIELD"].has_default_value = false
()["SC_34502_OTHER_BOSS_FIELD"].default_value = {}
()["SC_34502_OTHER_BOSS_FIELD"].message_type = WORLDBOSS_INFO
()["SC_34502_OTHER_BOSS_FIELD"].type = 11
()["SC_34502_OTHER_BOSS_FIELD"].cpp_type = 10
SC_34502.name = "sc_34502"
SC_34502.full_name = "p34.sc_34502"
SC_34502.nested_types = {}
SC_34502.enum_types = {}
SC_34502.fields = {
	()["SC_34502_FIGHT_COUNT_FIELD"],
	()["SC_34502_FIGHT_COUNT_UPDATE_TIME_FIELD"],
	()["SC_34502_SELF_BOSS_FIELD"],
	()["SC_34502_OTHER_BOSS_FIELD"]
}
SC_34502.is_extendable = false
SC_34502.extensions = {}
()["CS_34503_USER_ID_LIST_FIELD"].name = "user_id_list"
()["CS_34503_USER_ID_LIST_FIELD"].full_name = "p34.cs_34503.user_id_list"
()["CS_34503_USER_ID_LIST_FIELD"].number = 1
()["CS_34503_USER_ID_LIST_FIELD"].index = 0
()["CS_34503_USER_ID_LIST_FIELD"].label = 3
()["CS_34503_USER_ID_LIST_FIELD"].has_default_value = false
()["CS_34503_USER_ID_LIST_FIELD"].default_value = {}
()["CS_34503_USER_ID_LIST_FIELD"].type = 13
()["CS_34503_USER_ID_LIST_FIELD"].cpp_type = 3
CS_34503.name = "cs_34503"
CS_34503.full_name = "p34.cs_34503"
CS_34503.nested_types = {}
CS_34503.enum_types = {}
CS_34503.fields = {
	()["CS_34503_USER_ID_LIST_FIELD"]
}
CS_34503.is_extendable = false
CS_34503.extensions = {}
()["SC_34504_BOSS_LIST_FIELD"].name = "boss_list"
()["SC_34504_BOSS_LIST_FIELD"].full_name = "p34.sc_34504.boss_list"
()["SC_34504_BOSS_LIST_FIELD"].number = 1
()["SC_34504_BOSS_LIST_FIELD"].index = 0
()["SC_34504_BOSS_LIST_FIELD"].label = 3
()["SC_34504_BOSS_LIST_FIELD"].has_default_value = false
()["SC_34504_BOSS_LIST_FIELD"].default_value = {}
()["SC_34504_BOSS_LIST_FIELD"].message_type = WORLDBOSS_INFO
()["SC_34504_BOSS_LIST_FIELD"].type = 11
()["SC_34504_BOSS_LIST_FIELD"].cpp_type = 10
SC_34504.name = "sc_34504"
SC_34504.full_name = "p34.sc_34504"
SC_34504.nested_types = {}
SC_34504.enum_types = {}
SC_34504.fields = {
	()["SC_34504_BOSS_LIST_FIELD"]
}
SC_34504.is_extendable = false
SC_34504.extensions = {}
()["CS_34505_BOSS_ID_FIELD"].name = "boss_id"
()["CS_34505_BOSS_ID_FIELD"].full_name = "p34.cs_34505.boss_id"
()["CS_34505_BOSS_ID_FIELD"].number = 1
()["CS_34505_BOSS_ID_FIELD"].index = 0
()["CS_34505_BOSS_ID_FIELD"].label = 2
()["CS_34505_BOSS_ID_FIELD"].has_default_value = false
()["CS_34505_BOSS_ID_FIELD"].default_value = 0
()["CS_34505_BOSS_ID_FIELD"].type = 13
()["CS_34505_BOSS_ID_FIELD"].cpp_type = 3
CS_34505.name = "cs_34505"
CS_34505.full_name = "p34.cs_34505"
CS_34505.nested_types = {}
CS_34505.enum_types = {}
CS_34505.fields = {
	()["CS_34505_BOSS_ID_FIELD"]
}
CS_34505.is_extendable = false
CS_34505.extensions = {}
()["SC_34506_RANK_LIST_FIELD"].name = "rank_list"
()["SC_34506_RANK_LIST_FIELD"].full_name = "p34.sc_34506.rank_list"
()["SC_34506_RANK_LIST_FIELD"].number = 1
()["SC_34506_RANK_LIST_FIELD"].index = 0
()["SC_34506_RANK_LIST_FIELD"].label = 3
()["SC_34506_RANK_LIST_FIELD"].has_default_value = false
()["SC_34506_RANK_LIST_FIELD"].default_value = {}
()["SC_34506_RANK_LIST_FIELD"].message_type = WORLDBOSS_RANK
()["SC_34506_RANK_LIST_FIELD"].type = 11
()["SC_34506_RANK_LIST_FIELD"].cpp_type = 10
SC_34506.name = "sc_34506"
SC_34506.full_name = "p34.sc_34506"
SC_34506.nested_types = {}
SC_34506.enum_types = {}
SC_34506.fields = {
	()["SC_34506_RANK_LIST_FIELD"]
}
SC_34506.is_extendable = false
SC_34506.extensions = {}
()["SC_34507_BOSS_INFO_FIELD"].name = "boss_info"
()["SC_34507_BOSS_INFO_FIELD"].full_name = "p34.sc_34507.boss_info"
()["SC_34507_BOSS_INFO_FIELD"].number = 1
()["SC_34507_BOSS_INFO_FIELD"].index = 0
()["SC_34507_BOSS_INFO_FIELD"].label = 2
()["SC_34507_BOSS_INFO_FIELD"].has_default_value = false
()["SC_34507_BOSS_INFO_FIELD"].default_value = nil
()["SC_34507_BOSS_INFO_FIELD"].message_type = WORLDBOSS_INFO
()["SC_34507_BOSS_INFO_FIELD"].type = 11
()["SC_34507_BOSS_INFO_FIELD"].cpp_type = 10
()["SC_34507_USER_INFO_FIELD"].name = "user_info"
()["SC_34507_USER_INFO_FIELD"].full_name = "p34.sc_34507.user_info"
()["SC_34507_USER_INFO_FIELD"].number = 2
()["SC_34507_USER_INFO_FIELD"].index = 1
()["SC_34507_USER_INFO_FIELD"].label = 2
()["SC_34507_USER_INFO_FIELD"].has_default_value = false
()["SC_34507_USER_INFO_FIELD"].default_value = nil
()["SC_34507_USER_INFO_FIELD"].message_type = slot1.USERSIMPLEINFO
()["SC_34507_USER_INFO_FIELD"].type = 11
()["SC_34507_USER_INFO_FIELD"].cpp_type = 10
()["SC_34507_TYPE_FIELD"].name = "type"
()["SC_34507_TYPE_FIELD"].full_name = "p34.sc_34507.type"
()["SC_34507_TYPE_FIELD"].number = 3
()["SC_34507_TYPE_FIELD"].index = 2
()["SC_34507_TYPE_FIELD"].label = 2
()["SC_34507_TYPE_FIELD"].has_default_value = false
()["SC_34507_TYPE_FIELD"].default_value = 0
()["SC_34507_TYPE_FIELD"].type = 13
()["SC_34507_TYPE_FIELD"].cpp_type = 3
SC_34507.name = "sc_34507"
SC_34507.full_name = "p34.sc_34507"
SC_34507.nested_types = {}
SC_34507.enum_types = {}
SC_34507.fields = {
	()["SC_34507_BOSS_INFO_FIELD"],
	()["SC_34507_USER_INFO_FIELD"],
	()["SC_34507_TYPE_FIELD"]
}
SC_34507.is_extendable = false
SC_34507.extensions = {}
()["SC_34508_BOSS_ID_FIELD"].name = "boss_id"
()["SC_34508_BOSS_ID_FIELD"].full_name = "p34.sc_34508.boss_id"
()["SC_34508_BOSS_ID_FIELD"].number = 1
()["SC_34508_BOSS_ID_FIELD"].index = 0
()["SC_34508_BOSS_ID_FIELD"].label = 2
()["SC_34508_BOSS_ID_FIELD"].has_default_value = false
()["SC_34508_BOSS_ID_FIELD"].default_value = 0
()["SC_34508_BOSS_ID_FIELD"].type = 13
()["SC_34508_BOSS_ID_FIELD"].cpp_type = 3
()["SC_34508_HP_FIELD"].name = "hp"
()["SC_34508_HP_FIELD"].full_name = "p34.sc_34508.hp"
()["SC_34508_HP_FIELD"].number = 2
()["SC_34508_HP_FIELD"].index = 1
()["SC_34508_HP_FIELD"].label = 2
()["SC_34508_HP_FIELD"].has_default_value = false
()["SC_34508_HP_FIELD"].default_value = 0
()["SC_34508_HP_FIELD"].type = 13
()["SC_34508_HP_FIELD"].cpp_type = 3
SC_34508.name = "sc_34508"
SC_34508.full_name = "p34.sc_34508"
SC_34508.nested_types = {}
SC_34508.enum_types = {}
SC_34508.fields = {
	()["SC_34508_BOSS_ID_FIELD"],
	()["SC_34508_HP_FIELD"]
}
SC_34508.is_extendable = false
SC_34508.extensions = {}
()["CS_34509_TYPE_FIELD"].name = "type"
()["CS_34509_TYPE_FIELD"].full_name = "p34.cs_34509.type"
()["CS_34509_TYPE_FIELD"].number = 1
()["CS_34509_TYPE_FIELD"].index = 0
()["CS_34509_TYPE_FIELD"].label = 2
()["CS_34509_TYPE_FIELD"].has_default_value = false
()["CS_34509_TYPE_FIELD"].default_value = 0
()["CS_34509_TYPE_FIELD"].type = 13
()["CS_34509_TYPE_FIELD"].cpp_type = 3
CS_34509.name = "cs_34509"
CS_34509.full_name = "p34.cs_34509"
CS_34509.nested_types = {}
CS_34509.enum_types = {}
CS_34509.fields = {
	()["CS_34509_TYPE_FIELD"]
}
CS_34509.is_extendable = false
CS_34509.extensions = {}
()["SC_34510_RESULT_FIELD"].name = "result"
()["SC_34510_RESULT_FIELD"].full_name = "p34.sc_34510.result"
()["SC_34510_RESULT_FIELD"].number = 1
()["SC_34510_RESULT_FIELD"].index = 0
()["SC_34510_RESULT_FIELD"].label = 2
()["SC_34510_RESULT_FIELD"].has_default_value = false
()["SC_34510_RESULT_FIELD"].default_value = 0
()["SC_34510_RESULT_FIELD"].type = 13
()["SC_34510_RESULT_FIELD"].cpp_type = 3
SC_34510.name = "sc_34510"
SC_34510.full_name = "p34.sc_34510"
SC_34510.nested_types = {}
SC_34510.enum_types = {}
SC_34510.fields = {
	()["SC_34510_RESULT_FIELD"]
}
SC_34510.is_extendable = false
SC_34510.extensions = {}
()["CS_34511_BOSS_ID_FIELD"].name = "boss_id"
()["CS_34511_BOSS_ID_FIELD"].full_name = "p34.cs_34511.boss_id"
()["CS_34511_BOSS_ID_FIELD"].number = 1
()["CS_34511_BOSS_ID_FIELD"].index = 0
()["CS_34511_BOSS_ID_FIELD"].label = 2
()["CS_34511_BOSS_ID_FIELD"].has_default_value = false
()["CS_34511_BOSS_ID_FIELD"].default_value = 0
()["CS_34511_BOSS_ID_FIELD"].type = 13
()["CS_34511_BOSS_ID_FIELD"].cpp_type = 3
CS_34511.name = "cs_34511"
CS_34511.full_name = "p34.cs_34511"
CS_34511.nested_types = {}
CS_34511.enum_types = {}
CS_34511.fields = {
	()["CS_34511_BOSS_ID_FIELD"]
}
CS_34511.is_extendable = false
CS_34511.extensions = {}
()["SC_34512_RESULT_FIELD"].name = "result"
()["SC_34512_RESULT_FIELD"].full_name = "p34.sc_34512.result"
()["SC_34512_RESULT_FIELD"].number = 1
()["SC_34512_RESULT_FIELD"].index = 0
()["SC_34512_RESULT_FIELD"].label = 2
()["SC_34512_RESULT_FIELD"].has_default_value = false
()["SC_34512_RESULT_FIELD"].default_value = 0
()["SC_34512_RESULT_FIELD"].type = 13
()["SC_34512_RESULT_FIELD"].cpp_type = 3
()["SC_34512_DROPS_FIELD"].name = "drops"
()["SC_34512_DROPS_FIELD"].full_name = "p34.sc_34512.drops"
()["SC_34512_DROPS_FIELD"].number = 2
()["SC_34512_DROPS_FIELD"].index = 1
()["SC_34512_DROPS_FIELD"].label = 3
()["SC_34512_DROPS_FIELD"].has_default_value = false
()["SC_34512_DROPS_FIELD"].default_value = {}
()["SC_34512_DROPS_FIELD"].message_type = slot1.DROPINFO
()["SC_34512_DROPS_FIELD"].type = 11
()["SC_34512_DROPS_FIELD"].cpp_type = 10
SC_34512.name = "sc_34512"
SC_34512.full_name = "p34.sc_34512"
SC_34512.nested_types = {}
SC_34512.enum_types = {}
SC_34512.fields = {
	()["SC_34512_RESULT_FIELD"],
	()["SC_34512_DROPS_FIELD"]
}
SC_34512.is_extendable = false
SC_34512.extensions = {}
()["CS_34513_TYPE_FIELD"].name = "type"
()["CS_34513_TYPE_FIELD"].full_name = "p34.cs_34513.type"
()["CS_34513_TYPE_FIELD"].number = 1
()["CS_34513_TYPE_FIELD"].index = 0
()["CS_34513_TYPE_FIELD"].label = 2
()["CS_34513_TYPE_FIELD"].has_default_value = false
()["CS_34513_TYPE_FIELD"].default_value = 0
()["CS_34513_TYPE_FIELD"].type = 13
()["CS_34513_TYPE_FIELD"].cpp_type = 3
CS_34513.name = "cs_34513"
CS_34513.full_name = "p34.cs_34513"
CS_34513.nested_types = {}
CS_34513.enum_types = {}
CS_34513.fields = {
	()["CS_34513_TYPE_FIELD"]
}
CS_34513.is_extendable = false
CS_34513.extensions = {}
()["SC_34514_RESULT_FIELD"].name = "result"
()["SC_34514_RESULT_FIELD"].full_name = "p34.sc_34514.result"
()["SC_34514_RESULT_FIELD"].number = 1
()["SC_34514_RESULT_FIELD"].index = 0
()["SC_34514_RESULT_FIELD"].label = 2
()["SC_34514_RESULT_FIELD"].has_default_value = false
()["SC_34514_RESULT_FIELD"].default_value = 0
()["SC_34514_RESULT_FIELD"].type = 13
()["SC_34514_RESULT_FIELD"].cpp_type = 3
SC_34514.name = "sc_34514"
SC_34514.full_name = "p34.sc_34514"
SC_34514.nested_types = {}
SC_34514.enum_types = {}
SC_34514.fields = {
	()["SC_34514_RESULT_FIELD"]
}
SC_34514.is_extendable = false
SC_34514.extensions = {}
()["CS_34515_BOSS_ID_FIELD"].name = "boss_id"
()["CS_34515_BOSS_ID_FIELD"].full_name = "p34.cs_34515.boss_id"
()["CS_34515_BOSS_ID_FIELD"].number = 1
()["CS_34515_BOSS_ID_FIELD"].index = 0
()["CS_34515_BOSS_ID_FIELD"].label = 2
()["CS_34515_BOSS_ID_FIELD"].has_default_value = false
()["CS_34515_BOSS_ID_FIELD"].default_value = 0
()["CS_34515_BOSS_ID_FIELD"].type = 13
()["CS_34515_BOSS_ID_FIELD"].cpp_type = 3
()["CS_34515_LAST_TIME_FIELD"].name = "last_time"
()["CS_34515_LAST_TIME_FIELD"].full_name = "p34.cs_34515.last_time"
()["CS_34515_LAST_TIME_FIELD"].number = 2
()["CS_34515_LAST_TIME_FIELD"].index = 1
()["CS_34515_LAST_TIME_FIELD"].label = 1
()["CS_34515_LAST_TIME_FIELD"].has_default_value = false
()["CS_34515_LAST_TIME_FIELD"].default_value = 0
()["CS_34515_LAST_TIME_FIELD"].type = 13
()["CS_34515_LAST_TIME_FIELD"].cpp_type = 3
CS_34515.name = "cs_34515"
CS_34515.full_name = "p34.cs_34515"
CS_34515.nested_types = {}
CS_34515.enum_types = {}
CS_34515.fields = {
	()["CS_34515_BOSS_ID_FIELD"],
	()["CS_34515_LAST_TIME_FIELD"]
}
CS_34515.is_extendable = false
CS_34515.extensions = {}
()["SC_34516_RESULT_FIELD"].name = "result"
()["SC_34516_RESULT_FIELD"].full_name = "p34.sc_34516.result"
()["SC_34516_RESULT_FIELD"].number = 1
()["SC_34516_RESULT_FIELD"].index = 0
()["SC_34516_RESULT_FIELD"].label = 2
()["SC_34516_RESULT_FIELD"].has_default_value = false
()["SC_34516_RESULT_FIELD"].default_value = 0
()["SC_34516_RESULT_FIELD"].type = 13
()["SC_34516_RESULT_FIELD"].cpp_type = 3
SC_34516.name = "sc_34516"
SC_34516.full_name = "p34.sc_34516"
SC_34516.nested_types = {}
SC_34516.enum_types = {}
SC_34516.fields = {
	()["SC_34516_RESULT_FIELD"]
}
SC_34516.is_extendable = false
SC_34516.extensions = {}
()["CS_34517_BOSS_ID_FIELD"].name = "boss_id"
()["CS_34517_BOSS_ID_FIELD"].full_name = "p34.cs_34517.boss_id"
()["CS_34517_BOSS_ID_FIELD"].number = 1
()["CS_34517_BOSS_ID_FIELD"].index = 0
()["CS_34517_BOSS_ID_FIELD"].label = 3
()["CS_34517_BOSS_ID_FIELD"].has_default_value = false
()["CS_34517_BOSS_ID_FIELD"].default_value = {}
()["CS_34517_BOSS_ID_FIELD"].type = 13
()["CS_34517_BOSS_ID_FIELD"].cpp_type = 3
CS_34517.name = "cs_34517"
CS_34517.full_name = "p34.cs_34517"
CS_34517.nested_types = {}
CS_34517.enum_types = {}
CS_34517.fields = {
	()["CS_34517_BOSS_ID_FIELD"]
}
CS_34517.is_extendable = false
CS_34517.extensions = {}
()["SC_34518_LIST_FIELD"].name = "list"
()["SC_34518_LIST_FIELD"].full_name = "p34.sc_34518.list"
()["SC_34518_LIST_FIELD"].number = 1
()["SC_34518_LIST_FIELD"].index = 0
()["SC_34518_LIST_FIELD"].label = 3
()["SC_34518_LIST_FIELD"].has_default_value = false
()["SC_34518_LIST_FIELD"].default_value = {}
()["SC_34518_LIST_FIELD"].message_type = WORLDBOSS_SIMPLE
()["SC_34518_LIST_FIELD"].type = 11
()["SC_34518_LIST_FIELD"].cpp_type = 10
SC_34518.name = "sc_34518"
SC_34518.full_name = "p34.sc_34518"
SC_34518.nested_types = {}
SC_34518.enum_types = {}
SC_34518.fields = {
	()["SC_34518_LIST_FIELD"]
}
SC_34518.is_extendable = false
SC_34518.extensions = {}
()["CS_34519_BOSS_ID_FIELD"].name = "boss_id"
()["CS_34519_BOSS_ID_FIELD"].full_name = "p34.cs_34519.boss_id"
()["CS_34519_BOSS_ID_FIELD"].number = 1
()["CS_34519_BOSS_ID_FIELD"].index = 0
()["CS_34519_BOSS_ID_FIELD"].label = 2
()["CS_34519_BOSS_ID_FIELD"].has_default_value = false
()["CS_34519_BOSS_ID_FIELD"].default_value = 0
()["CS_34519_BOSS_ID_FIELD"].type = 13
()["CS_34519_BOSS_ID_FIELD"].cpp_type = 3
()["CS_34519_USERID_FIELD"].name = "userId"
()["CS_34519_USERID_FIELD"].full_name = "p34.cs_34519.userId"
()["CS_34519_USERID_FIELD"].number = 2
()["CS_34519_USERID_FIELD"].index = 1
()["CS_34519_USERID_FIELD"].label = 2
()["CS_34519_USERID_FIELD"].has_default_value = false
()["CS_34519_USERID_FIELD"].default_value = 0
()["CS_34519_USERID_FIELD"].type = 13
()["CS_34519_USERID_FIELD"].cpp_type = 3
CS_34519.name = "cs_34519"
CS_34519.full_name = "p34.cs_34519"
CS_34519.nested_types = {}
CS_34519.enum_types = {}
CS_34519.fields = {
	()["CS_34519_BOSS_ID_FIELD"],
	()["CS_34519_USERID_FIELD"]
}
CS_34519.is_extendable = false
CS_34519.extensions = {}
()["SC_34520_RESULT_FIELD"].name = "result"
()["SC_34520_RESULT_FIELD"].full_name = "p34.sc_34520.result"
()["SC_34520_RESULT_FIELD"].number = 1
()["SC_34520_RESULT_FIELD"].index = 0
()["SC_34520_RESULT_FIELD"].label = 2
()["SC_34520_RESULT_FIELD"].has_default_value = false
()["SC_34520_RESULT_FIELD"].default_value = 0
()["SC_34520_RESULT_FIELD"].type = 13
()["SC_34520_RESULT_FIELD"].cpp_type = 3
()["SC_34520_SHIP_LIST_FIELD"].name = "ship_list"
()["SC_34520_SHIP_LIST_FIELD"].full_name = "p34.sc_34520.ship_list"
()["SC_34520_SHIP_LIST_FIELD"].number = 2
()["SC_34520_SHIP_LIST_FIELD"].index = 1
()["SC_34520_SHIP_LIST_FIELD"].label = 3
()["SC_34520_SHIP_LIST_FIELD"].has_default_value = false
()["SC_34520_SHIP_LIST_FIELD"].default_value = {}
()["SC_34520_SHIP_LIST_FIELD"].message_type = slot1.SHIPINFO
()["SC_34520_SHIP_LIST_FIELD"].type = 11
()["SC_34520_SHIP_LIST_FIELD"].cpp_type = 10
SC_34520.name = "sc_34520"
SC_34520.full_name = "p34.sc_34520"
SC_34520.nested_types = {}
SC_34520.enum_types = {}
SC_34520.fields = {
	()["SC_34520_RESULT_FIELD"],
	()["SC_34520_SHIP_LIST_FIELD"]
}
SC_34520.is_extendable = false
SC_34520.extensions = {}
()["WORLDBOSS_INFO_ID_FIELD"].name = "id"
()["WORLDBOSS_INFO_ID_FIELD"].full_name = "p34.worldboss_info.id"
()["WORLDBOSS_INFO_ID_FIELD"].number = 1
()["WORLDBOSS_INFO_ID_FIELD"].index = 0
()["WORLDBOSS_INFO_ID_FIELD"].label = 2
()["WORLDBOSS_INFO_ID_FIELD"].has_default_value = false
()["WORLDBOSS_INFO_ID_FIELD"].default_value = 0
()["WORLDBOSS_INFO_ID_FIELD"].type = 13
()["WORLDBOSS_INFO_ID_FIELD"].cpp_type = 3
()["WORLDBOSS_INFO_TEMPLATE_ID_FIELD"].name = "template_id"
()["WORLDBOSS_INFO_TEMPLATE_ID_FIELD"].full_name = "p34.worldboss_info.template_id"
()["WORLDBOSS_INFO_TEMPLATE_ID_FIELD"].number = 2
()["WORLDBOSS_INFO_TEMPLATE_ID_FIELD"].index = 1
()["WORLDBOSS_INFO_TEMPLATE_ID_FIELD"].label = 2
()["WORLDBOSS_INFO_TEMPLATE_ID_FIELD"].has_default_value = false
()["WORLDBOSS_INFO_TEMPLATE_ID_FIELD"].default_value = 0
()["WORLDBOSS_INFO_TEMPLATE_ID_FIELD"].type = 13
()["WORLDBOSS_INFO_TEMPLATE_ID_FIELD"].cpp_type = 3
()["WORLDBOSS_INFO_LV_FIELD"].name = "lv"
()["WORLDBOSS_INFO_LV_FIELD"].full_name = "p34.worldboss_info.lv"
()["WORLDBOSS_INFO_LV_FIELD"].number = 3
()["WORLDBOSS_INFO_LV_FIELD"].index = 2
()["WORLDBOSS_INFO_LV_FIELD"].label = 2
()["WORLDBOSS_INFO_LV_FIELD"].has_default_value = false
()["WORLDBOSS_INFO_LV_FIELD"].default_value = 0
()["WORLDBOSS_INFO_LV_FIELD"].type = 13
()["WORLDBOSS_INFO_LV_FIELD"].cpp_type = 3
()["WORLDBOSS_INFO_HP_FIELD"].name = "hp"
()["WORLDBOSS_INFO_HP_FIELD"].full_name = "p34.worldboss_info.hp"
()["WORLDBOSS_INFO_HP_FIELD"].number = 4
()["WORLDBOSS_INFO_HP_FIELD"].index = 3
()["WORLDBOSS_INFO_HP_FIELD"].label = 2
()["WORLDBOSS_INFO_HP_FIELD"].has_default_value = false
()["WORLDBOSS_INFO_HP_FIELD"].default_value = 0
()["WORLDBOSS_INFO_HP_FIELD"].type = 13
()["WORLDBOSS_INFO_HP_FIELD"].cpp_type = 3
()["WORLDBOSS_INFO_OWNER_FIELD"].name = "owner"
()["WORLDBOSS_INFO_OWNER_FIELD"].full_name = "p34.worldboss_info.owner"
()["WORLDBOSS_INFO_OWNER_FIELD"].number = 5
()["WORLDBOSS_INFO_OWNER_FIELD"].index = 4
()["WORLDBOSS_INFO_OWNER_FIELD"].label = 2
()["WORLDBOSS_INFO_OWNER_FIELD"].has_default_value = false
()["WORLDBOSS_INFO_OWNER_FIELD"].default_value = 0
()["WORLDBOSS_INFO_OWNER_FIELD"].type = 13
()["WORLDBOSS_INFO_OWNER_FIELD"].cpp_type = 3
()["WORLDBOSS_INFO_LAST_TIME_FIELD"].name = "last_time"
()["WORLDBOSS_INFO_LAST_TIME_FIELD"].full_name = "p34.worldboss_info.last_time"
()["WORLDBOSS_INFO_LAST_TIME_FIELD"].number = 6
()["WORLDBOSS_INFO_LAST_TIME_FIELD"].index = 5
()["WORLDBOSS_INFO_LAST_TIME_FIELD"].label = 2
()["WORLDBOSS_INFO_LAST_TIME_FIELD"].has_default_value = false
()["WORLDBOSS_INFO_LAST_TIME_FIELD"].default_value = 0
()["WORLDBOSS_INFO_LAST_TIME_FIELD"].type = 13
()["WORLDBOSS_INFO_LAST_TIME_FIELD"].cpp_type = 3
()["WORLDBOSS_INFO_GUILD_SUPPORT_FIELD"].name = "guild_support"
()["WORLDBOSS_INFO_GUILD_SUPPORT_FIELD"].full_name = "p34.worldboss_info.guild_support"
()["WORLDBOSS_INFO_GUILD_SUPPORT_FIELD"].number = 7
()["WORLDBOSS_INFO_GUILD_SUPPORT_FIELD"].index = 6
()["WORLDBOSS_INFO_GUILD_SUPPORT_FIELD"].label = 2
()["WORLDBOSS_INFO_GUILD_SUPPORT_FIELD"].has_default_value = false
()["WORLDBOSS_INFO_GUILD_SUPPORT_FIELD"].default_value = 0
()["WORLDBOSS_INFO_GUILD_SUPPORT_FIELD"].type = 13
()["WORLDBOSS_INFO_GUILD_SUPPORT_FIELD"].cpp_type = 3
()["WORLDBOSS_INFO_FRIEND_SUPPORT_FIELD"].name = "friend_support"
()["WORLDBOSS_INFO_FRIEND_SUPPORT_FIELD"].full_name = "p34.worldboss_info.friend_support"
()["WORLDBOSS_INFO_FRIEND_SUPPORT_FIELD"].number = 8
()["WORLDBOSS_INFO_FRIEND_SUPPORT_FIELD"].index = 7
()["WORLDBOSS_INFO_FRIEND_SUPPORT_FIELD"].label = 2
()["WORLDBOSS_INFO_FRIEND_SUPPORT_FIELD"].has_default_value = false
()["WORLDBOSS_INFO_FRIEND_SUPPORT_FIELD"].default_value = 0
()["WORLDBOSS_INFO_FRIEND_SUPPORT_FIELD"].type = 13
()["WORLDBOSS_INFO_FRIEND_SUPPORT_FIELD"].cpp_type = 3
()["WORLDBOSS_INFO_WORLD_SUPPORT_FIELD"].name = "world_support"
()["WORLDBOSS_INFO_WORLD_SUPPORT_FIELD"].full_name = "p34.worldboss_info.world_support"
()["WORLDBOSS_INFO_WORLD_SUPPORT_FIELD"].number = 9
()["WORLDBOSS_INFO_WORLD_SUPPORT_FIELD"].index = 8
()["WORLDBOSS_INFO_WORLD_SUPPORT_FIELD"].label = 2
()["WORLDBOSS_INFO_WORLD_SUPPORT_FIELD"].has_default_value = false
()["WORLDBOSS_INFO_WORLD_SUPPORT_FIELD"].default_value = 0
()["WORLDBOSS_INFO_WORLD_SUPPORT_FIELD"].type = 13
()["WORLDBOSS_INFO_WORLD_SUPPORT_FIELD"].cpp_type = 3
()["WORLDBOSS_INFO_KILL_TIME_FIELD"].name = "kill_time"
()["WORLDBOSS_INFO_KILL_TIME_FIELD"].full_name = "p34.worldboss_info.kill_time"
()["WORLDBOSS_INFO_KILL_TIME_FIELD"].number = 10
()["WORLDBOSS_INFO_KILL_TIME_FIELD"].index = 9
()["WORLDBOSS_INFO_KILL_TIME_FIELD"].label = 2
()["WORLDBOSS_INFO_KILL_TIME_FIELD"].has_default_value = false
()["WORLDBOSS_INFO_KILL_TIME_FIELD"].default_value = 0
()["WORLDBOSS_INFO_KILL_TIME_FIELD"].type = 13
()["WORLDBOSS_INFO_KILL_TIME_FIELD"].cpp_type = 3
()["WORLDBOSS_INFO_FIGHT_COUNT_FIELD"].name = "fight_count"
()["WORLDBOSS_INFO_FIGHT_COUNT_FIELD"].full_name = "p34.worldboss_info.fight_count"
()["WORLDBOSS_INFO_FIGHT_COUNT_FIELD"].number = 11
()["WORLDBOSS_INFO_FIGHT_COUNT_FIELD"].index = 10
()["WORLDBOSS_INFO_FIGHT_COUNT_FIELD"].label = 2
()["WORLDBOSS_INFO_FIGHT_COUNT_FIELD"].has_default_value = false
()["WORLDBOSS_INFO_FIGHT_COUNT_FIELD"].default_value = 0
()["WORLDBOSS_INFO_FIGHT_COUNT_FIELD"].type = 13
()["WORLDBOSS_INFO_FIGHT_COUNT_FIELD"].cpp_type = 3
()["WORLDBOSS_INFO_RANK_COUNT_FIELD"].name = "rank_count"
()["WORLDBOSS_INFO_RANK_COUNT_FIELD"].full_name = "p34.worldboss_info.rank_count"
()["WORLDBOSS_INFO_RANK_COUNT_FIELD"].number = 12
()["WORLDBOSS_INFO_RANK_COUNT_FIELD"].index = 11
()["WORLDBOSS_INFO_RANK_COUNT_FIELD"].label = 2
()["WORLDBOSS_INFO_RANK_COUNT_FIELD"].has_default_value = false
()["WORLDBOSS_INFO_RANK_COUNT_FIELD"].default_value = 0
()["WORLDBOSS_INFO_RANK_COUNT_FIELD"].type = 13
()["WORLDBOSS_INFO_RANK_COUNT_FIELD"].cpp_type = 3
WORLDBOSS_INFO.name = "worldboss_info"
WORLDBOSS_INFO.full_name = "p34.worldboss_info"
WORLDBOSS_INFO.nested_types = {}
WORLDBOSS_INFO.enum_types = {}
WORLDBOSS_INFO.fields = {
	()["WORLDBOSS_INFO_ID_FIELD"],
	()["WORLDBOSS_INFO_TEMPLATE_ID_FIELD"],
	()["WORLDBOSS_INFO_LV_FIELD"],
	()["WORLDBOSS_INFO_HP_FIELD"],
	()["WORLDBOSS_INFO_OWNER_FIELD"],
	()["WORLDBOSS_INFO_LAST_TIME_FIELD"],
	()["WORLDBOSS_INFO_GUILD_SUPPORT_FIELD"],
	()["WORLDBOSS_INFO_FRIEND_SUPPORT_FIELD"],
	()["WORLDBOSS_INFO_WORLD_SUPPORT_FIELD"],
	()["WORLDBOSS_INFO_KILL_TIME_FIELD"],
	()["WORLDBOSS_INFO_FIGHT_COUNT_FIELD"],
	()["WORLDBOSS_INFO_RANK_COUNT_FIELD"]
}
WORLDBOSS_INFO.is_extendable = false
WORLDBOSS_INFO.extensions = {}
()["WORLDBOSS_RANK_ID_FIELD"].name = "id"
()["WORLDBOSS_RANK_ID_FIELD"].full_name = "p34.worldboss_rank.id"
()["WORLDBOSS_RANK_ID_FIELD"].number = 1
()["WORLDBOSS_RANK_ID_FIELD"].index = 0
()["WORLDBOSS_RANK_ID_FIELD"].label = 2
()["WORLDBOSS_RANK_ID_FIELD"].has_default_value = false
()["WORLDBOSS_RANK_ID_FIELD"].default_value = 0
()["WORLDBOSS_RANK_ID_FIELD"].type = 13
()["WORLDBOSS_RANK_ID_FIELD"].cpp_type = 3
()["WORLDBOSS_RANK_NAME_FIELD"].name = "name"
()["WORLDBOSS_RANK_NAME_FIELD"].full_name = "p34.worldboss_rank.name"
()["WORLDBOSS_RANK_NAME_FIELD"].number = 2
()["WORLDBOSS_RANK_NAME_FIELD"].index = 1
()["WORLDBOSS_RANK_NAME_FIELD"].label = 2
()["WORLDBOSS_RANK_NAME_FIELD"].has_default_value = false
()["WORLDBOSS_RANK_NAME_FIELD"].default_value = ""
()["WORLDBOSS_RANK_NAME_FIELD"].type = 9
()["WORLDBOSS_RANK_NAME_FIELD"].cpp_type = 9
()["WORLDBOSS_RANK_DAMAGE_FIELD"].name = "damage"
()["WORLDBOSS_RANK_DAMAGE_FIELD"].full_name = "p34.worldboss_rank.damage"
()["WORLDBOSS_RANK_DAMAGE_FIELD"].number = 3
()["WORLDBOSS_RANK_DAMAGE_FIELD"].index = 2
()["WORLDBOSS_RANK_DAMAGE_FIELD"].label = 2
()["WORLDBOSS_RANK_DAMAGE_FIELD"].has_default_value = false
()["WORLDBOSS_RANK_DAMAGE_FIELD"].default_value = 0
()["WORLDBOSS_RANK_DAMAGE_FIELD"].type = 13
()["WORLDBOSS_RANK_DAMAGE_FIELD"].cpp_type = 3
WORLDBOSS_RANK.name = "worldboss_rank"
WORLDBOSS_RANK.full_name = "p34.worldboss_rank"
WORLDBOSS_RANK.nested_types = {}
WORLDBOSS_RANK.enum_types = {}
WORLDBOSS_RANK.fields = {
	()["WORLDBOSS_RANK_ID_FIELD"],
	()["WORLDBOSS_RANK_NAME_FIELD"],
	()["WORLDBOSS_RANK_DAMAGE_FIELD"]
}
WORLDBOSS_RANK.is_extendable = false
WORLDBOSS_RANK.extensions = {}
()["WORLDBOSS_SIMPLE_ID_FIELD"].name = "id"
()["WORLDBOSS_SIMPLE_ID_FIELD"].full_name = "p34.worldboss_simple.id"
()["WORLDBOSS_SIMPLE_ID_FIELD"].number = 1
()["WORLDBOSS_SIMPLE_ID_FIELD"].index = 0
()["WORLDBOSS_SIMPLE_ID_FIELD"].label = 2
()["WORLDBOSS_SIMPLE_ID_FIELD"].has_default_value = false
()["WORLDBOSS_SIMPLE_ID_FIELD"].default_value = 0
()["WORLDBOSS_SIMPLE_ID_FIELD"].type = 13
()["WORLDBOSS_SIMPLE_ID_FIELD"].cpp_type = 3
()["WORLDBOSS_SIMPLE_HP_FIELD"].name = "hp"
()["WORLDBOSS_SIMPLE_HP_FIELD"].full_name = "p34.worldboss_simple.hp"
()["WORLDBOSS_SIMPLE_HP_FIELD"].number = 2
()["WORLDBOSS_SIMPLE_HP_FIELD"].index = 1
()["WORLDBOSS_SIMPLE_HP_FIELD"].label = 2
()["WORLDBOSS_SIMPLE_HP_FIELD"].has_default_value = false
()["WORLDBOSS_SIMPLE_HP_FIELD"].default_value = 0
()["WORLDBOSS_SIMPLE_HP_FIELD"].type = 13
()["WORLDBOSS_SIMPLE_HP_FIELD"].cpp_type = 3
()["WORLDBOSS_SIMPLE_RANK_COUNT_FIELD"].name = "rank_count"
()["WORLDBOSS_SIMPLE_RANK_COUNT_FIELD"].full_name = "p34.worldboss_simple.rank_count"
()["WORLDBOSS_SIMPLE_RANK_COUNT_FIELD"].number = 3
()["WORLDBOSS_SIMPLE_RANK_COUNT_FIELD"].index = 2
()["WORLDBOSS_SIMPLE_RANK_COUNT_FIELD"].label = 2
()["WORLDBOSS_SIMPLE_RANK_COUNT_FIELD"].has_default_value = false
()["WORLDBOSS_SIMPLE_RANK_COUNT_FIELD"].default_value = 0
()["WORLDBOSS_SIMPLE_RANK_COUNT_FIELD"].type = 13
()["WORLDBOSS_SIMPLE_RANK_COUNT_FIELD"].cpp_type = 3
WORLDBOSS_SIMPLE.name = "worldboss_simple"
WORLDBOSS_SIMPLE.full_name = "p34.worldboss_simple"
WORLDBOSS_SIMPLE.nested_types = {}
WORLDBOSS_SIMPLE.enum_types = {}
WORLDBOSS_SIMPLE.fields = {
	()["WORLDBOSS_SIMPLE_ID_FIELD"],
	()["WORLDBOSS_SIMPLE_HP_FIELD"],
	()["WORLDBOSS_SIMPLE_RANK_COUNT_FIELD"]
}
WORLDBOSS_SIMPLE.is_extendable = false
WORLDBOSS_SIMPLE.extensions = {}
cs_34501 = slot0.Message(CS_34501)
cs_34503 = slot0.Message(CS_34503)
cs_34505 = slot0.Message(CS_34505)
cs_34509 = slot0.Message(CS_34509)
cs_34511 = slot0.Message(CS_34511)
cs_34513 = slot0.Message(CS_34513)
cs_34515 = slot0.Message(CS_34515)
cs_34517 = slot0.Message(CS_34517)
cs_34519 = slot0.Message(CS_34519)
sc_34502 = slot0.Message(SC_34502)
sc_34504 = slot0.Message(SC_34504)
sc_34506 = slot0.Message(SC_34506)
sc_34507 = slot0.Message(SC_34507)
sc_34508 = slot0.Message(SC_34508)
sc_34510 = slot0.Message(SC_34510)
sc_34512 = slot0.Message(SC_34512)
sc_34514 = slot0.Message(SC_34514)
sc_34516 = slot0.Message(SC_34516)
sc_34518 = slot0.Message(SC_34518)
sc_34520 = slot0.Message(SC_34520)
worldboss_info = slot0.Message(WORLDBOSS_INFO)
worldboss_rank = slot0.Message(WORLDBOSS_RANK)
worldboss_simple = slot0.Message(WORLDBOSS_SIMPLE)

return
