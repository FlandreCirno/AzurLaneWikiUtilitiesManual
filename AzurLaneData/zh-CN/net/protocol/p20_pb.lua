slot0 = require("protobuf")
slot1 = require("common_pb")

module("p20_pb")

SC_20001 = slot0.Descriptor()
SC_20002 = slot0.Descriptor()
TASK_PROGRESS = slot0.Descriptor()
SC_20003 = slot0.Descriptor()
SC_20004 = slot0.Descriptor()
CS_20005 = slot0.Descriptor()
SC_20006 = slot0.Descriptor()
CS_20007 = slot0.Descriptor()
SC_20008 = slot0.Descriptor()
TASK_ADD = slot0.Descriptor()
CS_20009 = slot0.Descriptor()
SC_20010 = slot0.Descriptor()
CS_20011 = slot0.Descriptor()
SC_20012 = slot0.Descriptor()
TASK_UPDATE = slot0.Descriptor()
SC_20101 = slot0.Descriptor()
WEEKLY_INFO = slot0.Descriptor()
SC_20102 = slot0.Descriptor()
SC_20103 = slot0.Descriptor()
SC_20104 = slot0.Descriptor()
SC_20105 = slot0.Descriptor()
CS_20106 = slot0.Descriptor()
SC_20107 = slot0.Descriptor()
CS_20108 = slot0.Descriptor()
SC_20109 = slot0.Descriptor()
CS_20110 = slot0.Descriptor()
SC_20111 = slot0.Descriptor()
WEEKLY_TASK = slot0.Descriptor()
({
	SC_20001_INFO_FIELD = slot0.FieldDescriptor(),
	SC_20002_INFO_FIELD = slot0.FieldDescriptor(),
	TASK_PROGRESS_ID_FIELD = slot0.FieldDescriptor(),
	TASK_PROGRESS_PROGRESS_FIELD = slot0.FieldDescriptor(),
	SC_20003_INFO_FIELD = slot0.FieldDescriptor(),
	SC_20004_ID_LIST_FIELD = slot0.FieldDescriptor(),
	CS_20005_ID_FIELD = slot0.FieldDescriptor(),
	CS_20005_CHOICE_AWARD_FIELD = slot0.FieldDescriptor(),
	SC_20006_RESULT_FIELD = slot0.FieldDescriptor(),
	SC_20006_AWARD_LIST_FIELD = slot0.FieldDescriptor(),
	CS_20007_ID_FIELD = slot0.FieldDescriptor(),
	SC_20008_RESULT_FIELD = slot0.FieldDescriptor(),
	SC_20008_TASK_FIELD = slot0.FieldDescriptor(),
	TASK_ADD_ID_FIELD = slot0.FieldDescriptor(),
	TASK_ADD_PROGRESS_FIELD = slot0.FieldDescriptor(),
	TASK_ADD_ACCEPT_TIME_FIELD = slot0.FieldDescriptor(),
	TASK_ADD_SUBMIT_TIME_FIELD = slot0.FieldDescriptor(),
	CS_20009_PROGRESSINFO_FIELD = slot0.FieldDescriptor(),
	SC_20010_RESULT_FIELD = slot0.FieldDescriptor(),
	CS_20011_ID_LIST_FIELD = slot0.FieldDescriptor(),
	SC_20012_ID_LIST_FIELD = slot0.FieldDescriptor(),
	SC_20012_AWARD_LIST_FIELD = slot0.FieldDescriptor(),
	TASK_UPDATE_ID_FIELD = slot0.FieldDescriptor(),
	TASK_UPDATE_MODE_FIELD = slot0.FieldDescriptor(),
	TASK_UPDATE_PROGRESS_FIELD = slot0.FieldDescriptor(),
	SC_20101_INFO_FIELD = slot0.FieldDescriptor(),
	WEEKLY_INFO_TASK_FIELD = slot0.FieldDescriptor(),
	WEEKLY_INFO_PT_FIELD = slot0.FieldDescriptor(),
	WEEKLY_INFO_REWARD_LV_FIELD = slot0.FieldDescriptor(),
	SC_20102_TASK_FIELD = slot0.FieldDescriptor(),
	SC_20103_ID_FIELD = slot0.FieldDescriptor(),
	SC_20104_ID_FIELD = slot0.FieldDescriptor(),
	SC_20105_PT_FIELD = slot0.FieldDescriptor(),
	CS_20106_ID_FIELD = slot0.FieldDescriptor(),
	SC_20107_RESULT_FIELD = slot0.FieldDescriptor(),
	SC_20107_NEXT_FIELD = slot0.FieldDescriptor(),
	CS_20108_ID_FIELD = slot0.FieldDescriptor(),
	SC_20109_RESULT_FIELD = slot0.FieldDescriptor(),
	SC_20109_PT_FIELD = slot0.FieldDescriptor(),
	SC_20109_NEXT_FIELD = slot0.FieldDescriptor(),
	CS_20110_ID_FIELD = slot0.FieldDescriptor(),
	SC_20111_RESULT_FIELD = slot0.FieldDescriptor(),
	SC_20111_AWARD_LIST_FIELD = slot0.FieldDescriptor(),
	WEEKLY_TASK_ID_FIELD = slot0.FieldDescriptor(),
	WEEKLY_TASK_PROGRESS_FIELD = slot0.FieldDescriptor()
})["SC_20001_INFO_FIELD"].name = "info"
()["SC_20001_INFO_FIELD"].full_name = "p20.sc_20001.info"
()["SC_20001_INFO_FIELD"].number = 1
()["SC_20001_INFO_FIELD"].index = 0
()["SC_20001_INFO_FIELD"].label = 3
()["SC_20001_INFO_FIELD"].has_default_value = false
()["SC_20001_INFO_FIELD"].default_value = {}
()["SC_20001_INFO_FIELD"].message_type = slot1.TASKINFO
()["SC_20001_INFO_FIELD"].type = 11
()["SC_20001_INFO_FIELD"].cpp_type = 10
SC_20001.name = "sc_20001"
SC_20001.full_name = "p20.sc_20001"
SC_20001.nested_types = {}
SC_20001.enum_types = {}
SC_20001.fields = {
	()["SC_20001_INFO_FIELD"]
}
SC_20001.is_extendable = false
SC_20001.extensions = {}
()["SC_20002_INFO_FIELD"].name = "info"
()["SC_20002_INFO_FIELD"].full_name = "p20.sc_20002.info"
()["SC_20002_INFO_FIELD"].number = 1
()["SC_20002_INFO_FIELD"].index = 0
()["SC_20002_INFO_FIELD"].label = 3
()["SC_20002_INFO_FIELD"].has_default_value = false
()["SC_20002_INFO_FIELD"].default_value = {}
()["SC_20002_INFO_FIELD"].message_type = TASK_PROGRESS
()["SC_20002_INFO_FIELD"].type = 11
()["SC_20002_INFO_FIELD"].cpp_type = 10
SC_20002.name = "sc_20002"
SC_20002.full_name = "p20.sc_20002"
SC_20002.nested_types = {}
SC_20002.enum_types = {}
SC_20002.fields = {
	()["SC_20002_INFO_FIELD"]
}
SC_20002.is_extendable = false
SC_20002.extensions = {}
()["TASK_PROGRESS_ID_FIELD"].name = "id"
()["TASK_PROGRESS_ID_FIELD"].full_name = "p20.task_progress.id"
()["TASK_PROGRESS_ID_FIELD"].number = 1
()["TASK_PROGRESS_ID_FIELD"].index = 0
()["TASK_PROGRESS_ID_FIELD"].label = 2
()["TASK_PROGRESS_ID_FIELD"].has_default_value = false
()["TASK_PROGRESS_ID_FIELD"].default_value = 0
()["TASK_PROGRESS_ID_FIELD"].type = 13
()["TASK_PROGRESS_ID_FIELD"].cpp_type = 3
()["TASK_PROGRESS_PROGRESS_FIELD"].name = "progress"
()["TASK_PROGRESS_PROGRESS_FIELD"].full_name = "p20.task_progress.progress"
()["TASK_PROGRESS_PROGRESS_FIELD"].number = 2
()["TASK_PROGRESS_PROGRESS_FIELD"].index = 1
()["TASK_PROGRESS_PROGRESS_FIELD"].label = 2
()["TASK_PROGRESS_PROGRESS_FIELD"].has_default_value = false
()["TASK_PROGRESS_PROGRESS_FIELD"].default_value = 0
()["TASK_PROGRESS_PROGRESS_FIELD"].type = 13
()["TASK_PROGRESS_PROGRESS_FIELD"].cpp_type = 3
TASK_PROGRESS.name = "task_progress"
TASK_PROGRESS.full_name = "p20.task_progress"
TASK_PROGRESS.nested_types = {}
TASK_PROGRESS.enum_types = {}
TASK_PROGRESS.fields = {
	()["TASK_PROGRESS_ID_FIELD"],
	()["TASK_PROGRESS_PROGRESS_FIELD"]
}
TASK_PROGRESS.is_extendable = false
TASK_PROGRESS.extensions = {}
()["SC_20003_INFO_FIELD"].name = "info"
()["SC_20003_INFO_FIELD"].full_name = "p20.sc_20003.info"
()["SC_20003_INFO_FIELD"].number = 1
()["SC_20003_INFO_FIELD"].index = 0
()["SC_20003_INFO_FIELD"].label = 3
()["SC_20003_INFO_FIELD"].has_default_value = false
()["SC_20003_INFO_FIELD"].default_value = {}
()["SC_20003_INFO_FIELD"].message_type = TASK_ADD
()["SC_20003_INFO_FIELD"].type = 11
()["SC_20003_INFO_FIELD"].cpp_type = 10
SC_20003.name = "sc_20003"
SC_20003.full_name = "p20.sc_20003"
SC_20003.nested_types = {}
SC_20003.enum_types = {}
SC_20003.fields = {
	()["SC_20003_INFO_FIELD"]
}
SC_20003.is_extendable = false
SC_20003.extensions = {}
()["SC_20004_ID_LIST_FIELD"].name = "id_list"
()["SC_20004_ID_LIST_FIELD"].full_name = "p20.sc_20004.id_list"
()["SC_20004_ID_LIST_FIELD"].number = 1
()["SC_20004_ID_LIST_FIELD"].index = 0
()["SC_20004_ID_LIST_FIELD"].label = 3
()["SC_20004_ID_LIST_FIELD"].has_default_value = false
()["SC_20004_ID_LIST_FIELD"].default_value = {}
()["SC_20004_ID_LIST_FIELD"].type = 13
()["SC_20004_ID_LIST_FIELD"].cpp_type = 3
SC_20004.name = "sc_20004"
SC_20004.full_name = "p20.sc_20004"
SC_20004.nested_types = {}
SC_20004.enum_types = {}
SC_20004.fields = {
	()["SC_20004_ID_LIST_FIELD"]
}
SC_20004.is_extendable = false
SC_20004.extensions = {}
()["CS_20005_ID_FIELD"].name = "id"
()["CS_20005_ID_FIELD"].full_name = "p20.cs_20005.id"
()["CS_20005_ID_FIELD"].number = 1
()["CS_20005_ID_FIELD"].index = 0
()["CS_20005_ID_FIELD"].label = 2
()["CS_20005_ID_FIELD"].has_default_value = false
()["CS_20005_ID_FIELD"].default_value = 0
()["CS_20005_ID_FIELD"].type = 13
()["CS_20005_ID_FIELD"].cpp_type = 3
()["CS_20005_CHOICE_AWARD_FIELD"].name = "choice_award"
()["CS_20005_CHOICE_AWARD_FIELD"].full_name = "p20.cs_20005.choice_award"
()["CS_20005_CHOICE_AWARD_FIELD"].number = 2
()["CS_20005_CHOICE_AWARD_FIELD"].index = 1
()["CS_20005_CHOICE_AWARD_FIELD"].label = 3
()["CS_20005_CHOICE_AWARD_FIELD"].has_default_value = false
()["CS_20005_CHOICE_AWARD_FIELD"].default_value = {}
()["CS_20005_CHOICE_AWARD_FIELD"].message_type = slot1.DROPINFO
()["CS_20005_CHOICE_AWARD_FIELD"].type = 11
()["CS_20005_CHOICE_AWARD_FIELD"].cpp_type = 10
CS_20005.name = "cs_20005"
CS_20005.full_name = "p20.cs_20005"
CS_20005.nested_types = {}
CS_20005.enum_types = {}
CS_20005.fields = {
	()["CS_20005_ID_FIELD"],
	()["CS_20005_CHOICE_AWARD_FIELD"]
}
CS_20005.is_extendable = false
CS_20005.extensions = {}
()["SC_20006_RESULT_FIELD"].name = "result"
()["SC_20006_RESULT_FIELD"].full_name = "p20.sc_20006.result"
()["SC_20006_RESULT_FIELD"].number = 1
()["SC_20006_RESULT_FIELD"].index = 0
()["SC_20006_RESULT_FIELD"].label = 2
()["SC_20006_RESULT_FIELD"].has_default_value = false
()["SC_20006_RESULT_FIELD"].default_value = 0
()["SC_20006_RESULT_FIELD"].type = 13
()["SC_20006_RESULT_FIELD"].cpp_type = 3
()["SC_20006_AWARD_LIST_FIELD"].name = "award_list"
()["SC_20006_AWARD_LIST_FIELD"].full_name = "p20.sc_20006.award_list"
()["SC_20006_AWARD_LIST_FIELD"].number = 2
()["SC_20006_AWARD_LIST_FIELD"].index = 1
()["SC_20006_AWARD_LIST_FIELD"].label = 3
()["SC_20006_AWARD_LIST_FIELD"].has_default_value = false
()["SC_20006_AWARD_LIST_FIELD"].default_value = {}
()["SC_20006_AWARD_LIST_FIELD"].message_type = slot1.DROPINFO
()["SC_20006_AWARD_LIST_FIELD"].type = 11
()["SC_20006_AWARD_LIST_FIELD"].cpp_type = 10
SC_20006.name = "sc_20006"
SC_20006.full_name = "p20.sc_20006"
SC_20006.nested_types = {}
SC_20006.enum_types = {}
SC_20006.fields = {
	()["SC_20006_RESULT_FIELD"],
	()["SC_20006_AWARD_LIST_FIELD"]
}
SC_20006.is_extendable = false
SC_20006.extensions = {}
()["CS_20007_ID_FIELD"].name = "id"
()["CS_20007_ID_FIELD"].full_name = "p20.cs_20007.id"
()["CS_20007_ID_FIELD"].number = 1
()["CS_20007_ID_FIELD"].index = 0
()["CS_20007_ID_FIELD"].label = 2
()["CS_20007_ID_FIELD"].has_default_value = false
()["CS_20007_ID_FIELD"].default_value = 0
()["CS_20007_ID_FIELD"].type = 13
()["CS_20007_ID_FIELD"].cpp_type = 3
CS_20007.name = "cs_20007"
CS_20007.full_name = "p20.cs_20007"
CS_20007.nested_types = {}
CS_20007.enum_types = {}
CS_20007.fields = {
	()["CS_20007_ID_FIELD"]
}
CS_20007.is_extendable = false
CS_20007.extensions = {}
()["SC_20008_RESULT_FIELD"].name = "result"
()["SC_20008_RESULT_FIELD"].full_name = "p20.sc_20008.result"
()["SC_20008_RESULT_FIELD"].number = 1
()["SC_20008_RESULT_FIELD"].index = 0
()["SC_20008_RESULT_FIELD"].label = 2
()["SC_20008_RESULT_FIELD"].has_default_value = false
()["SC_20008_RESULT_FIELD"].default_value = 0
()["SC_20008_RESULT_FIELD"].type = 13
()["SC_20008_RESULT_FIELD"].cpp_type = 3
()["SC_20008_TASK_FIELD"].name = "task"
()["SC_20008_TASK_FIELD"].full_name = "p20.sc_20008.task"
()["SC_20008_TASK_FIELD"].number = 2
()["SC_20008_TASK_FIELD"].index = 1
()["SC_20008_TASK_FIELD"].label = 1
()["SC_20008_TASK_FIELD"].has_default_value = false
()["SC_20008_TASK_FIELD"].default_value = nil
()["SC_20008_TASK_FIELD"].message_type = TASK_ADD
()["SC_20008_TASK_FIELD"].type = 11
()["SC_20008_TASK_FIELD"].cpp_type = 10
SC_20008.name = "sc_20008"
SC_20008.full_name = "p20.sc_20008"
SC_20008.nested_types = {}
SC_20008.enum_types = {}
SC_20008.fields = {
	()["SC_20008_RESULT_FIELD"],
	()["SC_20008_TASK_FIELD"]
}
SC_20008.is_extendable = false
SC_20008.extensions = {}
()["TASK_ADD_ID_FIELD"].name = "id"
()["TASK_ADD_ID_FIELD"].full_name = "p20.task_add.id"
()["TASK_ADD_ID_FIELD"].number = 1
()["TASK_ADD_ID_FIELD"].index = 0
()["TASK_ADD_ID_FIELD"].label = 2
()["TASK_ADD_ID_FIELD"].has_default_value = false
()["TASK_ADD_ID_FIELD"].default_value = 0
()["TASK_ADD_ID_FIELD"].type = 13
()["TASK_ADD_ID_FIELD"].cpp_type = 3
()["TASK_ADD_PROGRESS_FIELD"].name = "progress"
()["TASK_ADD_PROGRESS_FIELD"].full_name = "p20.task_add.progress"
()["TASK_ADD_PROGRESS_FIELD"].number = 2
()["TASK_ADD_PROGRESS_FIELD"].index = 1
()["TASK_ADD_PROGRESS_FIELD"].label = 2
()["TASK_ADD_PROGRESS_FIELD"].has_default_value = false
()["TASK_ADD_PROGRESS_FIELD"].default_value = 0
()["TASK_ADD_PROGRESS_FIELD"].type = 13
()["TASK_ADD_PROGRESS_FIELD"].cpp_type = 3
()["TASK_ADD_ACCEPT_TIME_FIELD"].name = "accept_time"
()["TASK_ADD_ACCEPT_TIME_FIELD"].full_name = "p20.task_add.accept_time"
()["TASK_ADD_ACCEPT_TIME_FIELD"].number = 3
()["TASK_ADD_ACCEPT_TIME_FIELD"].index = 2
()["TASK_ADD_ACCEPT_TIME_FIELD"].label = 2
()["TASK_ADD_ACCEPT_TIME_FIELD"].has_default_value = false
()["TASK_ADD_ACCEPT_TIME_FIELD"].default_value = 0
()["TASK_ADD_ACCEPT_TIME_FIELD"].type = 13
()["TASK_ADD_ACCEPT_TIME_FIELD"].cpp_type = 3
()["TASK_ADD_SUBMIT_TIME_FIELD"].name = "submit_time"
()["TASK_ADD_SUBMIT_TIME_FIELD"].full_name = "p20.task_add.submit_time"
()["TASK_ADD_SUBMIT_TIME_FIELD"].number = 4
()["TASK_ADD_SUBMIT_TIME_FIELD"].index = 3
()["TASK_ADD_SUBMIT_TIME_FIELD"].label = 1
()["TASK_ADD_SUBMIT_TIME_FIELD"].has_default_value = false
()["TASK_ADD_SUBMIT_TIME_FIELD"].default_value = 0
()["TASK_ADD_SUBMIT_TIME_FIELD"].type = 13
()["TASK_ADD_SUBMIT_TIME_FIELD"].cpp_type = 3
TASK_ADD.name = "task_add"
TASK_ADD.full_name = "p20.task_add"
TASK_ADD.nested_types = {}
TASK_ADD.enum_types = {}
TASK_ADD.fields = {
	()["TASK_ADD_ID_FIELD"],
	()["TASK_ADD_PROGRESS_FIELD"],
	()["TASK_ADD_ACCEPT_TIME_FIELD"],
	()["TASK_ADD_SUBMIT_TIME_FIELD"]
}
TASK_ADD.is_extendable = false
TASK_ADD.extensions = {}
()["CS_20009_PROGRESSINFO_FIELD"].name = "progressinfo"
()["CS_20009_PROGRESSINFO_FIELD"].full_name = "p20.cs_20009.progressinfo"
()["CS_20009_PROGRESSINFO_FIELD"].number = 1
()["CS_20009_PROGRESSINFO_FIELD"].index = 0
()["CS_20009_PROGRESSINFO_FIELD"].label = 3
()["CS_20009_PROGRESSINFO_FIELD"].has_default_value = false
()["CS_20009_PROGRESSINFO_FIELD"].default_value = {}
()["CS_20009_PROGRESSINFO_FIELD"].message_type = TASK_UPDATE
()["CS_20009_PROGRESSINFO_FIELD"].type = 11
()["CS_20009_PROGRESSINFO_FIELD"].cpp_type = 10
CS_20009.name = "cs_20009"
CS_20009.full_name = "p20.cs_20009"
CS_20009.nested_types = {}
CS_20009.enum_types = {}
CS_20009.fields = {
	()["CS_20009_PROGRESSINFO_FIELD"]
}
CS_20009.is_extendable = false
CS_20009.extensions = {}
()["SC_20010_RESULT_FIELD"].name = "result"
()["SC_20010_RESULT_FIELD"].full_name = "p20.sc_20010.result"
()["SC_20010_RESULT_FIELD"].number = 1
()["SC_20010_RESULT_FIELD"].index = 0
()["SC_20010_RESULT_FIELD"].label = 2
()["SC_20010_RESULT_FIELD"].has_default_value = false
()["SC_20010_RESULT_FIELD"].default_value = 0
()["SC_20010_RESULT_FIELD"].type = 13
()["SC_20010_RESULT_FIELD"].cpp_type = 3
SC_20010.name = "sc_20010"
SC_20010.full_name = "p20.sc_20010"
SC_20010.nested_types = {}
SC_20010.enum_types = {}
SC_20010.fields = {
	()["SC_20010_RESULT_FIELD"]
}
SC_20010.is_extendable = false
SC_20010.extensions = {}
()["CS_20011_ID_LIST_FIELD"].name = "id_list"
()["CS_20011_ID_LIST_FIELD"].full_name = "p20.cs_20011.id_list"
()["CS_20011_ID_LIST_FIELD"].number = 1
()["CS_20011_ID_LIST_FIELD"].index = 0
()["CS_20011_ID_LIST_FIELD"].label = 3
()["CS_20011_ID_LIST_FIELD"].has_default_value = false
()["CS_20011_ID_LIST_FIELD"].default_value = {}
()["CS_20011_ID_LIST_FIELD"].type = 13
()["CS_20011_ID_LIST_FIELD"].cpp_type = 3
CS_20011.name = "cs_20011"
CS_20011.full_name = "p20.cs_20011"
CS_20011.nested_types = {}
CS_20011.enum_types = {}
CS_20011.fields = {
	()["CS_20011_ID_LIST_FIELD"]
}
CS_20011.is_extendable = false
CS_20011.extensions = {}
()["SC_20012_ID_LIST_FIELD"].name = "id_list"
()["SC_20012_ID_LIST_FIELD"].full_name = "p20.sc_20012.id_list"
()["SC_20012_ID_LIST_FIELD"].number = 1
()["SC_20012_ID_LIST_FIELD"].index = 0
()["SC_20012_ID_LIST_FIELD"].label = 3
()["SC_20012_ID_LIST_FIELD"].has_default_value = false
()["SC_20012_ID_LIST_FIELD"].default_value = {}
()["SC_20012_ID_LIST_FIELD"].type = 13
()["SC_20012_ID_LIST_FIELD"].cpp_type = 3
()["SC_20012_AWARD_LIST_FIELD"].name = "award_list"
()["SC_20012_AWARD_LIST_FIELD"].full_name = "p20.sc_20012.award_list"
()["SC_20012_AWARD_LIST_FIELD"].number = 2
()["SC_20012_AWARD_LIST_FIELD"].index = 1
()["SC_20012_AWARD_LIST_FIELD"].label = 3
()["SC_20012_AWARD_LIST_FIELD"].has_default_value = false
()["SC_20012_AWARD_LIST_FIELD"].default_value = {}
()["SC_20012_AWARD_LIST_FIELD"].message_type = slot1.DROPINFO
()["SC_20012_AWARD_LIST_FIELD"].type = 11
()["SC_20012_AWARD_LIST_FIELD"].cpp_type = 10
SC_20012.name = "sc_20012"
SC_20012.full_name = "p20.sc_20012"
SC_20012.nested_types = {}
SC_20012.enum_types = {}
SC_20012.fields = {
	()["SC_20012_ID_LIST_FIELD"],
	()["SC_20012_AWARD_LIST_FIELD"]
}
SC_20012.is_extendable = false
SC_20012.extensions = {}
()["TASK_UPDATE_ID_FIELD"].name = "id"
()["TASK_UPDATE_ID_FIELD"].full_name = "p20.task_update.id"
()["TASK_UPDATE_ID_FIELD"].number = 1
()["TASK_UPDATE_ID_FIELD"].index = 0
()["TASK_UPDATE_ID_FIELD"].label = 2
()["TASK_UPDATE_ID_FIELD"].has_default_value = false
()["TASK_UPDATE_ID_FIELD"].default_value = 0
()["TASK_UPDATE_ID_FIELD"].type = 13
()["TASK_UPDATE_ID_FIELD"].cpp_type = 3
()["TASK_UPDATE_MODE_FIELD"].name = "mode"
()["TASK_UPDATE_MODE_FIELD"].full_name = "p20.task_update.mode"
()["TASK_UPDATE_MODE_FIELD"].number = 2
()["TASK_UPDATE_MODE_FIELD"].index = 1
()["TASK_UPDATE_MODE_FIELD"].label = 2
()["TASK_UPDATE_MODE_FIELD"].has_default_value = false
()["TASK_UPDATE_MODE_FIELD"].default_value = 0
()["TASK_UPDATE_MODE_FIELD"].type = 13
()["TASK_UPDATE_MODE_FIELD"].cpp_type = 3
()["TASK_UPDATE_PROGRESS_FIELD"].name = "progress"
()["TASK_UPDATE_PROGRESS_FIELD"].full_name = "p20.task_update.progress"
()["TASK_UPDATE_PROGRESS_FIELD"].number = 3
()["TASK_UPDATE_PROGRESS_FIELD"].index = 2
()["TASK_UPDATE_PROGRESS_FIELD"].label = 2
()["TASK_UPDATE_PROGRESS_FIELD"].has_default_value = false
()["TASK_UPDATE_PROGRESS_FIELD"].default_value = 0
()["TASK_UPDATE_PROGRESS_FIELD"].type = 13
()["TASK_UPDATE_PROGRESS_FIELD"].cpp_type = 3
TASK_UPDATE.name = "task_update"
TASK_UPDATE.full_name = "p20.task_update"
TASK_UPDATE.nested_types = {}
TASK_UPDATE.enum_types = {}
TASK_UPDATE.fields = {
	()["TASK_UPDATE_ID_FIELD"],
	()["TASK_UPDATE_MODE_FIELD"],
	()["TASK_UPDATE_PROGRESS_FIELD"]
}
TASK_UPDATE.is_extendable = false
TASK_UPDATE.extensions = {}
()["SC_20101_INFO_FIELD"].name = "info"
()["SC_20101_INFO_FIELD"].full_name = "p20.sc_20101.info"
()["SC_20101_INFO_FIELD"].number = 1
()["SC_20101_INFO_FIELD"].index = 0
()["SC_20101_INFO_FIELD"].label = 2
()["SC_20101_INFO_FIELD"].has_default_value = false
()["SC_20101_INFO_FIELD"].default_value = nil
()["SC_20101_INFO_FIELD"].message_type = WEEKLY_INFO
()["SC_20101_INFO_FIELD"].type = 11
()["SC_20101_INFO_FIELD"].cpp_type = 10
SC_20101.name = "sc_20101"
SC_20101.full_name = "p20.sc_20101"
SC_20101.nested_types = {}
SC_20101.enum_types = {}
SC_20101.fields = {
	()["SC_20101_INFO_FIELD"]
}
SC_20101.is_extendable = false
SC_20101.extensions = {}
()["WEEKLY_INFO_TASK_FIELD"].name = "task"
()["WEEKLY_INFO_TASK_FIELD"].full_name = "p20.weekly_info.task"
()["WEEKLY_INFO_TASK_FIELD"].number = 1
()["WEEKLY_INFO_TASK_FIELD"].index = 0
()["WEEKLY_INFO_TASK_FIELD"].label = 3
()["WEEKLY_INFO_TASK_FIELD"].has_default_value = false
()["WEEKLY_INFO_TASK_FIELD"].default_value = {}
()["WEEKLY_INFO_TASK_FIELD"].message_type = WEEKLY_TASK
()["WEEKLY_INFO_TASK_FIELD"].type = 11
()["WEEKLY_INFO_TASK_FIELD"].cpp_type = 10
()["WEEKLY_INFO_PT_FIELD"].name = "pt"
()["WEEKLY_INFO_PT_FIELD"].full_name = "p20.weekly_info.pt"
()["WEEKLY_INFO_PT_FIELD"].number = 2
()["WEEKLY_INFO_PT_FIELD"].index = 1
()["WEEKLY_INFO_PT_FIELD"].label = 2
()["WEEKLY_INFO_PT_FIELD"].has_default_value = false
()["WEEKLY_INFO_PT_FIELD"].default_value = 0
()["WEEKLY_INFO_PT_FIELD"].type = 13
()["WEEKLY_INFO_PT_FIELD"].cpp_type = 3
()["WEEKLY_INFO_REWARD_LV_FIELD"].name = "reward_lv"
()["WEEKLY_INFO_REWARD_LV_FIELD"].full_name = "p20.weekly_info.reward_lv"
()["WEEKLY_INFO_REWARD_LV_FIELD"].number = 3
()["WEEKLY_INFO_REWARD_LV_FIELD"].index = 2
()["WEEKLY_INFO_REWARD_LV_FIELD"].label = 2
()["WEEKLY_INFO_REWARD_LV_FIELD"].has_default_value = false
()["WEEKLY_INFO_REWARD_LV_FIELD"].default_value = 0
()["WEEKLY_INFO_REWARD_LV_FIELD"].type = 13
()["WEEKLY_INFO_REWARD_LV_FIELD"].cpp_type = 3
WEEKLY_INFO.name = "weekly_info"
WEEKLY_INFO.full_name = "p20.weekly_info"
WEEKLY_INFO.nested_types = {}
WEEKLY_INFO.enum_types = {}
WEEKLY_INFO.fields = {
	()["WEEKLY_INFO_TASK_FIELD"],
	()["WEEKLY_INFO_PT_FIELD"],
	()["WEEKLY_INFO_REWARD_LV_FIELD"]
}
WEEKLY_INFO.is_extendable = false
WEEKLY_INFO.extensions = {}
()["SC_20102_TASK_FIELD"].name = "task"
()["SC_20102_TASK_FIELD"].full_name = "p20.sc_20102.task"
()["SC_20102_TASK_FIELD"].number = 1
()["SC_20102_TASK_FIELD"].index = 0
()["SC_20102_TASK_FIELD"].label = 3
()["SC_20102_TASK_FIELD"].has_default_value = false
()["SC_20102_TASK_FIELD"].default_value = {}
()["SC_20102_TASK_FIELD"].message_type = WEEKLY_TASK
()["SC_20102_TASK_FIELD"].type = 11
()["SC_20102_TASK_FIELD"].cpp_type = 10
SC_20102.name = "sc_20102"
SC_20102.full_name = "p20.sc_20102"
SC_20102.nested_types = {}
SC_20102.enum_types = {}
SC_20102.fields = {
	()["SC_20102_TASK_FIELD"]
}
SC_20102.is_extendable = false
SC_20102.extensions = {}
()["SC_20103_ID_FIELD"].name = "id"
()["SC_20103_ID_FIELD"].full_name = "p20.sc_20103.id"
()["SC_20103_ID_FIELD"].number = 1
()["SC_20103_ID_FIELD"].index = 0
()["SC_20103_ID_FIELD"].label = 3
()["SC_20103_ID_FIELD"].has_default_value = false
()["SC_20103_ID_FIELD"].default_value = {}
()["SC_20103_ID_FIELD"].type = 13
()["SC_20103_ID_FIELD"].cpp_type = 3
SC_20103.name = "sc_20103"
SC_20103.full_name = "p20.sc_20103"
SC_20103.nested_types = {}
SC_20103.enum_types = {}
SC_20103.fields = {
	()["SC_20103_ID_FIELD"]
}
SC_20103.is_extendable = false
SC_20103.extensions = {}
()["SC_20104_ID_FIELD"].name = "id"
()["SC_20104_ID_FIELD"].full_name = "p20.sc_20104.id"
()["SC_20104_ID_FIELD"].number = 1
()["SC_20104_ID_FIELD"].index = 0
()["SC_20104_ID_FIELD"].label = 3
()["SC_20104_ID_FIELD"].has_default_value = false
()["SC_20104_ID_FIELD"].default_value = {}
()["SC_20104_ID_FIELD"].type = 13
()["SC_20104_ID_FIELD"].cpp_type = 3
SC_20104.name = "sc_20104"
SC_20104.full_name = "p20.sc_20104"
SC_20104.nested_types = {}
SC_20104.enum_types = {}
SC_20104.fields = {
	()["SC_20104_ID_FIELD"]
}
SC_20104.is_extendable = false
SC_20104.extensions = {}
()["SC_20105_PT_FIELD"].name = "pt"
()["SC_20105_PT_FIELD"].full_name = "p20.sc_20105.pt"
()["SC_20105_PT_FIELD"].number = 1
()["SC_20105_PT_FIELD"].index = 0
()["SC_20105_PT_FIELD"].label = 2
()["SC_20105_PT_FIELD"].has_default_value = false
()["SC_20105_PT_FIELD"].default_value = 0
()["SC_20105_PT_FIELD"].type = 13
()["SC_20105_PT_FIELD"].cpp_type = 3
SC_20105.name = "sc_20105"
SC_20105.full_name = "p20.sc_20105"
SC_20105.nested_types = {}
SC_20105.enum_types = {}
SC_20105.fields = {
	()["SC_20105_PT_FIELD"]
}
SC_20105.is_extendable = false
SC_20105.extensions = {}
()["CS_20106_ID_FIELD"].name = "id"
()["CS_20106_ID_FIELD"].full_name = "p20.cs_20106.id"
()["CS_20106_ID_FIELD"].number = 1
()["CS_20106_ID_FIELD"].index = 0
()["CS_20106_ID_FIELD"].label = 2
()["CS_20106_ID_FIELD"].has_default_value = false
()["CS_20106_ID_FIELD"].default_value = 0
()["CS_20106_ID_FIELD"].type = 13
()["CS_20106_ID_FIELD"].cpp_type = 3
CS_20106.name = "cs_20106"
CS_20106.full_name = "p20.cs_20106"
CS_20106.nested_types = {}
CS_20106.enum_types = {}
CS_20106.fields = {
	()["CS_20106_ID_FIELD"]
}
CS_20106.is_extendable = false
CS_20106.extensions = {}
()["SC_20107_RESULT_FIELD"].name = "result"
()["SC_20107_RESULT_FIELD"].full_name = "p20.sc_20107.result"
()["SC_20107_RESULT_FIELD"].number = 1
()["SC_20107_RESULT_FIELD"].index = 0
()["SC_20107_RESULT_FIELD"].label = 2
()["SC_20107_RESULT_FIELD"].has_default_value = false
()["SC_20107_RESULT_FIELD"].default_value = 0
()["SC_20107_RESULT_FIELD"].type = 13
()["SC_20107_RESULT_FIELD"].cpp_type = 3
()["SC_20107_NEXT_FIELD"].name = "next"
()["SC_20107_NEXT_FIELD"].full_name = "p20.sc_20107.next"
()["SC_20107_NEXT_FIELD"].number = 2
()["SC_20107_NEXT_FIELD"].index = 1
()["SC_20107_NEXT_FIELD"].label = 1
()["SC_20107_NEXT_FIELD"].has_default_value = false
()["SC_20107_NEXT_FIELD"].default_value = nil
()["SC_20107_NEXT_FIELD"].message_type = WEEKLY_TASK
()["SC_20107_NEXT_FIELD"].type = 11
()["SC_20107_NEXT_FIELD"].cpp_type = 10
SC_20107.name = "sc_20107"
SC_20107.full_name = "p20.sc_20107"
SC_20107.nested_types = {}
SC_20107.enum_types = {}
SC_20107.fields = {
	()["SC_20107_RESULT_FIELD"],
	()["SC_20107_NEXT_FIELD"]
}
SC_20107.is_extendable = false
SC_20107.extensions = {}
()["CS_20108_ID_FIELD"].name = "id"
()["CS_20108_ID_FIELD"].full_name = "p20.cs_20108.id"
()["CS_20108_ID_FIELD"].number = 1
()["CS_20108_ID_FIELD"].index = 0
()["CS_20108_ID_FIELD"].label = 3
()["CS_20108_ID_FIELD"].has_default_value = false
()["CS_20108_ID_FIELD"].default_value = {}
()["CS_20108_ID_FIELD"].type = 13
()["CS_20108_ID_FIELD"].cpp_type = 3
CS_20108.name = "cs_20108"
CS_20108.full_name = "p20.cs_20108"
CS_20108.nested_types = {}
CS_20108.enum_types = {}
CS_20108.fields = {
	()["CS_20108_ID_FIELD"]
}
CS_20108.is_extendable = false
CS_20108.extensions = {}
()["SC_20109_RESULT_FIELD"].name = "result"
()["SC_20109_RESULT_FIELD"].full_name = "p20.sc_20109.result"
()["SC_20109_RESULT_FIELD"].number = 1
()["SC_20109_RESULT_FIELD"].index = 0
()["SC_20109_RESULT_FIELD"].label = 2
()["SC_20109_RESULT_FIELD"].has_default_value = false
()["SC_20109_RESULT_FIELD"].default_value = 0
()["SC_20109_RESULT_FIELD"].type = 13
()["SC_20109_RESULT_FIELD"].cpp_type = 3
()["SC_20109_PT_FIELD"].name = "pt"
()["SC_20109_PT_FIELD"].full_name = "p20.sc_20109.pt"
()["SC_20109_PT_FIELD"].number = 2
()["SC_20109_PT_FIELD"].index = 1
()["SC_20109_PT_FIELD"].label = 2
()["SC_20109_PT_FIELD"].has_default_value = false
()["SC_20109_PT_FIELD"].default_value = 0
()["SC_20109_PT_FIELD"].type = 13
()["SC_20109_PT_FIELD"].cpp_type = 3
()["SC_20109_NEXT_FIELD"].name = "next"
()["SC_20109_NEXT_FIELD"].full_name = "p20.sc_20109.next"
()["SC_20109_NEXT_FIELD"].number = 3
()["SC_20109_NEXT_FIELD"].index = 2
()["SC_20109_NEXT_FIELD"].label = 3
()["SC_20109_NEXT_FIELD"].has_default_value = false
()["SC_20109_NEXT_FIELD"].default_value = {}
()["SC_20109_NEXT_FIELD"].message_type = WEEKLY_TASK
()["SC_20109_NEXT_FIELD"].type = 11
()["SC_20109_NEXT_FIELD"].cpp_type = 10
SC_20109.name = "sc_20109"
SC_20109.full_name = "p20.sc_20109"
SC_20109.nested_types = {}
SC_20109.enum_types = {}
SC_20109.fields = {
	()["SC_20109_RESULT_FIELD"],
	()["SC_20109_PT_FIELD"],
	()["SC_20109_NEXT_FIELD"]
}
SC_20109.is_extendable = false
SC_20109.extensions = {}
()["CS_20110_ID_FIELD"].name = "id"
()["CS_20110_ID_FIELD"].full_name = "p20.cs_20110.id"
()["CS_20110_ID_FIELD"].number = 1
()["CS_20110_ID_FIELD"].index = 0
()["CS_20110_ID_FIELD"].label = 2
()["CS_20110_ID_FIELD"].has_default_value = false
()["CS_20110_ID_FIELD"].default_value = 0
()["CS_20110_ID_FIELD"].type = 13
()["CS_20110_ID_FIELD"].cpp_type = 3
CS_20110.name = "cs_20110"
CS_20110.full_name = "p20.cs_20110"
CS_20110.nested_types = {}
CS_20110.enum_types = {}
CS_20110.fields = {
	()["CS_20110_ID_FIELD"]
}
CS_20110.is_extendable = false
CS_20110.extensions = {}
()["SC_20111_RESULT_FIELD"].name = "result"
()["SC_20111_RESULT_FIELD"].full_name = "p20.sc_20111.result"
()["SC_20111_RESULT_FIELD"].number = 1
()["SC_20111_RESULT_FIELD"].index = 0
()["SC_20111_RESULT_FIELD"].label = 2
()["SC_20111_RESULT_FIELD"].has_default_value = false
()["SC_20111_RESULT_FIELD"].default_value = 0
()["SC_20111_RESULT_FIELD"].type = 13
()["SC_20111_RESULT_FIELD"].cpp_type = 3
()["SC_20111_AWARD_LIST_FIELD"].name = "award_list"
()["SC_20111_AWARD_LIST_FIELD"].full_name = "p20.sc_20111.award_list"
()["SC_20111_AWARD_LIST_FIELD"].number = 2
()["SC_20111_AWARD_LIST_FIELD"].index = 1
()["SC_20111_AWARD_LIST_FIELD"].label = 3
()["SC_20111_AWARD_LIST_FIELD"].has_default_value = false
()["SC_20111_AWARD_LIST_FIELD"].default_value = {}
()["SC_20111_AWARD_LIST_FIELD"].message_type = slot1.DROPINFO
()["SC_20111_AWARD_LIST_FIELD"].type = 11
()["SC_20111_AWARD_LIST_FIELD"].cpp_type = 10
SC_20111.name = "sc_20111"
SC_20111.full_name = "p20.sc_20111"
SC_20111.nested_types = {}
SC_20111.enum_types = {}
SC_20111.fields = {
	()["SC_20111_RESULT_FIELD"],
	()["SC_20111_AWARD_LIST_FIELD"]
}
SC_20111.is_extendable = false
SC_20111.extensions = {}
()["WEEKLY_TASK_ID_FIELD"].name = "id"
()["WEEKLY_TASK_ID_FIELD"].full_name = "p20.weekly_task.id"
()["WEEKLY_TASK_ID_FIELD"].number = 1
()["WEEKLY_TASK_ID_FIELD"].index = 0
()["WEEKLY_TASK_ID_FIELD"].label = 2
()["WEEKLY_TASK_ID_FIELD"].has_default_value = false
()["WEEKLY_TASK_ID_FIELD"].default_value = 0
()["WEEKLY_TASK_ID_FIELD"].type = 13
()["WEEKLY_TASK_ID_FIELD"].cpp_type = 3
()["WEEKLY_TASK_PROGRESS_FIELD"].name = "progress"
()["WEEKLY_TASK_PROGRESS_FIELD"].full_name = "p20.weekly_task.progress"
()["WEEKLY_TASK_PROGRESS_FIELD"].number = 2
()["WEEKLY_TASK_PROGRESS_FIELD"].index = 1
()["WEEKLY_TASK_PROGRESS_FIELD"].label = 2
()["WEEKLY_TASK_PROGRESS_FIELD"].has_default_value = false
()["WEEKLY_TASK_PROGRESS_FIELD"].default_value = 0
()["WEEKLY_TASK_PROGRESS_FIELD"].type = 13
()["WEEKLY_TASK_PROGRESS_FIELD"].cpp_type = 3
WEEKLY_TASK.name = "weekly_task"
WEEKLY_TASK.full_name = "p20.weekly_task"
WEEKLY_TASK.nested_types = {}
WEEKLY_TASK.enum_types = {}
WEEKLY_TASK.fields = {
	()["WEEKLY_TASK_ID_FIELD"],
	()["WEEKLY_TASK_PROGRESS_FIELD"]
}
WEEKLY_TASK.is_extendable = false
WEEKLY_TASK.extensions = {}
cs_20005 = slot0.Message(CS_20005)
cs_20007 = slot0.Message(CS_20007)
cs_20009 = slot0.Message(CS_20009)
cs_20011 = slot0.Message(CS_20011)
cs_20106 = slot0.Message(CS_20106)
cs_20108 = slot0.Message(CS_20108)
cs_20110 = slot0.Message(CS_20110)
sc_20001 = slot0.Message(SC_20001)
sc_20002 = slot0.Message(SC_20002)
sc_20003 = slot0.Message(SC_20003)
sc_20004 = slot0.Message(SC_20004)
sc_20006 = slot0.Message(SC_20006)
sc_20008 = slot0.Message(SC_20008)
sc_20010 = slot0.Message(SC_20010)
sc_20012 = slot0.Message(SC_20012)
sc_20101 = slot0.Message(SC_20101)
sc_20102 = slot0.Message(SC_20102)
sc_20103 = slot0.Message(SC_20103)
sc_20104 = slot0.Message(SC_20104)
sc_20105 = slot0.Message(SC_20105)
sc_20107 = slot0.Message(SC_20107)
sc_20109 = slot0.Message(SC_20109)
sc_20111 = slot0.Message(SC_20111)
task_add = slot0.Message(TASK_ADD)
task_progress = slot0.Message(TASK_PROGRESS)
task_update = slot0.Message(TASK_UPDATE)
weekly_info = slot0.Message(WEEKLY_INFO)
weekly_task = slot0.Message(WEEKLY_TASK)

return
