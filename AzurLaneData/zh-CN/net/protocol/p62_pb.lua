slot0 = require("protobuf")
slot2 = require("guild_pb")

module("p62_pb")

CS_62002 = slot0.Descriptor()
SC_62003 = slot0.Descriptor()
SC_62004 = slot0.Descriptor()
SC_62005 = slot0.Descriptor()
SC_62006 = slot0.Descriptor()
CS_62007 = slot0.Descriptor()
SC_62008 = slot0.Descriptor()
CS_62009 = slot0.Descriptor()
SC_62010 = slot0.Descriptor()
CS_62011 = slot0.Descriptor()
SC_62012 = slot0.Descriptor()
CS_62013 = slot0.Descriptor()
SC_62014 = slot0.Descriptor()
CS_62015 = slot0.Descriptor()
SC_62016 = slot0.Descriptor()
SC_62017 = slot0.Descriptor()
SC_62018 = slot0.Descriptor()
SC_62019 = slot0.Descriptor()
CS_62020 = slot0.Descriptor()
SC_62021 = slot0.Descriptor()
CS_62022 = slot0.Descriptor()
SC_62023 = slot0.Descriptor()
CS_62024 = slot0.Descriptor()
SC_62025 = slot0.Descriptor()
CS_62029 = slot0.Descriptor()
SC_62030 = slot0.Descriptor()
SC_62031 = slot0.Descriptor()
CS_62100 = slot0.Descriptor()
SC_62101 = slot0.Descriptor()
RANK_INFO = slot0.Descriptor()
RANK_USER_INFO = slot0.Descriptor()
({
	CS_62002_ID_FIELD = slot0.FieldDescriptor(),
	SC_62003_RESULT_FIELD = slot0.FieldDescriptor(),
	SC_62003_DONATE_TASKS_FIELD = slot0.FieldDescriptor(),
	SC_62004_THIS_WEEKLY_TASKS_FIELD = slot0.FieldDescriptor(),
	SC_62005_BENEFIT_FINISH_TIME_FIELD = slot0.FieldDescriptor(),
	SC_62006_PROGRESS_FIELD = slot0.FieldDescriptor(),
	CS_62007_TYPE_FIELD = slot0.FieldDescriptor(),
	SC_62008_RESULT_FIELD = slot0.FieldDescriptor(),
	CS_62009_TYPE_FIELD = slot0.FieldDescriptor(),
	SC_62010_RESULT_FIELD = slot0.FieldDescriptor(),
	SC_62010_DROP_LIST_FIELD = slot0.FieldDescriptor(),
	CS_62011_TYPE_FIELD = slot0.FieldDescriptor(),
	SC_62012_RESULT_FIELD = slot0.FieldDescriptor(),
	SC_62012_LOG_FIELD = slot0.FieldDescriptor(),
	CS_62013_ID_FIELD = slot0.FieldDescriptor(),
	SC_62014_RESULT_FIELD = slot0.FieldDescriptor(),
	CS_62015_ID_FIELD = slot0.FieldDescriptor(),
	SC_62016_RESULT_FIELD = slot0.FieldDescriptor(),
	SC_62017_ID_FIELD = slot0.FieldDescriptor(),
	SC_62018_ID_FIELD = slot0.FieldDescriptor(),
	SC_62019_ID_FIELD = slot0.FieldDescriptor(),
	SC_62019_USER_ID_FIELD = slot0.FieldDescriptor(),
	SC_62019_HAS_CAPITAL_FIELD = slot0.FieldDescriptor(),
	SC_62019_HAS_TECH_POINT_FIELD = slot0.FieldDescriptor(),
	CS_62020_ID_FIELD = slot0.FieldDescriptor(),
	SC_62021_RESULT_FIELD = slot0.FieldDescriptor(),
	CS_62022_TYPE_FIELD = slot0.FieldDescriptor(),
	SC_62023_RESULT_FIELD = slot0.FieldDescriptor(),
	SC_62023_PROGRESS_FIELD = slot0.FieldDescriptor(),
	CS_62024_TYPE_FIELD = slot0.FieldDescriptor(),
	SC_62025_RESULT_FIELD = slot0.FieldDescriptor(),
	SC_62025_CAPITAL_FIELD = slot0.FieldDescriptor(),
	CS_62029_TYPE_FIELD = slot0.FieldDescriptor(),
	SC_62030_LIST_FIELD = slot0.FieldDescriptor(),
	SC_62031_DONATE_TASKS_FIELD = slot0.FieldDescriptor(),
	CS_62100_TYPE_FIELD = slot0.FieldDescriptor(),
	SC_62101_TECHNOLOGYS_FIELD = slot0.FieldDescriptor(),
	RANK_INFO_PERIOD_FIELD = slot0.FieldDescriptor(),
	RANK_INFO_RANKUSERINFO_FIELD = slot0.FieldDescriptor(),
	RANK_USER_INFO_USER_ID_FIELD = slot0.FieldDescriptor(),
	RANK_USER_INFO_COUNT_FIELD = slot0.FieldDescriptor()
})["CS_62002_ID_FIELD"].name = "id"
()["CS_62002_ID_FIELD"].full_name = "p62.cs_62002.id"
()["CS_62002_ID_FIELD"].number = 1
()["CS_62002_ID_FIELD"].index = 0
()["CS_62002_ID_FIELD"].label = 2
()["CS_62002_ID_FIELD"].has_default_value = false
()["CS_62002_ID_FIELD"].default_value = 0
()["CS_62002_ID_FIELD"].type = 13
()["CS_62002_ID_FIELD"].cpp_type = 3
CS_62002.name = "cs_62002"
CS_62002.full_name = "p62.cs_62002"
CS_62002.nested_types = {}
CS_62002.enum_types = {}
CS_62002.fields = {
	()["CS_62002_ID_FIELD"]
}
CS_62002.is_extendable = false
CS_62002.extensions = {}
()["SC_62003_RESULT_FIELD"].name = "result"
()["SC_62003_RESULT_FIELD"].full_name = "p62.sc_62003.result"
()["SC_62003_RESULT_FIELD"].number = 1
()["SC_62003_RESULT_FIELD"].index = 0
()["SC_62003_RESULT_FIELD"].label = 2
()["SC_62003_RESULT_FIELD"].has_default_value = false
()["SC_62003_RESULT_FIELD"].default_value = 0
()["SC_62003_RESULT_FIELD"].type = 13
()["SC_62003_RESULT_FIELD"].cpp_type = 3
()["SC_62003_DONATE_TASKS_FIELD"].name = "donate_tasks"
()["SC_62003_DONATE_TASKS_FIELD"].full_name = "p62.sc_62003.donate_tasks"
()["SC_62003_DONATE_TASKS_FIELD"].number = 2
()["SC_62003_DONATE_TASKS_FIELD"].index = 1
()["SC_62003_DONATE_TASKS_FIELD"].label = 3
()["SC_62003_DONATE_TASKS_FIELD"].has_default_value = false
()["SC_62003_DONATE_TASKS_FIELD"].default_value = {}
()["SC_62003_DONATE_TASKS_FIELD"].type = 13
()["SC_62003_DONATE_TASKS_FIELD"].cpp_type = 3
SC_62003.name = "sc_62003"
SC_62003.full_name = "p62.sc_62003"
SC_62003.nested_types = {}
SC_62003.enum_types = {}
SC_62003.fields = {
	()["SC_62003_RESULT_FIELD"],
	()["SC_62003_DONATE_TASKS_FIELD"]
}
SC_62003.is_extendable = false
SC_62003.extensions = {}
()["SC_62004_THIS_WEEKLY_TASKS_FIELD"].name = "this_weekly_tasks"
()["SC_62004_THIS_WEEKLY_TASKS_FIELD"].full_name = "p62.sc_62004.this_weekly_tasks"
()["SC_62004_THIS_WEEKLY_TASKS_FIELD"].number = 1
()["SC_62004_THIS_WEEKLY_TASKS_FIELD"].index = 0
()["SC_62004_THIS_WEEKLY_TASKS_FIELD"].label = 2
()["SC_62004_THIS_WEEKLY_TASKS_FIELD"].has_default_value = false
()["SC_62004_THIS_WEEKLY_TASKS_FIELD"].default_value = nil
()["SC_62004_THIS_WEEKLY_TASKS_FIELD"].message_type = slot2.WEEKLY_TASK
()["SC_62004_THIS_WEEKLY_TASKS_FIELD"].type = 11
()["SC_62004_THIS_WEEKLY_TASKS_FIELD"].cpp_type = 10
SC_62004.name = "sc_62004"
SC_62004.full_name = "p62.sc_62004"
SC_62004.nested_types = {}
SC_62004.enum_types = {}
SC_62004.fields = {
	()["SC_62004_THIS_WEEKLY_TASKS_FIELD"]
}
SC_62004.is_extendable = false
SC_62004.extensions = {}
()["SC_62005_BENEFIT_FINISH_TIME_FIELD"].name = "benefit_finish_time"
()["SC_62005_BENEFIT_FINISH_TIME_FIELD"].full_name = "p62.sc_62005.benefit_finish_time"
()["SC_62005_BENEFIT_FINISH_TIME_FIELD"].number = 1
()["SC_62005_BENEFIT_FINISH_TIME_FIELD"].index = 0
()["SC_62005_BENEFIT_FINISH_TIME_FIELD"].label = 2
()["SC_62005_BENEFIT_FINISH_TIME_FIELD"].has_default_value = false
()["SC_62005_BENEFIT_FINISH_TIME_FIELD"].default_value = 0
()["SC_62005_BENEFIT_FINISH_TIME_FIELD"].type = 13
()["SC_62005_BENEFIT_FINISH_TIME_FIELD"].cpp_type = 3
SC_62005.name = "sc_62005"
SC_62005.full_name = "p62.sc_62005"
SC_62005.nested_types = {}
SC_62005.enum_types = {}
SC_62005.fields = {
	()["SC_62005_BENEFIT_FINISH_TIME_FIELD"]
}
SC_62005.is_extendable = false
SC_62005.extensions = {}
()["SC_62006_PROGRESS_FIELD"].name = "progress"
()["SC_62006_PROGRESS_FIELD"].full_name = "p62.sc_62006.progress"
()["SC_62006_PROGRESS_FIELD"].number = 1
()["SC_62006_PROGRESS_FIELD"].index = 0
()["SC_62006_PROGRESS_FIELD"].label = 2
()["SC_62006_PROGRESS_FIELD"].has_default_value = false
()["SC_62006_PROGRESS_FIELD"].default_value = 0
()["SC_62006_PROGRESS_FIELD"].type = 13
()["SC_62006_PROGRESS_FIELD"].cpp_type = 3
SC_62006.name = "sc_62006"
SC_62006.full_name = "p62.sc_62006"
SC_62006.nested_types = {}
SC_62006.enum_types = {}
SC_62006.fields = {
	()["SC_62006_PROGRESS_FIELD"]
}
SC_62006.is_extendable = false
SC_62006.extensions = {}
()["CS_62007_TYPE_FIELD"].name = "type"
()["CS_62007_TYPE_FIELD"].full_name = "p62.cs_62007.type"
()["CS_62007_TYPE_FIELD"].number = 1
()["CS_62007_TYPE_FIELD"].index = 0
()["CS_62007_TYPE_FIELD"].label = 2
()["CS_62007_TYPE_FIELD"].has_default_value = false
()["CS_62007_TYPE_FIELD"].default_value = 0
()["CS_62007_TYPE_FIELD"].type = 13
()["CS_62007_TYPE_FIELD"].cpp_type = 3
CS_62007.name = "cs_62007"
CS_62007.full_name = "p62.cs_62007"
CS_62007.nested_types = {}
CS_62007.enum_types = {}
CS_62007.fields = {
	()["CS_62007_TYPE_FIELD"]
}
CS_62007.is_extendable = false
CS_62007.extensions = {}
()["SC_62008_RESULT_FIELD"].name = "result"
()["SC_62008_RESULT_FIELD"].full_name = "p62.sc_62008.result"
()["SC_62008_RESULT_FIELD"].number = 1
()["SC_62008_RESULT_FIELD"].index = 0
()["SC_62008_RESULT_FIELD"].label = 2
()["SC_62008_RESULT_FIELD"].has_default_value = false
()["SC_62008_RESULT_FIELD"].default_value = 0
()["SC_62008_RESULT_FIELD"].type = 13
()["SC_62008_RESULT_FIELD"].cpp_type = 3
SC_62008.name = "sc_62008"
SC_62008.full_name = "p62.sc_62008"
SC_62008.nested_types = {}
SC_62008.enum_types = {}
SC_62008.fields = {
	()["SC_62008_RESULT_FIELD"]
}
SC_62008.is_extendable = false
SC_62008.extensions = {}
()["CS_62009_TYPE_FIELD"].name = "type"
()["CS_62009_TYPE_FIELD"].full_name = "p62.cs_62009.type"
()["CS_62009_TYPE_FIELD"].number = 1
()["CS_62009_TYPE_FIELD"].index = 0
()["CS_62009_TYPE_FIELD"].label = 2
()["CS_62009_TYPE_FIELD"].has_default_value = false
()["CS_62009_TYPE_FIELD"].default_value = 0
()["CS_62009_TYPE_FIELD"].type = 13
()["CS_62009_TYPE_FIELD"].cpp_type = 3
CS_62009.name = "cs_62009"
CS_62009.full_name = "p62.cs_62009"
CS_62009.nested_types = {}
CS_62009.enum_types = {}
CS_62009.fields = {
	()["CS_62009_TYPE_FIELD"]
}
CS_62009.is_extendable = false
CS_62009.extensions = {}
()["SC_62010_RESULT_FIELD"].name = "result"
()["SC_62010_RESULT_FIELD"].full_name = "p62.sc_62010.result"
()["SC_62010_RESULT_FIELD"].number = 1
()["SC_62010_RESULT_FIELD"].index = 0
()["SC_62010_RESULT_FIELD"].label = 2
()["SC_62010_RESULT_FIELD"].has_default_value = false
()["SC_62010_RESULT_FIELD"].default_value = 0
()["SC_62010_RESULT_FIELD"].type = 13
()["SC_62010_RESULT_FIELD"].cpp_type = 3
()["SC_62010_DROP_LIST_FIELD"].name = "drop_list"
()["SC_62010_DROP_LIST_FIELD"].full_name = "p62.sc_62010.drop_list"
()["SC_62010_DROP_LIST_FIELD"].number = 2
()["SC_62010_DROP_LIST_FIELD"].index = 1
()["SC_62010_DROP_LIST_FIELD"].label = 3
()["SC_62010_DROP_LIST_FIELD"].has_default_value = false
()["SC_62010_DROP_LIST_FIELD"].default_value = {}
()["SC_62010_DROP_LIST_FIELD"].message_type = require("common_pb").DROPINFO
()["SC_62010_DROP_LIST_FIELD"].type = 11
()["SC_62010_DROP_LIST_FIELD"].cpp_type = 10
SC_62010.name = "sc_62010"
SC_62010.full_name = "p62.sc_62010"
SC_62010.nested_types = {}
SC_62010.enum_types = {}
SC_62010.fields = {
	()["SC_62010_RESULT_FIELD"],
	()["SC_62010_DROP_LIST_FIELD"]
}
SC_62010.is_extendable = false
SC_62010.extensions = {}
()["CS_62011_TYPE_FIELD"].name = "type"
()["CS_62011_TYPE_FIELD"].full_name = "p62.cs_62011.type"
()["CS_62011_TYPE_FIELD"].number = 1
()["CS_62011_TYPE_FIELD"].index = 0
()["CS_62011_TYPE_FIELD"].label = 2
()["CS_62011_TYPE_FIELD"].has_default_value = false
()["CS_62011_TYPE_FIELD"].default_value = 0
()["CS_62011_TYPE_FIELD"].type = 13
()["CS_62011_TYPE_FIELD"].cpp_type = 3
CS_62011.name = "cs_62011"
CS_62011.full_name = "p62.cs_62011"
CS_62011.nested_types = {}
CS_62011.enum_types = {}
CS_62011.fields = {
	()["CS_62011_TYPE_FIELD"]
}
CS_62011.is_extendable = false
CS_62011.extensions = {}
()["SC_62012_RESULT_FIELD"].name = "result"
()["SC_62012_RESULT_FIELD"].full_name = "p62.sc_62012.result"
()["SC_62012_RESULT_FIELD"].number = 1
()["SC_62012_RESULT_FIELD"].index = 0
()["SC_62012_RESULT_FIELD"].label = 2
()["SC_62012_RESULT_FIELD"].has_default_value = false
()["SC_62012_RESULT_FIELD"].default_value = 0
()["SC_62012_RESULT_FIELD"].type = 13
()["SC_62012_RESULT_FIELD"].cpp_type = 3
()["SC_62012_LOG_FIELD"].name = "log"
()["SC_62012_LOG_FIELD"].full_name = "p62.sc_62012.log"
()["SC_62012_LOG_FIELD"].number = 2
()["SC_62012_LOG_FIELD"].index = 1
()["SC_62012_LOG_FIELD"].label = 3
()["SC_62012_LOG_FIELD"].has_default_value = false
()["SC_62012_LOG_FIELD"].default_value = {}
()["SC_62012_LOG_FIELD"].message_type = slot2.CAPITAL_LOG
()["SC_62012_LOG_FIELD"].type = 11
()["SC_62012_LOG_FIELD"].cpp_type = 10
SC_62012.name = "sc_62012"
SC_62012.full_name = "p62.sc_62012"
SC_62012.nested_types = {}
SC_62012.enum_types = {}
SC_62012.fields = {
	()["SC_62012_RESULT_FIELD"],
	()["SC_62012_LOG_FIELD"]
}
SC_62012.is_extendable = false
SC_62012.extensions = {}
()["CS_62013_ID_FIELD"].name = "id"
()["CS_62013_ID_FIELD"].full_name = "p62.cs_62013.id"
()["CS_62013_ID_FIELD"].number = 1
()["CS_62013_ID_FIELD"].index = 0
()["CS_62013_ID_FIELD"].label = 2
()["CS_62013_ID_FIELD"].has_default_value = false
()["CS_62013_ID_FIELD"].default_value = 0
()["CS_62013_ID_FIELD"].type = 13
()["CS_62013_ID_FIELD"].cpp_type = 3
CS_62013.name = "cs_62013"
CS_62013.full_name = "p62.cs_62013"
CS_62013.nested_types = {}
CS_62013.enum_types = {}
CS_62013.fields = {
	()["CS_62013_ID_FIELD"]
}
CS_62013.is_extendable = false
CS_62013.extensions = {}
()["SC_62014_RESULT_FIELD"].name = "result"
()["SC_62014_RESULT_FIELD"].full_name = "p62.sc_62014.result"
()["SC_62014_RESULT_FIELD"].number = 1
()["SC_62014_RESULT_FIELD"].index = 0
()["SC_62014_RESULT_FIELD"].label = 2
()["SC_62014_RESULT_FIELD"].has_default_value = false
()["SC_62014_RESULT_FIELD"].default_value = 0
()["SC_62014_RESULT_FIELD"].type = 13
()["SC_62014_RESULT_FIELD"].cpp_type = 3
SC_62014.name = "sc_62014"
SC_62014.full_name = "p62.sc_62014"
SC_62014.nested_types = {}
SC_62014.enum_types = {}
SC_62014.fields = {
	()["SC_62014_RESULT_FIELD"]
}
SC_62014.is_extendable = false
SC_62014.extensions = {}
()["CS_62015_ID_FIELD"].name = "id"
()["CS_62015_ID_FIELD"].full_name = "p62.cs_62015.id"
()["CS_62015_ID_FIELD"].number = 1
()["CS_62015_ID_FIELD"].index = 0
()["CS_62015_ID_FIELD"].label = 2
()["CS_62015_ID_FIELD"].has_default_value = false
()["CS_62015_ID_FIELD"].default_value = 0
()["CS_62015_ID_FIELD"].type = 13
()["CS_62015_ID_FIELD"].cpp_type = 3
CS_62015.name = "cs_62015"
CS_62015.full_name = "p62.cs_62015"
CS_62015.nested_types = {}
CS_62015.enum_types = {}
CS_62015.fields = {
	()["CS_62015_ID_FIELD"]
}
CS_62015.is_extendable = false
CS_62015.extensions = {}
()["SC_62016_RESULT_FIELD"].name = "result"
()["SC_62016_RESULT_FIELD"].full_name = "p62.sc_62016.result"
()["SC_62016_RESULT_FIELD"].number = 1
()["SC_62016_RESULT_FIELD"].index = 0
()["SC_62016_RESULT_FIELD"].label = 2
()["SC_62016_RESULT_FIELD"].has_default_value = false
()["SC_62016_RESULT_FIELD"].default_value = 0
()["SC_62016_RESULT_FIELD"].type = 13
()["SC_62016_RESULT_FIELD"].cpp_type = 3
SC_62016.name = "sc_62016"
SC_62016.full_name = "p62.sc_62016"
SC_62016.nested_types = {}
SC_62016.enum_types = {}
SC_62016.fields = {
	()["SC_62016_RESULT_FIELD"]
}
SC_62016.is_extendable = false
SC_62016.extensions = {}
()["SC_62017_ID_FIELD"].name = "id"
()["SC_62017_ID_FIELD"].full_name = "p62.sc_62017.id"
()["SC_62017_ID_FIELD"].number = 1
()["SC_62017_ID_FIELD"].index = 0
()["SC_62017_ID_FIELD"].label = 2
()["SC_62017_ID_FIELD"].has_default_value = false
()["SC_62017_ID_FIELD"].default_value = 0
()["SC_62017_ID_FIELD"].type = 13
()["SC_62017_ID_FIELD"].cpp_type = 3
SC_62017.name = "sc_62017"
SC_62017.full_name = "p62.sc_62017"
SC_62017.nested_types = {}
SC_62017.enum_types = {}
SC_62017.fields = {
	()["SC_62017_ID_FIELD"]
}
SC_62017.is_extendable = false
SC_62017.extensions = {}
()["SC_62018_ID_FIELD"].name = "id"
()["SC_62018_ID_FIELD"].full_name = "p62.sc_62018.id"
()["SC_62018_ID_FIELD"].number = 1
()["SC_62018_ID_FIELD"].index = 0
()["SC_62018_ID_FIELD"].label = 2
()["SC_62018_ID_FIELD"].has_default_value = false
()["SC_62018_ID_FIELD"].default_value = 0
()["SC_62018_ID_FIELD"].type = 13
()["SC_62018_ID_FIELD"].cpp_type = 3
SC_62018.name = "sc_62018"
SC_62018.full_name = "p62.sc_62018"
SC_62018.nested_types = {}
SC_62018.enum_types = {}
SC_62018.fields = {
	()["SC_62018_ID_FIELD"]
}
SC_62018.is_extendable = false
SC_62018.extensions = {}
()["SC_62019_ID_FIELD"].name = "id"
()["SC_62019_ID_FIELD"].full_name = "p62.sc_62019.id"
()["SC_62019_ID_FIELD"].number = 1
()["SC_62019_ID_FIELD"].index = 0
()["SC_62019_ID_FIELD"].label = 2
()["SC_62019_ID_FIELD"].has_default_value = false
()["SC_62019_ID_FIELD"].default_value = 0
()["SC_62019_ID_FIELD"].type = 13
()["SC_62019_ID_FIELD"].cpp_type = 3
()["SC_62019_USER_ID_FIELD"].name = "user_id"
()["SC_62019_USER_ID_FIELD"].full_name = "p62.sc_62019.user_id"
()["SC_62019_USER_ID_FIELD"].number = 2
()["SC_62019_USER_ID_FIELD"].index = 1
()["SC_62019_USER_ID_FIELD"].label = 2
()["SC_62019_USER_ID_FIELD"].has_default_value = false
()["SC_62019_USER_ID_FIELD"].default_value = 0
()["SC_62019_USER_ID_FIELD"].type = 13
()["SC_62019_USER_ID_FIELD"].cpp_type = 3
()["SC_62019_HAS_CAPITAL_FIELD"].name = "has_capital"
()["SC_62019_HAS_CAPITAL_FIELD"].full_name = "p62.sc_62019.has_capital"
()["SC_62019_HAS_CAPITAL_FIELD"].number = 3
()["SC_62019_HAS_CAPITAL_FIELD"].index = 2
()["SC_62019_HAS_CAPITAL_FIELD"].label = 2
()["SC_62019_HAS_CAPITAL_FIELD"].has_default_value = false
()["SC_62019_HAS_CAPITAL_FIELD"].default_value = 0
()["SC_62019_HAS_CAPITAL_FIELD"].type = 13
()["SC_62019_HAS_CAPITAL_FIELD"].cpp_type = 3
()["SC_62019_HAS_TECH_POINT_FIELD"].name = "has_tech_point"
()["SC_62019_HAS_TECH_POINT_FIELD"].full_name = "p62.sc_62019.has_tech_point"
()["SC_62019_HAS_TECH_POINT_FIELD"].number = 4
()["SC_62019_HAS_TECH_POINT_FIELD"].index = 3
()["SC_62019_HAS_TECH_POINT_FIELD"].label = 2
()["SC_62019_HAS_TECH_POINT_FIELD"].has_default_value = false
()["SC_62019_HAS_TECH_POINT_FIELD"].default_value = 0
()["SC_62019_HAS_TECH_POINT_FIELD"].type = 13
()["SC_62019_HAS_TECH_POINT_FIELD"].cpp_type = 3
SC_62019.name = "sc_62019"
SC_62019.full_name = "p62.sc_62019"
SC_62019.nested_types = {}
SC_62019.enum_types = {}
SC_62019.fields = {
	()["SC_62019_ID_FIELD"],
	()["SC_62019_USER_ID_FIELD"],
	()["SC_62019_HAS_CAPITAL_FIELD"],
	()["SC_62019_HAS_TECH_POINT_FIELD"]
}
SC_62019.is_extendable = false
SC_62019.extensions = {}
()["CS_62020_ID_FIELD"].name = "id"
()["CS_62020_ID_FIELD"].full_name = "p62.cs_62020.id"
()["CS_62020_ID_FIELD"].number = 1
()["CS_62020_ID_FIELD"].index = 0
()["CS_62020_ID_FIELD"].label = 2
()["CS_62020_ID_FIELD"].has_default_value = false
()["CS_62020_ID_FIELD"].default_value = 0
()["CS_62020_ID_FIELD"].type = 13
()["CS_62020_ID_FIELD"].cpp_type = 3
CS_62020.name = "cs_62020"
CS_62020.full_name = "p62.cs_62020"
CS_62020.nested_types = {}
CS_62020.enum_types = {}
CS_62020.fields = {
	()["CS_62020_ID_FIELD"]
}
CS_62020.is_extendable = false
CS_62020.extensions = {}
()["SC_62021_RESULT_FIELD"].name = "result"
()["SC_62021_RESULT_FIELD"].full_name = "p62.sc_62021.result"
()["SC_62021_RESULT_FIELD"].number = 1
()["SC_62021_RESULT_FIELD"].index = 0
()["SC_62021_RESULT_FIELD"].label = 2
()["SC_62021_RESULT_FIELD"].has_default_value = false
()["SC_62021_RESULT_FIELD"].default_value = 0
()["SC_62021_RESULT_FIELD"].type = 13
()["SC_62021_RESULT_FIELD"].cpp_type = 3
SC_62021.name = "sc_62021"
SC_62021.full_name = "p62.sc_62021"
SC_62021.nested_types = {}
SC_62021.enum_types = {}
SC_62021.fields = {
	()["SC_62021_RESULT_FIELD"]
}
SC_62021.is_extendable = false
SC_62021.extensions = {}
()["CS_62022_TYPE_FIELD"].name = "type"
()["CS_62022_TYPE_FIELD"].full_name = "p62.cs_62022.type"
()["CS_62022_TYPE_FIELD"].number = 1
()["CS_62022_TYPE_FIELD"].index = 0
()["CS_62022_TYPE_FIELD"].label = 2
()["CS_62022_TYPE_FIELD"].has_default_value = false
()["CS_62022_TYPE_FIELD"].default_value = 0
()["CS_62022_TYPE_FIELD"].type = 13
()["CS_62022_TYPE_FIELD"].cpp_type = 3
CS_62022.name = "cs_62022"
CS_62022.full_name = "p62.cs_62022"
CS_62022.nested_types = {}
CS_62022.enum_types = {}
CS_62022.fields = {
	()["CS_62022_TYPE_FIELD"]
}
CS_62022.is_extendable = false
CS_62022.extensions = {}
()["SC_62023_RESULT_FIELD"].name = "result"
()["SC_62023_RESULT_FIELD"].full_name = "p62.sc_62023.result"
()["SC_62023_RESULT_FIELD"].number = 1
()["SC_62023_RESULT_FIELD"].index = 0
()["SC_62023_RESULT_FIELD"].label = 2
()["SC_62023_RESULT_FIELD"].has_default_value = false
()["SC_62023_RESULT_FIELD"].default_value = 0
()["SC_62023_RESULT_FIELD"].type = 13
()["SC_62023_RESULT_FIELD"].cpp_type = 3
()["SC_62023_PROGRESS_FIELD"].name = "progress"
()["SC_62023_PROGRESS_FIELD"].full_name = "p62.sc_62023.progress"
()["SC_62023_PROGRESS_FIELD"].number = 2
()["SC_62023_PROGRESS_FIELD"].index = 1
()["SC_62023_PROGRESS_FIELD"].label = 2
()["SC_62023_PROGRESS_FIELD"].has_default_value = false
()["SC_62023_PROGRESS_FIELD"].default_value = 0
()["SC_62023_PROGRESS_FIELD"].type = 13
()["SC_62023_PROGRESS_FIELD"].cpp_type = 3
SC_62023.name = "sc_62023"
SC_62023.full_name = "p62.sc_62023"
SC_62023.nested_types = {}
SC_62023.enum_types = {}
SC_62023.fields = {
	()["SC_62023_RESULT_FIELD"],
	()["SC_62023_PROGRESS_FIELD"]
}
SC_62023.is_extendable = false
SC_62023.extensions = {}
()["CS_62024_TYPE_FIELD"].name = "type"
()["CS_62024_TYPE_FIELD"].full_name = "p62.cs_62024.type"
()["CS_62024_TYPE_FIELD"].number = 1
()["CS_62024_TYPE_FIELD"].index = 0
()["CS_62024_TYPE_FIELD"].label = 2
()["CS_62024_TYPE_FIELD"].has_default_value = false
()["CS_62024_TYPE_FIELD"].default_value = 0
()["CS_62024_TYPE_FIELD"].type = 13
()["CS_62024_TYPE_FIELD"].cpp_type = 3
CS_62024.name = "cs_62024"
CS_62024.full_name = "p62.cs_62024"
CS_62024.nested_types = {}
CS_62024.enum_types = {}
CS_62024.fields = {
	()["CS_62024_TYPE_FIELD"]
}
CS_62024.is_extendable = false
CS_62024.extensions = {}
()["SC_62025_RESULT_FIELD"].name = "result"
()["SC_62025_RESULT_FIELD"].full_name = "p62.sc_62025.result"
()["SC_62025_RESULT_FIELD"].number = 1
()["SC_62025_RESULT_FIELD"].index = 0
()["SC_62025_RESULT_FIELD"].label = 2
()["SC_62025_RESULT_FIELD"].has_default_value = false
()["SC_62025_RESULT_FIELD"].default_value = 0
()["SC_62025_RESULT_FIELD"].type = 13
()["SC_62025_RESULT_FIELD"].cpp_type = 3
()["SC_62025_CAPITAL_FIELD"].name = "capital"
()["SC_62025_CAPITAL_FIELD"].full_name = "p62.sc_62025.capital"
()["SC_62025_CAPITAL_FIELD"].number = 2
()["SC_62025_CAPITAL_FIELD"].index = 1
()["SC_62025_CAPITAL_FIELD"].label = 2
()["SC_62025_CAPITAL_FIELD"].has_default_value = false
()["SC_62025_CAPITAL_FIELD"].default_value = 0
()["SC_62025_CAPITAL_FIELD"].type = 13
()["SC_62025_CAPITAL_FIELD"].cpp_type = 3
SC_62025.name = "sc_62025"
SC_62025.full_name = "p62.sc_62025"
SC_62025.nested_types = {}
SC_62025.enum_types = {}
SC_62025.fields = {
	()["SC_62025_RESULT_FIELD"],
	()["SC_62025_CAPITAL_FIELD"]
}
SC_62025.is_extendable = false
SC_62025.extensions = {}
()["CS_62029_TYPE_FIELD"].name = "type"
()["CS_62029_TYPE_FIELD"].full_name = "p62.cs_62029.type"
()["CS_62029_TYPE_FIELD"].number = 1
()["CS_62029_TYPE_FIELD"].index = 0
()["CS_62029_TYPE_FIELD"].label = 2
()["CS_62029_TYPE_FIELD"].has_default_value = false
()["CS_62029_TYPE_FIELD"].default_value = 0
()["CS_62029_TYPE_FIELD"].type = 13
()["CS_62029_TYPE_FIELD"].cpp_type = 3
CS_62029.name = "cs_62029"
CS_62029.full_name = "p62.cs_62029"
CS_62029.nested_types = {}
CS_62029.enum_types = {}
CS_62029.fields = {
	()["CS_62029_TYPE_FIELD"]
}
CS_62029.is_extendable = false
CS_62029.extensions = {}
()["SC_62030_LIST_FIELD"].name = "list"
()["SC_62030_LIST_FIELD"].full_name = "p62.sc_62030.list"
()["SC_62030_LIST_FIELD"].number = 1
()["SC_62030_LIST_FIELD"].index = 0
()["SC_62030_LIST_FIELD"].label = 3
()["SC_62030_LIST_FIELD"].has_default_value = false
()["SC_62030_LIST_FIELD"].default_value = {}
()["SC_62030_LIST_FIELD"].message_type = RANK_INFO
()["SC_62030_LIST_FIELD"].type = 11
()["SC_62030_LIST_FIELD"].cpp_type = 10
SC_62030.name = "sc_62030"
SC_62030.full_name = "p62.sc_62030"
SC_62030.nested_types = {}
SC_62030.enum_types = {}
SC_62030.fields = {
	()["SC_62030_LIST_FIELD"]
}
SC_62030.is_extendable = false
SC_62030.extensions = {}
()["SC_62031_DONATE_TASKS_FIELD"].name = "donate_tasks"
()["SC_62031_DONATE_TASKS_FIELD"].full_name = "p62.sc_62031.donate_tasks"
()["SC_62031_DONATE_TASKS_FIELD"].number = 1
()["SC_62031_DONATE_TASKS_FIELD"].index = 0
()["SC_62031_DONATE_TASKS_FIELD"].label = 3
()["SC_62031_DONATE_TASKS_FIELD"].has_default_value = false
()["SC_62031_DONATE_TASKS_FIELD"].default_value = {}
()["SC_62031_DONATE_TASKS_FIELD"].type = 13
()["SC_62031_DONATE_TASKS_FIELD"].cpp_type = 3
SC_62031.name = "sc_62031"
SC_62031.full_name = "p62.sc_62031"
SC_62031.nested_types = {}
SC_62031.enum_types = {}
SC_62031.fields = {
	()["SC_62031_DONATE_TASKS_FIELD"]
}
SC_62031.is_extendable = false
SC_62031.extensions = {}
()["CS_62100_TYPE_FIELD"].name = "type"
()["CS_62100_TYPE_FIELD"].full_name = "p62.cs_62100.type"
()["CS_62100_TYPE_FIELD"].number = 1
()["CS_62100_TYPE_FIELD"].index = 0
()["CS_62100_TYPE_FIELD"].label = 2
()["CS_62100_TYPE_FIELD"].has_default_value = false
()["CS_62100_TYPE_FIELD"].default_value = 0
()["CS_62100_TYPE_FIELD"].type = 13
()["CS_62100_TYPE_FIELD"].cpp_type = 3
CS_62100.name = "cs_62100"
CS_62100.full_name = "p62.cs_62100"
CS_62100.nested_types = {}
CS_62100.enum_types = {}
CS_62100.fields = {
	()["CS_62100_TYPE_FIELD"]
}
CS_62100.is_extendable = false
CS_62100.extensions = {}
()["SC_62101_TECHNOLOGYS_FIELD"].name = "technologys"
()["SC_62101_TECHNOLOGYS_FIELD"].full_name = "p62.sc_62101.technologys"
()["SC_62101_TECHNOLOGYS_FIELD"].number = 1
()["SC_62101_TECHNOLOGYS_FIELD"].index = 0
()["SC_62101_TECHNOLOGYS_FIELD"].label = 3
()["SC_62101_TECHNOLOGYS_FIELD"].has_default_value = false
()["SC_62101_TECHNOLOGYS_FIELD"].default_value = {}
()["SC_62101_TECHNOLOGYS_FIELD"].message_type = slot2.GUILD_TECHNOLOGY
()["SC_62101_TECHNOLOGYS_FIELD"].type = 11
()["SC_62101_TECHNOLOGYS_FIELD"].cpp_type = 10
SC_62101.name = "sc_62101"
SC_62101.full_name = "p62.sc_62101"
SC_62101.nested_types = {}
SC_62101.enum_types = {}
SC_62101.fields = {
	()["SC_62101_TECHNOLOGYS_FIELD"]
}
SC_62101.is_extendable = false
SC_62101.extensions = {}
()["RANK_INFO_PERIOD_FIELD"].name = "period"
()["RANK_INFO_PERIOD_FIELD"].full_name = "p62.rank_info.period"
()["RANK_INFO_PERIOD_FIELD"].number = 1
()["RANK_INFO_PERIOD_FIELD"].index = 0
()["RANK_INFO_PERIOD_FIELD"].label = 2
()["RANK_INFO_PERIOD_FIELD"].has_default_value = false
()["RANK_INFO_PERIOD_FIELD"].default_value = 0
()["RANK_INFO_PERIOD_FIELD"].type = 13
()["RANK_INFO_PERIOD_FIELD"].cpp_type = 3
()["RANK_INFO_RANKUSERINFO_FIELD"].name = "rankuserinfo"
()["RANK_INFO_RANKUSERINFO_FIELD"].full_name = "p62.rank_info.rankuserinfo"
()["RANK_INFO_RANKUSERINFO_FIELD"].number = 2
()["RANK_INFO_RANKUSERINFO_FIELD"].index = 1
()["RANK_INFO_RANKUSERINFO_FIELD"].label = 3
()["RANK_INFO_RANKUSERINFO_FIELD"].has_default_value = false
()["RANK_INFO_RANKUSERINFO_FIELD"].default_value = {}
()["RANK_INFO_RANKUSERINFO_FIELD"].message_type = RANK_USER_INFO
()["RANK_INFO_RANKUSERINFO_FIELD"].type = 11
()["RANK_INFO_RANKUSERINFO_FIELD"].cpp_type = 10
RANK_INFO.name = "rank_info"
RANK_INFO.full_name = "p62.rank_info"
RANK_INFO.nested_types = {}
RANK_INFO.enum_types = {}
RANK_INFO.fields = {
	()["RANK_INFO_PERIOD_FIELD"],
	()["RANK_INFO_RANKUSERINFO_FIELD"]
}
RANK_INFO.is_extendable = false
RANK_INFO.extensions = {}
()["RANK_USER_INFO_USER_ID_FIELD"].name = "user_id"
()["RANK_USER_INFO_USER_ID_FIELD"].full_name = "p62.rank_user_info.user_id"
()["RANK_USER_INFO_USER_ID_FIELD"].number = 1
()["RANK_USER_INFO_USER_ID_FIELD"].index = 0
()["RANK_USER_INFO_USER_ID_FIELD"].label = 2
()["RANK_USER_INFO_USER_ID_FIELD"].has_default_value = false
()["RANK_USER_INFO_USER_ID_FIELD"].default_value = 0
()["RANK_USER_INFO_USER_ID_FIELD"].type = 13
()["RANK_USER_INFO_USER_ID_FIELD"].cpp_type = 3
()["RANK_USER_INFO_COUNT_FIELD"].name = "count"
()["RANK_USER_INFO_COUNT_FIELD"].full_name = "p62.rank_user_info.count"
()["RANK_USER_INFO_COUNT_FIELD"].number = 2
()["RANK_USER_INFO_COUNT_FIELD"].index = 1
()["RANK_USER_INFO_COUNT_FIELD"].label = 2
()["RANK_USER_INFO_COUNT_FIELD"].has_default_value = false
()["RANK_USER_INFO_COUNT_FIELD"].default_value = 0
()["RANK_USER_INFO_COUNT_FIELD"].type = 13
()["RANK_USER_INFO_COUNT_FIELD"].cpp_type = 3
RANK_USER_INFO.name = "rank_user_info"
RANK_USER_INFO.full_name = "p62.rank_user_info"
RANK_USER_INFO.nested_types = {}
RANK_USER_INFO.enum_types = {}
RANK_USER_INFO.fields = {
	()["RANK_USER_INFO_USER_ID_FIELD"],
	()["RANK_USER_INFO_COUNT_FIELD"]
}
RANK_USER_INFO.is_extendable = false
RANK_USER_INFO.extensions = {}
cs_62002 = slot0.Message(CS_62002)
cs_62007 = slot0.Message(CS_62007)
cs_62009 = slot0.Message(CS_62009)
cs_62011 = slot0.Message(CS_62011)
cs_62013 = slot0.Message(CS_62013)
cs_62015 = slot0.Message(CS_62015)
cs_62020 = slot0.Message(CS_62020)
cs_62022 = slot0.Message(CS_62022)
cs_62024 = slot0.Message(CS_62024)
cs_62029 = slot0.Message(CS_62029)
cs_62100 = slot0.Message(CS_62100)
rank_info = slot0.Message(RANK_INFO)
rank_user_info = slot0.Message(RANK_USER_INFO)
sc_62003 = slot0.Message(SC_62003)
sc_62004 = slot0.Message(SC_62004)
sc_62005 = slot0.Message(SC_62005)
sc_62006 = slot0.Message(SC_62006)
sc_62008 = slot0.Message(SC_62008)
sc_62010 = slot0.Message(SC_62010)
sc_62012 = slot0.Message(SC_62012)
sc_62014 = slot0.Message(SC_62014)
sc_62016 = slot0.Message(SC_62016)
sc_62017 = slot0.Message(SC_62017)
sc_62018 = slot0.Message(SC_62018)
sc_62019 = slot0.Message(SC_62019)
sc_62021 = slot0.Message(SC_62021)
sc_62023 = slot0.Message(SC_62023)
sc_62025 = slot0.Message(SC_62025)
sc_62030 = slot0.Message(SC_62030)
sc_62031 = slot0.Message(SC_62031)
sc_62101 = slot0.Message(SC_62101)

return
