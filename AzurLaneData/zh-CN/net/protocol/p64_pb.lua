slot0 = require("protobuf")
slot1 = require("common_pb")

module("p64_pb")

SC_64000 = slot0.Descriptor()
CS_64001 = slot0.Descriptor()
SC_64002 = slot0.Descriptor()
CS_64003 = slot0.Descriptor()
SC_64004 = slot0.Descriptor()
FLEETTECH = slot0.Descriptor()
({
	SC_64000_TECH_LIST_FIELD = slot0.FieldDescriptor(),
	CS_64001_TECH_GROUP_ID_FIELD = slot0.FieldDescriptor(),
	CS_64001_TECH_ID_FIELD = slot0.FieldDescriptor(),
	SC_64002_RESULT_FIELD = slot0.FieldDescriptor(),
	CS_64003_TECH_GROUP_ID_FIELD = slot0.FieldDescriptor(),
	SC_64004_RESULT_FIELD = slot0.FieldDescriptor(),
	FLEETTECH_GROUP_ID_FIELD = slot0.FieldDescriptor(),
	FLEETTECH_EFFECT_TECH_ID_FIELD = slot0.FieldDescriptor(),
	FLEETTECH_STUDY_TECH_ID_FIELD = slot0.FieldDescriptor(),
	FLEETTECH_STUDY_FINISH_TIME_FIELD = slot0.FieldDescriptor()
})["SC_64000_TECH_LIST_FIELD"].name = "tech_list"
()["SC_64000_TECH_LIST_FIELD"].full_name = "p64.sc_64000.tech_list"
()["SC_64000_TECH_LIST_FIELD"].number = 1
()["SC_64000_TECH_LIST_FIELD"].index = 0
()["SC_64000_TECH_LIST_FIELD"].label = 3
()["SC_64000_TECH_LIST_FIELD"].has_default_value = false
()["SC_64000_TECH_LIST_FIELD"].default_value = {}
()["SC_64000_TECH_LIST_FIELD"].message_type = FLEETTECH
()["SC_64000_TECH_LIST_FIELD"].type = 11
()["SC_64000_TECH_LIST_FIELD"].cpp_type = 10
SC_64000.name = "sc_64000"
SC_64000.full_name = "p64.sc_64000"
SC_64000.nested_types = {}
SC_64000.enum_types = {}
SC_64000.fields = {
	()["SC_64000_TECH_LIST_FIELD"]
}
SC_64000.is_extendable = false
SC_64000.extensions = {}
()["CS_64001_TECH_GROUP_ID_FIELD"].name = "tech_group_id"
()["CS_64001_TECH_GROUP_ID_FIELD"].full_name = "p64.cs_64001.tech_group_id"
()["CS_64001_TECH_GROUP_ID_FIELD"].number = 1
()["CS_64001_TECH_GROUP_ID_FIELD"].index = 0
()["CS_64001_TECH_GROUP_ID_FIELD"].label = 2
()["CS_64001_TECH_GROUP_ID_FIELD"].has_default_value = false
()["CS_64001_TECH_GROUP_ID_FIELD"].default_value = 0
()["CS_64001_TECH_GROUP_ID_FIELD"].type = 13
()["CS_64001_TECH_GROUP_ID_FIELD"].cpp_type = 3
()["CS_64001_TECH_ID_FIELD"].name = "tech_id"
()["CS_64001_TECH_ID_FIELD"].full_name = "p64.cs_64001.tech_id"
()["CS_64001_TECH_ID_FIELD"].number = 2
()["CS_64001_TECH_ID_FIELD"].index = 1
()["CS_64001_TECH_ID_FIELD"].label = 2
()["CS_64001_TECH_ID_FIELD"].has_default_value = false
()["CS_64001_TECH_ID_FIELD"].default_value = 0
()["CS_64001_TECH_ID_FIELD"].type = 13
()["CS_64001_TECH_ID_FIELD"].cpp_type = 3
CS_64001.name = "cs_64001"
CS_64001.full_name = "p64.cs_64001"
CS_64001.nested_types = {}
CS_64001.enum_types = {}
CS_64001.fields = {
	()["CS_64001_TECH_GROUP_ID_FIELD"],
	()["CS_64001_TECH_ID_FIELD"]
}
CS_64001.is_extendable = false
CS_64001.extensions = {}
()["SC_64002_RESULT_FIELD"].name = "result"
()["SC_64002_RESULT_FIELD"].full_name = "p64.sc_64002.result"
()["SC_64002_RESULT_FIELD"].number = 1
()["SC_64002_RESULT_FIELD"].index = 0
()["SC_64002_RESULT_FIELD"].label = 2
()["SC_64002_RESULT_FIELD"].has_default_value = false
()["SC_64002_RESULT_FIELD"].default_value = 0
()["SC_64002_RESULT_FIELD"].type = 13
()["SC_64002_RESULT_FIELD"].cpp_type = 3
SC_64002.name = "sc_64002"
SC_64002.full_name = "p64.sc_64002"
SC_64002.nested_types = {}
SC_64002.enum_types = {}
SC_64002.fields = {
	()["SC_64002_RESULT_FIELD"]
}
SC_64002.is_extendable = false
SC_64002.extensions = {}
()["CS_64003_TECH_GROUP_ID_FIELD"].name = "tech_group_id"
()["CS_64003_TECH_GROUP_ID_FIELD"].full_name = "p64.cs_64003.tech_group_id"
()["CS_64003_TECH_GROUP_ID_FIELD"].number = 1
()["CS_64003_TECH_GROUP_ID_FIELD"].index = 0
()["CS_64003_TECH_GROUP_ID_FIELD"].label = 2
()["CS_64003_TECH_GROUP_ID_FIELD"].has_default_value = false
()["CS_64003_TECH_GROUP_ID_FIELD"].default_value = 0
()["CS_64003_TECH_GROUP_ID_FIELD"].type = 13
()["CS_64003_TECH_GROUP_ID_FIELD"].cpp_type = 3
CS_64003.name = "cs_64003"
CS_64003.full_name = "p64.cs_64003"
CS_64003.nested_types = {}
CS_64003.enum_types = {}
CS_64003.fields = {
	()["CS_64003_TECH_GROUP_ID_FIELD"]
}
CS_64003.is_extendable = false
CS_64003.extensions = {}
()["SC_64004_RESULT_FIELD"].name = "result"
()["SC_64004_RESULT_FIELD"].full_name = "p64.sc_64004.result"
()["SC_64004_RESULT_FIELD"].number = 1
()["SC_64004_RESULT_FIELD"].index = 0
()["SC_64004_RESULT_FIELD"].label = 2
()["SC_64004_RESULT_FIELD"].has_default_value = false
()["SC_64004_RESULT_FIELD"].default_value = 0
()["SC_64004_RESULT_FIELD"].type = 13
()["SC_64004_RESULT_FIELD"].cpp_type = 3
SC_64004.name = "sc_64004"
SC_64004.full_name = "p64.sc_64004"
SC_64004.nested_types = {}
SC_64004.enum_types = {}
SC_64004.fields = {
	()["SC_64004_RESULT_FIELD"]
}
SC_64004.is_extendable = false
SC_64004.extensions = {}
()["FLEETTECH_GROUP_ID_FIELD"].name = "group_id"
()["FLEETTECH_GROUP_ID_FIELD"].full_name = "p64.fleettech.group_id"
()["FLEETTECH_GROUP_ID_FIELD"].number = 1
()["FLEETTECH_GROUP_ID_FIELD"].index = 0
()["FLEETTECH_GROUP_ID_FIELD"].label = 2
()["FLEETTECH_GROUP_ID_FIELD"].has_default_value = false
()["FLEETTECH_GROUP_ID_FIELD"].default_value = 0
()["FLEETTECH_GROUP_ID_FIELD"].type = 13
()["FLEETTECH_GROUP_ID_FIELD"].cpp_type = 3
()["FLEETTECH_EFFECT_TECH_ID_FIELD"].name = "effect_tech_id"
()["FLEETTECH_EFFECT_TECH_ID_FIELD"].full_name = "p64.fleettech.effect_tech_id"
()["FLEETTECH_EFFECT_TECH_ID_FIELD"].number = 2
()["FLEETTECH_EFFECT_TECH_ID_FIELD"].index = 1
()["FLEETTECH_EFFECT_TECH_ID_FIELD"].label = 2
()["FLEETTECH_EFFECT_TECH_ID_FIELD"].has_default_value = false
()["FLEETTECH_EFFECT_TECH_ID_FIELD"].default_value = 0
()["FLEETTECH_EFFECT_TECH_ID_FIELD"].type = 13
()["FLEETTECH_EFFECT_TECH_ID_FIELD"].cpp_type = 3
()["FLEETTECH_STUDY_TECH_ID_FIELD"].name = "study_tech_id"
()["FLEETTECH_STUDY_TECH_ID_FIELD"].full_name = "p64.fleettech.study_tech_id"
()["FLEETTECH_STUDY_TECH_ID_FIELD"].number = 3
()["FLEETTECH_STUDY_TECH_ID_FIELD"].index = 2
()["FLEETTECH_STUDY_TECH_ID_FIELD"].label = 2
()["FLEETTECH_STUDY_TECH_ID_FIELD"].has_default_value = false
()["FLEETTECH_STUDY_TECH_ID_FIELD"].default_value = 0
()["FLEETTECH_STUDY_TECH_ID_FIELD"].type = 13
()["FLEETTECH_STUDY_TECH_ID_FIELD"].cpp_type = 3
()["FLEETTECH_STUDY_FINISH_TIME_FIELD"].name = "study_finish_time"
()["FLEETTECH_STUDY_FINISH_TIME_FIELD"].full_name = "p64.fleettech.study_finish_time"
()["FLEETTECH_STUDY_FINISH_TIME_FIELD"].number = 4
()["FLEETTECH_STUDY_FINISH_TIME_FIELD"].index = 3
()["FLEETTECH_STUDY_FINISH_TIME_FIELD"].label = 2
()["FLEETTECH_STUDY_FINISH_TIME_FIELD"].has_default_value = false
()["FLEETTECH_STUDY_FINISH_TIME_FIELD"].default_value = 0
()["FLEETTECH_STUDY_FINISH_TIME_FIELD"].type = 13
()["FLEETTECH_STUDY_FINISH_TIME_FIELD"].cpp_type = 3
FLEETTECH.name = "fleettech"
FLEETTECH.full_name = "p64.fleettech"
FLEETTECH.nested_types = {}
FLEETTECH.enum_types = {}
FLEETTECH.fields = {
	()["FLEETTECH_GROUP_ID_FIELD"],
	()["FLEETTECH_EFFECT_TECH_ID_FIELD"],
	()["FLEETTECH_STUDY_TECH_ID_FIELD"],
	()["FLEETTECH_STUDY_FINISH_TIME_FIELD"]
}
FLEETTECH.is_extendable = false
FLEETTECH.extensions = {}
cs_64001 = slot0.Message(CS_64001)
cs_64003 = slot0.Message(CS_64003)
fleettech = slot0.Message(FLEETTECH)
sc_64000 = slot0.Message(SC_64000)
sc_64002 = slot0.Message(SC_64002)
sc_64004 = slot0.Message(SC_64004)

return
